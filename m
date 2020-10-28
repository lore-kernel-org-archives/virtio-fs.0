Date: Wed, 28 Oct 2020 10:53:27 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201028105327.GD221115@stefanha-x1.localdomain>
References: <AM0PR03MB6292A6819675EF4384D80510A6190@AM0PR03MB6292.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="EP0wieDxd4TSJjHq"
Content-Disposition: inline
In-Reply-To: <AM0PR03MB6292A6819675EF4384D80510A6190@AM0PR03MB6292.eurprd03.prod.outlook.com>
Subject: Re: [Virtio-fs] Architecture diagram license
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Fotis Xenakis <foxen@windowslive.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>


--EP0wieDxd4TSJjHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 26, 2020 at 11:31:54PM +0000, Fotis Xenakis wrote:
> OSv is a unikernel happily running on QEMU/KVM, supporting different filesystems. Virtio-fs is a great fit for unikernels: it offers an escape route from rebuilding images for every change and very competitive performance just to name a couple of factors.
> I decided as part of my thesis to tackle read-only virtio-fs DAX window support on the OSv side (nothing big, no comparison to linux). This has been merged and works on OSv and I 've been working on evaluating it (spoiler: it works very nicely and performance is pretty good).
> Unfortunately, the thesis containing the detailed evaluation is mostly in Greek, in any case you can find it here https://github.com/foxeng/diploma. When time allows, I will also do an English write-up for sharing. If anyone's interested, I 'll make sure to post it here too!

You are welcome to write a guest post on the QEMU blog
(https://qemu.org/blog/) that gives an overview of OSv and the virtio-fs
device interface. I imagine people would be interested in learning about
both these topics.

The git repo for the QEMU website and blog is here:
https://gitlab.com/qemu-project/qemu-web

You can create a new blog post by dropping a Markdown file into _posts/.
Images can be added to screenshots/ directory.

The blog post can be sent to the QEMU mailing list using
git-send-email(1) with Thomas Huth <thuth@redhat.com> CCed. Please also
CC virtio-fs@redhat.com and we'll review it.

Stefan

--EP0wieDxd4TSJjHq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+ZTacACgkQnKSrs4Gr
c8jm2gf9FtOt2LETfxM0Dzt2bIbNwTvJj/OgBFT/mxa2/IYsq4z8mCiCxP+tuJTO
GH/YYAnm6wwtRaAEhO9XicryvYGLhK9GPn8/YaGPMP4lDigpLTfwAjG6sPqRPzCr
RhMx7Dng/ho29pKkT1lWEfnyzlkZUO+IYmV7TNRWTBdVgrybZa/1/RFRGzABr3D3
u6/ZkDhQdNOzBzjGo/nIua3gRgjJs5yBx3ObL7ISNR6NHH0Yh1OHIKp8Xhr1sZAy
ZgO1K+EgbsnQkA/3u9V5Bz1uwruu3/ZNNb5HMfUbSLIwNHGCNuZeCVViejJNJmnA
cafBn6PASSFI+lqFyZ1TU0WpVzCTyw==
=8ZgR
-----END PGP SIGNATURE-----

--EP0wieDxd4TSJjHq--

