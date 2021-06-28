Date: Mon, 28 Jun 2021 18:55:50 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YNoNJqddWhNGr6b8@work-vm>
References: <20210622150852.1507204-1-vgoyal@redhat.com>
	<20210622150852.1507204-7-vgoyal@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210622150852.1507204-7-vgoyal@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v7 6/7] virtiofsd: Switch creds,
 drop FSETID for system.posix_acl_access xattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, miklos@szeredi.hu, qemu-devel@nongnu.org

* Vivek Goyal (vgoyal@redhat.com) wrote:
> When posix access acls are set on a file, it can lead to adjusting file
> permissions (mode) as well. If caller does not have CAP_FSETID and it
> also does not have membership of owner group, this will lead to clearing
> SGID bit in mode.
> 
> Current fuse code is written in such a way that it expects file server
> to take care of chaning file mode (permission), if there is a need.
> Right now, host kernel does not clear SGID bit because virtiofsd is
> running as root and has CAP_FSETID. For host kernel to clear SGID,
> virtiofsd need to switch to gid of caller in guest and also drop
> CAP_FSETID (if caller did not have it to begin with).
> 
> If SGID needs to be cleared, client will set the flag
> FUSE_SETXATTR_ACL_KILL_SGID in setxattr request. In that case server
> should kill sgid.
> 
> Currently just switch to uid/gid of the caller and drop CAP_FSETID
> and that should do it.
> 
> This should fix the xfstest generic/375 test case.
> 
> We don't have to switch uid for this to work. That could be one optimization
> that pass a parameter to lo_change_cred() to only switch gid and not uid.
> 
> Also this will not work whenever (if ever) we support idmapped mounts. In
> that case it is possible that uid/gid in request are 0/0 but still we
> need to clear SGID. So we will have to pick a non-root sgid and switch
> to that instead. That's an TODO item for future when idmapped mount
> support is introduced.
> 
> This patch only adds the capability to switch creds and drop FSETID
> when acl xattr is set. This does not take affect yet. It can take
> affect when next patch adds the capability to enable posix_acl.
> 
> Reported-by: Luis Henriques <lhenriques@suse.de>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  tools/virtiofsd/passthrough_ll.c | 75 ++++++++++++++++++++++++++++++++
>  1 file changed, 75 insertions(+)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 0c9084ea15..113c725def 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -175,6 +175,7 @@ struct lo_data {
>      int user_killpriv_v2, killpriv_v2;
>      /* If set, virtiofsd is responsible for setting umask during creation */
>      bool change_umask;
> +    int posix_acl;
>  };
>  
>  static const struct fuse_opt lo_opts[] = {
> @@ -1185,6 +1186,51 @@ static void lo_restore_cred(struct lo_cred *old, bool restore_umask)
>          umask(old->umask);
>  }
>  
> +/*
> + * A helper to change cred and drop capability. Returns 0 on success and
> + * errno on error
> + */
> +static int lo_drop_cap_change_cred(fuse_req_t req, struct lo_cred *old,
> +                                   bool change_umask, const char *cap_name,
> +                                   bool *cap_dropped)
> +{
> +    int ret;
> +    bool __cap_dropped;
> +
> +    assert(cap_name);
> +
> +    ret = drop_effective_cap(cap_name, &__cap_dropped);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    ret = lo_change_cred(req, old, change_umask);
> +    if (ret) {
> +        if (__cap_dropped) {
> +            if (gain_effective_cap(cap_name)) {
> +                fuse_log(FUSE_LOG_ERR, "Failed to gain CAP_%s\n", cap_name);
> +            }
> +        }
> +    }
> +
> +    if (cap_dropped) {
> +        *cap_dropped = __cap_dropped;
> +    }
> +    return ret;
> +}
> +
> +static void lo_restore_cred_gain_cap(struct lo_cred *old, bool restore_umask,
> +                                     const char *cap_name)
> +{
> +    assert(cap_name);
> +
> +    lo_restore_cred(old, restore_umask);
> +
> +    if (gain_effective_cap(cap_name)) {
> +        fuse_log(FUSE_LOG_ERR, "Failed to gain CAP_%s\n", cap_name);
> +    }
> +}
> +
>  static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
>                               const char *name, mode_t mode, dev_t rdev,
>                               const char *link)
> @@ -2976,6 +3022,9 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
>      ssize_t ret;
>      int saverr;
>      int fd = -1;
> +    bool switched_creds = false;
> +    bool cap_fsetid_dropped = false;
> +    struct lo_cred old = {};
>  
>      mapped_name = NULL;
>      name = in_name;
> @@ -3006,6 +3055,26 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
>               ", name=%s value=%s size=%zd)\n", ino, name, value, size);
>  
>      sprintf(procname, "%i", inode->fd);
> +    /*
> +     * If we are setting posix access acl and if SGID needs to be
> +     * cleared, then switch to caller's gid and drop CAP_FSETID
> +     * and that should make sure host kernel clears SGID.
> +     *
> +     * This probably will not work when we support idmapped mounts.
> +     * In that case we will need to find a non-root gid and switch
> +     * to it. (Instead of gid in request). Fix it when we support
> +     * idmapped mounts.
> +     */
> +    if (lo->posix_acl && !strcmp(name, "system.posix_acl_access")
> +        && (extra_flags & FUSE_SETXATTR_ACL_KILL_SGID)) {
> +        ret = lo_drop_cap_change_cred(req, &old, false, "FSETID",
> +                                      &cap_fsetid_dropped);
> +        if (ret) {
> +            saverr = ret;
> +            goto out;
> +        }
> +        switched_creds = true;
> +    }
>      if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
>          fd = openat(lo->proc_self_fd, procname, O_RDONLY);
>          if (fd < 0) {
> @@ -3021,6 +3090,12 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
>          saverr = ret == -1 ? errno : 0;
>          FCHDIR_NOFAIL(lo->root.fd);
>      }
> +    if (switched_creds) {
> +        if (cap_fsetid_dropped)
> +            lo_restore_cred_gain_cap(&old, false, "FSETID");
> +        else
> +            lo_restore_cred(&old, false);
> +    }
>  
>  out:
>      if (fd >= 0) {
> -- 
> 2.25.4
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

