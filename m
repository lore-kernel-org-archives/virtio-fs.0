Date: Wed, 24 Feb 2021 15:02:48 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YDZqmFRjo7EfuSA2@stefanha-x1.localdomain>
References: <20210223225250.23945-1-vgoyal@redhat.com>
	<20210223225250.23945-3-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="qeak9ylNud5wPNaF"
Content-Disposition: inline
In-Reply-To: <20210223225250.23945-3-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 2/2] virtiofsd: Enable posix_acls by
 default if xattrs are enabled
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, miklos@szeredi.hu, qemu-devel@nongnu.org


--qeak9ylNud5wPNaF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 23, 2021 at 05:52:50PM -0500, Vivek Goyal wrote:
> Fuse protocl wants file server to opt in for FUSE_POSIX_ACL if posix
> acls are to be enabled. Right now virtiofsd does not enable it. This
> patch opts in for FUSE_POSIX_ACL if xattr support is enabled.
>=20
> When parent directory has default acl and a file is created in that
> directory, then umask is ignored and final file permissions are
> determined using default acl instead. (man 2 umask).
>=20
> Currently, fuse applies the umask and sends modified mode in create
> request accordingly. fuse server can set FUSE_DONT_MASK and tell
> fuse client to not apply umask and fuse server will take care of
> it as needed.
>=20
> With posix acls enabled, requirement will be that we want umask
> to determine final file mode if parent directory does not have
> default acl.
>=20
> So if posix acls are enabled, opt in for FUSE_DONT_MASK. virtiofsd
> will set umask of the thread doing file creation. And host kernel
> should use that umask if parent directory does not have default
> acls, otherwise umask does not take affect.
>=20
> Miklos mentioned that we already call unshare(CLONE_FS) for
> every thread. That means umask has now become property of per
> thread and it should be ok to manipulate it in file creation path.
>=20
> So this patch also opts in for FUSE_DONT_MASK if posix acls are enabled
> and changes umask to caller umask before file creation and restores
> original umask after file creation is done.
>=20
> This should fix fstest generic/099.
>=20
> Reported-by: Luis Henriques <lhenriques@suse.de>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--qeak9ylNud5wPNaF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmA2apgACgkQnKSrs4Gr
c8hohggArikNHhycv2EGxYGzN2/ktYvmeaDlAOhQ/xB11j26Bx3xo2QoV3Zf1MfV
nlBGEH6iCYzUcCj9jg9F1yWN2O8z1StkyIFUuccwxKoCLYt1ag4J0j8EYnNPrubE
A1Pi72Zyl8xrdTr8P/E7Sq++ybmiGmrKzUgSjsER6u3NeSQ6Ok7lOphE8gS9Z3WV
kYBu8Wqs0bclBd8XD2eKZm/kdOZWdR3VIl98XNL5pvL0Rg5Kbs+u46y86t+lPanL
yfpSfVPOtVMU0kSsYKNjx6Hky4Et4rZpRxyMIfITuH43K1y3soGfu1HJZ4FiKYD5
ZQIxRclZoYFyh4/4ddj2BXeUgwLhUQ==
=i7ub
-----END PGP SIGNATURE-----

--qeak9ylNud5wPNaF--

