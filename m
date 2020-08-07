Date: Fri, 7 Aug 2020 17:33:00 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200807163300.GH2780@work-vm>
References: <20200730194736.173994-1-vgoyal@redhat.com>
	<20200730194736.173994-2-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730194736.173994-2-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 1/5] virtiofsd: Add notion of
	unprivileged mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: berrange@redhat.com, vromanso@redhat.com, qemu-devel@nongnu.org, virtio-fs@redhat.com

* Vivek Goyal (vgoyal@redhat.com) wrote:
> At startup if we are running as non-root user, then internally set
> unpriviliged mode set. Also add a notion of sandbox NONE and set
> that internally in unprivileged mode. setting up namespaces and
> chroot() fails in unpriviliged mode.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index e2fbc614fd..cd91c4a831 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -147,11 +147,13 @@ enum {
>  enum {
>      SANDBOX_NAMESPACE,
>      SANDBOX_CHROOT,
> +    SANDBOX_NONE,
>  };
>  
>  struct lo_data {
>      pthread_mutex_t mutex;
>      int sandbox;
> +    bool unprivileged;
>      int debug;
>      int writeback;
>      int flock;
> @@ -3288,6 +3290,12 @@ int main(int argc, char *argv[])
>      lo_map_init(&lo.dirp_map);
>      lo_map_init(&lo.fd_map);
>  
> +    if (geteuid() != 0) {
> +       lo.unprivileged = true;
> +       lo.sandbox = SANDBOX_NONE;
> +       fuse_log(FUSE_LOG_DEBUG, "Running in unprivileged passthrough mode.\n");
> +    }

I don't like this being automatic; to switch to a less secure mode, the
user should have to explicitly ask for it; we don't want people
accidentally ending up with less security.

Also, I'm not sure that checking for geteuid() != 0  is the right test -
wouldn't the current virtiofsd run with a non-root user as long
as it had the correct capabilities?

I was doing to suggest we match cloud-hypervisor where we added
--disable-sandbox; but with this we now have a trinary switch;
so sandbox=none is probably the right way.

Dave

>      if (fuse_parse_cmdline(&args, &opts) != 0) {
>          goto err_out1;
>      }
> -- 
> 2.25.4
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

