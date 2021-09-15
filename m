Date: Wed, 15 Sep 2021 15:45:18 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YUIG/s7hrJLtGiXZ@stefanha-x1.localdomain>
References: <20210914123214.181885-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="JyxRkJI0/G7zwlE3"
Content-Disposition: inline
In-Reply-To: <20210914123214.181885-1-thuth@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] tools/virtiofsd: Add fstatfs64 syscall to
 the seccomp allowlist
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Thomas Huth <thuth@redhat.com>
Cc: virtio-fs@redhat.com, qemu-s390x@nongnu.org, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>


--JyxRkJI0/G7zwlE3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 14, 2021 at 02:32:14PM +0200, Thomas Huth wrote:
> The virtiofsd currently crashes on s390x when doing something like
> this in the guest:
>=20
>  mkdir -p /mnt/myfs
>  mount -t virtiofs myfs /mnt/myfs
>  touch /mnt/myfs/foo.txt
>  stat -f /mnt/myfs/foo.txt
>=20
> The problem is that the fstatfs64 syscall is called in this case
> from the virtiofsd. We have to put it on the seccomp allowlist to
> avoid that the daemon gets killed in this case.
>=20
> Buglink: https://bugzilla.redhat.com/show_bug.cgi?id=3D2001728
> Suggested-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  tools/virtiofsd/passthrough_seccomp.c | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--JyxRkJI0/G7zwlE3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFCBv4ACgkQnKSrs4Gr
c8isvwf/TinaF8f4yLc4IqxLf6wS4JtXdLaxXpZLZHHlU1NURkxIXD8a7XncQvHp
51IILqi4LgHPNHDdTBNFupE7tDwPjRzhueuMaOxo+aQJg+NI0j0kYaeR05jocoEL
AERlNu66XVR10DPaja9O1blOxxF2sou+C2MYDSV7lHYWs2g8iS9t9hEO77zF+VHB
VhL0jCt5GCdfQyME1wljLcXoHQWgBTArF7s/STjWWFaha+QoP6Ns/HyXqY7EbxIM
3uMxAPyypTCcrsi/2CNIOVyXmbUSzXPfG/Q+bbp6PNJDJ05UAfAxmavX3mqmCelh
SlGhr+pwvaAPRkVDAUeXZ3+tVqzAaA==
=jpo1
-----END PGP SIGNATURE-----

--JyxRkJI0/G7zwlE3--

