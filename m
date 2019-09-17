Date: Tue, 17 Sep 2019 16:42:10 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190917154210.GA18511@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
Subject: [Virtio-fs] virtio-fs needs option parsing?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs@redhat.com


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Miklos,
While testing the latest virtio-fs kernel patches I noticed that
/proc/mounts says:

  myfs / virtiofs rw,relatime,user_id=0,group_id=0,default_permissions,allow_other 0 0

And this causes an error when shutting down the guest:

  [2339]: Remounting '/' read-only in with options 'user_id=0,group_id=0,default_permissions,allow_other'.
  virtiofs: Unknown parameter 'user_id'
  [2339]: Failed to remount '/' read-only: Invalid argument

I guess that either options shouldn't be reported in /proc/mounts or the
'virtiofs' file system should parse options.

This isn't a show-stopper but I think it should be fixed eventually.
Thoughts?

Stefan

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2A/tIACgkQnKSrs4Gr
c8gGSQgAwu7RrW5t2q8KuSMEZ15p9zA/K7yr9xiC+Rl/V9sqXEGsLHR1LKUB/KKP
XU7LvSZKWpf79pX434yRQk1pm8Gm+JGx1iU8G8hyO5uJhu0Ri73lZbmeABFIdzHw
jpu8mw1o6/Qa/zpK2FgbrsXFb+AiQqlZ1zhBxJgsCHOZzsHhL8j6XPHU2DI5/7T6
hdi8lA6erO+y0a+6qR5QJcWFxGGj2t5JQBTi8/rUx6nSBNApEJFc4+dFsypWQxBr
e/Jxl4s7VszoMEjcao7rlrHxsmX7D90+UxUYFEkwHBofgFL78ce9fyuCF1yu1/6B
okpsL0Knazo8dXkGWptUp9wdfUhMuw==
=rVns
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--

