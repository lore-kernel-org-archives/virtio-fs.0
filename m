Date: Wed, 23 Oct 2019 10:46:36 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20191023094636.GB2834@work-vm>
References: <20191016160157.12414-1-stefanha@redhat.com>
	<20191016160157.12414-3-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016160157.12414-3-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/2] virtiofsd: move to a new pid namespace
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> virtiofsd needs access to /proc/self/fd.  Let's move to a new pid
> namespace so that a compromised process cannot see another other
> processes running on the system.
> 
> One wrinkle in this approach: unshare(CLONE_NEWPID) affects *child*
> processes and not the current process.  Therefore we need to fork the
> pid 1 process that will actually run virtiofsd and leave a parent in
> waitpid(2).  This is not the same thing as daemonization and parent
> processes should not notice a difference.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

OK, I think that's OK (I don't know the mount semantics that well).

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  contrib/virtiofsd/passthrough_ll.c | 95 ++++++++++++++++++++++--------
>  1 file changed, 72 insertions(+), 23 deletions(-)
> 
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index c27ff7d800..b6ee9b2e90 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -56,9 +56,12 @@
>  #include <sys/xattr.h>
>  #include <sys/mman.h>
>  #include <sys/socket.h>
> +#include <sys/types.h>
>  #include <sys/un.h>
> +#include <sys/wait.h>
>  #include <sys/capability.h>
>  
> +
>  #include "ireg.h"
>  #include <sys/mount.h>
>  #include <sys/resource.h>
> @@ -2749,6 +2752,72 @@ static void setup_net_namespace(void)
>  	}
>  }
>  
> +/*
> + * Move to a new pid namespace to prevent access to other processes if this
> + * process is compromised.
> + */
> +static void setup_pid_namespace(void)
> +{
> +	pid_t child;
> +
> +	/*
> +	 * Create a new pid namespace for *child* processes.  We'll have to
> +	 * fork in order to enter the new pid namespace.  A new mount namespace
> +	 * is also needed so that we can remount /proc for the new pid
> +	 * namespace.
> +	 */
> +	if (unshare(CLONE_NEWPID | CLONE_NEWNS) != 0) {
> +		fuse_log(FUSE_LOG_ERR, "unshare(CLONE_NEWPID | CLONE_NEWNS): %m\n");
> +		exit(1);
> +	}
> +
> +	child = fork();
> +	if (child < 0) {
> +		fuse_log(FUSE_LOG_ERR, "fork() failed: %m\n");
> +		exit(1);
> +	}
> +	if (child > 0) {
> +		pid_t waited;
> +		int wstatus;
> +
> +		/* The parent waits for the child */
> +		do {
> +			waited = waitpid(child, &wstatus, 0);
> +		} while (waited < 0 && errno == EINTR);
> +
> +		if (WIFEXITED(wstatus)) {
> +			exit(WEXITSTATUS(wstatus));
> +		}
> +
> +		exit(1);
> +	}
> +
> +	/*
> +	 * If the mounts have shared propagation then we want to opt out so our
> +	 * mount changes don't affect the parent mount namespace.
> +	 */
> +	if (mount(NULL, "/", NULL, MS_REC|MS_SLAVE, NULL) < 0) {
> +		fuse_log(FUSE_LOG_ERR, "mount(/, MS_REC|MS_SLAVE): %m\n");
> +		exit(1);
> +	}
> +
> +	/* The child must remount /proc to use the new pid namespace */
> +	if (mount("proc", "/proc", "proc",
> +		  MS_NODEV | MS_NOEXEC | MS_NOSUID | MS_RELATIME, NULL) < 0) {
> +		fuse_log(FUSE_LOG_ERR, "mount(/proc): %m\n");
> +		exit(1);
> +	}
> +}
> +
> +static void setup_proc_self_fd(struct lo_data *lo)
> +{
> +	lo->proc_self_fd = open("/proc/self/fd", O_PATH);
> +	if (lo->proc_self_fd == -1) {
> +		fuse_log(FUSE_LOG_ERR, "open(/proc/self/fd, O_PATH): %m\n");
> +		exit(1);
> +	}
> +}
> +
>  /* This magic is based on lxc's lxc_pivot_root() */
>  static void setup_pivot_root(const char *source)
>  {
> @@ -2803,20 +2872,10 @@ static void setup_pivot_root(const char *source)
>  
>  /*
>   * Make the source directory our root so symlinks cannot escape and no other
> - * files are accessible.
> + * files are accessible.  Assumes unshare(CLONE_NEWNS) was already called.
>   */
>  static void setup_mount_namespace(const char *source)
>  {
> -	if (unshare(CLONE_NEWNS) != 0) {
> -		fuse_log(FUSE_LOG_ERR, "unshare(CLONE_NEWNS): %m\n");
> -		exit(1);
> -	}
> -
> -	if (mount(NULL, "/", NULL, MS_REC|MS_SLAVE, NULL) < 0) {
> -		fuse_log(FUSE_LOG_ERR, "mount(/, MS_REC|MS_PRIVATE): %m\n");
> -		exit(1);
> -	}
> -
>  	if (mount(source, source, NULL, MS_BIND, NULL) < 0) {
>  		fuse_log(FUSE_LOG_ERR, "mount(%s, %s, MS_BIND): %m\n", source, source);
>  		exit(1);
> @@ -2831,6 +2890,8 @@ static void setup_mount_namespace(const char *source)
>   */
>  static void setup_sandbox(struct lo_data *lo, bool enable_syslog)
>  {
> +	setup_pid_namespace();
> +	setup_proc_self_fd(lo);
>  	setup_net_namespace();
>  	setup_mount_namespace(lo->source);
>  	setup_seccomp(enable_syslog);
> @@ -2860,15 +2921,6 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
>  	g_atomic_int_set(&root->refcount, 2);
>  }
>  
> -static void setup_proc_self_fd(struct lo_data *lo)
> -{
> -	lo->proc_self_fd = open("/proc/self/fd", O_PATH);
> -	if (lo->proc_self_fd == -1) {
> -		fuse_log(FUSE_LOG_ERR, "open(/proc/self/fd, O_PATH): %m\n");
> -		exit(1);
> -	}
> -}
> -
>  /* Raise the maximum number of open file descriptors to the system limit */
>  static void setup_nofile_rlimit(void)
>  {
> @@ -3110,9 +3162,6 @@ int main(int argc, char *argv[])
>  		get_shared(&lo, &lo.root);
>  	}
>  
> -	/* Must be after daemonize to get the right /proc/self/fd */
> -	setup_proc_self_fd(&lo);
> -
>  	setup_sandbox(&lo, opts.syslog);
>  
>  	setup_root(&lo, &lo.root);
> -- 
> 2.21.0
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

