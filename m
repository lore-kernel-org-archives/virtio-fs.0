Date: Wed, 16 Jun 2021 16:29:31 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YMoY27s0zoFzE5wg@stefanha-x1.localdomain>
References: <20210428110100.27757-27-dgilbert@redhat.com>
	<YJQNIPaFCJlG7ZKc@stefanha-x1.localdomain>
	<20210506160223.GA277745@redhat.com>
	<YJj3RSxXKZHxmiKu@stefanha-x1.localdomain>
	<20210510152324.GB150402@horse>
	<YJlSHZ0vzNtCAjkJ@stefanha-x1.localdomain>
	<YK/uUUZI3zy9k8Vk@work-vm> <YMIv5odJWdkbJzWL@work-vm>
	<YMI8fS6m8CjtUtmE@stefanha-x1.localdomain>
	<YMnwOs9bxKLB8wSL@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vCVPAPq/bsUMZ+fR"
Content-Disposition: inline
In-Reply-To: <YMnwOs9bxKLB8wSL@work-vm>
Subject: Re: [Virtio-fs] [PATCH v3 26/26] virtiofsd: Ask qemu to drop
 CAP_FSETID if client asked for it
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>


--vCVPAPq/bsUMZ+fR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 16, 2021 at 01:36:10PM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > On Thu, Jun 10, 2021 at 04:29:42PM +0100, Dr. David Alan Gilbert wrote:
> > > * Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
> > > > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > > +    uint64_t addr; /* In the bus address of the device */
> >=20
> > Please check the spec for preferred terminology. "bus address" isn't
> > used in the spec, so there's probably another term for it.
>=20
> I'm not seeing anything useful in the virtio spec; it mostly talks about
> guest physical addresses; it does say 'bus addresses' in the definition
> of 'VIRTIO_F_ACCESS_PLATFORM' .

I meant the docs/interop/vhost-user.rst spec.

Stefan

--vCVPAPq/bsUMZ+fR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDKGNQACgkQnKSrs4Gr
c8gLiwgAn8wLJm2ypupTK9cxtNCYleDFZ+gqwPLMEnxXNbLdRvTZhB+leOAkqV1w
bX36vWqDcXAk+gxk6Ld3ocZcnEl8/0YLeMjI9cj1dSSnPt6FxaaD/wLsthJPdk5h
TajFVUX9b1b7PhCWYnYrGxntCsjtbhE3C81/A4iyWWGIutoBwVViZgKO28wUJD0p
Yeu/s5YAdNs+U+Ge6Q9MbqOZRGXa1ftDwLq5u8aDFU+730JO0nW77njMLej2rhlz
IF/H9qAByNg5mmc18zUmc/xyJAEg7gv7Xs3vbsN7eqBoKvDPZuqkGqudYRCigX2U
DvasdqGwBmq6azWna46Bo4FJVLkOJA==
=RR56
-----END PGP SIGNATURE-----

--vCVPAPq/bsUMZ+fR--

