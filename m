Date: Mon, 1 Mar 2021 11:33:24 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210301163324.GC186178@redhat.com>
References: <20210226183357.28467-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210226183357.28467-1-lhenriques@suse.de>
Subject: Re: [Virtio-fs] [RFC PATCH] fuse: Clear SGID bit when setting mode
	in setacl
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Luis Henriques <lhenriques@suse.de>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Feb 26, 2021 at 06:33:57PM +0000, Luis Henriques wrote:
> Setting file permissions with POSIX ACLs (setxattr) isn't clearing the
> setgid bit.  This seems to be CVE-2016-7097, detected by running fstest
> generic/375 in virtiofs.  Unfortunately, when the fix for this CVE landed
> in the kernel with commit 073931017b49 ("posix_acl: Clear SGID bit when
> setting file permissions"), FUSE didn't had ACLs support yet.

Hi Luis,

Interesting. I did not know that "chmod" can lead to clearing of SGID
as well. Recently we implemented FUSE_HANDLE_KILLPRIV_V2 flag which
means that file server is responsible for clearing of SUID/SGID/caps
as per following rules.

    - caps are always cleared on chown/write/truncate
    - suid is always cleared on chown, while for truncate/write it is cleared
      only if caller does not have CAP_FSETID.
    - sgid is always cleared on chown, while for truncate/write it is cleared
      only if caller does not have CAP_FSETID as well as file has group execute
      permission.

And we don't have anything about "chmod" in this list. Well, I will test
this and come back to this little later.

I see following comment in fuse_set_acl().

                /*
                 * Fuse userspace is responsible for updating access
                 * permissions in the inode, if needed. fuse_setxattr
                 * invalidates the inode attributes, which will force
                 * them to be refreshed the next time they are used,
                 * and it also updates i_ctime.
                 */

So looks like that original code has been written with intent that
file server is responsible for updating inode permissions. I am
assuming this will include clearing of S_ISGID if needed.

But question is, does file server has enough information to be able
to handle proper clearing of S_ISGID info. IIUC, file server will need
two pieces of information atleast.

- gid of the caller.
- Whether caller has CAP_FSETID or not.

I think we have first piece of information but not the second one. May
be we need to send this in fuse_setxattr_in->flags. And file server
can drop CAP_FSETID while doing setxattr().

What about "gid" info. We don't change to caller's uid/gid while doing
setxattr(). So host might not clear S_ISGID or clear it when it should
not. I am wondering that can we switch to caller's uid/gid in setxattr(),
atleast while setting acls.

Thanks
Vivek

> 
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
>  fs/fuse/acl.c | 29 ++++++++++++++++++++++++++---
>  1 file changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/fuse/acl.c b/fs/fuse/acl.c
> index f529075a2ce8..1b273277c1c9 100644
> --- a/fs/fuse/acl.c
> +++ b/fs/fuse/acl.c
> @@ -54,7 +54,9 @@ int fuse_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
>  	struct fuse_conn *fc = get_fuse_conn(inode);
>  	const char *name;
> +	umode_t mode = inode->i_mode;
>  	int ret;
> +	bool update_mode = false;
>  
>  	if (fuse_is_bad(inode))
>  		return -EIO;
> @@ -62,11 +64,18 @@ int fuse_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  	if (!fc->posix_acl || fc->no_setxattr)
>  		return -EOPNOTSUPP;
>  
> -	if (type == ACL_TYPE_ACCESS)
> +	if (type == ACL_TYPE_ACCESS) {
>  		name = XATTR_NAME_POSIX_ACL_ACCESS;
> -	else if (type == ACL_TYPE_DEFAULT)
> +		if (acl) {
> +			ret = posix_acl_update_mode(inode, &mode, &acl);
> +			if (ret)
> +				return ret;
> +			if (inode->i_mode != mode)
> +				update_mode = true;
> +		}
> +	} else if (type == ACL_TYPE_DEFAULT) {
>  		name = XATTR_NAME_POSIX_ACL_DEFAULT;
> -	else
> +	} else
>  		return -EINVAL;
>  
>  	if (acl) {
> @@ -98,6 +107,20 @@ int fuse_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  	} else {
>  		ret = fuse_removexattr(inode, name);
>  	}
> +	if (!ret && update_mode) {
> +		struct dentry *entry;
> +		struct iattr attr;
> +
> +		entry = d_find_alias(inode);
> +		if (entry) {
> +			memset(&attr, 0, sizeof(attr));
> +			attr.ia_valid = ATTR_MODE | ATTR_CTIME;
> +			attr.ia_mode = mode;
> +			attr.ia_ctime = current_time(inode);
> +			ret = fuse_do_setattr(entry, &attr, NULL);
> +			dput(entry);
> +		}
> +	}
>  	forget_all_cached_acls(inode);
>  	fuse_invalidate_attr(inode);
>  
> 

