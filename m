Date: Fri, 6 Sep 2019 11:36:13 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190906103613.GH5900@stefanha-x1.localdomain>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<CAJfpegu8POz9gC4MDEcXxDWBD0giUNFgJhMEzntJX_u4+cS9Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="K1n7F7fSdjvFAEnM"
Content-Disposition: inline
In-Reply-To: <CAJfpegu8POz9gC4MDEcXxDWBD0giUNFgJhMEzntJX_u4+cS9Zw@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 00/18] virtiofs: Fix various races and
	cleanups round 1
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>


--K1n7F7fSdjvFAEnM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 06, 2019 at 10:15:14AM +0200, Miklos Szeredi wrote:
> On Thu, Sep 5, 2019 at 9:49 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Hi,
> >
> > Michael Tsirkin pointed out issues w.r.t various locking related TODO
> > items and races w.r.t device removal.
> >
> > In this first round of cleanups, I have taken care of most pressing
> > issues.
> >
> > These patches apply on top of following.
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git#virtiof=
s-v4
> >
> > I have tested these patches with mount/umount and device removal using
> > qemu monitor. For example.
>=20
> Is device removal mandatory?  Can't this be made a non-removable
> device?  Is there a good reason why removing the virtio-fs device
> makes sense?

Hot plugging and unplugging virtio PCI adapters is common.  I'd very
much like removal to work from the beginning.

Stefan

--K1n7F7fSdjvFAEnM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1yNpwACgkQnKSrs4Gr
c8hY9AgAmU3k7f2gZ5ko9Rvr8+tXDTSrw1Uakzbgk+pEb54Z2M4jFGJgWglMNfqa
4PI0iDsPz1ikbT9wOhko7AGyaeX1/EQqmXWdBGgCjXVBekhLsOR4dOl/y6Q/1eW1
fEQ5B/Ngl1Z5AbMZ5xwlYA89Iq4yZCVn8IbyhkreLZ8KHzMc6CnQkNEM8goE1HgO
oSiD15lf3RiiwQlYbBabMOc3nOlIqebZKyk2oizbPfQLC9/afkmPcPv+sZfTMMwW
LXa6ZV7ZHxi6sgQSPaN/yh9Ve+2NvMcyPPYyAZFduruK5C/Rkx+Er/uzXgPDQ4j3
57uYA27caA6arIq+CUvclGvmk2+ajA==
=Llfc
-----END PGP SIGNATURE-----

--K1n7F7fSdjvFAEnM--

