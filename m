Date: Tue, 17 Nov 2020 09:55:09 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201117095509.GA131917@stefanha-x1.localdomain>
References: <951c3359-f820-5c61-aa05-3419916761dc@jwatt.org>
	<CAGFMKp_nG4D7jZo=F8S=zhLUetOLF+nbN4h9teZgzSdnNp-cgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <CAGFMKp_nG4D7jZo=F8S=zhLUetOLF+nbN4h9teZgzSdnNp-cgQ@mail.gmail.com>
Subject: Re: [Virtio-fs] Issues with the virtio-fs Windows how-to
 (unexpected read-only file system)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jonas Andradas <j.andradas@gmail.com>
Cc: virtio-fs@redhat.com, ghammer@redhat.com, Jonathan Watt <jwatt@jwatt.org>


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2020 at 07:59:27PM +0100, Jonas Andradas wrote:
> On Mon, Nov 16, 2020 at 12:36 PM Jonathan Watt <jwatt@jwatt.org> wrote:

CCing Gal Hammer regarding the Windows virtio-fs drivers.

When you find a solution we can update the howto. Pull requests for
making changes to the website can be sent here:
https://gitlab.com/virtio-fs/virtio-fs.gitlab.io

>=20
> > Hello list,
> >
> > Thank you all for your work on virtio-fs. It's a very exciting step
> > forward!
> >
> > Like others[1], I've encountered the issue where virtio-fs mounted file
> > systems
> > are unexpectedly read-only/inaccessible on Windows.
> >
> > I worked through the Windows how-to page[2], but the "Installing the
> > virtio-fs
> > service" instructions at the bottom did not work for me, as written. The
> > instructions are to set the new `VirtioFsSvc` service to depend on both
> > `WinFsp.Launcher` and `VirtioFsDrv`. However, like others, I found that
> > the new
> > service would not run since `VirtioFsDrv` does not appear to exist (be a
> > service).
> >
> >
> I too did not manage this to work, and initially removed any dependencies,
> thus resulting in the same behaviour you mention.
>=20
>=20
> > After opening `regedit`, opening the key:
> >
> >   HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VirtioFsSvc
> >
> > removing `VirtioFsDrv` from the value of `DependsOnService`, and then
> > restarting
> > the `VirtioFsSvc` service, the file system shared via virtio-fs appeare=
d at
> > 'Z:\' and worked as expected. However, this only works until the Windows
> > VM is
> > rebooted.
> >
> > On rebooting the Windows VM, the shared file system becomes read-only a=
nd
> > its
> > sub-directories cannot be opened. Manually restarting the `VirtioFsSvc`
> > service
> > gets the share working again (until next reboot). This seems to indicate
> > that
> > `VirtioFsSvc` is running too early, and that it really does need to wait
> > for
> > *something* else to be ready before starting.
> >
> > I suppose the first question is what is `VirtioFsDrv` and where is it
> > supposed
> >
> to come from? Are there steps missing from the Windows how-to or has the
> > name of
> > this service changed?
> >
> >
> I checked the Virtio FS driver, both from the Device Manager (Properties
> and then checking the "Service" name associated with it) and also using t=
he
> "driverquery" command.  Based on this, I modified the service to depend
> both on WinFps.Launcher and this driver ("VirtFS") by issuing the followi=
ng
> command:
>=20
> sc.exe config VirtioFSsvc depend=3D WinFsp.Launcher/VirtFS
>=20
> However, so far I have not had better results than you, as when I reboot I
> still have the shared folder as read-only, and only restarting the service
> manually fixes it.
>=20
> I have tried different combinations by adding all the drivers I saw which
> could be involved (although unlikely, but just in case), resulting in
> dependencies such as:
>=20
> sc.exe config VirtioFSsvc depend=3D
> WinFsp.Launcher/VirtFS/vioscsi/viostor/VirtioSerial/WinFsp
>=20
> But, still, to no avail.
>=20
>=20
> > -Jonathan
> >
> > 1. For example, the comments starting here:
> >
> > https://github.com/virtio-win/kvm-guest-drivers-windows/issues/473#issu=
ecomment-658379853
> >
> > 2. https://virtio-fs.gitlab.io/howto-windows.html
> >

> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs


--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+znf0ACgkQnKSrs4Gr
c8g7zwgAuZEO30tbehJi8GD4nIEkZ9FWPCzwrafwWdQ36zccIlIMIyY5+djdnTRS
/+4nv3bpDoaxK5ul0xVpq+5fTv42Fe8MRozGRarmQq9xWwqcnmEiWoBxFr5fvOSR
qc6koyHmnbeSpm5XsLSibaFYaX0xu0P6Q5cInBPtF+bpf/A6OqjVhHdyFWNDEALE
2Ei3EWMvyRfl4VxyTBLqFvM7wdo3XCRp4E1y8MDB/tpRm/pRh4Y1nD9wXrkT+tl/
5dC1RzpSHuSHTxuZQHynQBwWa68ykWX5pP/5NFZ46IhjB66NY9es3+fKSeruVi9M
cBEDN9GwbNe968qA/ViDt6xvAzrTwQ==
=1gxD
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--

