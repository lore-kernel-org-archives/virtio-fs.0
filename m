Date: Tue, 22 Oct 2019 16:56:41 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191022155641.GA762@stefanha-x1.localdomain>
References: <20191021150414.GD5837@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <20191021150414.GD5837@work-vm>
Subject: Re: [Virtio-fs] Upstreaming virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2019 at 04:04:14PM +0100, Dr. David Alan Gilbert wrote:
> Hi,
>   I've started upstreaming virtiofsd to qemu's contrib directory;
> my first set (
> https://lists.gnu.org/archive/html/qemu-devel/2019-10/msg05200.html )
> is a minimal base set of patches that mounts and basically works - it
> has none of the security work, the performance or many of the fixes.
>=20
> In parallel with responding to any comments on that set, I'll be
> working up the security set to be sent next; then performance and then
> fixes.

Please include "[PATCH 0/2] virtiofsd: add net and pid namespace
sandboxing" (<20191016160157.12414-1-stefanha@redhat.com>) in the
security patch series.

Thanks,
Stefan

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2vJrkACgkQnKSrs4Gr
c8hzZQgAjtW9POdPnGpRE4MOllD9ARZ7699bEpCUD1QNDaqBb4AjWoOsWFdWc5LO
l1yNuFtrrUHF70t7d4GT2OA7fdohwSYlIrfWXTdhXQnm8q1RFFnqWwKcoKndMfhn
xO356GzTuhysLU3V3xLJuOdKEohkXg2gk8ju7ShTma4NZJdcT94FCTtHT30M2Rzq
uYyyxNJ/mlccZKaNUPrwJXmLvkxGeN11ql+E5MGpd9kQtHUAb/ooT1P9RFZOeRcq
r1+vchjBQy8QtgpQ9EFi4KzF0HPE+K4pfZu/4LDqXLeppkRCda9Pfjs1q2wwAPYG
G2CKRav0uHs7GmLhh3Sft14Jlka7WA==
=wzWq
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--

