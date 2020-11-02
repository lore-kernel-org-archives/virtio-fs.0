Date: Mon, 2 Nov 2020 15:13:50 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201102151350.GH3673@work-vm>
References: <20201102150750.34565-1-dgilbert@redhat.com>
	<e1a007ed-7a9f-38cd-4003-144d0e99dd6e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <e1a007ed-7a9f-38cd-4003-144d0e99dd6e@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Seccomp: Add 'send' for syslog
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, amulmek1@in.ibm.com

* Philippe Mathieu-Daud=E9 (philmd@redhat.com) wrote:
> On 11/2/20 4:07 PM, Dr. David Alan Gilbert (git) wrote:
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
>=20
> Is it worth restricting the syscall to POWER?
>=20
>    #if defined(__powerpc64__)

I don't think so, since it's legal for a libc to use either;
so any other libc or architecture could choose either to use.

Dave

> > +    SCMP_SYS(send),
>=20
>    #endif
>=20
> >      SCMP_SYS(sendto),
> >  };
> > =20
> >=20
>=20
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

