Date: Tue, 8 Jun 2021 11:18:19 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YL9D62SZ5OGdI0Fp@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NHfctDhmzRYzYJ15"
Content-Disposition: inline
Subject: [Virtio-fs] Controlling the virtiofsd pidfile location
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: virtio-fs@redhat.com


--NHfctDhmzRYzYJ15
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
The following was filed in the virtiofs issue tracker:
https://gitlab.com/qemu-project/qemu/-/issues/365

  $ /pkg/qemu-6.0.0-0/libexec/virtiofsd --socket-path=/tmp/vhostqemu -o source=virtiofsd -o cache=always
  fv_socket_lock: Failed to create directory /pkg/qemu-6.0.0-0/libexec/../var/run/virtiofsd: Permission denied

In this case the relative path to the virtiofsd run directory is
incorrect.

Do you have time to look at this bug report?

Thanks,
Stefan

--NHfctDhmzRYzYJ15
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmC/Q+sACgkQnKSrs4Gr
c8h7YggAid74MTF3lSB6HOnFzmFAig00vwTzkuo0mNyK1+9+SsTnW4tJa6CNGZJR
g4Fzfgo9483t2yHUjskVg2omW6s2WqN0E27bI3dCPDD3OOYLprXLx2WUInDQ1t0U
enEfuML974wX7d6ya1feADkde1NhViYpcdIyHgUrzWkZTK0OCDUZ4QVcwi9lcq5/
9418qgoadSfolFfrNl7sAlHZH4BLbLV4/L3t0YjL+MYML3Wh/UW5Ewyd2eRA3y/3
FNkrFK7qIyJuaVeRdPQ11aZlplPmYeiTjUJdEhtTaItEtdsk/UMoe9LUyJE9qVDZ
YLHcZVu+aOu3HHU01MMx8+aMoGqd+A==
=sbHS
-----END PGP SIGNATURE-----

--NHfctDhmzRYzYJ15--

