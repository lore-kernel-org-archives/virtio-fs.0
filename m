Date: Thu, 23 Dec 2021 12:22:19 +0100
From: Sergio Lopez <slp@redhat.com>
Message-ID: <20211223112219.7z6k4zrxq42intge@mhamilton>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cicflxcmhqgtnji3"
Content-Disposition: inline
Subject: [Virtio-fs] Announcing the release of virtiofsd (Rust) v1.0.0
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com


--cicflxcmhqgtnji3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On behalf of the Virtiofs Maintainers Team, it's my pleasure to
announce the release of virtiofsd v1.0.0, the first stable release of
the Rust implementation of the vhost-user virtiofs daemon.

This version is intended to be a drop-in replacement for the legacy C
implementation, including support for most of its command line
arguments.

You can obtain the sources for this version by checking out the
corresponding tag [1]. This version has also been published on
crates.io [2], so it's also possible to install it from sources with a
single command, by running "cargo install virtiofsd".

Thanks,
Sergio.

[1] https://gitlab.com/virtio-fs/virtiofsd/-/tags/v1.0.0
[2] https://crates.io/crates/virtiofsd

--cicflxcmhqgtnji3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmHEW+gACgkQ9GknjS8M
AjXtLw//VYFMShJZM3nCgvBJzOFBVP5t3bNMDK6vAw8Z4F/x+QA5I0GU4sLB8saW
8JtHOk9lncgaMXmf3Q6tv53yyHjuK5+k5DgmXwQoHJEsl+/lU6FWA9CHa8V4+9/Y
bZPS0wxDfF8hui1uNxbX4f2MMQ11Tn0+27zNpTQYiBvBH8qXiF38WxpKMCkQ5ZWE
9bSjlja5g17JBI8wS16xxOkKhVg3tZUfXUdyAojLcRdUZcMea01zWnIf2WrXTS5H
3BZWXqHT67tBu/0Cd9qnT163+Z4atX3wdzMSCSWpKyGqMZ9JVRoLukd5FMqmQtGv
fX2LaT/y//fHmQbXlpkHUfwxEefOs+X7rvHxIUoILjIQuRabueYEp5pxJ677fj8+
xqyJ4lIurvRaFV9d1/843pGGiBGA2FXqj/TP+1zh4LfhjjBDOpNyi+pX+b0+mF4D
JXvFpsMLHLC0rk8n+7qXjQDqxc2Oj/9mP/a77R5uVP9iRq9lz80SKK4LAlWxgnJ+
ZSDqFJRusj9K9wvqZpx/nyOONisT0QIPfGaSYcXEvy3M5FGFCn5OmWvlJk/tydlT
EvgjVEU3OpIl1Nn8A9k76lLh8QPJHmgUTefvQoRXjM0i8fhxhK10gVU/j3oRR8vc
37AjJ9On3B3UwC6S8LcL+JAq2HQExVLifUrFNMC6DB10zg9M+8A=
=V2GU
-----END PGP SIGNATURE-----

--cicflxcmhqgtnji3--

