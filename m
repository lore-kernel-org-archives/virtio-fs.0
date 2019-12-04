DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=Aa169N1UtEIbyfjf6WBYNseasf1KWqknd0jj88Vj308=;
	b=afj/EV0zkdYcF4uEEMRb7r7guMtNJKw8AhN85TR4IDrxZA4WCxp1lLYA91kIsN4P23I/o4/uiX5cNsSFitwYDaSknLa8Q2aIr9wHZ8NmePsC5QZ2dmDKjoqneRwRVcXb4Avzk6NFCWKMj0AqP7C7GC9kpMGibAMLubM/hfY5+OY=
From: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Date: Wed, 4 Dec 2019 07:20:46 +0000
Message-ID: <OSBPR01MB4582D3E0F96FEF4949B2A544E55D0@OSBPR01MB4582.jpnprd01.prod.outlook.com>
References: <20191203131423.40962-1-dgilbert@redhat.com>
	<20191203131423.40962-2-dgilbert@redhat.com>
In-Reply-To: <20191203131423.40962-2-dgilbert@redhat.com>
Content-Language: ja-JP
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 1/2] virtiofsd: cap-ng helpers
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "'Dr. David Alan Gilbert (git)'" <dgilbert@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>

> -----Original Message-----
> From: virtio-fs-bounces@redhat.com [mailto:virtio-fs-bounces@redhat.com] On Behalf Of Dr. David Alan Gilbert (git)
> Sent: Tuesday, December 3, 2019 10:14 PM
> To: virtio-fs@redhat.com; vgoyal@redhat.com
> Subject: [Virtio-fs] [PATCH 1/2] virtiofsd: cap-ng helpers
> 
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> 
> libcap-ng reads /proc during capng_get_caps_process, and virtiofsd's
> sandboxing doesn't have /proc mounted; thus we have to do the
> caps read before we sandbox it and save/restore the state.
> 
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  Makefile                           |  2 +-
>  contrib/virtiofsd/passthrough_ll.c | 72 ++++++++++++++++++++++++++++++
>  2 files changed, 73 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 237cbdfee1..1484c23a9b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -323,7 +323,7 @@ HELPERS-$(call land,$(CONFIG_SOFTMMU),$(CONFIG_LINUX)) = qemu-bridge-helper$(EXE
> 
>  ifdef CONFIG_LINUX
>  ifdef CONFIG_SECCOMP
> -ifdef CONFIG_LIBCAP
> +ifdef CONFIG_LIBCAP_NG
>  HELPERS-y += virtiofsd$(EXESUF)
>  vhost-user-json-y += contrib/virtiofsd/50-qemu-virtiofsd.json
>  endif
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index 1688071c10..139261efc1 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -47,6 +47,7 @@
>  #include <string.h>
>  #include <syslog.h>
>  #include <limits.h>
> +#include <cap-ng.h>
>  #include <dirent.h>
>  #include <assert.h>
>  #include <errno.h>
> @@ -216,6 +217,13 @@ static const struct fuse_opt lo_opts[] = {
>  };
>  static bool use_syslog = false;
>  static int current_log_level;
> +static struct {
> +	pthread_mutex_t mutex;
> +	void *saved;
> +} cap;
> +/* That we loaded cap-ng in the current thread from the saved */
> +static __thread bool cap_loaded = 0;
> +
>  static void unref_inode_lolocked(struct lo_data *lo, struct lo_inode *inode, uint64_t n);
>  static void put_shared(struct lo_data *lo, struct lo_inode *inode);
> 
> @@ -242,6 +250,37 @@ static struct lo_data *lo_data(fuse_req_t req)
>  	return (struct lo_data *) fuse_req_userdata(req);
>  }
> 
> +/*
> + * Load capng's state from our saved state if the current thread
> + * hadn't previously been loaded.
> + * returns 0 on success
> + */
> +static int load_capng(void)
> +{
> +	if (!cap_loaded) {
> +		pthread_mutex_lock(&cap.mutex);
> +		capng_restore_state(&cap.saved);
> +		/*
> +		 * restore_state free's the saved copy
> +		 * so make another.
> +		 */
> +		cap.saved = capng_save_state();
> +		if (!cap.saved) {
> +			fuse_log(FUSE_LOG_ERR, "capng_save_state (thread)\n");
> +			return -EINVAL;
> +		}
> +		pthread_mutex_unlock(&cap.mutex);
> +
> +		/*
> +		 * We want to use the loaded state for our pid,
> +		 * not the original
> +		 */
> +		capng_setpid(gettid());

Hi,

I got build error on Fedora 30 with glibc 2.29 since gettid() wrapper is introduced in glibc 2.30.
How about using syscall(__NR_gettid) directly? Or is 2.30 required?

Thanks,
Misono

> +		cap_loaded = true;
> +	}
> +	return 0;
> +}
> +
>  /* Helpers for dropping and regaining effective capabilities. Returns 0
>   * on success, error otherwise  */
>  static int drop_effective_cap(const char *cap_name, bool *cap_dropped)
> @@ -2754,6 +2793,35 @@ static void setup_namespaces(struct lo_data *lo, struct fuse_session *se)
>  	}
>  }
> 
> +/*
> + * Capture the capability state, we'll need to restore this for individual
> + * threads later; see load_capng.
> + */
> +static void setup_capng(void)
> +{
> +	/* Note this accesses /proc so has to happen before the sandbox */
> +	if (capng_get_caps_process()) {
> +		fuse_log(FUSE_LOG_ERR, "capng_get_caps_process\n");
> +		exit(1);
> +	}
> +	pthread_mutex_init(&cap.mutex, NULL);
> +	pthread_mutex_lock(&cap.mutex);
> +	cap.saved = capng_save_state();
> +	if (!cap.saved) {
> +		fuse_log(FUSE_LOG_ERR, "capng_save_state\n");
> +		exit(1);
> +	}
> +	pthread_mutex_unlock(&cap.mutex);
> +}
> +
> +static void cleanup_capng(void)
> +{
> +	free(cap.saved);
> +	cap.saved = NULL;
> +	pthread_mutex_destroy(&cap.mutex);
> +}
> +
> +
>  /*
>   * Make the source directory our root so symlinks cannot escape and no other
>   * files are accessible.  Assumes unshare(CLONE_NEWNS) was already called.
> @@ -3173,6 +3241,9 @@ int main(int argc, char *argv[])
> 
>  	setup_nofile_rlimit();
> 
> +	/* Must be before sandbox since it wants /proc */
> +	setup_capng();
> +
>  	setup_sandbox(&lo, se, opts.syslog);
> 
>  	setup_root(&lo, &lo.root);
> @@ -3195,6 +3266,7 @@ int main(int argc, char *argv[])
> 
>  err_out4:
>  	fuse_session_unmount(se);
> +	cleanup_capng();
>  err_out3:
>  	fuse_remove_signal_handlers(se);
>  err_out2:
> --
> 2.23.0
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs


