Date: Tue, 2 Jun 2020 10:29:16 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200602092916.GC9852@stefanha-x1.localdomain>
References: <20200424062540.23679-1-chirantan@chromium.org>
	<20200424062540.23679-2-chirantan@chromium.org>
	<20200427151934.GB1042399@stefanha-x1.localdomain>
	<CAJFHJrr2DAgQC9ZWx78OudX1x6A57_vpLf4rJu80ceR6bnpbaQ@mail.gmail.com>
	<20200501154752.GA222606@stefanha-x1.localdomain>
	<CAJFHJrpdbVKWyGuJJCBATVaYZsPLeg6JzpZmGFDsUcF_a4gcMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
Content-Disposition: inline
In-Reply-To: <CAJFHJrpdbVKWyGuJJCBATVaYZsPLeg6JzpZmGFDsUcF_a4gcMA@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 2/2] fuse: virtiofs: Add basic multiqueue
	support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Suleiman Souhlal <suleiman@chromium.org>, virtio-fs-list <virtio-fs@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Dylan Reid <dgreid@chromium.org>, Vivek Goyal <vgoyal@redhat.com>


--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 07, 2020 at 05:10:15PM +0900, Chirantan Ekbote wrote:
> On Sat, May 2, 2020 at 12:48 AM Stefan Hajnoczi <stefanha@redhat.com> wro=
te:
> > On Fri, May 01, 2020 at 04:14:38PM +0900, Chirantan Ekbote wrote:
> > > On Tue, Apr 28, 2020 at 12:20 AM Stefan Hajnoczi <stefanha@redhat.com=
> wrote:
> > io_uring's vocabulary is expanding.  It can now do openat2(2), close(2),
> > statx(2), but not mkdir(2), unlink(2), rename(2), etc.
> >
> > I guess there are two options:
> > 1. Fall back to threads for FUSE operations that cannot yet be done via
> >    io_uring.
> > 2. Process FUSE operations that cannot be done via io_uring
> >    synchronously.
> >
>=20
> I'm hoping that using io_uring for just the reads and writes should
> give us a big enough improvement that we can do the rest of the
> operations synchronously.

Sounds like a good idea.

Stefan

--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7WG+wACgkQnKSrs4Gr
c8itMggArze0SlGMV0FObjiOGh2x91wC4w83cdukHjDRXnx8LUROTBFIWVUDTxYz
YRq46Fr1LAx38jacfEQVrTbBVDgK5FQzobPKrJycw4X2z5b3OvfH3iO+Xx9KcL4M
4MXBvL+Z4EBpXQmdWeR25jAztg75rqapof0x4o+ZESbu7h4oItjYjmBHszbx+t+s
63anVjgk/0zoi66ifHzupCJSuxfAVuyFMUU6zNQBWPtWPzhjE87rPH/ZKDtQAylB
H5UxNF5nidSN7qTPm9sFxEa7SPuXUw+tdfKXZZVN3PbOBITQSgE7NHdAjEpDzgRs
MOS5GYYlk740tAAMpTFDFydpJuGQdQ==
=FKk/
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--

