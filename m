Date: Tue, 12 Oct 2021 16:38:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YWXyOH0oA2C5TOSF@redhat.com>
References: <20211012180624.447474-1-vgoyal@redhat.com>
	<20211012180624.447474-2-vgoyal@redhat.com>
	<2a7afeee-1f34-fb1c-13b1-0af1dcd95b68@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a7afeee-1f34-fb1c-13b1-0af1dcd95b68@schaufler-ca.com>
Subject: Re: [Virtio-fs] [PATCH v2 1/2] fuse: Add a flag FUSE_SECURITY_CTX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: miklos@szeredi.hu, selinux@vger.kernel.org, stephen.smalley.work@gmail.com, omosnace@redhat.com, virtio-fs@redhat.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Oct 12, 2021 at 12:09:35PM -0700, Casey Schaufler wrote:
> On 10/12/2021 11:06 AM, Vivek Goyal wrote:
> > Add the FUSE_SECURITY_CTX flag for the `flags` field of the
> > fuse_init_out struct.  When this flag is set the kernel will append the
> > security context for a newly created inode to the request (create,
> > mkdir, mknod, and symlink).  The server is responsible for ensuring that
> > the inode appears atomically (preferrably) with the requested security context.
> >
> > For example, if the server is backed by a "real" linux file system then
> > it can write the security context value to
> > /proc/thread-self/attr/fscreate before making the syscall to create the
> > inode.
> 
> his only works for SELinux, as I've mentioned before. Perhaps:
> 
> If the server is using SELinux and backed by a "real" linux file system
> that supports extended attributes it can write the security context value
> to /proc/thread-self/attr/fscreate before making the syscall to create
> the inode.

Agreed, this comment is more accurate. Server needs to be using SELinux.

Vivek

> 
> >
> > Vivek:
> > This patch is slightly modified version of patch from
> > Chirantan Ekbote <chirantan@chromium.org>. I made changes so that this
> > patch applies to latest kernel.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  include/uapi/linux/fuse.h | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> > index 36ed092227fa..2fe54c80051a 100644
> > --- a/include/uapi/linux/fuse.h
> > +++ b/include/uapi/linux/fuse.h
> > @@ -184,6 +184,10 @@
> >   *
> >   *  7.34
> >   *  - add FUSE_SYNCFS
> > + *
> > + *  7.35
> > + *  - add FUSE_SECURITY_CTX flag for fuse_init_out
> > + *  - add security context to create, mkdir, symlink, and mknod requests
> >   */
> >  
> >  #ifndef _LINUX_FUSE_H
> > @@ -219,7 +223,7 @@
> >  #define FUSE_KERNEL_VERSION 7
> >  
> >  /** Minor version number of this interface */
> > -#define FUSE_KERNEL_MINOR_VERSION 34
> > +#define FUSE_KERNEL_MINOR_VERSION 35
> >  
> >  /** The node ID of the root inode */
> >  #define FUSE_ROOT_ID 1
> > @@ -336,6 +340,8 @@ struct fuse_file_lock {
> >   *			write/truncate sgid is killed only if file has group
> >   *			execute permission. (Same as Linux VFS behavior).
> >   * FUSE_SETXATTR_EXT:	Server supports extended struct fuse_setxattr_in
> > + * FUSE_SECURITY_CTX:	add security context to create, mkdir, symlink, and
> > + * 			mknod
> >   */
> >  #define FUSE_ASYNC_READ		(1 << 0)
> >  #define FUSE_POSIX_LOCKS	(1 << 1)
> > @@ -367,6 +373,7 @@ struct fuse_file_lock {
> >  #define FUSE_SUBMOUNTS		(1 << 27)
> >  #define FUSE_HANDLE_KILLPRIV_V2	(1 << 28)
> >  #define FUSE_SETXATTR_EXT	(1 << 29)
> > +#define FUSE_SECURITY_CTX	(1 << 30)
> >  
> >  /**
> >   * CUSE INIT request/reply flags
> 

