Date: Fri, 11 Sep 2020 11:39:24 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200911103924.GJ94280@stefanha-x1.localdomain>
References: <20200909184603.263700-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GlnCQLZWzqLRJED8"
Content-Disposition: inline
In-Reply-To: <20200909184603.263700-1-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 0/9] fuse: Mirror virtio-fs submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, fuse-devel@lists.sourceforge.net


--GlnCQLZWzqLRJED8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 09, 2020 at 08:45:54PM +0200, Max Reitz wrote:
> When using virtio-fs, we want all nodes that have a unique st_dev/st_ino
> combination on the host to have such a unique combination in the guest
> as well.  To do so, we introduce a flags field to fuse_attr, where
> virtiofsd can announce submounts.  All such entries are then translated
> to auto-mounts by the FUSE driver in the guest.

The easy parts look good. I'm leaving the hard parts to Miklos :).

Stefan

--GlnCQLZWzqLRJED8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9bU9wACgkQnKSrs4Gr
c8jpqgf9HQ4mVa69Ipd1zXX0+U04dpW97IQxYnC9RSa/+utZJH+oedv1wJgVJ3EZ
aezlQYddUWpRtI1gc1anm1WxTtCAYi9SqPrPrISuNWMZlTKLQgnJ68ZQI3ohJx3t
dO1bbdaTUwSqSpXkYKoueKA8RzPsU2GDgH45BCxG8mk99pmYov8GgYuhC/06mI5I
IAH8NR/2Ey5jkU/+VS1Rxz1Z+4m4uEBFjN/Sgb1jRJ9UJ4GZI4NsvzpF5epkexMS
OfLZfZ3irT1tFdcfbtDIqRhM4PA5ZICdf8mkrOeRojI+YAXpbFV+2lVKfChDGjrb
jyD+jdioZLZX7JSZkzppPeaN0HiHFA==
=RoQp
-----END PGP SIGNATURE-----

--GlnCQLZWzqLRJED8--

