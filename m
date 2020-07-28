Date: Tue, 28 Jul 2020 16:32:19 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200728153219.GC21660@stefanha-x1.localdomain>
References: <20200727190223.422280-1-stefanha@redhat.com>
	<20200727190223.422280-4-stefanha@redhat.com>
	<OSBPR01MB45826073E5A54CF869E56721E5730@OSBPR01MB4582.jpnprd01.prod.outlook.com>
	<CALDPj7syG0KPhtZEma5n403=YFZ2ptcD4MtP=GdrY9n1eUs5Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oJ71EGRlYNjSvfq7"
Content-Disposition: inline
In-Reply-To: <CALDPj7syG0KPhtZEma5n403=YFZ2ptcD4MtP=GdrY9n1eUs5Eg@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS)
 and print an error
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Roman Mohr <rmohr@redhat.com>
Cc: "vromanso@redhat.com" <vromanso@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "mpatel@redhat.com" <mpatel@redhat.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>


--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2020 at 12:00:20PM +0200, Roman Mohr wrote:
> On Tue, Jul 28, 2020 at 3:07 AM misono.tomohiro@fujitsu.com <
> misono.tomohiro@fujitsu.com> wrote:
>=20
> > > Subject: [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS) and print =
an
> > error
> > >
> > > An assertion failure is raised during request processing if
> > > unshare(CLONE_FS) fails. Implement a probe at startup so the problem =
can
> > > be detected right away.
> > >
> > > Unfortunately Docker/Moby does not include unshare in the seccomp.json
> > > list unless CAP_SYS_ADMIN is given. Other seccomp.json lists always
> > > include unshare (e.g. podman is unaffected):
> > >
> > https://raw.githubusercontent.com/seccomp/containers-golang/master/secc=
omp.json
> > >
> > > Use "docker run --security-opt seccomp=3Dpath/to/seccomp.json ..." if=
 the
> > > default seccomp.json is missing unshare.
> >
> > Hi, sorry for a bit late.
> >
> > unshare() was added to fix xattr problem:
> >
> > https://github.com/qemu/qemu/commit/bdfd66788349acc43cd3f1298718ad49166=
3cfcc#
> > In theory we don't need to call unshare if xattr is disabled, but it is
> > hard to get to know
> > if xattr is enabled or disabled in fv_queue_worker(), right?
> >
> >
> In kubevirt we want to run virtiofsd in containers. We would already not
> have xattr support for e.g. overlayfs in the VM after this patch series (=
an
> acceptable con at least for us right now).
> If we can get rid of the unshare (and potentially of needing root) that
> would be great. We always assume that everything which we run in containe=
rs
> should work for cri-o and docker.

Root is required to access files with any uid/gid.

Dave Gilbert is working on xattr support without CAP_SYS_ADMIN. He may
be able to find a way to drop unshare (at least in containers).

> "Just" pointing docker to a different seccomp.json file is something which
> k8s users/admin in many cases can't do.

There is a Moby PR to change the default seccomp.json file here but it's
unclear if it will be merged:
https://github.com/moby/moby/pull/41244

Stefan

--oJ71EGRlYNjSvfq7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8gRQMACgkQnKSrs4Gr
c8gFewf+N/01Xy2AeoJ+M2D/I7CvBDsqtoktTXivzhkqUYVQV1APtrrvRl3VJm3f
/9s0A+uFATHccykvXHorARbYZzp6xj4ELnSWwkrHyVfqN8+gVCFJmEpumddusRFP
t7sG03AyDmWtXQmWNEtNqDNsKzp377P7Vb4TBaUd5f5KsjskmrvSs9SV/f3NBi0k
yQC/4wUmB5kcaNWMvC6ReCUQ8WUJU6VPwebiOPAdVJdQq5jG/UIY24uiPoqPyvz/
XFVbt1IbNxoYp6TwzUOfdcSu2CX4I20E+fmRbBvZFtgwWwKWWOlDOdcGPCtLtEK1
HSqcs8Jln8pC6/5Zff+FT6SqhNSFBg==
=06TQ
-----END PGP SIGNATURE-----

--oJ71EGRlYNjSvfq7--

