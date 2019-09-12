DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to:user-agent;
	bh=n8T04u79jUZe66wVUcNWnxBT9Dm4wvJmfZ2mZSFVOl8=;
	b=WCEiFMefSOqIqgjIRLiAUsMJdKLdBjQBwxHYWdjrR530Gkr7zk7GzMkdbv5fog6r8l
	oWdJ6k67hxm+8xnt7OhRgz/WXn7Ly2ysQsOuIDCmGq/W+6Q83WiAYCKNvQRNyjciWwqP
	CpHBQZ9B/nHcji56XCynammpoFU9WrY9+3GENUtrqakdzz6gfKqK29RszEICXNByOYVM
	Ach+CFmxICeV7kf0XsGFErUV2/eZLDgB0lkaSW3auV+xi4rPNZzXPVe4FC6pMJVHgux1
	WsFcK9EHes77HtFn38p+SlF32LEGKtSDU+CE4uw0SUtXSacKUnGwxFAMJ4cf5jNOXKv4
	94ow==
Date: Thu, 12 Sep 2019 13:12:48 +0200
From: Stefan Hajnoczi <stefanha@gmail.com>
Message-ID: <20190912111248.GD23174@stefanha-x1.localdomain>
References: <20190827095437.18819-1-stefanha@redhat.com>
	<20190827095437.18819-3-stefanha@redhat.com>
	<20190903172644.GS2744@work-vm>
	<20190904155121.GA25679@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="kvUQC+jR9YzypDnK"
Content-Disposition: inline
In-Reply-To: <20190904155121.GA25679@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [Qemu-devel] [PATCH 2/4] virtiofsd: add
 --print-capabilities option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>
Cc: virtio-fs@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org


--kvUQC+jR9YzypDnK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 04, 2019 at 04:51:21PM +0100, Stefan Hajnoczi wrote:
> On Tue, Sep 03, 2019 at 06:26:44PM +0100, Dr. David Alan Gilbert wrote:
> > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > > Add the --print-capabilities option as per vhost-user.rst "Backend
> > > programs conventions".  Currently there are no advertised features.
> > >=20
> > > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> >=20
> > That looks OK to me, but can someone who understands the json
> > requirement explain what says whether a 'features' entry is optional?
>=20
> I have defined a VHostUserBackendType ('fs') but no
> VHostUserBackendCapabilities union field.
>=20
> I guess this is allowed since many other VIRTIO device types are also
> defined without a VHostUserBackendCapabilities union field (only 'gpu'
> and 'input' have one).

Hi Marc-Andr=E9,
Please review when you have time.  You are the vhost-user.json expert
:).

Stefan

--kvUQC+jR9YzypDnK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl16KDAACgkQnKSrs4Gr
c8jVhAf+MnO0wa7JSgNN6e8L1Wnq3QL2u2G62Gt2zZMb16kzKZV6CW02oWq0kOMi
n6TGUTlfXCegSd1Dx9ghh3iYEnO/AGoFoKf3s1S8fGUWlgHzVw8ZAiT0Kc615rL4
vIHK555a5mXYSxImutFE+ehozw9fOfyDoC4wtGF9azDJph2wH964aIgMYffICY28
LVLiQl5tEwn8W4rMZF3D45GQMbml+DSCoW+Dwbawn/61GgPsblT15TdP8eTz8g2E
hOlxtu8Q/swHEOLTkVbf9m1zPGwrzKf3iAx/RKA5YysTzPVZYLO2r+1z5J8yVBsn
fXWlUvLJC6aqKYG7NNhZnIAxNf/UFg==
=G8wK
-----END PGP SIGNATURE-----

--kvUQC+jR9YzypDnK--

