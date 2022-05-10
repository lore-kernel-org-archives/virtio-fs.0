Return-Path: <slp@redhat.com>
Date: Tue, 10 May 2022 12:17:24 +0200
From: Sergio Lopez <slp@redhat.com>
Message-ID: <20220510101724.4tpwr5vj3uxegusz@mhamilton>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="p5vs5euyb36ke2rg"
Content-Disposition: inline
Subject: [Virtio-fs] Release announcement: virtiofsd v1.2.0
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com


--p5vs5euyb36ke2rg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

We've just released version v1.2.0 of virtiofsd (Rust). This release
comes with a significant number of fixes and improvements. The list of
merged MRs is included the tag annotation.

Starting with this release, we're attaching a statically-linked binary
with each tag for easy consumption from CI/CD systems. You can find
the link just after the change log:

https://gitlab.com/virtio-fs/virtiofsd/-/tags/v1.2.0

This release is also available on creates.io:

https://crates.io/crates/virtiofsd

Thanks to all the contributors that have made this release possible!
Sergio.

--p5vs5euyb36ke2rg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmJ6O7EACgkQ9GknjS8M
AjWLJhAAijr+tLkQQ384xSr+I+iTipj9hc02hrUYMNHMr7kMAus+5CNx3OVNdxrg
f3ulGczvfhuWK321qDMbdKfm/+toGnzyCyfRELQrbPJhRaBTrs+8wdfhsuFWYjyi
shF8d2HmShX1tJv7+4fea0xRLZqUg+js0n2uGzgnFZ/dpYbGSNS+OddGEmiVCtzV
h9nyncL+BgSyGTY70Q5fuJBnVwj2jOEEd9ePbxabefyWDZbxGgWklg+jOv906kaT
hLkKrTrsYDxVMmbgL0lafoE9OCFllEqb6z2BgyZ2Tm58oCjGv8vdJYF5cuEQNqKu
N5NpPBqtJcqn4Qt7lE0WYtF4YyhZ8VmtbsjKKjZno4ZA127hJcQKf9Gaj87WOr4R
qovWFAcMcyYe0h3GOjdaExgVuLB3MGEGMa7G0CSujAVklNv1sDzvD6K7ilGUsnZv
7FCoUSIjbAoRZmXaN90yhHvGRR+hAR2qYuBK9NmJIgQ0NI1ZsABN9TMFce9/Wnqs
0nZ7przoO9LuAZmktFr/z7u8e242YibVLoKg+WlJUePTjow/Hh3ff6/4CLeFsntf
KD1/J5DtmxAXfCecPJTD124vX4JXVxPM1Ms013oYM45htTVhgkA4lSw4QRQGGpkP
12uNDpz2tIAJMzqLOzQNXzb33itq57wo7VAiQaut9njLmjZ9T2Y=
=ICRg
-----END PGP SIGNATURE-----

--p5vs5euyb36ke2rg--
