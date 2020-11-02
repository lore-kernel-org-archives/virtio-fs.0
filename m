Date: Mon, 2 Nov 2020 15:17:12 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <20201102151712.GF138796@redhat.com>
References: <20201102150750.34565-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201102150750.34565-1-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Seccomp: Add 'send' for syslog
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, amulmek1@in.ibm.com

On Mon, Nov 02, 2020 at 03:07:50PM +0000, Dr. David Alan Gilbert (git) wrote:
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
> +    SCMP_SYS(send),
>      SCMP_SYS(sendto),
>  };

With glibc, syslog() calls __send() which for Linux target is implemented
as:


ssize_t
__libc_send (int fd, const void *buf, size_t len, int flags)
{
#ifdef __ASSUME_SEND_SYSCALL
  return SYSCALL_CANCEL (send, fd, buf, len, flags);
#elif defined __ASSUME_SENDTO_SYSCALL
  return SYSCALL_CANCEL (sendto, fd, buf, len, flags, NULL, 0);
#else
  return SOCKETCALL_CANCEL (send, fd, buf, len, flags);
#endif
}

We can see those defines being referenced vary per architecture:

$ git grep -E '__ASSUME_SEND(TO)?_SYSCALL' sysdeps/
sysdeps/unix/sysv/linux/alpha/kernel-features.h:#define __ASSUME_SEND_SYSCALL   1
sysdeps/unix/sysv/linux/arm/kernel-features.h:#define __ASSUME_SEND_SYSCALL     1
sysdeps/unix/sysv/linux/hppa/kernel-features.h:#define __ASSUME_SEND_SYSCALL    1
sysdeps/unix/sysv/linux/i386/kernel-features.h:# undef __ASSUME_SENDTO_SYSCALL
sysdeps/unix/sysv/linux/ia64/kernel-features.h:#define __ASSUME_SEND_SYSCALL            1
sysdeps/unix/sysv/linux/kernel-features.h:#define __ASSUME_SENDTO_SYSCALL               1
sysdeps/unix/sysv/linux/m68k/kernel-features.h:# undef __ASSUME_SENDTO_SYSCALL
sysdeps/unix/sysv/linux/microblaze/kernel-features.h:#define __ASSUME_SEND_SYSCALL              1
sysdeps/unix/sysv/linux/mips/kernel-features.h:# define __ASSUME_SEND_SYSCALL           1
sysdeps/unix/sysv/linux/powerpc/kernel-features.h:#define __ASSUME_SEND_SYSCALL         1
sysdeps/unix/sysv/linux/s390/kernel-features.h:# undef __ASSUME_SENDTO_SYSCALL
sysdeps/unix/sysv/linux/send.c:#ifdef __ASSUME_SEND_SYSCALL
sysdeps/unix/sysv/linux/send.c:#elif defined __ASSUME_SENDTO_SYSCALL
sysdeps/unix/sysv/linux/sendto.c:#ifdef __ASSUME_SENDTO_SYSCALL
sysdeps/unix/sysv/linux/sh/kernel-features.h:#define __ASSUME_SEND_SYSCALL              1
sysdeps/unix/sysv/linux/sparc/kernel-features.h:# undef __ASSUME_SENDTO_SYSCALL


So the patch is correct, but the commit message could be updated becase
this isn't specific to PPC.  Any platform except x86, s490, m68k will
use send() rather than sendto() based on what I see here.

With any commit message update, you can add

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>


Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

