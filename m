Date: Fri, 17 Apr 2020 10:42:26 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200417094226.GC9261@stefanha-x1.localdomain>
References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200416201022.GD276932@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
Content-Disposition: inline
In-Reply-To: <20200416201022.GD276932@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: drop Linux capabilities(7)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 16, 2020 at 04:10:22PM -0400, Vivek Goyal wrote:
> On Thu, Apr 16, 2020 at 05:49:05PM +0100, Stefan Hajnoczi wrote:
> > virtiofsd doesn't need of all Linux capabilities(7) available to root. =
 Keep a
> > whitelisted set of capabilities that we require.  This improves securit=
y in
> > case virtiofsd is compromised by making it hard for an attacker to gain=
 further
> > access to the system.
>=20
> Hi Stefan,
>=20
> Good to see this patch. We needed to limit capabilities to reduce attack
> surface.
>=20
> What tests have you run to make sure this current set of whitelisted
> capabilities is good enough.

Booting and light usage of Fedora 29 and running blogbench.

I would appreciate it if others could try it out with their
tests/workloads.

Stefan

--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl6ZegIACgkQnKSrs4Gr
c8gCwQf/SGclgNGX+8xOqlJ74zhIpp6bGlVeuuRcjn87CM/oMgA0vS+f8aGZu5O7
c+YkV99TYQ5lB8xXzkg8BsyYyHUAJ3DQHOb/cb+x66zgF+kVoPMT8LNgozBC88ze
+4FCFFCBXLEoVnVyNcj+eATdLkH5usRjdfjtJ3LJRInEV+VwO7soogPmMTICZCXU
aPWOP9Ta1omkUBPvBMdqPUCXO4ihHabdBb/ZBPnWi+1TXg9gBTApmYPN40HwtIIB
Vhgnnbam8PDTRMSJQp1JDcGTFUOn6Uom4StlQJD1EObySpG2W4xYH+qAUOFXsJ2X
4yZaXikgN8AfzF42/6bbY/OLpmkeqw==
=sU5C
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--

