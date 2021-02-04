Date: Thu, 4 Feb 2021 12:08:40 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20210204120840.GG3039@work-vm>
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
	<20201215162119.27360-7-zhangjiachen.jaycee@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215162119.27360-7-zhangjiachen.jaycee@bytedance.com>
Subject: Re: [Virtio-fs] [RFC PATCH 6/9] virtiofsd: Add two new options for
 crash reconnection
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Cc: virtio-fs@redhat.com, Xie Yongji <xieyongji@bytedance.com>, qemu-devel@nongnu.org, "Michael S . Tsirkin" <mst@redhat.com>

* Jiachen Zhang (zhangjiachen.jaycee@bytedance.com) wrote:
> We add two options for virtiofsd crash reconnection: reconnect |
> no_reconnect(default) and
> 
> User of virtiofsd should set "-o reconnect" for crash reconnection. Note
> that, when "-o reconnect" is set, some options will not be supported and we
> need to disable them:
> 
>   - mount namespace: When mount namespace is enabled, reconnected
>     virtiofsd will failed to link/rename for EXDEV. The reason is, when
>     virtiofsd is sandboxed by mount namespace, attempts to link/rename
>     the fds opened before crashing (also recovered from QEMU) will be
>     considered as across mount operations between mounts, which is not
>     allowed by host kernel.
> 
>     So we introduce another option "-o mount_ns|no_mount_ns" (mount_ns
>     by default, and takes no effect when sandbox=chroot is specified).
>     The option "-o no_mount_ns" should be used with "-o reconnect".

Why not just use -o sandbox=chroot?

>   - remote locking: As it is hard to determine wether a file is locked or
>     not when handling inflight locking requests, we should specify "-o
>     no_posix_lock" (default) and "-o no_flock" (default).
> 
>   - extended attributes: When handling inflight removexattr requests after
>     reconnecting, it is hard to determine wether a attr is already removed
>     or not. Therefore, we should also use "-o noxattr" (default) with "-o
>     reconnect".

Can you explain a bit more about why removexattr is hard to restart?

