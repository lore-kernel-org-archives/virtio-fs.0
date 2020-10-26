Date: Mon, 26 Oct 2020 14:59:04 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201026145904.GC52035@stefanha-x1.localdomain>
References: <20201023165812.36028-1-dgilbert@redhat.com>
	<20201023165812.36028-2-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ALfTUftag+2gvp1h"
Content-Disposition: inline
In-Reply-To: <20201023165812.36028-2-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 1/5] tools/virtiofsd: xattr name
	mappings: Add option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: dinechin@redhat.com, virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2020 at 05:58:08PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Add an option to define mappings of xattr names so that
> the client and server filesystems see different views.
> This can be used to have different SELinux mappings as
> seen by the guest, to run the virtiofsd with less privileges
> (e.g. in a case where it can't set trusted/system/security
> xattrs but you want the guest to be able to), or to isolate
> multiple users of the same name; e.g. trusted attributes
> used by stacking overlayfs.
>=20
> A mapping engine is used with 3 simple rules; the rules can
> be combined to allow most useful mapping scenarios.
> The ruleset is defined by -o xattrmap=3D'rules...'.
>=20
> This patch doesn't use the rule maps yet.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  docs/tools/virtiofsd.rst         |  92 ++++++++++++++++
>  tools/virtiofsd/passthrough_ll.c | 173 +++++++++++++++++++++++++++++++
>  2 files changed, 265 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--ALfTUftag+2gvp1h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+W5DgACgkQnKSrs4Gr
c8hXnAf9FRtyTrpmi38Fkm6CGlb2OCJiWoJvjz0oEPb82LFKPmDQglfbALDYRtNe
r0/iJScUlsbemrzhqow6+B/DgjQn5J/HgYXBLxi5HHvi2flAnHVUvB1fb9BCwOGH
loxODG1b6lBXDHfh6+2Ikk9sClPhM0dak6W4+2p8gmqFpvDcNs1TrC8Y46C36P+O
9zKijiF8g+OWl+Uy2W7G+pmWCP3dJqttKKP2KsDII47JTTlboVWJMVTPlJo8lxA+
Ig78ZfthyF8zwqunMZS6wBJICiJ8Awc2pGV0OcVgy/iUNo1UTTGn9jMR0aJJB9A8
gzt9o06tX7bOsbmb/BAY4mri57BmFA==
=lUXW
-----END PGP SIGNATURE-----

--ALfTUftag+2gvp1h--

