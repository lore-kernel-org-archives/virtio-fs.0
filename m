Date: Tue, 18 Feb 2020 13:38:21 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200218133821.GE786556@stefanha-x1.localdomain>
References: <20200214192705.GE18654@redhat.com> <20200214194130.GP3283@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="nHwqXXcoX0o6fKCv"
Content-Disposition: inline
In-Reply-To: <20200214194130.GP3283@work-vm>
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
Cc: virtio-fs-list <virtio-fs@redhat.com>, Mrunal Patel <mpatel@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>


--nHwqXXcoX0o6fKCv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 14, 2020 at 07:41:30PM +0000, Dr. David Alan Gilbert wrote:
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > Hi,
> >=20
> > Dan Walsh and Mrunal mentioned that one virtiofsd daemon per exported
> > directory requirement sounds excessive. For container use case, they ha=
ve
> > atleast 2-3 more directories they need to export (secrets and /etc/host=
). And
> > that means 3-4 virtiofsd running for each kata container.=20
> >=20
> > One option seems that bind mount all exports in one directory and export
> > that directory using one virtiofsd. I am aware of atleast one problem
> > with that configuraiton and that is possibility of inode number collisi=
on
> > if bind mounts are coming from different devices. Not sure how many
> > applications care though. Sergio is looking into solving this issue. It
> > might take a while though.
>=20
> I thought the bind mount setup was the normal setup seen under both Kata
> and k8s?

Kata Containers works as follows:

kata-runtime manages a bind mount directory for each sandbox VM (k8s
pod) in /run/kata-containers/shared/sandboxes/$VM_ID.

That directory contains the bind-mounted rootfs as well as resolv.conf
and other per-container files.

When volumes (podman run --volume) are present they are also
bind-mounted alongside the rootfs.

So kata-runtime ends up with something like this:

  /run/kata-containers/shared/sandboxes/
  ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310268385/
      ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310268385/
          ... rootfs/
      ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310268385-=
04b134d40c6255cf-hostname
      ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310268385-=
62cff51b641310e5-resolv.conf
      ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310268385-=
b8dedcdf0c623c40-hosts
      ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310268385-=
d181eeeb4171c3c5-myvolume/

Only one virtio-fs device is used per sandbox VM.

Stefan

--nHwqXXcoX0o6fKCv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5L6M0ACgkQnKSrs4Gr
c8hTVggAqLTuHuk9pw3ncUH5t0upzpB3dHlHuw/nvW9c1hLq+zQEg6g71v4GLu5v
mZezkdEYKjmqRj1iG+3MheCF9+Z1PAMKmNiJoTJerVCpM+C2nx/3nZFzXnqDHDGA
Rr9FcC5xSSUhXanQcxT2//xiNj7azTqpIzKcs+190SWQyamKGVGKgFQ6ckzMbH37
NmMmwAk1PW5Bh4R8MyjFZmqCh0tEqD+i/PXY6tVsYX38PCyjMgm+/SDgz6MQeE9/
Ziu8lOcxuxf3nET2lW4d0N6/In9k76zBpdJMKOuet4j6RiuMpvi0HnOaJLQnwFQg
LGplZ7OvUTaEILQc286wUq7qJ7d9QQ==
=A17v
-----END PGP SIGNATURE-----

--nHwqXXcoX0o6fKCv--

