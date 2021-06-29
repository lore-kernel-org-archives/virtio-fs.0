Date: Tue, 29 Jun 2021 09:22:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210629132236.GB5231@redhat.com>
References: <20210622150852.1507204-1-vgoyal@redhat.com>
	<20210622150852.1507204-3-vgoyal@redhat.com>
	<YNnrT/mCw3w26/lT@work-vm> <20210629150343.5cf10a26@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210629150343.5cf10a26@bahia.lan>
Subject: Re: [Virtio-fs] [PATCH v7 2/7] virtiofsd: Fix xattr operations
 overwriting errno
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, miklos@szeredi.hu

On Tue, Jun 29, 2021 at 03:03:43PM +0200, Greg Kurz wrote:
> On Mon, 28 Jun 2021 16:31:27 +0100
> "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> 
> > * Vivek Goyal (vgoyal@redhat.com) wrote:
> > > getxattr/setxattr/removexattr/listxattr operations handle regualar
> > > and non-regular files differently. For the case of non-regular files
> > > we do fchdir(/proc/self/fd) and the xattr operation and then revert
> > > back to original working directory. After this we are saving errno
> > > and that's buggy because fchdir() will overwrite the errno.
> > > 
> > > FCHDIR_NOFAIL(lo->proc_self_fd);
> > > ret = getxattr(procname, name, value, size);
> > > FCHDIR_NOFAIL(lo->root.fd);
> > > 
> > > if (ret == -1)
> > >     saverr = errno
> > > 
> > > In above example, if getxattr() failed, we will still return 0 to caller
> > > as errno must have been written by FCHDIR_NOFAIL(lo->root.fd) call.
> 
> This assertion doesn't look right.
> 
> From the errno(3) manual page:
> 
>        The value in errno is significant only when the return value of
>        the call indicated an error (i.e., -1 from most system calls; -1
>        or NULL from most library functions); a function that succeeds is
>        allowed to change errno.  The value of errno is never set to zero
>                                               ^^^^^^^^^^^^^^^^^^^^^^^^^^
>        by any system call or library function.

Ok. So it will not set errno to 0. But it also says "a function that
succeeds is allowed to change errno". So that means a successful
fchdir(fd) can change errno to something else and we lost original
error code returned by getxattr() operation. Even "assert(fchdir_res == 0)"
will not kick in because fchdir() succeeded.

IOW, with current code we can still lose original error code as experienced
while executing getxattr()/setxattr()/listxattr(). So it makese sense
to fix it.

Vivek

> > > Fix all such instances and capture "errno" early and save in "saverr"
> > > variable.
> > > 
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > 
> > I think the existing code is actually safe; I don't think fchdir
> > will/should set errno unless there's an error, and we're explictly
> > asserting there isn't one.
> > 
> > However, I do prefer doing this save since we already have the save
> > variables and it makes the chance of screwing it up from any other
> > forgotten syscall less likely, so
> > 
> 
> Agreed. With this rationale in the changelog:
> 
> Reviewed-by: Greg Kurz <groug@kaod.org>
> 
> > 
> > Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > 
> > > ---
> > >  tools/virtiofsd/passthrough_ll.c | 16 ++++++++++------
> > >  1 file changed, 10 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> > > index 49c21fd855..ec91b3c133 100644
> > > --- a/tools/virtiofsd/passthrough_ll.c
> > > +++ b/tools/virtiofsd/passthrough_ll.c
> > > @@ -2791,15 +2791,17 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
> > >              goto out_err;
> > >          }
> > >          ret = fgetxattr(fd, name, value, size);
> > > +        saverr = ret == -1 ? errno : 0;
> > >      } else {
> > >          /* fchdir should not fail here */
> > >          FCHDIR_NOFAIL(lo->proc_self_fd);
> > >          ret = getxattr(procname, name, value, size);
> > > +        saverr = ret == -1 ? errno : 0;
> > >          FCHDIR_NOFAIL(lo->root.fd);
> > >      }
> > >  
> > >      if (ret == -1) {
> > > -        goto out_err;
> > > +        goto out;
> > >      }
> > >      if (size) {
> > >          saverr = 0;
> > > @@ -2864,15 +2866,17 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
> > >              goto out_err;
> > >          }
> > >          ret = flistxattr(fd, value, size);
> > > +        saverr = ret == -1 ? errno : 0;
> > >      } else {
> > >          /* fchdir should not fail here */
> > >          FCHDIR_NOFAIL(lo->proc_self_fd);
> > >          ret = listxattr(procname, value, size);
> > > +        saverr = ret == -1 ? errno : 0;
> > >          FCHDIR_NOFAIL(lo->root.fd);
> > >      }
> > >  
> > >      if (ret == -1) {
> > > -        goto out_err;
> > > +        goto out;
> > >      }
> > >      if (size) {
> > >          saverr = 0;
> > > @@ -2998,15 +3002,15 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
> > >              goto out;
> > >          }
> > >          ret = fsetxattr(fd, name, value, size, flags);
> > > +        saverr = ret == -1 ? errno : 0;
> > >      } else {
> > >          /* fchdir should not fail here */
> > >          FCHDIR_NOFAIL(lo->proc_self_fd);
> > >          ret = setxattr(procname, name, value, size, flags);
> > > +        saverr = ret == -1 ? errno : 0;
> > >          FCHDIR_NOFAIL(lo->root.fd);
> > >      }
> > >  
> > > -    saverr = ret == -1 ? errno : 0;
> > > -
> > >  out:
> > >      if (fd >= 0) {
> > >          close(fd);
> > > @@ -3064,15 +3068,15 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *in_name)
> > >              goto out;
> > >          }
> > >          ret = fremovexattr(fd, name);
> > > +        saverr = ret == -1 ? errno : 0;
> > >      } else {
> > >          /* fchdir should not fail here */
> > >          FCHDIR_NOFAIL(lo->proc_self_fd);
> > >          ret = removexattr(procname, name);
> > > +        saverr = ret == -1 ? errno : 0;
> > >          FCHDIR_NOFAIL(lo->root.fd);
> > >      }
> > >  
> > > -    saverr = ret == -1 ? errno : 0;
> > > -
> > >  out:
> > >      if (fd >= 0) {
> > >          close(fd);
> > > -- 
> > > 2.25.4
> > > 
> 

