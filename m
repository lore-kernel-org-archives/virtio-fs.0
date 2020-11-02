References: <20201102150750.34565-1-dgilbert@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <e1a007ed-7a9f-38cd-4003-144d0e99dd6e@redhat.com>
Date: Mon, 2 Nov 2020 16:11:44 +0100
MIME-Version: 1.0
In-Reply-To: <20201102150750.34565-1-dgilbert@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Seccomp: Add 'send' for syslog
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, amulmek1@in.ibm.com, stefanha@redhat.com

On 11/2/20 4:07 PM, Dr. David Alan Gilbert (git) wrote:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> 
> On ppc it looks like syslog ends up using 'send' rather than 'sendto'.
> 
> Reference: https://github.com/kata-containers/kata-containers/issues/1050
> 
> Reported-by: amulmek1@in.ibm.com
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  tools/virtiofsd/passthrough_seccomp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
> index eb9af8265f..672fb72a31 100644
> --- a/tools/virtiofsd/passthrough_seccomp.c
> +++ b/tools/virtiofsd/passthrough_seccomp.c
> @@ -118,6 +118,7 @@ static const int syscall_whitelist[] = {
>  
>  /* Syscalls used when --syslog is enabled */
>  static const int syscall_whitelist_syslog[] = {

Is it worth restricting the syscall to POWER?

   #if defined(__powerpc64__)

> +    SCMP_SYS(send),

   #endif

>      SCMP_SYS(sendto),
>  };
>  
> 

