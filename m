Date: Thu, 22 Oct 2020 20:19:54 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201022191954.GK2951@work-vm>
References: <20201008085534.16070-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008085534.16070-1-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3] virtiofsd: add container-friendly -o
 sandbox=chroot option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: vromanso@redhat.com, qemu-devel@nongnu.org, rmohr@redhat.com, virtio-fs@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, mpatel@redhat.com, vgoyal@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> virtiofsd cannot run in a container because CAP_SYS_ADMIN is required to
> create namespaces.
> 
> Introduce a weaker sandbox mode that is sufficient in container
> environments because the container runtime already sets up namespaces.
> Use chroot to restrict path traversal to the shared directory.
> 
> virtiofsd loses the following:
> 
> 1. Mount namespace. The process chroots to the shared directory but
>    leaves the mounts in place. Seccomp rejects mount(2)/umount(2)
>    syscalls.
> 
> 2. Pid namespace. This should be fine because virtiofsd is the only
>    process running in the container.
> 
> 3. Network namespace. This should be fine because seccomp already
>    rejects the connect(2) syscall, but an additional layer of security
>    is lost. Container runtime-specific network security policies can be
>    used drop network traffic (except for the vhost-user UNIX domain
>    socket).
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

I've just tripped over another case where this probably helps (but not
yet tested...); pivot_root doesn't work if your current / isn't a
mountpoint - so you can't currently run the existing virtiofsd inside
a chroot.

(pivot_root is awful for telling you this - it has 6 different manpage
listed reasons it might return EINVAL and leaves you to figure out how
you offended it).

Dave

