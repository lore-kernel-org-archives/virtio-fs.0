Date: Fri, 6 Sep 2019 09:48:03 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190906084803.GA5900@stefanha-x1.localdomain>
References: <5f49cefd-a051-8af4-86a2-3ea94acd9eee@redhat.com>
	<20190827130207.GC4290@stefanha-x1.localdomain>
	<b2d18411-d518-788a-0783-1d55a11407c6@redhat.com>
	<20190828113639.GI5573@stefanha-x1.localdomain>
	<bf9d73ed-0533-1cc1-9884-3c08281dd961@redhat.com>
	<20190902102149.GH9069@stefanha-x1.localdomain>
	<def8239b-94b3-10d2-ccfa-4e71e80c8a17@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <def8239b-94b3-10d2-ccfa-4e71e80c8a17@redhat.com>
Subject: Re: [Virtio-fs] basic questions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Laszlo Ersek <lersek@redhat.com>
Cc: virtio-fs@redhat.com


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 02, 2019 at 07:27:35PM +0200, Laszlo Ersek wrote:
> On 09/02/19 12:21, Stefan Hajnoczi wrote:

Thank you for explaining!

> Of course the question is what we *want* here. The above targets the
> case when a user specifically wants to access virtio-fs *from within*
> UEFI (including the UEFI boot manager, the UEFI shell, and UEFI
> applications, such as grub2-efi).
>=20
>=20
> Other goals can be imagined. For example, the following goal is slightly
> different: "I want a guest kernel running on virtio-fs, and that guest
> kernel should find a UEFI environment underneath itself". This use case
> should be covered right now, because OVMF supports kernel / initramfs /
> cmdline via fw_cfg already. You would launch OVMF from pflash (like
> always), and instruct QEMU to load the kernel / initramfs / cmdline into
> fw_cfg from files located within the virtio-fs directory tree. OVMF
> would fetch the kernel / initramfs / cmdline from fw_cfg -- note: *no*
> firmware-level access to virtio-fs --, OVMF would launch the kernel, and
> the kernel would use its own smart driver for talking to virtio-fs. The
> kernel would also find a UEFI environment.
>=20
> This would eliminate shim/grub2 from the picture. For some cases, that
> could be seen as a benefit. For other cases, as a limitation; for
> example, if you needed Secure Boot with the Machine Owner Key management
> that shim implements.

I think the existing -kernel/-initrd/-append feature is enough for the
time being and firmware virtio-fs support is not urgent.  However, I can
also imagine cases where end-users are unable to set QEMU command-line
options because they don't have access to the virtualization management
layer, but would still like to configure virtio-fs boot from within the
VM.

Stefan

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1yHUMACgkQnKSrs4Gr
c8heLQf/eld1Cm2DksRrAZ2YMdVc3enyCpzMF3Dnr1tkKhTlc61rT1knLT02F75U
4tCmaN5nGeZYKrwMGPXBhBVlezrfnbAgogaAjnur9D/jKP4gr15Xxcz/cEopfxkh
aMsNkvwTpEk32Wk11deiFGJA71dpS/3poeGctg+hnmgKI7Nm6JHDa7ydx4aFQqV+
cAKHyxwF4QZmIAz4wayHvPZOwBcF1AVNh42h0DSulHJgJh1K7C+O1HaiUWWGX1FC
BHlO9met/mSKojdmj1hp+gyJi8iDyGLu9MUjpJvZmillfD7oCZLJ4kleFSBsPFh3
pB1xwytv1pd2GHmoZzqMU5rfoONJOA==
=V91g
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--

