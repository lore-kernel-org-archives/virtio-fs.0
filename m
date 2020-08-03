Date: Mon, 3 Aug 2020 10:45:36 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200803094536.GC244853@stefanha-x1.localdomain>
References: <20200730194736.173994-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="QRj9sO5tAVLaXnSD"
Content-Disposition: inline
In-Reply-To: <20200730194736.173994-1-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 0/5] virtiofsd: Add a unprivileged
	passthrough mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: berrange@redhat.com, vromanso@redhat.com, qemu-devel@nongnu.org, virtio-fs@redhat.com


--QRj9sO5tAVLaXnSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2020 at 03:47:31PM -0400, Vivek Goyal wrote:
> Hi,
>=20
> This is V2 of patches. Only change since last version is handling of
> lock/pid file creation as per the comments from Daniel Berrange.
>=20
> I can't think of any more changes needed. As a unpriviliged user
> inside VM I can do simple operations like create/remove/read/write
> files.
>=20
> For more testing, I probably need a testsuite which runs as unpriviliged
> user. pjdfstests needs to run as root and this does not work in this
> setup as creation of files as root fails. (On host, daemon tries to
> switch to root uid and that fails).
>=20
> So as of now, I think these are the minimum changes needed to support
> unprivileged passthrough mode of virtiofsd.

Ideas for testing user file I/O:

  $ git clone https://git.qemu.org/git/qemu.git
  $ find qemu -name \*.c
  $ grep -r vhost_user_fs qemu
  $ rm -rf qemu

  $ pip install --user Django
  $ .local/bin/django-admin

Stefan

--QRj9sO5tAVLaXnSD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8n3MAACgkQnKSrs4Gr
c8hoIgf/ZTByOdimELMej45C/RGvU3uhcdkojdd51N6vDiVmVRpqUqlIX3hVYHu1
cTfluSOAFrqLnP0708FteI8Lr+aIPx2n+LxGbyHpJkv2KRkZnBaj69Vpg8BAsump
EIRcTdDBr7FeZfeacNtoprJ2Y4WAZTjRKM5wgZRpZGMqI95uzJ72v4xESws+5eVy
wVdYOq0q+w02kcSlMTWVUh730k4uBQINPQpBT1fTmm7Q/me7izRJrsPaVTdtSjCz
5hv/RAnquvbUWO0XZLiwpPkzdbG1UeemaBC6S0QM1AdNzNKFBgBnPnA5Wk5MluVF
/hl01NZyK4teidhtq3uQZk8wyjpAgQ==
=PYhx
-----END PGP SIGNATURE-----

--QRj9sO5tAVLaXnSD--

