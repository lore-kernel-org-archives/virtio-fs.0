Date: Thu, 21 Jan 2021 17:03:28 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210121170328.GE59088@stefanha-x1.localdomain>
References: <20210119221849.GC77840@redhat.com> <20210120104501.GB2930@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="u5E4XgoOPWr4PD9E"
Content-Disposition: inline
In-Reply-To: <20210120104501.GB2930@work-vm>
Subject: Re: [Virtio-fs] What are libvhost-user locking requirements
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: gkurz@redhat.com, johannes.berg@intel.com, qemu-devel@nongnu.org, virtio-fs-list <virtio-fs@redhat.com>, marcandre.lureau@redhat.com, Vivek Goyal <vgoyal@redhat.com>


--u5E4XgoOPWr4PD9E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 20, 2021 at 10:45:01AM +0000, Dr. David Alan Gilbert wrote:
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > - what's the locking model needed to use libvhost-user. Is there one?=
=20
>=20
> I don't think it really had one.

Same. Most libvhost-user applications are single-threaded.

Stefan

--u5E4XgoOPWr4PD9E
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAJs+AACgkQnKSrs4Gr
c8h6DggAhqheaeMFWe1tnHAqYPpYcacSoGr8yUTVsy94B750Ro+mSXuvRbFl6lS5
bCV/VeNTjoJFRb9/Le1twrnodelEsrlKP6hL9MMDVfaBDp56mmmbG5e1GfVzkt0R
MIIrsArluXkXwLCuzq04Lj8A+33/+vmL1ELHCDgsw82ODIEzpE7HzmN8WNlr2nAT
6phl0OMln38CtLnNrUe/rAfj3lDdf6/Z68IXBKDb9natMpfwtZBdg7XYHU2LPE5B
HT9WoVbk4KR/oH94nK5oQ+vQUhpcYLk0WbD2bbFffccxT5vS5MWQINkZalNYp72s
brbNqD4tsutKhhAr/YvmY8MJVSp84Q==
=/2ur
-----END PGP SIGNATURE-----

--u5E4XgoOPWr4PD9E--

