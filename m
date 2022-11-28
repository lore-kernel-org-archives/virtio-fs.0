Return-Path: <dgilbert@redhat.com>
Date: Mon, 28 Nov 2022 18:47:25 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <Y4UCPQ0E2ZY15aEq@work-vm>
References: <20221125143946.27717-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
In-Reply-To: <20221125143946.27717-1-mhartmay@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Add `sigreturn` to the seccomp
 whitelist
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Marc Hartmayer <mhartmay@linux.ibm.com>
Cc: qemu-devel@nongnu.org, qemu-s390x <qemu-s390x@nongnu.org>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Stefan Liebler <stli@linux.ibm.com>

* Marc Hartmayer (mhartmay@linux.ibm.com) wrote:
> The virtiofsd currently crashes on s390x. This is because of a
> `sigreturn` system call. See audit log below:
> 
> type=SECCOMP msg=audit(1669382477.611:459): auid=4294967295 uid=0 gid=0 ses=4294967295 subj=system_u:system_r:virtd_t:s0-s0:c0.c1023 pid=6649 comm="virtiofsd" exe="/usr/libexec/virtiofsd" sig=31 arch=80000016 syscall=119 compat=0 ip=0x3fff15f748a code=0x80000000AUID="unset" UID="root" GID="root" ARCH=s390x SYSCALL=sigreturn

I'm curious; doesn't that mean that some signal is being delivered and
you're returning?  Which one?

Dave

> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  tools/virtiofsd/passthrough_seccomp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
> index 888295c073de..0033dab4939e 100644
> --- a/tools/virtiofsd/passthrough_seccomp.c
> +++ b/tools/virtiofsd/passthrough_seccomp.c
> @@ -110,6 +110,7 @@ static const int syscall_allowlist[] = {
>  #endif
>      SCMP_SYS(set_robust_list),
>      SCMP_SYS(setxattr),
> +    SCMP_SYS(sigreturn),
>      SCMP_SYS(symlinkat),
>      SCMP_SYS(syncfs),
>      SCMP_SYS(time), /* Rarely needed, except on static builds */
> -- 
> 2.34.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

