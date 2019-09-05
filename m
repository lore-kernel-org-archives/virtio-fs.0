Date: Thu, 5 Sep 2019 11:36:13 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190905103613.GK2700@work-vm>
References: <20190905082947.6633-1-stefanha@redhat.com>
	<6e9ff4f7-2906-3c11-8191-05cff3e60f53@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <6e9ff4f7-2906-3c11-8191-05cff3e60f53@redhat.com>
Subject: Re: [Virtio-fs] [Qemu-devel] [PATCH RESEND 0/2] virtiofsd: use
 "fuse_log.h" APIs instead of <err.h>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Philippe Mathieu-Daud=E9 (philmd@redhat.com) wrote:
> Hi Stefan,
>=20
> On 9/5/19 10:29 AM, Stefan Hajnoczi wrote:
> > warn(3), warnx(3), err(3), and errx(3) print to stderr even when the --=
syslog
> > option was given.  In this case messages to stderr are likely to be los=
t and
> > this makes troubleshooting hard.  Use "fuse_log.h" APIs instead of <err=
.h>.
> >=20
> > Stefan Hajnoczi (2):
> >   virtiofsd: replace warn(3) and warnx(3) with fuse_warning()
> >   virtiofsd: replace err(3) and errx(3) with fuse_err()
>=20
> Is this a straight RESEND or are there any changes in this series?
>=20
> I'm asking because IIRC your first series had:
> - Reviewed-by: Jun Piao <piaojun@huawei.com>
> - Reviewed-by: Philippe Mathieu-Daud=E9 <philmd@redhat.com>
>=20
> If this isn't a RESEND then I'll review it again.

I'll pick those reviews up.

Dave

> Thanks,
>=20
> Phil.
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

