Date: Mon, 18 Oct 2021 08:35:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YW1qJKLHYHWia2Nd@redhat.com>
References: <YWWMO/ZDrvDZ5X4c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWWMO/ZDrvDZ5X4c@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2] security: Return xattr name from
 security_dentry_init_security()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: jmorris@namei.org
Cc: bfields@fieldses.org, linux-nfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, selinux@vger.kernel.org, stephen.smalley.work@gmail.com, jlayton@kernel.org, Ondrej Mosnacek <omosnace@redhat.com>, anna.schumaker@netapp.com, virtio-fs@redhat.com, casey@schaufler-ca.com, linux-security-module@vger.kernel.org, chuck.lever@oracle.com, linux-fsdevel@vger.kernel.org, idryomov@gmail.com, ceph-devel@vger.kernel.org, trond.myklebust@hammerspace.com, serge@hallyn.com

Hi James,

I am assuming this patch will need to be routed through security tree.
Can you please consider it for inclusion.

Thanks
Vivek

On Tue, Oct 12, 2021 at 09:23:07AM -0400, Vivek Goyal wrote:
> Right now security_dentry_init_security() only supports single security
> label and is used by SELinux only. There are two users of of this hook,
> namely ceph and nfs.
> 
> NFS does not care about xattr name. Ceph hardcodes the xattr name to
> security.selinux (XATTR_NAME_SELINUX).
> 
> I am making changes to fuse/virtiofs to send security label to virtiofsd
> and I need to send xattr name as well. I also hardcoded the name of
> xattr to security.selinux.
> 
> Stephen Smalley suggested that it probably is a good idea to modify
> security_dentry_init_security() to also return name of xattr so that
> we can avoid this hardcoding in the callers.
> 
> This patch adds a new parameter "const char **xattr_name" to
> security_dentry_init_security() and LSM puts the name of xattr
> too if caller asked for it (xattr_name != NULL).
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> ---
> 
> Changes since v1:
> - Updated comment to make it clear caller does not have to free the
>   xattr_name. (Jeff Layton).
> - Captured Jeff's Reviewed-by ack.
> 
> I have tested this patch with virtiofs and compile tested for ceph and nfs.
> 
> NFS changes are trivial. Looking for an ack from NFS maintainers.
> 
> ---
>  fs/ceph/xattr.c               |    3 +--
>  fs/nfs/nfs4proc.c             |    3 ++-
>  include/linux/lsm_hook_defs.h |    3 ++-
>  include/linux/lsm_hooks.h     |    3 +++
>  include/linux/security.h      |    6 ++++--
>  security/security.c           |    7 ++++---
>  security/selinux/hooks.c      |    6 +++++-
>  7 files changed, 21 insertions(+), 10 deletions(-)
> 
> Index: redhat-linux/security/selinux/hooks.c
> ===================================================================
> --- redhat-linux.orig/security/selinux/hooks.c	2021-10-04 15:40:28.978453324 -0400
> +++ redhat-linux/security/selinux/hooks.c	2021-10-06 15:20:57.745247170 -0400
> @@ -2948,7 +2948,8 @@ static void selinux_inode_free_security(
>  }
>  
>  static int selinux_dentry_init_security(struct dentry *dentry, int mode,
> -					const struct qstr *name, void **ctx,
> +					const struct qstr *name,
> +					const char **xattr_name, void **ctx,
>  					u32 *ctxlen)
>  {
>  	u32 newsid;
> @@ -2961,6 +2962,9 @@ static int selinux_dentry_init_security(
>  	if (rc)
>  		return rc;
>  
> +	if (xattr_name)
> +		*xattr_name = XATTR_NAME_SELINUX;
> +
>  	return security_sid_to_context(&selinux_state, newsid, (char **)ctx,
>  				       ctxlen);
>  }
> Index: redhat-linux/security/security.c
> ===================================================================
> --- redhat-linux.orig/security/security.c	2021-10-04 15:40:28.978453324 -0400
> +++ redhat-linux/security/security.c	2021-10-06 15:20:57.749247170 -0400
> @@ -1052,11 +1052,12 @@ void security_inode_free(struct inode *i
>  }
>  
>  int security_dentry_init_security(struct dentry *dentry, int mode,
> -					const struct qstr *name, void **ctx,
> -					u32 *ctxlen)
> +				  const struct qstr *name,
> +				  const char **xattr_name, void **ctx,
> +				  u32 *ctxlen)
>  {
>  	return call_int_hook(dentry_init_security, -EOPNOTSUPP, dentry, mode,
> -				name, ctx, ctxlen);
> +				name, xattr_name, ctx, ctxlen);
>  }
>  EXPORT_SYMBOL(security_dentry_init_security);
>  
> Index: redhat-linux/include/linux/lsm_hooks.h
> ===================================================================
> --- redhat-linux.orig/include/linux/lsm_hooks.h	2021-10-04 15:40:28.978453324 -0400
> +++ redhat-linux/include/linux/lsm_hooks.h	2021-10-12 09:05:00.830399245 -0400
> @@ -196,6 +196,9 @@
>   *	@dentry dentry to use in calculating the context.
>   *	@mode mode used to determine resource type.
>   *	@name name of the last path component used to create file
> + *	@xattr_name pointer to place the pointer to security xattr name.
> + *		    Caller does not have to free the resulting pointer. Its
> + *		    a pointer to static string.
>   *	@ctx pointer to place the pointer to the resulting context in.
>   *	@ctxlen point to place the length of the resulting context.
>   * @dentry_create_files_as:
> Index: redhat-linux/include/linux/security.h
> ===================================================================
> --- redhat-linux.orig/include/linux/security.h	2021-10-04 15:40:28.978453324 -0400
> +++ redhat-linux/include/linux/security.h	2021-10-06 15:20:57.751247170 -0400
> @@ -317,8 +317,9 @@ int security_add_mnt_opt(const char *opt
>  				int len, void **mnt_opts);
>  int security_move_mount(const struct path *from_path, const struct path *to_path);
>  int security_dentry_init_security(struct dentry *dentry, int mode,
> -					const struct qstr *name, void **ctx,
> -					u32 *ctxlen);
> +				  const struct qstr *name,
> +				  const char **xattr_name, void **ctx,
> +				  u32 *ctxlen);
>  int security_dentry_create_files_as(struct dentry *dentry, int mode,
>  					struct qstr *name,
>  					const struct cred *old,
> @@ -739,6 +740,7 @@ static inline void security_inode_free(s
>  static inline int security_dentry_init_security(struct dentry *dentry,
>  						 int mode,
>  						 const struct qstr *name,
> +						 const char **xattr_name,
>  						 void **ctx,
>  						 u32 *ctxlen)
>  {
> Index: redhat-linux/include/linux/lsm_hook_defs.h
> ===================================================================
> --- redhat-linux.orig/include/linux/lsm_hook_defs.h	2021-10-04 15:40:28.978453324 -0400
> +++ redhat-linux/include/linux/lsm_hook_defs.h	2021-10-06 15:20:57.752247170 -0400
> @@ -83,7 +83,8 @@ LSM_HOOK(int, 0, sb_add_mnt_opt, const c
>  LSM_HOOK(int, 0, move_mount, const struct path *from_path,
>  	 const struct path *to_path)
>  LSM_HOOK(int, 0, dentry_init_security, struct dentry *dentry,
> -	 int mode, const struct qstr *name, void **ctx, u32 *ctxlen)
> +	 int mode, const struct qstr *name, const char **xattr_name,
> +	 void **ctx, u32 *ctxlen)
>  LSM_HOOK(int, 0, dentry_create_files_as, struct dentry *dentry, int mode,
>  	 struct qstr *name, const struct cred *old, struct cred *new)
>  
> Index: redhat-linux/fs/nfs/nfs4proc.c
> ===================================================================
> --- redhat-linux.orig/fs/nfs/nfs4proc.c	2021-10-04 15:40:28.978453324 -0400
> +++ redhat-linux/fs/nfs/nfs4proc.c	2021-10-06 15:20:57.754247170 -0400
> @@ -127,7 +127,8 @@ nfs4_label_init_security(struct inode *d
>  		return NULL;
>  
>  	err = security_dentry_init_security(dentry, sattr->ia_mode,
> -				&dentry->d_name, (void **)&label->label, &label->len);
> +				&dentry->d_name, NULL,
> +				(void **)&label->label, &label->len);
>  	if (err == 0)
>  		return label;
>  
> Index: redhat-linux/fs/ceph/xattr.c
> ===================================================================
> --- redhat-linux.orig/fs/ceph/xattr.c	2021-10-04 15:40:28.978453324 -0400
> +++ redhat-linux/fs/ceph/xattr.c	2021-10-06 15:20:57.756247170 -0400
> @@ -1311,7 +1311,7 @@ int ceph_security_init_secctx(struct den
>  	int err;
>  
>  	err = security_dentry_init_security(dentry, mode, &dentry->d_name,
> -					    &as_ctx->sec_ctx,
> +					    &name, &as_ctx->sec_ctx,
>  					    &as_ctx->sec_ctxlen);
>  	if (err < 0) {
>  		WARN_ON_ONCE(err != -EOPNOTSUPP);
> @@ -1335,7 +1335,6 @@ int ceph_security_init_secctx(struct den
>  	 * It only supports single security module and only selinux has
>  	 * dentry_init_security hook.
>  	 */
> -	name = XATTR_NAME_SELINUX;
>  	name_len = strlen(name);
>  	err = ceph_pagelist_reserve(pagelist,
>  				    4 * 2 + name_len + as_ctx->sec_ctxlen);
> 

