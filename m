Date: Mon, 29 Mar 2021 14:16:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210329181651.GD676525@redhat.com>
References: <20210325151823.572089-1-vgoyal@redhat.com>
	<20210325151823.572089-2-vgoyal@redhat.com>
	<YGHpPWcZYQQWMvAi@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGHpPWcZYQQWMvAi@suse.de>
Subject: Re: [Virtio-fs] [PATCH v2 1/2] fuse: Add support for
	FUSE_SETXATTR_V2
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Luis Henriques <lhenriques@suse.de>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, seth.forshee@canonical.com, linux-fsdevel@vger.kernel.org

On Mon, Mar 29, 2021 at 03:50:37PM +0100, Luis Henriques wrote:
> On Thu, Mar 25, 2021 at 11:18:22AM -0400, Vivek Goyal wrote:
> > Fuse client needs to send additional information to file server when
> > it calls SETXATTR(system.posix_acl_access). Right now there is no extra
> > space in fuse_setxattr_in. So introduce a v2 of the structure which has
> > more space in it and can be used to send extra flags.
> > 
> > "struct fuse_setxattr_in_v2" is only used if file server opts-in for it using
> > flag FUSE_SETXATTR_V2 during feature negotiations.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/fuse/acl.c             |  2 +-
> >  fs/fuse/fuse_i.h          |  5 ++++-
> >  fs/fuse/inode.c           |  4 +++-
> >  fs/fuse/xattr.c           | 21 +++++++++++++++------
> >  include/uapi/linux/fuse.h | 10 ++++++++++
> >  5 files changed, 33 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/fuse/acl.c b/fs/fuse/acl.c
> > index e9c0f916349d..d31260a139d4 100644
> > --- a/fs/fuse/acl.c
> > +++ b/fs/fuse/acl.c
> > @@ -94,7 +94,7 @@ int fuse_set_acl(struct user_namespace *mnt_userns, struct inode *inode,
> >  			return ret;
> >  		}
> >  
> > -		ret = fuse_setxattr(inode, name, value, size, 0);
> > +		ret = fuse_setxattr(inode, name, value, size, 0, 0);
> >  		kfree(value);
> >  	} else {
> >  		ret = fuse_removexattr(inode, name);
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index 63d97a15ffde..d00bf0b9a38c 100644
> > --- a/fs/fuse/fuse_i.h
> > +++ b/fs/fuse/fuse_i.h
> > @@ -668,6 +668,9 @@ struct fuse_conn {
> >  	/** Is setxattr not implemented by fs? */
> >  	unsigned no_setxattr:1;
> >  
> > +	/** Does file server support setxattr_v2 */
> > +	unsigned setxattr_v2:1;
> > +
> 
> Minor (pedantic!) comment: most of the fields here start with 'no_*', so
> maybe it's worth setting the logic to use 'no_setxattr_v2' instead?

Hi Luis,

"setxattr_v2" kind of makes more sense to me because it is disabled
by default untile and unless client opts in. If I use no_setxattr_v2,
then it means by default I will have to initialize it to 1. Right
now, following automatically takes care of it.

fc = kzalloc(sizeof(struct fuse_conn), GFP_KERNEL);

Also, there are other examples which don't use "no_" prefix.

auto_inval_data, explicit_inval_data, do_readdirplus, readdirplus_auto, 
async_dio..... and list goes on.

Vivek

