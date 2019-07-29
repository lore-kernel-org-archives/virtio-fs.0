DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to:user-agent;
	bh=73zTbjBhdCreP9v2bIcpK5krU/bv5GhzhGh5NJwMGQc=;
	b=mbq6n+CsnRymPLyVok2m8fp1pZn4j2bSOl7AKZAmL8wVazZyyxp4zhemS1nAcYnje1
	44KnGm+UafhAgKcIf7Q1RTXCDPvUXlIy1CEHLpUcRb4HpYO95YhCMIX/8EZhjm42ZgAQ
	Fi6yGopu4CM4K6pQcbOblFX+AxFjqPlAMmIf7rgwrOi7nZ7Db0WnjVu2cf7Mb16i02NZ
	XY0IUtDHTM0bA0u9lfjjv4Hh5vQ9RslbgtFPOZhPuc+jSMxzjbwfhXZISkib1/yhcSv0
	byMGVSRmRJOcTcj7G4KR7XDNU5gATmPYEIGCiSVQCQnPfxQ3rnxTKjxQjbL3IbGilIHg
	DSlA==
Date: Mon, 29 Jul 2019 16:41:18 +0100
From: Stefan Hajnoczi <stefanha@gmail.com>
Message-ID: <20190729154118.GA21560@stefanha-x1.localdomain>
References: <20190726091103.23503-1-stefanha@redhat.com>
	<20190726091103.23503-3-stefanha@redhat.com>
	<e83e2463-5239-e5c0-cc44-e1e0b74df37c@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <e83e2463-5239-e5c0-cc44-e1e0b74df37c@huawei.com>
Subject: Re: [Virtio-fs] [Qemu-devel] [PATCH 2/5] virtiofsd: prevent
 lo_lookup() NULL pointer dereference
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2019 at 08:35:36PM +0800, piaojun wrote:
> Hi Stefan,
>=20
> On 2019/7/26 17:11, Stefan Hajnoczi wrote:
> > Most lo_do_lookup() have already checked that the parent inode exists.
> > lo_lookup() hasn't and can therefore hit a NULL pointer dereference when
> > lo_inode(req, parent) returns NULL.
> >=20
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  contrib/virtiofsd/passthrough_ll.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >=20
> > diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/pas=
sthrough_ll.c
> > index 9ae1381618..277a17fc03 100644
> > --- a/contrib/virtiofsd/passthrough_ll.c
> > +++ b/contrib/virtiofsd/passthrough_ll.c
> > @@ -766,6 +766,10 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t=
 parent, const char *name,
> >  	struct lo_data *lo =3D lo_data(req);
> >  	struct lo_inode *inode, *dir =3D lo_inode(req, parent);
> > =20
> > +	if (!dir) {
> > +		return EBADF;
> > +	}
> > +
>=20
> I worry about that dir will be released or set NULL just after NULL
> checking. Or could we use some lock to prevent the simultaneity?

Yes, I agree.  I haven't audited lo_inode yet, but it needs a refcount
and/or lock to ensure accesses are safe.  I'll do that and other things
in a separate patch series.

Stefan

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0/E50ACgkQnKSrs4Gr
c8j3iAgAlmmrhpX+5EjT3WA3AinUScd4UGS35+bJ0/wg/D8AuVfVuvbf2AV5jOsC
iDq/vxyxZdDttfN5w+GPswZa2XbgC3c8P90829WA2YUzHBVg59D77uoLrQZJWexN
bNeaBQC2cJKv8g0pQvlv1Jy1aIR382MCa/BpsaRdRyvGomfFsx5kIwbaSmvpfUHp
AKVnxDArnyCryRGsQjq0D1Hb/hiKshgxSdwxJyYXnKNxfoLty8s0BZChA20wP0Y/
I/9dt1docczI9s/Trp2pTlR5zhJ1rsDbM2Tf74ZYFpJBh7y2JWaP0NQ7s/YKEIxm
j+U/lqPFfbfaDeB83lc0FB1kBqM8JA==
=+NgF
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--

