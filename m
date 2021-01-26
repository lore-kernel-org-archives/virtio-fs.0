Date: Tue, 26 Jan 2021 10:18:39 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210126101839.GC226981@stefanha-x1.localdomain>
References: <20210121144429.58885-1-stefanha@redhat.com>
	<CAOssrKfjLrR0TXqPgk7sYAz9xiuNankgQpOtX69-zXWaGOnu6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="m51xatjYGsM+13rf"
Content-Disposition: inline
In-Reply-To: <CAOssrKfjLrR0TXqPgk7sYAz9xiuNankgQpOtX69-zXWaGOnu6w@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: prevent opening of special files
 (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: QEMU Developers <qemu-devel@nongnu.org>, P J P <ppandit@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, Alex Xu <alex@alxu.ca>, Vivek Goyal <vgoyal@redhat.com>


--m51xatjYGsM+13rf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 25, 2021 at 05:12:23PM +0100, Miklos Szeredi wrote:
> On Thu, Jan 21, 2021 at 3:44 PM Stefan Hajnoczi <stefanha@redhat.com> wro=
te:
>=20
> > This patch adds the missing checks to virtiofsd. This is a short-term
> > solution because it does not prevent a compromised virtiofsd process
> > from opening device nodes on the host.
>=20
> I think the proper solution is adding support to the host in order to
> restrict opens on filesystems that virtiofsd has access to.
>=20
> My idea was to add a "force_nodev" mount option that cannot be
> disabled and will make propagated mounts  also be marked
> "force_nodev,nodev".

Interesting idea! Mount options that are relevant:
 * noexec
 * nosuid
 * nodev
 * nosymfollow

Do you have time to work on the force_* mount options?

> A possibly simpler solution is to extend seccomp to restrict the
> process itself from being able to open special files.  Not sure if
> that's within the scope of seccomp though.

I don't think seccomp can provide that restriction since it's unrelated
to the syscall or its arguments.

Stefan

--m51xatjYGsM+13rf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAP7H8ACgkQnKSrs4Gr
c8jdSwf9E1mD1VAaCfckl0hm6tbK8c1Wt54RHVHhQf35aUTrvJ3OlHkTAHa8vNRj
70enEUf44Nb3xnVXMHeVW1/oS9DmuMqgjTHZx6rK6JF6NZnUlBSliWNU5f1q7Sqa
2eisPVryuXnyPKURZwqxvpd+nVIMbhwIGA+QwTNzUq4ph9ZSBbCaxcLdfYzHlIm+
OuoJ61nbExx0xDlZ9gbC8GFGSxmrwcDJpzEbf3D4XSrzEyq+Fsl43EIWd/qxTX1w
Mxn6y8JD1taY6B4Lk7fx0X7XlVvcW7eGI1OBZUNh0MmzyAqNgbfDV0A9ZYoN2VzU
P9yYfJJyTeVZzX8Vwdm4PiCRAGWFCQ==
=dyMC
-----END PGP SIGNATURE-----

--m51xatjYGsM+13rf--

