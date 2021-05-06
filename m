Date: Thu, 6 May 2021 16:31:22 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJQLyo3hP2FdnXiv@stefanha-x1.localdomain>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-25-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="S21FU8qdwV527UnP"
Content-Disposition: inline
In-Reply-To: <20210428110100.27757-25-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 24/26] vhost-user-fs: Extend
 VhostUserFSSlaveMsg to pass additional info
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--S21FU8qdwV527UnP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 28, 2021 at 12:00:58PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: Vivek Goyal <vgoyal@redhat.com>
>=20
> Extend VhostUserFSSlaveMsg so that slave can ask it to drop CAP_FSETID
> before doing I/O on fd.
>=20
> In some cases, virtiofsd takes the onus of clearing setuid bit on a file
> when WRITE happens. Generally virtiofsd does the WRITE to fd (from guest
> memory which is mapped in virtiofsd as well), but if this memory is
> unmappable in virtiofsd (like cache window), then virtiofsd asks qemu
> to do the I/O instead.
>=20
> To retain the capability to drop suid bit on write, qemu needs to
> drop the CAP_FSETID as well before write to fd. Extend VhostUserFSSlaveMsg
> so that virtiofsd can specify in message if CAP_FSETID needs to be
> dropped.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  hw/virtio/vhost-user-fs.c                 | 5 +++++
>  include/hw/virtio/vhost-user-fs.h         | 6 ++++++
>  subprojects/libvhost-user/libvhost-user.h | 6 ++++++
>  3 files changed, 17 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--S21FU8qdwV527UnP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCUC8oACgkQnKSrs4Gr
c8iY5Af+OlFBZalg9r/BoV2HNpGFwoLEPI923YX6hPbgocGfUAm8v3kZ6RwaBZ1I
ZFdWqKVBzrI3YZKYcGOWgu2NDhp50/OFyNcGYtEXXg1GEpzA5Re2AsWCiwnArggL
2AdCJbXWnO9LpefASRs9Utp93DypEeKXSftYY9upIGAqbhAqKEwMYCubShVjPkVi
c+5lv6/qf7GYX1mkfq5MI7Vzx+lJVhhrDoMaDhEeLs/mbqtnL7PCRHfCZ0rRwvpg
sGhbo+lqtNG6mO+q9GfQaom4lJW7wYeOKoH4UZ1BbIFCpJV+xaIr+tkluFLylMTE
clZlxPUCGivzfQUUXWynqHvWZkYlHA==
=WgX0
-----END PGP SIGNATURE-----

--S21FU8qdwV527UnP--

