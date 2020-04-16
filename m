References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200416164907.244868-3-stefanha@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <989583c7-f7a0-544f-420d-43eb197098cb@redhat.com>
Date: Thu, 16 Apr 2020 19:50:53 +0200
MIME-Version: 1.0
In-Reply-To: <20200416164907.244868-3-stefanha@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 2/2] virtiofsd: drop all capabilities in the
 wait parent process
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

On 4/16/20 6:49 PM, Stefan Hajnoczi wrote:
> All this process does is wait for its child.  No capabilities are
> needed.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>   tools/virtiofsd/passthrough_ll.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index af97ba1c41..0c3f33b074 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2530,6 +2530,17 @@ static void print_capabilities(void)
>       printf("}\n");
>   }
>   
> +/*
> + * Drop all Linux capabilities because the wait parent process only needs to
> + * sit in waitpid(2) and terminate.
> + */
> +static void setup_wait_parent_capabilities(void)
> +{
> +    capng_setpid(syscall(SYS_gettid));

Maybe worth a /* Drop all capabilities */ comment here.

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

> +    capng_clear(CAPNG_SELECT_BOTH);
> +    capng_apply(CAPNG_SELECT_BOTH);
> +}
> +
>   /*
>    * Move to a new mount, net, and pid namespaces to isolate this process.
>    */
> @@ -2561,6 +2572,8 @@ static void setup_namespaces(struct lo_data *lo, struct fuse_session *se)
>           pid_t waited;
>           int wstatus;
>   
> +        setup_wait_parent_capabilities();
> +
>           /* The parent waits for the child */
>           do {
>               waited = waitpid(child, &wstatus, 0);
> 


