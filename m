Date: Tue, 28 Apr 2020 12:48:15 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200428114815.GC2794@work-vm>
References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200416164907.244868-2-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416164907.244868-2-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 1/2] virtiofsd: only retain file system
	capabilities
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> virtiofsd runs as root but only needs a subset of root's Linux
> capabilities(7).  As a file server its purpose is to create and access
> files on behalf of a client.  It needs to be able to access files with
> arbitrary uid/gid owners.  It also needs to be create device nodes.
> 
> Introduce a Linux capabilities(7) whitelist and drop all capabilities
> that we don't need, making the virtiofsd process less powerful than a
> regular uid root process.
> 
>   # cat /proc/PID/status
>   ...
>           Before           After
>   CapInh: 0000000000000000 0000000000000000
>   CapPrm: 0000003fffffffff 00000000880000df
>   CapEff: 0000003fffffffff 00000000880000df
>   CapBnd: 0000003fffffffff 0000000000000000
>   CapAmb: 0000000000000000 0000000000000000
> 
> Note that file capabilities cannot be used to achieve the same effect on
> the virtiofsd executable because mount is used during sandbox setup.
> Therefore we drop capabilities programmatically at the right point
> during startup.
> 
> This patch only affects the sandboxed child process.  The parent process
> that sits in waitpid(2) still has full root capabilities and will be
> addressed in the next patch.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Looks reasonable to me; I can't see any capabilities in the manpage that
you're missing that make sense.
They also look old enough not to be a problem with reasonably old
systems.



Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  tools/virtiofsd/passthrough_ll.c | 38 ++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 4c35c95b25..af97ba1c41 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2695,6 +2695,43 @@ static void setup_mounts(const char *source)
>      close(oldroot);
>  }
>  
> +/*
> + * Only keep whitelisted capabilities that are needed for file system operation
> + */
> +static void setup_capabilities(void)
> +{
> +    pthread_mutex_lock(&cap.mutex);
> +    capng_restore_state(&cap.saved);
> +
> +    /*
> +     * Whitelist file system-related capabilities that are needed for a file
> +     * server to act like root.  Drop everything else like networking and
> +     * sysadmin capabilities.
> +     *
> +     * Exclusions:
> +     * 1. CAP_LINUX_IMMUTABLE is not included because it's only used via ioctl
> +     *    and we don't support that.
> +     * 2. CAP_MAC_OVERRIDE is not included because it only seems to be
> +     *    used by the Smack LSM.  Omit it until there is demand for it.
> +     */
> +    capng_setpid(syscall(SYS_gettid));
> +    capng_clear(CAPNG_SELECT_BOTH);
> +    capng_updatev(CAPNG_ADD, CAPNG_PERMITTED | CAPNG_EFFECTIVE,
> +            CAP_CHOWN,
> +            CAP_DAC_OVERRIDE,
> +            CAP_DAC_READ_SEARCH,
> +            CAP_FOWNER,
> +            CAP_FSETID,
> +            CAP_SETGID,
> +            CAP_SETUID,
> +            CAP_MKNOD,
> +            CAP_SETFCAP);
> +    capng_apply(CAPNG_SELECT_BOTH);
> +
> +    cap.saved = capng_save_state();
> +    pthread_mutex_unlock(&cap.mutex);
> +}
> +
>  /*
>   * Lock down this process to prevent access to other processes or files outside
>   * source directory.  This reduces the impact of arbitrary code execution bugs.
> @@ -2705,6 +2742,7 @@ static void setup_sandbox(struct lo_data *lo, struct fuse_session *se,
>      setup_namespaces(lo, se);
>      setup_mounts(lo->source);
>      setup_seccomp(enable_syslog);
> +    setup_capabilities();
>  }
>  
>  /* Raise the maximum number of open file descriptors */
> -- 
> 2.25.1
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

