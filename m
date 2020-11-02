Date: Mon, 2 Nov 2020 18:30:52 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201102183052.GB4845@work-vm>
References: <20201102150750.34565-1-dgilbert@redhat.com>
	<20201102151712.GF138796@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201102151712.GF138796@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Seccomp: Add 'send' for syslog
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, amulmek1@in.ibm.com

* Daniel P. Berrang=E9 (berrange@redhat.com) wrote:
> On Mon, Nov 02, 2020 at 03:07:50PM +0000, Dr. David Alan Gilbert (git) wr=
ote:
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> >=20
> > On ppc it looks like syslog ends up using 'send' rather than 'sendto'.
> >=20
> > Reference: https://github.com/kata-containers/kata-containers/issues/10=
50
> >=20
> > Reported-by: amulmek1@in.ibm.com
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > ---
> >  tools/virtiofsd/passthrough_seccomp.c | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/pa=
ssthrough_seccomp.c
> > index eb9af8265f..672fb72a31 100644
> > --- a/tools/virtiofsd/passthrough_seccomp.c
> > +++ b/tools/virtiofsd/passthrough_seccomp.c
> > @@ -118,6 +118,7 @@ static const int syscall_whitelist[] =3D {
> > =20
> >  /* Syscalls used when --syslog is enabled */
> >  static const int syscall_whitelist_syslog[] =3D {
> > +    SCMP_SYS(send),
> >      SCMP_SYS(sendto),
> >  };
>=20
> With glibc, syslog() calls __send() which for Linux target is implemented
> as:
>=20
>=20
> ssize_t
> __libc_send (int fd, const void *buf, size_t len, int flags)
> {
> #ifdef __ASSUME_SEND_SYSCALL
>   return SYSCALL_CANCEL (send, fd, buf, len, flags);
> #elif defined __ASSUME_SENDTO_SYSCALL
>   return SYSCALL_CANCEL (sendto, fd, buf, len, flags, NULL, 0);
> #else
>   return SOCKETCALL_CANCEL (send, fd, buf, len, flags);
> #endif
> }
>=20
> We can see those defines being referenced vary per architecture:
>=20
> $ git grep -E '__ASSUME_SEND(TO)?_SYSCALL' sysdeps/
> sysdeps/unix/sysv/linux/alpha/kernel-features.h:#define __ASSUME_SEND_SYS=
CALL   1
> sysdeps/unix/sysv/linux/arm/kernel-features.h:#define __ASSUME_SEND_SYSCA=
LL     1
> sysdeps/unix/sysv/linux/hppa/kernel-features.h:#define __ASSUME_SEND_SYSC=
ALL    1
> sysdeps/unix/sysv/linux/i386/kernel-features.h:# undef __ASSUME_SENDTO_SY=
SCALL
> sysdeps/unix/sysv/linux/ia64/kernel-features.h:#define __ASSUME_SEND_SYSC=
ALL            1
> sysdeps/unix/sysv/linux/kernel-features.h:#define __ASSUME_SENDTO_SYSCALL=
               1
> sysdeps/unix/sysv/linux/m68k/kernel-features.h:# undef __ASSUME_SENDTO_SY=
SCALL
> sysdeps/unix/sysv/linux/microblaze/kernel-features.h:#define __ASSUME_SEN=
D_SYSCALL              1
> sysdeps/unix/sysv/linux/mips/kernel-features.h:# define __ASSUME_SEND_SYS=
CALL           1
> sysdeps/unix/sysv/linux/powerpc/kernel-features.h:#define __ASSUME_SEND_S=
YSCALL         1
> sysdeps/unix/sysv/linux/s390/kernel-features.h:# undef __ASSUME_SENDTO_SY=
SCALL
> sysdeps/unix/sysv/linux/send.c:#ifdef __ASSUME_SEND_SYSCALL
> sysdeps/unix/sysv/linux/send.c:#elif defined __ASSUME_SENDTO_SYSCALL
> sysdeps/unix/sysv/linux/sendto.c:#ifdef __ASSUME_SENDTO_SYSCALL
> sysdeps/unix/sysv/linux/sh/kernel-features.h:#define __ASSUME_SEND_SYSCAL=
L              1
> sysdeps/unix/sysv/linux/sparc/kernel-features.h:# undef __ASSUME_SENDTO_S=
YSCALL
>=20
>=20
> So the patch is correct, but the commit message could be updated becase
> this isn't specific to PPC.  Any platform except x86, s490, m68k will
> use send() rather than sendto() based on what I see here.
>=20
> With any commit message update, you can add
>=20
> Reviewed-by: Daniel P. Berrang=E9 <berrange@redhat.com>

Thanks, changed to:

  On ppc, and some other archs, it looks like syslog ends up using 'send'
  rather than 'sendto'.

Dave

>=20
>=20
> Regards,
> Daniel
> --=20
> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberran=
ge :|
> |: https://libvirt.org         -o-            https://fstop138.berrange.c=
om :|
> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberran=
ge :|
>=20
>=20
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

