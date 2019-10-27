Date: Sun, 27 Oct 2019 13:36:23 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191027123623.GO4472@stefanha-x1.localdomain>
References: <20191025100152.6638-1-stefanha@redhat.com>
	<20191025100152.6638-2-stefanha@redhat.com>
	<20191026174745-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="HFD/Dq8JdnjNvyuv"
Content-Disposition: inline
In-Reply-To: <20191026174745-mutt-send-email-mst@kernel.org>
Subject: Re: [Virtio-fs] [RFC 1/3] WIP virtiofsd: import Linux <fuse.h>
	header file
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>, Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, vgoyal@redhat.com


--HFD/Dq8JdnjNvyuv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 26, 2019 at 05:49:11PM -0400, Michael S. Tsirkin wrote:
> On Fri, Oct 25, 2019 at 12:01:50PM +0200, Stefan Hajnoczi wrote:
> > tests/vhost-user-fs-test.c needs fuse.h.  The private copy that
> > virtiofsd has can be replaced with a properly imported file using
> > update-linux-headers.sh.
> >=20
> > TODO rerun update-linux-headers.sh with upstream kernel tree!
> >=20
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
>=20
> OK I would just add this with the virtiofsd patchset.

Yes, I'll talk to David.

Stefan

--HFD/Dq8JdnjNvyuv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl21j0cACgkQnKSrs4Gr
c8j6ugf/SwP+Qyw7qmyQInH0iArUl4QbSR98SvctUVw066Vw109WHPpDr8v3LFbE
xJ90vnF6s+yaKbvMeFCtJMpJ0nRosEhjc20XjrpfINvvlUQANgkPl4NUpqD3gxeg
daqXIoOux2Yi5gi5m/VyQdNf71u/Y4VU4mImXN+0WnFUfko4VkH28N+JTwT4Bkng
NjspBEVSTDMfqS2BPPwT8tvITpOFlVNb2skkR8qngT0Dq3bEp5NelxKVMdGgMA8x
4D1AvV52BU2pRyiWocCjelJXsXRCKDOX+LYNt15c2GIeVPDOmaCa+1fvzxdHYMOT
eoC+xLolTWudUHY6b1etEmQGHqwRXg==
=RCds
-----END PGP SIGNATURE-----

--HFD/Dq8JdnjNvyuv--