Dave
> 
> Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>  tools/virtiofsd/helper.c         |   9 +++
>  tools/virtiofsd/passthrough_ll.c | 112 ++++++++++++++++++++++---------
>  2 files changed, 88 insertions(+), 33 deletions(-)
> 
> diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
> index 75ac48dec2..e0d6525b1a 100644
> --- a/tools/virtiofsd/helper.c
> +++ b/tools/virtiofsd/helper.c
> @@ -174,6 +174,10 @@ void fuse_cmdline_help(void)
>             "                               - chroot: chroot(2) into shared\n"
>             "                                 directory (use in containers)\n"
>             "                               default: namespace\n"
> +           "    -o mount_ns|no_mount_ns    enable/disable mount namespace\n"
> +           "                               default: mount_ns\n"
> +           "                               note: if chroot sandbox mode is used,\n"
> +           "                               mount_ns will not take effect.\n"
>             "    -o timeout=<number>        I/O timeout (seconds)\n"
>             "                               default: depends on cache= option.\n"
>             "    -o writeback|no_writeback  enable/disable writeback cache\n"
> @@ -191,6 +195,11 @@ void fuse_cmdline_help(void)
>             "                               to virtiofsd from guest applications.\n"
>             "                               default: no_allow_direct_io\n"
>             "    -o announce_submounts      Announce sub-mount points to the guest\n"
> +           "    -o reconnect|no_reconnect  enable/disable crash reconnection\n"
> +           "                               to enable crash reconnection, the options\n"
> +           "                               no_mount_ns, no_flock, no_posix_lock, and\n"
> +           "                               no_xattr should also be set.\n"
> +           "                               default: no_reconnect\n"
>             );
>  }
>  
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 815b001076..73a50bd7a3 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -170,6 +170,8 @@ struct lo_data {
>      pthread_mutex_t mutex;
>      int sandbox;
>      int debug;
> +    int mount_ns;
> +    int reconnect;
>      int writeback;
>      int flock;
>      int posix_lock;
> @@ -204,8 +206,12 @@ static const struct fuse_opt lo_opts[] = {
>      { "sandbox=chroot",
>        offsetof(struct lo_data, sandbox),
>        SANDBOX_CHROOT },
> +    { "reconnect", offsetof(struct lo_data, reconnect), 1 },
> +    { "no_reconnect", offsetof(struct lo_data, reconnect), 0 },
>      { "writeback", offsetof(struct lo_data, writeback), 1 },
>      { "no_writeback", offsetof(struct lo_data, writeback), 0 },
> +    { "mount_ns", offsetof(struct lo_data, mount_ns), 1 },
> +    { "no_mount_ns", offsetof(struct lo_data, mount_ns), 0 },
>      { "source=%s", offsetof(struct lo_data, source), 0 },
>      { "flock", offsetof(struct lo_data, flock), 1 },
>      { "no_flock", offsetof(struct lo_data, flock), 0 },
> @@ -3047,8 +3053,14 @@ static void setup_namespaces(struct lo_data *lo, struct fuse_session *se)
>       * an empty network namespace to prevent TCP/IP and other network
>       * activity in case this process is compromised.
>       */
> -    if (unshare(CLONE_NEWPID | CLONE_NEWNS | CLONE_NEWNET) != 0) {
> -        fuse_log(FUSE_LOG_ERR, "unshare(CLONE_NEWPID | CLONE_NEWNS): %m\n");
> +    int unshare_flag;
> +    if (lo->mount_ns) {
> +        unshare_flag = CLONE_NEWPID | CLONE_NEWNS | CLONE_NEWNET;
> +    } else {
> +        unshare_flag = CLONE_NEWPID | CLONE_NEWNET;
> +    }
> +    if (unshare(unshare_flag) != 0) {
> +        fuse_log(FUSE_LOG_ERR, "unshare(): %m\n");
>          exit(1);
>      }
>  
> @@ -3083,38 +3095,47 @@ static void setup_namespaces(struct lo_data *lo, struct fuse_session *se)
>      /* Send us SIGTERM when the parent thread terminates, see prctl(2) */
>      prctl(PR_SET_PDEATHSIG, SIGTERM);
>  
> -    /*
> -     * If the mounts have shared propagation then we want to opt out so our
> -     * mount changes don't affect the parent mount namespace.
> -     */
> -    if (mount(NULL, "/", NULL, MS_REC | MS_SLAVE, NULL) < 0) {
> -        fuse_log(FUSE_LOG_ERR, "mount(/, MS_REC|MS_SLAVE): %m\n");
> -        exit(1);
> -    }
> +    if (lo->mount_ns) {
> +        /*
> +         * If the mounts have shared propagation then we want to opt out so our
> +         * mount changes don't affect the parent mount namespace.
> +         */
> +        if (mount(NULL, "/", NULL, MS_REC | MS_SLAVE, NULL) < 0) {
> +            fuse_log(FUSE_LOG_ERR, "mount(/, MS_REC|MS_SLAVE): %m\n");
> +            exit(1);
> +        }
>  
> -    /* The child must remount /proc to use the new pid namespace */
> -    if (mount("proc", "/proc", "proc",
> -              MS_NODEV | MS_NOEXEC | MS_NOSUID | MS_RELATIME, NULL) < 0) {
> -        fuse_log(FUSE_LOG_ERR, "mount(/proc): %m\n");
> -        exit(1);
> -    }
> +        /* The child must remount /proc to use the new pid namespace */
> +        if (mount("proc", "/proc", "proc",
> +                  MS_NODEV | MS_NOEXEC | MS_NOSUID | MS_RELATIME, NULL) < 0) {
> +            fuse_log(FUSE_LOG_ERR, "mount(/proc): %m\n");
> +            exit(1);
> +        }
>  
> -    /*
> -     * We only need /proc/self/fd. Prevent ".." from accessing parent
> -     * directories of /proc/self/fd by bind-mounting it over /proc. Since / was
> -     * previously remounted with MS_REC | MS_SLAVE this mount change only
> -     * affects our process.
> -     */
> -    if (mount("/proc/self/fd", "/proc", NULL, MS_BIND, NULL) < 0) {
> -        fuse_log(FUSE_LOG_ERR, "mount(/proc/self/fd, MS_BIND): %m\n");
> -        exit(1);
> -    }
> +        /*
> +         * We only need /proc/self/fd. Prevent ".." from accessing parent
> +         * directories of /proc/self/fd by bind-mounting it over /proc. Since
> +         * / was previously remounted with MS_REC | MS_SLAVE this mount change
> +         * only affects our process.
> +         */
> +        if (mount("/proc/self/fd", "/proc", NULL, MS_BIND, NULL) < 0) {
> +            fuse_log(FUSE_LOG_ERR, "mount(/proc/self/fd, MS_BIND): %m\n");
> +            exit(1);
> +        }
>  
> -    /* Get the /proc (actually /proc/self/fd, see above) file descriptor */
> -    lo->proc_self_fd = open("/proc", O_PATH);
> -    if (lo->proc_self_fd == -1) {
> -        fuse_log(FUSE_LOG_ERR, "open(/proc, O_PATH): %m\n");
> -        exit(1);
> +        /* Get the /proc (actually /proc/self/fd, see above) file descriptor */
> +        lo->proc_self_fd = open("/proc", O_PATH);
> +        if (lo->proc_self_fd == -1) {
> +            fuse_log(FUSE_LOG_ERR, "open(/proc, O_PATH): %m\n");
> +            exit(1);
> +        }
> +    } else {
> +        /* Now we can get our /proc/self/fd directory file descriptor */
> +        lo->proc_self_fd = open("/proc/self/fd", O_PATH);
> +        if (lo->proc_self_fd == -1) {
> +            fuse_log(FUSE_LOG_ERR, "open(/proc/self/fd, O_PATH): %m\n");
> +            exit(1);
> +        }
>      }
>  }
>  
> @@ -3347,7 +3368,9 @@ static void setup_sandbox(struct lo_data *lo, struct fuse_session *se,
>  {
>      if (lo->sandbox == SANDBOX_NAMESPACE) {
>          setup_namespaces(lo, se);
> -        setup_mounts(lo->source);
> +        if (lo->mount_ns) {
> +            setup_mounts(lo->source);
> +        }
>      } else {
>          setup_chroot(lo);
>      }
> @@ -3438,7 +3461,11 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
>      struct stat stat;
>      uint64_t mnt_id;
>  
> -    fd = open("/", O_PATH);
> +    if (lo->mount_ns) {
> +        fd = open("/", O_PATH);
> +    } else {
> +        fd = open(lo->source, O_PATH);
> +    }
>      if (fd == -1) {
>          fuse_log(FUSE_LOG_ERR, "open(%s, O_PATH): %m\n", lo->source);
>          exit(1);
> @@ -3515,6 +3542,9 @@ int main(int argc, char *argv[])
>      lo.allow_direct_io = 0,
>      lo.proc_self_fd = -1;
>  
> +    lo.reconnect = 0;
> +    lo.mount_ns = 1;
> +
>      /* Don't mask creation mode, kernel already did that */
>      umask(0);
>  
> @@ -3577,6 +3607,22 @@ int main(int argc, char *argv[])
>          goto err_out1;
>      }
>  
> +    /* For sandbox mode "chroot", set the mount_ns option to 0. */
> +    if (lo.sandbox == SANDBOX_CHROOT) {
> +        lo.mount_ns = 0;
> +    }
> +
> +    if (lo.reconnect) {
> +        if ((lo.sandbox == SANDBOX_NAMESPACE && lo.mount_ns) || lo.flock
> +                                               || lo.posix_lock || lo.xattr) {
> +            printf("Mount namespace, remote lock, and extended attributes"
> +                   " are not supported by reconnection (-o reconnect). Please "
> +                   "specify  -o no_mount_ns, -o no_flock (default), -o"
> +                   "no_posix_lock (default), and -o no_xattr (default).\n");
> +            exit(1);
> +        }
> +    }
> +
>      if (opts.log_level != 0) {
>          current_log_level = opts.log_level;
>      } else {
> -- 
> 2.20.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

