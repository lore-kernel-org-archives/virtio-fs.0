Date: Wed, 10 Nov 2021 15:14:19 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YYvhy5Lm7YaqCWix@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<25571471.tMsSMU6axZ@silver>
	<YYuZfkfbxcX0JDRN@stefanha-x1.localdomain>
	<2300275.fgjvgC56zr@silver>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="MTgpPM+Ebq/nv70D"
Content-Disposition: inline
In-Reply-To: <2300275.fgjvgC56zr@silver>
Subject: Re: [Virtio-fs] [PATCH v2 0/3] virtio: increase VIRTQUEUE_MAX_SIZE
	to 32k
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christian Schoenebeck <qemu_oss@crudebyte.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Amit Shah <amit@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Fam Zheng <fam@euphon.net>, Raphael Norwitz <raphael.norwitz@nutanix.com>


--MTgpPM+Ebq/nv70D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 10, 2021 at 02:14:43PM +0100, Christian Schoenebeck wrote:
> On Mittwoch, 10. November 2021 11:05:50 CET Stefan Hajnoczi wrote:
> As you are apparently reluctant for changing the virtio specs, what about=
=20
> introducing those discussed virtio capabalities either as experimental on=
es=20
> without specs changes, or even just as 9p specific device capabilities fo=
r=20
> now. I mean those could be revoked on both sides at any time anyway.

I would like to understand the root cause before making changes.

"It's faster when I do X" is useful information but it doesn't
necessarily mean doing X is the solution. The "it's faster when I do X
because Y" part is missing in my mind. Once there is evidence that shows
Y then it will be clearer if X is a good solution, if there's a more
general solution, or if it was just a side-effect.

I'm sorry for frustrating your efforts here. We have discussed a lot of
different ideas and maybe our perspectives are not that far apart
anymore.

Keep going with what you think is best. If I am still skeptical we can
ask someone else to review the patches instead of me so you have a
second opinion.

Stefan

--MTgpPM+Ebq/nv70D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmGL4csACgkQnKSrs4Gr
c8hXHAgAtaP4ELK5JSkI414ODRdabvMoQt2nDELgtpS3NUjXpfqKHpUHbyrcUpaE
DGxzhTczL404hvICt0gUNX220NweknvsnJrnzVVgk4gntfXr8lFX47/kmJSa9UER
axepbVKICpupNjnU3qb/4xpatpCfG58yLOjJOs1KokxJJE0eRuX3UmwZanf2nVyY
X4DDv+4GeVjSuy5CLyiqXEB/WgGOQNMeKdoQujDqlM9Qq/2P3CNVZ06uz1+cVa/g
6+6X99e5f02yw6ud6+zXOHp3kkdVUdDaCf9w9Lv5+x+HQ7k8G00OmC2tuzv6CGYY
xqzmyiCsjmH0Ky0z2BL3EzAGLwdy5A==
=n0yC
-----END PGP SIGNATURE-----

--MTgpPM+Ebq/nv70D--

