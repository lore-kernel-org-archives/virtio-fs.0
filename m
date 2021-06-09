Date: Wed, 9 Jun 2021 10:51:56 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YMCPPCbjbRoPAEcL@stefanha-x1.localdomain>
References: <20210608153524.GB504497@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="1gWRfrkqtUD7GC5m"
Content-Disposition: inline
In-Reply-To: <20210608153524.GB504497@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] init/do_mounts.c: Add root="fstag:<tag>"
 syntax for root device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard.weinberger@gmail.com>, Dominique Martinet <asmadeus@codewreck.org>, linux kernel mailing list <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net


--1gWRfrkqtUD7GC5m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 08, 2021 at 11:35:24AM -0400, Vivek Goyal wrote:
> We want to be able to mount virtiofs as rootfs and pass appropriate
> kernel command line. Right now there does not seem to be a good way
> to do that. If I specify "root=3Dmyfs rootfstype=3Dvirtiofs", system
> panics.
>=20
> virtio-fs: tag </dev/root> not found
> ..
> ..
> [ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown=
-block(0,0) ]
>=20
> Basic problem here is that kernel assumes that device identifier
> passed in "root=3D" is a block device. But there are few execptions
> to this rule to take care of the needs of mtd, ubi, NFS and CIFS.
>=20
> For example, mtd and ubi prefix "mtd:" or "ubi:" respectively.
>=20
> "root=3Dmtd:<identifier>" or "root=3Dubi:<identifier>"
>=20
> NFS and CIFS use "root=3D/dev/nfs" and CIFS passes "root=3D/dev/cifs" and
> actual root device details come from filesystem specific kernel
> command line options.
>=20
> virtiofs does not seem to fit in any of the above categories. In fact
> we have 9pfs which can be used to boot from but it also does not
> have a proper syntax to specify rootfs and does not fit into any of
> the existing syntax. They both expect a device "tag" to be passed
> in a device to be mounted. And filesystem knows how to parse and
> use "tag".
>=20
> So this patch proposes that we add a new prefix "fstag:" which specifies
> that identifier which follows is filesystem specific tag and its not
> a block device. Just pass this tag to filesystem and filesystem will
> figure out how to mount it.
>=20
> For example, "root=3Dfstag:<tag>".
>=20
> In case of virtiofs, I can specify "root=3Dfstag:myfs rootfstype=3Dvirtio=
fs"
> and it works.
>=20
> I think this should work for 9p as well. "root=3Dfstag:myfs rootfstype=3D=
9p".
> Though I have yet to test it.
>=20
> This kind of syntax should be able to address wide variety of use cases
> where root device is not a block device and is simply some kind of
> tag/label understood by filesystem.

"fstag" is kind of virtio-9p/fs specific. The intended effect is really
to specify the file system source (like in mount(2)) without it being
interpreted as a block device.

In a previous discussion David Gilbert suggested detecting file systems
that do not need a block device:
https://patchwork.kernel.org/project/linux-fsdevel/patch/20190906100324.849=
2-1-stefanha@redhat.com/

I never got around to doing it, but can do_mounts.c just look at struct
file_system_type::fs_flags FS_REQUIRES_DEV to detect non-block device
file systems?

That way it would know to just mount with root=3D as the source instead of
treating it as a block device. No root=3D prefix would be required and it
would handle NFS, virtiofs, virtio-9p, etc without introducing the
concept of a "tag".

  root=3Dmyfs rootfstype=3Dvirtiofs rootflags=3D...

I wrote this up quickly after not thinking about the topic for 2 years,
so the idea may not work at all :).

--1gWRfrkqtUD7GC5m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDAjzwACgkQnKSrs4Gr
c8g2rwf+Lbq/l7qNfPeFBCeT7qDKMbAHP2CWZ4cOwtMJlonO6Dizq4JR3Uo5ac6/
Trie8uXKrFnh2h7kr8DD5AVWsljs5+AJ8OlIJkMWltY0S2gxXxtdlTCOpQGKxWJK
Bh8EiKe7pbCQcu57HKkOHaC9LLG0FZy6H5pMe+7kfZmQYwQRR/Uv3pnDw+79+N21
cfNLK54eK1i/3vQQnckIJ72dlQTbWUyF0MgXtSBwL+AAT7LYsex7EBhGZ7m8BLXG
ohOBGCslB/Uifdo5HU2qpKiuaO5cYksQvD5QxTZvz1mq+C7BwXX/Ogom4VjzJMUh
wuxTjfmYn45Rp66p1EzQ31EWtkgqXw==
=5rNC
-----END PGP SIGNATURE-----

--1gWRfrkqtUD7GC5m--

