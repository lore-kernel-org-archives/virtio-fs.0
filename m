Date: Tue, 9 Jun 2020 08:31:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200609123155.GB211764@redhat.com>
References: <20200608093111.14942-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608093111.14942-1-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Whitelist fchmod
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, qemu-stable@nongnu.org

On Mon, Jun 08, 2020 at 11:31:11AM +0200, Max Reitz wrote:
> lo_setattr() invokes fchmod() in a rarely used code path, so it should
> be whitelisted or virtiofsd will crash with EBADSYS.
> 
> Said code path can be triggered for example as follows:
> 
> On the host, in the shared directory, create a file with the sticky bit
> set and a security.capability xattr:
> (1) # touch foo
> (2) # chmod u+s foo
> (3) # setcap '' foo
> 
> Then in the guest let some process truncate that file after it has
> dropped all of its capabilities (at least CAP_FSETID):
> 
> int main(int argc, char *argv[])
> {
>     capng_setpid(getpid());
>     capng_clear(CAPNG_SELECT_BOTH);
>     capng_updatev(CAPNG_ADD, CAPNG_PERMITTED | CAPNG_EFFECTIVE, 0);
>     capng_apply(CAPNG_SELECT_BOTH);
> 
>     ftruncate(open(argv[1], O_RDWR), 0);
> }
> 
> This will cause the guest kernel to drop the sticky bit (i.e. perform a
> mode change) as part of the truncate (where FATTR_FH is set), and that
> will cause virtiofsd to invoke fchmod() instead of fchmodat().
> 
> (A similar configuration exists further below with futimens() vs.
> utimensat(), but the former is not a syscall but just a wrapper for the
> latter, so no further whitelisting is required.)
> 
> Buglink: https://bugzilla.redhat.com/show_bug.cgi?id=1842667
> Reported-by: Qian Cai <caiqian@redhat.com>
> Cc: qemu-stable@nongnu.org
> Signed-off-by: Max Reitz <mreitz@redhat.com>

Nice catch. 

Reviewed-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  tools/virtiofsd/seccomp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/virtiofsd/seccomp.c b/tools/virtiofsd/seccomp.c
> index bd9e7b083c..3b1522acdd 100644
> --- a/tools/virtiofsd/seccomp.c
> +++ b/tools/virtiofsd/seccomp.c
> @@ -42,6 +42,7 @@ static const int syscall_whitelist[] = {
>      SCMP_SYS(exit_group),
>      SCMP_SYS(fallocate),
>      SCMP_SYS(fchdir),
> +    SCMP_SYS(fchmod),
>      SCMP_SYS(fchmodat),
>      SCMP_SYS(fchownat),
>      SCMP_SYS(fcntl),
> -- 
> 2.26.2
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

