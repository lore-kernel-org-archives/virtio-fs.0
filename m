Date: Fri, 5 Jul 2019 09:04:01 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190705080401.GC10995@stefanha-x1.localdomain>
References: <20190704104650.GF1609@stefanha-x1.localdomain>
	<5D1ED564.6040705@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uh9ZiVrAOUUm9fzH"
Content-Disposition: inline
In-Reply-To: <5D1ED564.6040705@huawei.com>
Subject: Re: [Virtio-fs] Achieving parallelism in virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com


--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 05, 2019 at 12:43:16PM +0800, piaojun wrote:
> From your description, virtiofsd does the same work as SPDK, and I
> wonder if we could adapt it to SPDK-vhost-fs which is widely used.

I don't see 9P code in spdk.git/master.  How does the guest access
SPDK's vhost-fs device and where is the code?

A quick look at blobfs suggests additional work is needed to introduce
the concept of inodes instead of performing path name traversal on most
operations.  This also changes the semantics of the file system since
POSIX files can still be accessed after they are unlinked or renamed.

In theory SPDK can implement the vhost-user-fs device interface and
replace virtiofsd but SPDK needs a POSIX file system implementation
first.

Stefan

--uh9ZiVrAOUUm9fzH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0fBHEACgkQnKSrs4Gr
c8jYmgf+Lw6O7w+/DFjxdBgyJYl7flhXyNL7a2OLP86/j4vHuyw3XD0JMThRtCK2
iAqtvE41kz8ut8DmmdtrZvl6gGA213nhOs3JM7oXEvaBKbILe+11mxjSdVDINqFp
xK+zrMN2zq2KijUHweuu2QtMOUwRiJhGIZfU44KxLDXhnRvE+mS+ukE2oTMq8Y6H
mav2T3/n6air0E1dOSLCq8/KRW0cAZQT73cy89Y8Nh5BPk9dcqc1Y1KC/43qUcAO
cH360eJgTJntbl/UCkIxaUWHBv13ZId3NSuIshUObZXzx0inS2+rId0yEk0fKwqZ
BPSrOFIT2trEWU1EmQjXxm52X8+JMg==
=bARX
-----END PGP SIGNATURE-----

--uh9ZiVrAOUUm9fzH--

