Date: Mon, 28 Jun 2021 14:12:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210628181218.GF1803896@redhat.com>
References: <20210622150852.1507204-1-vgoyal@redhat.com>
	<20210622150852.1507204-6-vgoyal@redhat.com>
	<YNn03dfqpGnTTIne@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNn03dfqpGnTTIne@work-vm>
Subject: Re: [Virtio-fs] [PATCH v7 5/7] virtiofsd: Add capability to
	change/restore umask
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, miklos@szeredi.hu, qemu-devel@nongnu.org

On Mon, Jun 28, 2021 at 05:12:13PM +0100, Dr. David Alan Gilbert wrote:
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > When parent directory has default acl and a file is created in that
> > directory, then umask is ignored and final file permissions are
> > determined using default acl instead. (man 2 umask).
> > 
> > Currently, fuse applies the umask and sends modified mode in create
> > request accordingly. fuse server can set FUSE_DONT_MASK and tell
> > fuse client to not apply umask and fuse server will take care of
> > it as needed.
> > 
> > With posix acls enabled, requirement will be that we want umask
> > to determine final file mode if parent directory does not have
> > default acl.
> > 
> > So if posix acls are enabled, opt in for FUSE_DONT_MASK. virtiofsd
> > will set umask of the thread doing file creation. And host kernel
> > should use that umask if parent directory does not have default
> > acls, otherwise umask does not take affect.
> > 
> > Miklos mentioned that we already call unshare(CLONE_FS) for
> > every thread. That means umask has now become property of per
> > thread and it should be ok to manipulate it in file creation path.
> > 
> > This patch only adds capability to change umask and restore it. It
> > does not enable it yet. Next few patches will add capability to enable it
> > based on if user enabled posix_acl or not.
> > 
> > This should fix fstest generic/099.
> > 
> > Reported-by: Luis Henriques <lhenriques@suse.de>
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  tools/virtiofsd/passthrough_ll.c | 22 ++++++++++++++++------
> >  1 file changed, 16 insertions(+), 6 deletions(-)
> > 
> > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> > index 9f5cd98fb5..0c9084ea15 100644
> > --- a/tools/virtiofsd/passthrough_ll.c
> > +++ b/tools/virtiofsd/passthrough_ll.c
> > @@ -122,6 +122,7 @@ struct lo_inode {
> >  struct lo_cred {
> >      uid_t euid;
> >      gid_t egid;
> > +    mode_t umask;
> >  };
> >  
> >  enum {
> > @@ -172,6 +173,8 @@ struct lo_data {
> >      /* An O_PATH file descriptor to /proc/self/fd/ */
> >      int proc_self_fd;
> >      int user_killpriv_v2, killpriv_v2;
> > +    /* If set, virtiofsd is responsible for setting umask during creation */
> > +    bool change_umask;
> >  };
> >  
> >  static const struct fuse_opt lo_opts[] = {
> > @@ -1134,7 +1137,8 @@ static void lo_lookup(fuse_req_t req, fuse_ino_t parent, const char *name)
> >   * ownership of caller.
> >   * TODO: What about selinux context?
> >   */
> > -static int lo_change_cred(fuse_req_t req, struct lo_cred *old)
> > +static int lo_change_cred(fuse_req_t req, struct lo_cred *old,
> > +                          bool change_umask)
> >  {
> >      int res;
> >  
> > @@ -1154,11 +1158,14 @@ static int lo_change_cred(fuse_req_t req, struct lo_cred *old)
> >          return errno_save;
> >      }
> >  
> > +    if (change_umask) {
> > +        old->umask = umask(req->ctx.umask);
> > +    }
> >      return 0;
> >  }
> >  
> >  /* Regain Privileges */
> > -static void lo_restore_cred(struct lo_cred *old)
> > +static void lo_restore_cred(struct lo_cred *old, bool restore_umask)
> >  {
> >      int res;
> >  
> > @@ -1173,6 +1180,9 @@ static void lo_restore_cred(struct lo_cred *old)
> >          fuse_log(FUSE_LOG_ERR, "setegid(%u): %m\n", old->egid);
> >          exit(1);
> >      }
> > +
> > +    if (restore_umask)
> > +        umask(old->umask);
> >  }
> >  
> >  static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
> > @@ -1202,7 +1212,7 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
> >          return;
> >      }
> >  
> > -    saverr = lo_change_cred(req, &old);
> > +    saverr = lo_change_cred(req, &old, lo->change_umask && !S_ISLNK(mode));
> 
> Can you explain what these ISLNK checks are for (insid mknod_symlink, so
> is that always true or irrelevant?)

I think I put this check in because if we are creating symlink then we
don't have to change umask as symlink will always get a some fix
mode (usually 777) and umask will not have an affect. So this is
just an optimization to avoid switching umask in some cases. I 
can't think of any other reason.

thanks
Vivek

