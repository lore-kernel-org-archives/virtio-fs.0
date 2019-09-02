Date: Mon, 2 Sep 2019 11:21:49 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190902102149.GH9069@stefanha-x1.localdomain>
References: <5f49cefd-a051-8af4-86a2-3ea94acd9eee@redhat.com>
	<20190827130207.GC4290@stefanha-x1.localdomain>
	<b2d18411-d518-788a-0783-1d55a11407c6@redhat.com>
	<20190828113639.GI5573@stefanha-x1.localdomain>
	<bf9d73ed-0533-1cc1-9884-3c08281dd961@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BXr400anF0jyguTS"
Content-Disposition: inline
In-Reply-To: <bf9d73ed-0533-1cc1-9884-3c08281dd961@redhat.com>
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


--BXr400anF0jyguTS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29, 2019 at 04:08:00PM +0200, Laszlo Ersek wrote:
> On 08/28/19 13:36, Stefan Hajnoczi wrote:
> > On Tue, Aug 27, 2019 at 11:05:45PM +0200, Laszlo Ersek wrote:
> >> On 08/27/19 15:02, Stefan Hajnoczi wrote:
> >>> On Sat, Aug 24, 2019 at 01:09:18PM +0200, Laszlo Ersek wrote:
> >>>> [...]
> >>> [...]
> >>
> >> Thanks for the updates for / answers to my questions (1) through (5). =
In
> >> particular I hadn't realized that it's virtiofsd to process the virtqu=
eues!
> >>
> >>>> (6) I seem to recall that virtio-fs allows guests to notice if files
> >>>> have changed since they last looked.
> >>>>
> >>>> Is that functionality tied to "ireg" daemon, and to the "versiontabl=
e"
> >>>> property added in commit 8fb5b17bea63 ("virtio-fs: Allow mapping of =
meta
> >>>> data version table", 2019-08-23)?
> >>>
> >>> Currently only virtiofsd -o cache=3Dnone guarantees fresh metadata (a=
t a
> >>> performance cost).  The ireg daemon is experimental and incomplete, b=
ut
> >>> it will make coherent metadata cheaper in the future.
> >>>
> >>> There is currently no inotify support in FUSE, so the guest does not
> >>> receive notifications when the file system changes.  Right now guests
> >>> would have to poll for changes.
> >>
> >> Sorry, I was unclear. It's fine for my use case if the guest has to ask
> >> actively about intermittent metadata changes. My interest is not in
> >> notifications.
> >>
> >> E.g. assume the guest tries to read or write a file it has opened
> >> earlier. (With explicit FUSE_READ / FUSE_WRITE requests, wrapped into
> >> the usual virtio descriptor chains.) Can the guest ask, in the read or
> >> write request, "please reject this request of mine if the file has
> >> changed since I last looked"? [1]
> >=20
> > No, FUSE_READ/FUSE_WRITE don't support that.
> >=20
> >> Is the "ireg" daemon, or "-o cache=3Dnone", required for that?
> >=20
> > No.  Userspace applications that share access to a file with at least
> > one writer need to synchronize via file locks or out-of-band
> > communication.  This is how existing applications work so even if
> > virtio-fs offered Compare-and-Swap semantics or similar conditional I/O
> > primitives, I think very few applications would use them.
> >=20
> >> However: is another (different) shared memory region planned, for the
> >> kind of stale metadata detection that I describe above, at [1]?
> >=20
> > Yes, there will be a second region containing inode version numbers.
> > This way FUSE clients can check if the inode was modified by another
> > client without making a FUSE request to the server.
>=20
> I think I understand now:
>=20
> * "inode version number has changed"
>=20
>   implies
>=20
>   "it makes sense to look at the file again"
>=20
> * "inode version number has not changed"
>=20
>   does *not* imply
>=20
>   "my next FUSE_READ / FUSE_WRITE will apply to state I've seen"

Yes.  The version number only relates to metadata, not data.  There
would be a race between checking the number and FUSE_READ/FUSE_WRITE
anyway.

> --*--
>=20
> Here's why I've raised this line of questions. In the UEFI-2.8 spec,
> EFI_SIMPLE_FILE_SYSTEM_PROTOCOL.OpenVolume() says,
>=20
>     [...] If the medium is changed while there are open file handles to
>     the volume, all file handles to the volume will return
>     EFI_MEDIA_CHANGED. To access the files on the new medium, the volume
>     must be reopened with OpenVolume(). [...]
>=20
> Additionally, in EFI_FILE_PROTOCOL.Open():
>=20
>     [...] If the medium of the device changes, all accesses (including
>     the File handle) will result in EFI_MEDIA_CHANGED. To access the new
>     medium, the volume must be reopened. [...]
>=20
> And I've been wondering if the UEFI driver could check inode versions
> for returning EFI_MEDIA_CHANGED.
>=20
> - For that however, extending our VIRTIO_DEVICE_PROTOCOL with shared
> memory region mapping facilities would be a pre-requisite. That would
> not be a trivial amount of work.
>=20
> - And even if the UEFI driver checked the inode version before
> submitting a FUSE_READ / FUSE_WRITE, that would be a TOC/TOU race.
>=20
> So I think we'll take EFI_MEDIA_CHANGED (and shared memory region
> mapping) off the table. Instead, we should document -- whenever we get
> there -- that with EFI_SIMPLE_FILE_SYSTEM_PROTOCOL abstracting a
> virtio-fs device, the file system could change asynchronously to the
> guest firmware.

Yes, I agree.

> Should we ever need synchronization more flexible than (1) and (2), we
> could expose discretionary file locks to specific UEFI applications that
> cared:
>=20
> EFI_FILE_PROTOCOL.GetInfo() and EFI_FILE_PROTOCOL.SetInfo() take a GUID
> that identifies the "type of information", plus a (Buffer, Size) pair.
> We can invent a new GUID with "uuidgen", for handling file locks.
>=20
> (The SetInfo() and GetInfo() APIs were deliberately designed like this
> in UEFI. There are a few standardized GUIDs that all filesystems are
> expected to support -- EFI_FILE_INFO, EFI_FILE_SYSTEM_INFO,
> EFI_FILE_SYSTEM_VOLUME_LABEL --, but filesystem implementations are free
> to extend these interfaces with new GUIDs that they invent and document.)

Interesting.  File locking support is being worked on in virtio-fs at
the moment.  The majority of UEFI use cases will probably be limited to
booting though and won't need file locking.

Another topic:
Does UEFI have a standard interface for configuring and storing boot
devices and information (e.g. kernel filename, initramfs, command-line)?
This information is necessary when booting directly from virtio-fs.

Stefan

--BXr400anF0jyguTS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1s7T0ACgkQnKSrs4Gr
c8jz1Af/TdIOdzw8BqSBLCVKfJSrh3Hy+CftOePDLOGK8fmfK08BA4y2m8zskuWS
UJZmYl3p+VBHziHzPWjzgwK99VIc6AM5RaCBwoDEzHSd4Fh79SazYQSRjPpC6rkr
KNljnroRHQLZN0DAoEVFep9VQQ2RlxsZsww3yURoKmtZqzhfeeMo+edM6uSvpFNR
QbiKUyPV1P+JxRC/5Jg8+YE+WwXcm7xPJ0OT7ngf1IW/mDe7iNzceeC7+BsFRK2z
S7wlbjiOvc6bdeKWULNumj0BeDl0cOvH7+9THrLtnoBwoG9AoOJu25sFLiCRgk0q
vp7VQyLNwAn3nEX2SQR9RLYBrR9fLg==
=IlMU
-----END PGP SIGNATURE-----

--BXr400anF0jyguTS--

