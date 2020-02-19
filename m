Date: Wed, 19 Feb 2020 15:24:05 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200219152405.GA1085125@stefanha-x1.localdomain>
References: <20200214192705.GE18654@redhat.com> <20200214194130.GP3283@work-vm>
	<20200218133821.GE786556@stefanha-x1.localdomain>
	<a3880c0b-32b2-0197-822c-d78fcbfe177c@redhat.com>
	<47f62cf4-5b44-b2f0-52f3-5b889d1c3ac8@redhat.com>
	<20200218185831.GV3080@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20200218185831.GV3080@work-vm>
Subject: Re: [Virtio-fs] One virtiofs daemon per exported dir requirement
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


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2020 at 06:58:31PM +0000, Dr. David Alan Gilbert wrote:
> * Daniel Walsh (dwalsh@redhat.com) wrote:
> > On 2/18/20 1:29 PM, Daniel Walsh wrote:
> > > On 2/18/20 8:38 AM, Stefan Hajnoczi wrote:
> > >> On Fri, Feb 14, 2020 at 07:41:30PM +0000, Dr. David Alan Gilbert wro=
te:
> > >>> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > >>>> Hi,
> > >>>>
> > >>>> Dan Walsh and Mrunal mentioned that one virtiofsd daemon per expor=
ted
> > >>>> directory requirement sounds excessive. For container use case, th=
ey have
> > >>>> atleast 2-3 more directories they need to export (secrets and /etc=
/host). And
> > >>>> that means 3-4 virtiofsd running for each kata container.=20
> > >>>>
> > >>>> One option seems that bind mount all exports in one directory and =
export
> > >>>> that directory using one virtiofsd. I am aware of atleast one prob=
lem
> > >>>> with that configuraiton and that is possibility of inode number co=
llision
> > >>>> if bind mounts are coming from different devices. Not sure how many
> > >>>> applications care though. Sergio is looking into solving this issu=
e. It
> > >>>> might take a while though.
> > >>> I thought the bind mount setup was the normal setup seen under both=
 Kata
> > >>> and k8s?
> > >> Kata Containers works as follows:
> > >>
> > >> kata-runtime manages a bind mount directory for each sandbox VM (k8s
> > >> pod) in /run/kata-containers/shared/sandboxes/$VM_ID.
> > >>
> > >> That directory contains the bind-mounted rootfs as well as resolv.co=
nf
> > >> and other per-container files.
> > >>
> > >> When volumes (podman run --volume) are present they are also
> > >> bind-mounted alongside the rootfs.
> > >>
> > >> So kata-runtime ends up with something like this:
> > >>
> > >>   /run/kata-containers/shared/sandboxes/
> > >>   ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d93102683=
85/
> > >>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310=
268385/
> > >>           ... rootfs/
> > >>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310=
268385-04b134d40c6255cf-hostname
> > >>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310=
268385-62cff51b641310e5-resolv.conf
> > >>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310=
268385-b8dedcdf0c623c40-hosts
> > >>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310=
268385-d181eeeb4171c3c5-myvolume/
> > >>
> > >> Only one virtio-fs device is used per sandbox VM.
> > >>
> > >> Stefan
> > >>
> > >> _______________________________________________
> > >> Virtio-fs mailing list
> > >> Virtio-fs@redhat.com
> > >> https://www.redhat.com/mailman/listinfo/virtio-fs
> > >
> > > Also what happens if some of the volumes are mounted as read/only?=A0
> > > What kind of error does the container process get when it attempts to
> > > write to the volume?
> > >
> > >
> > > _______________________________________________
> > > Virtio-fs mailing list
> > > Virtio-fs@redhat.com
> > > https://www.redhat.com/mailman/listinfo/virtio-fs
> >=20
> > Also need to think about the volume being mounted as noexec, nodev,
> > nosuid,=A0 Does the kernel inside of the container handle this correctl=
y?
>=20
> I'd need to check, but I *think* you'll get the error propagated
> directly from the errno that the daemon sees; i.e. you'll probably
> get the ro-fs error when trying to write the file on the mount that's
> ro.
>=20
> I'm expecting it to behave like FUSE, since it's mostly the transport
> level that's changed.

There are two levels here: 1) kata-agent setups up per-container bind
mounts and 2) virtiofsd performs file system operations on behalf of the
guest.

kata-agent can apply the 'ro' mount option to a per-container bind
mount, so even if the kataShared virtio-fs mount as a whole is
read/write the container will have read-only access.

What I hope happens (but I haven't checked) is that kata-agent sets
mount options on per-container bind mounts.

If a file system operation does make its way through to the host, then
virtiofsd should fail because the bind mount on the host should also be
'ro'.

But does anyone want to check? :-)

Stefan

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5NUxUACgkQnKSrs4Gr
c8ha7Qf/R65iJE71at6X9arj+Sr53J2lH9ty88WNPJ918EYe/W3DX8xJCNxB7VTo
FQ1TZtgcqjEwYr24dXZ2BtlGe636s46iudPHrbJJwHJmS9RGHuWQaOAdBSG61eTe
Efw07Jfl8euUa8mtuxK+/ZsEgRoDlm0mPcBR4362UDmdk/ImccI4SwnnfWr8bjnb
8BIM/8LOMXNQFzPj0L56IFuVO05B9qMTVZeSnFiw/LUvFTMojIF+O+ivOE/21WIg
F8u5aIArvFpiHytnJI9OZ0iFxZedEs18kdOWNIkdakfs+ZKQe+N5ITQW5ngMqO1s
B2UdIQ+bCGOsPo/qdcmSUtlobuQP+A==
=ICth
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--

