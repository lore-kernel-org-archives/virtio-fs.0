Date: Mon, 29 Mar 2021 15:50:37 +0100
From: Luis Henriques <lhenriques@suse.de>
Message-ID: <YGHpPWcZYQQWMvAi@suse.de>
References: <20210325151823.572089-1-vgoyal@redhat.com>
	<20210325151823.572089-2-vgoyal@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210325151823.572089-2-vgoyal@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, seth.forshee@canonical.com, linux-fsdevel@vger.kernel.org

On Thu, Mar 25, 2021 at 11:18:22AM -0400, Vivek Goyal wrote:
> Fuse client needs to send additional information to file server when
> it calls SETXATTR(system.posix_acl_access). Right now there is no extra
> space in fuse_setxattr_in. So introduce a v2 of the structure which has
> more space in it and can be used to send extra flags.
>=20
> "struct fuse_setxattr_in_v2" is only used if file server opts-in for it u=
sing
> flag FUSE_SETXATTR_V2 during feature negotiations.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/acl.c             |  2 +-
>  fs/fuse/fuse_i.h          |  5 ++++-
>  fs/fuse/inode.c           |  4 +++-
>  fs/fuse/xattr.c           | 21 +++++++++++++++------
>  include/uapi/linux/fuse.h | 10 ++++++++++
>  5 files changed, 33 insertions(+), 9 deletions(-)
>=20
> diff --git a/fs/fuse/acl.c b/fs/fuse/acl.c
> index e9c0f916349d..d31260a139d4 100644
> --- a/fs/fuse/acl.c
> +++ b/fs/fuse/acl.c
> @@ -94,7 +94,7 @@ int fuse_set_acl(struct user_namespace *mnt_userns, str=
uct inode *inode,
>  			return ret;
>  		}
> =20
> -		ret =3D fuse_setxattr(inode, name, value, size, 0);
> +		ret =3D fuse_setxattr(inode, name, value, size, 0, 0);
>  		kfree(value);
>  	} else {
>  		ret =3D fuse_removexattr(inode, name);
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 63d97a15ffde..d00bf0b9a38c 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -668,6 +668,9 @@ struct fuse_conn {
>  	/** Is setxattr not implemented by fs? */
>  	unsigned no_setxattr:1;
> =20
> +	/** Does file server support setxattr_v2 */
> +	unsigned setxattr_v2:1;
> +

Minor (pedantic!) comment: most of the fields here start with 'no_*', so
maybe it's worth setting the logic to use 'no_setxattr_v2' instead?

Cheers,
--
Lu=EDs


>  	/** Is getxattr not implemented by fs? */
>  	unsigned no_getxattr:1;
> =20
> @@ -1170,7 +1173,7 @@ void fuse_unlock_inode(struct inode *inode, bool lo=
cked);
>  bool fuse_lock_inode(struct inode *inode);
> =20
>  int fuse_setxattr(struct inode *inode, const char *name, const void *val=
ue,
> -		  size_t size, int flags);
> +		  size_t size, int flags, unsigned extra_flags);
>  ssize_t fuse_getxattr(struct inode *inode, const char *name, void *value,
>  		      size_t size);
>  ssize_t fuse_listxattr(struct dentry *entry, char *list, size_t size);
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index b0e18b470e91..1c726df13f80 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1052,6 +1052,8 @@ static void process_init_reply(struct fuse_mount *f=
m, struct fuse_args *args,
>  				fc->handle_killpriv_v2 =3D 1;
>  				fm->sb->s_flags |=3D SB_NOSEC;
>  			}
> +			if (arg->flags & FUSE_SETXATTR_V2)
> +				fc->setxattr_v2 =3D 1;
>  		} else {
>  			ra_pages =3D fc->max_read / PAGE_SIZE;
>  			fc->no_lock =3D 1;
> @@ -1095,7 +1097,7 @@ void fuse_send_init(struct fuse_mount *fm)
>  		FUSE_PARALLEL_DIROPS | FUSE_HANDLE_KILLPRIV | FUSE_POSIX_ACL |
>  		FUSE_ABORT_ERROR | FUSE_MAX_PAGES | FUSE_CACHE_SYMLINKS |
>  		FUSE_NO_OPENDIR_SUPPORT | FUSE_EXPLICIT_INVAL_DATA |
> -		FUSE_HANDLE_KILLPRIV_V2;
> +		FUSE_HANDLE_KILLPRIV_V2 | FUSE_SETXATTR_V2;
>  #ifdef CONFIG_FUSE_DAX
>  	if (fm->fc->dax)
>  		ia->in.flags |=3D FUSE_MAP_ALIGNMENT;
> diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
> index 1a7d7ace54e1..f2aae72653dc 100644
> --- a/fs/fuse/xattr.c
> +++ b/fs/fuse/xattr.c
> @@ -12,24 +12,33 @@
>  #include <linux/posix_acl_xattr.h>
> =20
>  int fuse_setxattr(struct inode *inode, const char *name, const void *val=
ue,
> -		  size_t size, int flags)
> +		  size_t size, int flags, unsigned extra_flags)
>  {
>  	struct fuse_mount *fm =3D get_fuse_mount(inode);
>  	FUSE_ARGS(args);
>  	struct fuse_setxattr_in inarg;
> +	struct fuse_setxattr_in_v2 inarg_v2;
> +	bool setxattr_v2 =3D fm->fc->setxattr_v2;
>  	int err;
> =20
>  	if (fm->fc->no_setxattr)
>  		return -EOPNOTSUPP;
> =20
>  	memset(&inarg, 0, sizeof(inarg));
> -	inarg.size =3D size;
> -	inarg.flags =3D flags;
> +	memset(&inarg_v2, 0, sizeof(inarg_v2));
> +	if (setxattr_v2) {
> +		inarg_v2.size =3D size;
> +		inarg_v2.flags =3D flags;
> +		inarg_v2.setxattr_flags =3D extra_flags;
> +	} else {
> +		inarg.size =3D size;
> +		inarg.flags =3D flags;
> +	}
>  	args.opcode =3D FUSE_SETXATTR;
>  	args.nodeid =3D get_node_id(inode);
>  	args.in_numargs =3D 3;
> -	args.in_args[0].size =3D sizeof(inarg);
> -	args.in_args[0].value =3D &inarg;
> +	args.in_args[0].size =3D setxattr_v2 ? sizeof(inarg_v2) : sizeof(inarg);
> +	args.in_args[0].value =3D setxattr_v2 ? &inarg_v2 : (void *)&inarg;
>  	args.in_args[1].size =3D strlen(name) + 1;
>  	args.in_args[1].value =3D name;
>  	args.in_args[2].size =3D size;
> @@ -199,7 +208,7 @@ static int fuse_xattr_set(const struct xattr_handler =
*handler,
>  	if (!value)
>  		return fuse_removexattr(inode, name);
> =20
> -	return fuse_setxattr(inode, name, value, size, flags);
> +	return fuse_setxattr(inode, name, value, size, flags, 0);
>  }
> =20
>  static bool no_xattr_list(struct dentry *dentry)
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 54442612c48b..1bb555c1c117 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -179,6 +179,7 @@
>   *  7.33
>   *  - add FUSE_HANDLE_KILLPRIV_V2, FUSE_WRITE_KILL_SUIDGID, FATTR_KILL_S=
UIDGID
>   *  - add FUSE_OPEN_KILL_SUIDGID
> + *  - add FUSE_SETXATTR_V2
>   */
> =20
>  #ifndef _LINUX_FUSE_H
> @@ -330,6 +331,7 @@ struct fuse_file_lock {
>   *			does not have CAP_FSETID. Additionally upon
>   *			write/truncate sgid is killed only if file has group
>   *			execute permission. (Same as Linux VFS behavior).
> + * FUSE_SETXATTR_V2:	Does file server support V2 of struct fuse_setxattr=
_in
>   */
>  #define FUSE_ASYNC_READ		(1 << 0)
>  #define FUSE_POSIX_LOCKS	(1 << 1)
> @@ -360,6 +362,7 @@ struct fuse_file_lock {
>  #define FUSE_MAP_ALIGNMENT	(1 << 26)
>  #define FUSE_SUBMOUNTS		(1 << 27)
>  #define FUSE_HANDLE_KILLPRIV_V2	(1 << 28)
> +#define FUSE_SETXATTR_V2	(1 << 29)
> =20
>  /**
>   * CUSE INIT request/reply flags
> @@ -686,6 +689,13 @@ struct fuse_setxattr_in {
>  	uint32_t	flags;
>  };
> =20
> +struct fuse_setxattr_in_v2 {
> +	uint32_t	size;
> +	uint32_t	flags;
> +	uint32_t	setxattr_flags;
> +	uint32_t	padding;
> +};
> +
>  struct fuse_getxattr_in {
>  	uint32_t	size;
>  	uint32_t	padding;
> --=20
> 2.25.4
>=20


