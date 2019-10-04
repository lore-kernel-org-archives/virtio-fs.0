Date: Fri, 4 Oct 2019 19:54:00 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20191004185400.GH2772@work-vm>
References: <20191004110759.32665-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004110759.32665-1-misono.tomohiro@jp.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Add pread64() to seccomp list
 for posix_fallocate()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Misono Tomohiro (misono.tomohiro@jp.fujitsu.com) wrote:
> I test virtiofs with NFS 4.0 as backend and notice that fallocate
> causes system hang (kernel: 5.4-rc1, qemu: virtio-fs-dev branch):
>  $ mount -t virtiofs myfs /mnt
>  $ dd if=/dev/urandom bs=1000 seek=1 count=1 of=/mnt/file
>  $ fallocate -l 2000 /mnt/file # system hang
> 
> This is because:
>  1. virtiofs supports fallocate syscall while NFS 4.0 does not.
>  2. virtiofsd uses posix_fallocate() and it fallbacks to pread64()/
>     pwrite64() sequence to reserve blocks if fallocate syscall is
>     not available.
>  3. pread64() syscall is prohibited by seccomp and virtiofsd thread
>     is killed by SIGSYS.
> 
> So, just add pread64() to seccomp white list to fix this problem.
> 
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Thanks, I've squashed this into our seccomp commit.
(It'll be a little while before I push it out, I need to finish a tidyup
I'm doing).

Dave

> ---
>  contrib/virtiofsd/seccomp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/contrib/virtiofsd/seccomp.c b/contrib/virtiofsd/seccomp.c
> index 93b679271d..88b61bca42 100644
> --- a/contrib/virtiofsd/seccomp.c
> +++ b/contrib/virtiofsd/seccomp.c
> @@ -61,6 +61,7 @@ static const int syscall_whitelist[] = {
>  	SCMP_SYS(ppoll),
>  	SCMP_SYS(prctl), /* TODO restrict to just PR_SET_NAME? */
>  	SCMP_SYS(preadv),
> +	SCMP_SYS(pread64),
>  	SCMP_SYS(pwritev),
>  	SCMP_SYS(pwrite64),
>  	SCMP_SYS(read),
> -- 
> 2.21.0
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