> ---
> v3:
>  * Rebased onto David Gilbert's latest migration & virtiofsd pull
>    request
> 
>  tools/virtiofsd/helper.c         |  8 +++++
>  tools/virtiofsd/passthrough_ll.c | 57 ++++++++++++++++++++++++++++++--
>  docs/tools/virtiofsd.rst         | 32 ++++++++++++++----
>  3 files changed, 88 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
> index 85770d63f1..2e181a49b5 100644
> --- a/tools/virtiofsd/helper.c
> +++ b/tools/virtiofsd/helper.c
> @@ -166,6 +166,14 @@ void fuse_cmdline_help(void)
>             "                               enable/disable readirplus\n"
>             "                               default: readdirplus except with "
>             "cache=none\n"
> +           "    -o sandbox=namespace|chroot\n"
> +           "                               sandboxing mode:\n"
> +           "                               - namespace: mount, pid, and net\n"
> +           "                                 namespaces with pivot_root(2)\n"
> +           "                                 into shared directory\n"
> +           "                               - chroot: chroot(2) into shared\n"
> +           "                                 directory (use in containers)\n"
> +           "                               default: namespace\n"
>             "    -o timeout=<number>        I/O timeout (seconds)\n"
>             "                               default: depends on cache= option.\n"
>             "    -o writeback|no_writeback  enable/disable writeback cache\n"
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index ff53df4451..5b9064278a 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -137,8 +137,14 @@ enum {
>      CACHE_ALWAYS,
>  };
>  
> +enum {
> +    SANDBOX_NAMESPACE,
> +    SANDBOX_CHROOT,
> +};
> +
>  struct lo_data {
>      pthread_mutex_t mutex;
> +    int sandbox;
>      int debug;
>      int writeback;
>      int flock;
> @@ -163,6 +169,12 @@ struct lo_data {
>  };
>  
>  static const struct fuse_opt lo_opts[] = {
> +    { "sandbox=namespace",
> +      offsetof(struct lo_data, sandbox),
> +      SANDBOX_NAMESPACE },
> +    { "sandbox=chroot",
> +      offsetof(struct lo_data, sandbox),
> +      SANDBOX_CHROOT },
>      { "writeback", offsetof(struct lo_data, writeback), 1 },
>      { "no_writeback", offsetof(struct lo_data, writeback), 0 },
>      { "source=%s", offsetof(struct lo_data, source), 0 },
> @@ -2660,6 +2672,41 @@ static void setup_capabilities(char *modcaps_in)
>      pthread_mutex_unlock(&cap.mutex);
>  }
>  
> +/*
> + * Use chroot as a weaker sandbox for environments where the process is
> + * launched without CAP_SYS_ADMIN.
> + */
> +static void setup_chroot(struct lo_data *lo)
> +{
> +    lo->proc_self_fd = open("/proc/self/fd", O_PATH);
> +    if (lo->proc_self_fd == -1) {
> +        fuse_log(FUSE_LOG_ERR, "open(\"/proc/self/fd\", O_PATH): %m\n");
> +        exit(1);
> +    }
> +
> +    /*
> +     * Make the shared directory the file system root so that FUSE_OPEN
> +     * (lo_open()) cannot escape the shared directory by opening a symlink.
> +     *
> +     * The chroot(2) syscall is later disabled by seccomp and the
> +     * CAP_SYS_CHROOT capability is dropped so that tampering with the chroot
> +     * is not possible.
> +     *
> +     * However, it's still possible to escape the chroot via lo->proc_self_fd
> +     * but that requires first gaining control of the process.
> +     */
> +    if (chroot(lo->source) != 0) {
> +        fuse_log(FUSE_LOG_ERR, "chroot(\"%s\"): %m\n", lo->source);
> +        exit(1);
> +    }
> +
> +    /* Move into the chroot */
> +    if (chdir("/") != 0) {
> +        fuse_log(FUSE_LOG_ERR, "chdir(\"/\"): %m\n");
> +        exit(1);
> +    }
> +}
> +
>  /*
>   * Lock down this process to prevent access to other processes or files outside
>   * source directory.  This reduces the impact of arbitrary code execution bugs.
> @@ -2667,8 +2714,13 @@ static void setup_capabilities(char *modcaps_in)
>  static void setup_sandbox(struct lo_data *lo, struct fuse_session *se,
>                            bool enable_syslog)
>  {
> -    setup_namespaces(lo, se);
> -    setup_mounts(lo->source);
> +    if (lo->sandbox == SANDBOX_NAMESPACE) {
> +        setup_namespaces(lo, se);
> +        setup_mounts(lo->source);
> +    } else {
> +        setup_chroot(lo);
> +    }
> +
>      setup_seccomp(enable_syslog);
>      setup_capabilities(g_strdup(lo->modcaps));
>  }
> @@ -2815,6 +2867,7 @@ int main(int argc, char *argv[])
>      struct fuse_session *se;
>      struct fuse_cmdline_opts opts;
>      struct lo_data lo = {
> +        .sandbox = SANDBOX_NAMESPACE,
>          .debug = 0,
>          .writeback = 0,
>          .posix_lock = 0,
> diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
> index 7ecee49834..65f8e76569 100644
> --- a/docs/tools/virtiofsd.rst
> +++ b/docs/tools/virtiofsd.rst
> @@ -17,13 +17,24 @@ This program is designed to work with QEMU's ``--device vhost-user-fs-pci``
>  but should work with any virtual machine monitor (VMM) that supports
>  vhost-user.  See the Examples section below.
>  
> -This program must be run as the root user.  Upon startup the program will
> -switch into a new file system namespace with the shared directory tree as its
> -root.  This prevents "file system escapes" due to symlinks and other file
> -system objects that might lead to files outside the shared directory.  The
> -program also sandboxes itself using seccomp(2) to prevent ptrace(2) and other
> -vectors that could allow an attacker to compromise the system after gaining
> -control of the virtiofsd process.
> +This program must be run as the root user.  The program drops privileges where
> +possible during startup although it must be able to create and access files
> +with any uid/gid:
> +
> +* The ability to invoke syscalls is limited using seccomp(2).
> +* Linux capabilities(7) are dropped.
> +
> +In "namespace" sandbox mode the program switches into a new file system
> +namespace and invokes pivot_root(2) to make the shared directory tree its root.
> +A new pid and net namespace is also created to isolate the process.
> +
> +In "chroot" sandbox mode the program invokes chroot(2) to make the shared
> +directory tree its root. This mode is intended for container environments where
> +the container runtime has already set up the namespaces and the program does
> +not have permission to create namespaces itself.
> +
> +Both sandbox modes prevent "file system escapes" due to symlinks and other file
> +system objects that might lead to files outside the shared directory.
>  
>  Options
>  -------
> @@ -69,6 +80,13 @@ Options
>    * readdirplus|no_readdirplus -
>      Enable/disable readdirplus.  The default is ``readdirplus``.
>  
> +  * sandbox=namespace|chroot -
> +    Sandbox mode:
> +    - namespace: Create mount, pid, and net namespaces and pivot_root(2) into
> +    the shared directory.
> +    - chroot: chroot(2) into shared directory (use in containers).
> +    The default is "namespace".
> +
>    * source=PATH -
>      Share host directory tree located at PATH.  This option is required.
>  
> -- 
> 2.26.2
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

