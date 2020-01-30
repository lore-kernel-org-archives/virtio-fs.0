Date: Thu, 30 Jan 2020 10:02:48 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200130150248.GB26448@redhat.com>
References: <20200128101819.21766-1-misono.tomohiro@jp.fujitsu.com>
	<20200128101819.21766-3-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128101819.21766-3-misono.tomohiro@jp.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH v2 2/2] virtiofsd: Add support of posix_acl
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: virtio-fs@redhat.com

On Tue, Jan 28, 2020 at 07:18:19PM +0900, Misono Tomohiro wrote:
> This commit adds support of posix_acl which is enabled by 'posix_acl'
> option (default: disabled).
> 
> If posix_acl is enabled, virtiofsd handles umask handling otherwise done
> in guest kenrel in order to treat default ACL correctly.
> 
> With this, ACL-related xfstest generic/{099,237,319,444} passes on XFS
> backend.

Can you please explain what's the problem with current code.

Thanks
Vivek
> 
> Implementation:
>   virtiofsd adds FUSE_CAP_POSIX_ACL/FUSE_CAP_DONT_MASK to INIT replay if
>  posix_acl is enabled. This results in skipping umask handling in guest
>  kernel. In turn, virtiofsd sets umask before creating files by using
>  umask value included in fuse_request and restore umask after that.
>  Note that calling umask() is ok since now each worker thread has called
>  unshare(CLONE_FS) when starting up.
> 
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> ---
>  tools/virtiofsd/helper.c         |  3 +++
>  tools/virtiofsd/passthrough_ll.c | 36 ++++++++++++++++++++++++++------
>  tools/virtiofsd/seccomp.c        |  1 +
>  3 files changed, 34 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
> index 0801cf752c..97968a9385 100644
> --- a/tools/virtiofsd/helper.c
> +++ b/tools/virtiofsd/helper.c
> @@ -171,6 +171,9 @@ void fuse_cmdline_help(void)
>             "                               default: no_writeback\n"
>             "    -o xattr|no_xattr          enable/disable xattr\n"
>             "                               default: no_xattr\n"
> +           "    -o posix_acl|no_posxi_acl  enable/disable posix_acl\n"
> +           "                               enabling this also enables xattr\n"
> +           "                               default: no_posix_acl\n"
>             );
>  }
>  
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 6bcc33e0eb..e1bb261b51 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -152,6 +152,7 @@ struct lo_data {
>      int flock;
>      int posix_lock;
>      int xattr;
> +    int posix_acl;
>      char *source;
>      double timeout;
>      int cache;
> @@ -182,6 +183,8 @@ static const struct fuse_opt lo_opts[] = {
>      { "no_posix_lock", offsetof(struct lo_data, posix_lock), 0 },
>      { "xattr", offsetof(struct lo_data, xattr), 1 },
>      { "no_xattr", offsetof(struct lo_data, xattr), 0 },
> +    { "posix_acl", offsetof(struct lo_data, posix_acl), 1 },
> +    { "no_posix_acl", offsetof(struct lo_data, posix_acl), 0 },
>      { "timeout=%lf", offsetof(struct lo_data, timeout), 0 },
>      { "timeout=", offsetof(struct lo_data, timeout_set), 1 },
>      { "cache=none", offsetof(struct lo_data, cache), CACHE_NONE },
> @@ -587,6 +590,17 @@ static void lo_init(void *userdata, struct fuse_conn_info *conn)
>          fuse_log(FUSE_LOG_DEBUG, "lo_init: disabling readdirplus\n");
>          conn->want &= ~FUSE_CAP_READDIRPLUS;
>      }
> +
> +    if (conn->capable & FUSE_CAP_POSIX_ACL) {
> +        if (lo->posix_acl) {
> +            if (!lo->xattr)  {
> +                fuse_log(FUSE_LOG_DEBUG, "lo_init: enabling xattr for ACL\n");
> +                lo->xattr = 1;
> +            }
> +            fuse_log(FUSE_LOG_DEBUG, "lo_init: enabling ACL\n");
> +            conn->want |= (FUSE_CAP_POSIX_ACL | FUSE_CAP_DONT_MASK);
> +        }
> +    }
>  }
>  
>  static int64_t *version_ptr(struct lo_data *lo, struct lo_inode *inode)
> @@ -1137,9 +1151,11 @@ static void lo_lookup(fuse_req_t req, fuse_ino_t parent, const char *name)
>  /*
>   * Change to uid/gid of caller so that file is created with
>   * ownership of caller.
> + * Also update umask if posix_acl is enabled.
>   * TODO: What about selinux context?
>   */
> -static int lo_change_cred(fuse_req_t req, struct lo_cred *old)
> +static int lo_change_cred_and_umask(fuse_req_t req, struct lo_cred *old,
> +                                    struct lo_data *lo)
>  {
>      int res;
>  
> @@ -1159,11 +1175,15 @@ static int lo_change_cred(fuse_req_t req, struct lo_cred *old)
>          return errno_save;
>      }
>  
> +    if (lo->posix_acl) {
> +        umask(req->ctx.umask);
> +    }
> +
>      return 0;
>  }
>  
>  /* Regain Privileges */
> -static void lo_restore_cred(struct lo_cred *old)
> +static void lo_restore_cred_and_umask(struct lo_cred *old, struct lo_data *lo)
>  {
>      int res;
>  
> @@ -1178,6 +1198,10 @@ static void lo_restore_cred(struct lo_cred *old)
>          fuse_log(FUSE_LOG_ERR, "setegid(%u): %m\n", old->egid);
>          exit(1);
>      }
> +
> +    if (lo->posix_acl) {
> +        umask(0);
> +    }
>  }
>  
>  static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
> @@ -1204,7 +1228,7 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
>  
>      saverr = ENOMEM;
>  
> -    saverr = lo_change_cred(req, &old);
> +    saverr = lo_change_cred_and_umask(req, &old, lo);
>      if (saverr) {
>          goto out;
>      }
> @@ -1213,7 +1237,7 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
>  
>      saverr = errno;
>  
> -    lo_restore_cred(&old);
> +    lo_restore_cred_and_umask(&old, lo);
>  
>      if (res == -1) {
>          goto out;
> @@ -1898,7 +1922,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
>          return;
>      }
>  
> -    err = lo_change_cred(req, &old);
> +    err = lo_change_cred_and_umask(req, &old, lo);
>      if (err) {
>          goto out;
>      }
> @@ -1908,7 +1932,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
>      fd = openat(parent_inode->fd, name, (fi->flags | O_CREAT) & ~O_NOFOLLOW,
>                  mode);
>      err = fd == -1 ? errno : 0;
> -    lo_restore_cred(&old);
> +    lo_restore_cred_and_umask(&old, lo);
>  
>      if (!err) {
>          ssize_t fh;
> diff --git a/tools/virtiofsd/seccomp.c b/tools/virtiofsd/seccomp.c
> index 9ee99e4725..1b6f579452 100644
> --- a/tools/virtiofsd/seccomp.c
> +++ b/tools/virtiofsd/seccomp.c
> @@ -102,6 +102,7 @@ static const int syscall_whitelist[] = {
>      SCMP_SYS(symlinkat),
>      SCMP_SYS(time), /* Rarely needed, except on static builds */
>      SCMP_SYS(tgkill),
> +    SCMP_SYS(umask),
>      SCMP_SYS(unlinkat),
>      SCMP_SYS(unshare),
>      SCMP_SYS(utimensat),
> -- 
> 2.21.1
> 

