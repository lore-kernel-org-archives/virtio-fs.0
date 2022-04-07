Return-Path: <dgilbert@redhat.com>
Date: Thu, 7 Apr 2022 13:44:35 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <Yk7cs6xSImIyDqpZ@work-vm>
References: <20220217172500.60500-1-dgilbert@redhat.com>
 <20220217172500.60500-10-dgilbert@redhat.com>
 <CAFEAcA9m2U2fcUYXpRJwt09UgGqDA2K3BDt1xgXZL63jc1EWEQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAFEAcA9m2U2fcUYXpRJwt09UgGqDA2K3BDt1xgXZL63jc1EWEQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PULL 09/12] virtiofsd: Create new file with
 security context
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org, vgoyal@redhat.com, groug@kaod.org, sebastian.hasler@stuvus.uni-stuttgart.de, virtio-fs@redhat.com, stefanha@redhat.com, slp@redhat.com

* Peter Maydell (peter.maydell@linaro.org) wrote:
> On Thu, 17 Feb 2022 at 17:40, Dr. David Alan Gilbert (git)
> <dgilbert@redhat.com> wrote:
> >
> > From: Vivek Goyal <vgoyal@redhat.com>
> >
> > This patch adds support for creating new file with security context
> > as sent by client. It basically takes three paths.
> >
> > - If no security context enabled, then it continues to create files without
> >   security context.
> >
> > - If security context is enabled and but security.selinux has not been
> >   remapped, then it uses /proc/thread-self/attr/fscreate knob to set
> >   security context and then create the file. This will make sure that
> >   newly created file gets the security context as set in "fscreate" and
> >   this is atomic w.r.t file creation.
> >
> >   This is useful and host and guest SELinux policies don't conflict and
> >   can work with each other. In that case, guest security.selinux xattr
> >   is not remapped and it is passthrough as "security.selinux" xattr
> >   on host.
> >
> > - If security context is enabled but security.selinux xattr has been
> >   remapped to something else, then it first creates the file and then
> >   uses setxattr() to set the remapped xattr with the security context.
> >   This is a non-atomic operation w.r.t file creation.
> >
> >   This mode will be most versatile and allow host and guest to have their
> >   own separate SELinux xattrs and have their own separate SELinux policies.
> >
> > Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > Message-Id: <20220208204813.682906-9-vgoyal@redhat.com>
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> 
> Hi; Coverity reports some issues (CID 1487142, 1487195), because
> it is not a fan of the error-handling pattern used in this code:
> 
> > +static int do_mknod_symlink_secctx(fuse_req_t req, struct lo_inode *dir,
> > +                                   const char *name, const char *secctx_name)
> > +{
> > +    int path_fd, err;
> > +    char procname[64];
> > +    struct lo_data *lo = lo_data(req);
> > +
> > +    if (!req->secctx.ctxlen) {
> > +        return 0;
> > +    }
> > +
> > +    /* Open newly created element with O_PATH */
> > +    path_fd = openat(dir->fd, name, O_PATH | O_NOFOLLOW);
> > +    err = path_fd == -1 ? errno : 0;
> > +    if (err) {
> > +        return err;
> > +    }
> 
> We set err based on whether path_fd is -1 or not, but we decide
> whether to early-return based on the value of err. Coverity
> doesn't know that openat() will always set errno to something
> non-zero if it returns -1, so it complains because it thinks
> there's a code path where openat() returns -1, but errno is 0,
> and so we don't take the early-return and instead continue
> through all the code below to the "close(path_fd)", which
> should not be being passed a negative value for the filedescriptor.
> 
> I could just mark these as false-positives, but it does seem a bit
> odd that we are using two different conditions here. Perhaps it would
> be better to rephrase? For instance, for the openat() we could write:
> 
>    path_fd = openat(dir->fd, name, O_PATH | O_NOFOLLOW);
>    if (path_fd == -1) {
>        return errno;
>    }

That looks OK to me; please send a patch.

Some of the cases look like they need to just be a little careful that
'err' always gets set to 0 if there are later cases that might set err.

Dave

> and similarly for the openat() in open_set_proc_fscreate().
> 
> > +    sprintf(procname, "%i", path_fd);
> > +    FCHDIR_NOFAIL(lo->proc_self_fd);
> > +    /* Set security context. This is not atomic w.r.t file creation */
> > +    err = setxattr(procname, secctx_name, req->secctx.ctx, req->secctx.ctxlen,
> > +                   0);
> > +    if (err) {
> > +        err = errno;
> > +    }
> 
> > +    FCHDIR_NOFAIL(lo->root.fd);
> > +    close(path_fd);
> > +    return err;
> > +}
> 
> thanks
> -- PMM
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

