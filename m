Date: Wed, 21 Aug 2019 17:05:51 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190821160551.GD9095@stefanha-x1.localdomain>
References: <5abd7616-5351-761c-0c14-21d511251006@huawei.com>
	<20190820091650.GE9855@stefanha-x1.localdomain>
	<CAJfpegs8fSLoUaWKhC1543Hoy9821vq8=nYZy-pw1+95+Yv4gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="XvKFcGCOAo53UbWW"
Content-Disposition: inline
In-Reply-To: <CAJfpegs8fSLoUaWKhC1543Hoy9821vq8=nYZy-pw1+95+Yv4gQ@mail.gmail.com>
Subject: Re: [Virtio-fs] [QUESTION] A performance problem for buffer write
 compared with 9p
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, Miklos Szeredi <mszeredi@redhat.com>


--XvKFcGCOAo53UbWW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 21, 2019 at 09:51:20AM +0200, Miklos Szeredi wrote:
> On Tue, Aug 20, 2019 at 11:16 AM Stefan Hajnoczi <stefanha@redhat.com> wr=
ote:
> >
> > On Thu, Aug 15, 2019 at 08:30:43AM +0800, wangyan wrote:
> > > Hi all,
> > >
> > > I met a performance problem when I tested buffer write compared with =
9p.
> >
> > CCing Miklos, FUSE maintainer, since this is mostly a FUSE file system
> > writeback question.
>=20
> This is expected.   FUSE contains lots of complexity in the buffered
> write path related to preventing DoS caused by the userspace server.
>=20
> This added complexity, which causes the performance issue, could be
> disabled in virtio-fs, since the server lives on a different kernel
> than the filesystem.
>=20
> I'll do a patch..

Great, thanks!  Maybe wangyan can try your patch to see how the numbers
compare to 9P.

Stefan

--XvKFcGCOAo53UbWW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1da98ACgkQnKSrs4Gr
c8gFfggAyRL0QCaPyX1cmqi2FhRh2CeRCsiRY/htPGdMIsiAj/nnnw6LbyGXJuLn
I3SbKbto+tCFF5/I0Vvgm+9GxNuVvWTw7aRMH7G8HHHqM/gg+KJgtjdBTXizNqHK
l+tQxEEGIqqQ2k41QyUd49PDJ+7uL/KZEPUjS2zh/XYXUPpcyuP1Sdtkvi9Pd05q
WPMIXrUaC4enEM1+ucHp2guIJMILo1+D+uSUtCdquoywkK/xlQWrgTzu4/VYhj+D
/OvB951mJSr4BC9DXafuBoGzcJatO3vW5xN6I9Mqh8YOFg0CVQOM4JGzFKfIjKDw
rzKWye90d/We2s63UHvmiQMyfRxDzQ==
=wydV
-----END PGP SIGNATURE-----

--XvKFcGCOAo53UbWW--

