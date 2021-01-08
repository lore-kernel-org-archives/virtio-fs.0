Date: Fri, 8 Jan 2021 17:08:48 +0100
From: Sergio Lopez <slp@redhat.com>
Message-ID: <20210108160848.ucj3rvgbsgavcvlk@mhamilton>
References: <41bd32c5-1dab-5c7a-b6cd-f1474c3f7f68@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zh36onaiwca6bt3n"
Content-Disposition: inline
In-Reply-To: <41bd32c5-1dab-5c7a-b6cd-f1474c3f7f68@redhat.com>
Subject: Re: [Virtio-fs] virtiofsd-rs: A rust virtiofs daemon
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Connor Kuehl <ckuehl@redhat.com>
Cc: virtio-fs@redhat.com


--zh36onaiwca6bt3n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 07, 2021 at 01:09:34PM -0600, Connor Kuehl wrote:
> Is the feature parity list documented somewhere? I would like to help.

Probably the biggest missing piece is xattr mapping:

https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/3

The other was remote locks, but we already have a MR for that:

https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/2
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/4

I'd also be nice keeping an eye on the improvements that are being
made on fuse-backend-rs [1] to see if we can cherry-pick some of them.

[1] https://github.com/cloud-hypervisor/fuse-backend-rs/

Thanks!
Sergio.

--zh36onaiwca6bt3n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl/4g48ACgkQ9GknjS8M
AjVL8w//bh+yU7nqa1p/87uU4uDjatw81njPDwDCMSZYFcbB7e14y31w7dfC2TBn
a79QizLrf0FMb5DUXF36vFanuODIGKgGdN5trXgaYthVAAm3fRJ63ENyqVX31OVJ
nEdZbuTeBxy22f9pM1ape0I2SCaKNIAhDi85EYxAkpx4/+7s1ZVhcNbw0xc7LllQ
fAXZmGkEphdCWGN3M6VSvZyZoQw7rwsax8PRtMYPqvijHC7QCDqjLUUwe1rTRsR2
UJGkfSTrIjABnnofy/Y5izeKdkul+VgCx10cNniPmF5Z48fJY/e6vnCzv6ea1jIB
KetrFBiL9lu5VbNkcZtrH+A6TETRA3kNZrOFhX9Q6YIJx1sXnacnIupuvM4urKN2
Wo4N+73+dYxjaIna64FV9AVPy9IOCkbgjtnU3DI8wikAUjqKzxAX13622jkrgrDb
bqGAggre7tAuVYmE86mWQs8FdtRIhmSpGOh3I2KqBjEtx0tdc6fV6M9uvIEjHqTR
TOD6kDk1hfm0aqpOyqqadFZ2r6KTkMnv0cbmEy+/e+lTuQYvJY29JxSJH1aaYIz6
/lllx3Y6wsNuFByx2d3h+iaskKHbuYTB92SZL2D/XhHA7XWK7Unxfbw1st5ML6NJ
hvahwS6PlXt70OIHtTdNjHhnxx5xxc17GfuZHVo9oyArC9Voxx4=
=Fawp
-----END PGP SIGNATURE-----

--zh36onaiwca6bt3n--

