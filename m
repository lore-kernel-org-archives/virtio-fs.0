Date: Wed, 31 Mar 2021 11:14:27 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YGRLgzlo1DgA5uQv@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-19-dgilbert@redhat.com>
	<20210211142948.GS247031@stefanha-x1.localdomain>
	<YDd5swx5HA+WinFF@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4AZoSTMUp9LDSKPC"
Content-Disposition: inline
In-Reply-To: <YDd5swx5HA+WinFF@work-vm>
Subject: Re: [Virtio-fs] [PATCH 18/24] DAX/unmap virtiofsd: Parse unmappable
	elements
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com, mst@redhat.com


--4AZoSTMUp9LDSKPC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 25, 2021 at 10:19:31AM +0000, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > On Tue, Feb 09, 2021 at 07:02:18PM +0000, Dr. David Alan Gilbert (git) =
wrote:
> > > diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_com=
mon.h
> > > index a090040bb2..ed9280de91 100644
> > > --- a/tools/virtiofsd/fuse_common.h
> > > +++ b/tools/virtiofsd/fuse_common.h
> > > @@ -611,6 +611,13 @@ enum fuse_buf_flags {
> > >       * detected.
> > >       */
> > >      FUSE_BUF_FD_RETRY =3D (1 << 3),
> > > +
> > > +    /**
> > > +     * The addresses in the iovec represent guest physical addresses
> > > +     * that can't be mapped by the daemon process.
> > > +     * IO must be bounced back to the VMM to do it.
> > > +     */
> > > +    FUSE_BUF_PHYS_ADDR =3D (1 << 4),
> >=20
> > With a vIOMMU it's an IOVA. Without a vIOMMU it's a GPA. This constant
> > may need to be renamed in the future, but it is okay for now.
>=20
> Do we have any naming for something that's either a GPA or a IOVA?

I don't remember but I think the naming is confusing in core vhost code
too :). I just don't remember if it's called a "physical address" there.

Stefan

--4AZoSTMUp9LDSKPC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBkS4MACgkQnKSrs4Gr
c8iepggAibhDpVfW5Ttxe6osMKNmSL2sZSo+pWdQH1at8h1Nbfh+fzFta+FSJCvf
X84KkOnP+i7q1ObryGsy4WWDiyeL5Z2HE9lUhwuySKylK+x4/KdHykgioPKJ2+sL
N5926Qb59qNo/icI/XdQ7ghvAE3Rm7gKYz9DaaCVTxVq+V4tawFdjEoE7XevQ0LH
ft93Muo8ya9lCN/EPBZ3UYWxC7Gtj4Hst9dDA2ZMhTHDlxdElLbv1VaeJxAc2kt9
T5FDFLmbVwMyWwlfXE7GpjvbsIpZ1waJ0Zm0hV/SPGlGuMq8EMR2MAPc/yVx2tfp
ngiq+I/40avjVfrz0M3UjugPj6sDVA==
=J+P8
-----END PGP SIGNATURE-----

--4AZoSTMUp9LDSKPC--

