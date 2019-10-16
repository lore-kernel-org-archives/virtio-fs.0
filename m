Date: Wed, 16 Oct 2019 15:14:07 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191016141407.GB5487@stefanha-x1.localdomain>
References: <20191011195935.GB13861@redhat.com>
	<CAJFHJrq6bQo=yvO0tAxH7RWg=U=ftpsePs3c7y-AcE90Wh4afg@mail.gmail.com>
	<20191011203647.GC13861@redhat.com>
	<20191014091108.GH22963@stefanha-x1.localdomain>
	<CAJFHJrrqfjQqMu-K99DiBYNmD1=hB710wRZ88w--SQ0GxQv9Tw@mail.gmail.com>
	<20191015155749.GH3073@work-vm>
	<CAJFHJroxYvu_cfwCCxdWV_mN-0pxZ4qBbXdjiJEzPECui-ygrA@mail.gmail.com>
	<20191015162634.GI3073@work-vm>
	<ac410eee095de0faf2e8ccd3f917e322c7d68384.camel@intel.com>
	<CAJFHJrpwkry6r9WDf=4aY2ONUvXKvm_BqWrONFfgRboqGony9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <CAJFHJrpwkry6r9WDf=4aY2ONUvXKvm_BqWrONFfgRboqGony9g@mail.gmail.com>
Subject: Re: [Virtio-fs] xfstest results for virtio-fs on aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: "slp@redhat.com" <slp@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "Boeuf, Sebastien" <sebastien.boeuf@intel.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2019 at 03:21:52AM +0900, Chirantan Ekbote wrote:
> On Wed, Oct 16, 2019 at 2:28 AM Boeuf, Sebastien
> <sebastien.boeuf@intel.com> wrote:
> >
> > Thanks Dave for adding me to the loop here!
> >
> > On Tue, 2019-10-15 at 17:26 +0100, Dr. David Alan Gilbert wrote:
> > > * Chirantan Ekbote (chirantan@chromium.org) wrote:
> > > > On Wed, Oct 16, 2019 at 12:58 AM Dr. David Alan Gilbert
> > > > <dgilbert@redhat.com> wrote:
> > > > > * Chirantan Ekbote (chirantan@chromium.org) wrote:
> > > > > > I'm not using virtiofsd.  We have our own server for crosvm,
> > > > > > which
> > > > > > supports multiple queues.
> > > > >
> > > > > Ah excellent; is that public anywhere?
> > > > >
> > > >
> > > > It's currently under review here:
> > > > https://chromium-review.googlesource.com/c/chromiumos/platform/cros=
vm/+/1758103
> > > >
> > > > I expect to have it merged sometime this week.
> >
> > Oh that's very nice to hear. We have some code from the cloud-
> > hypervisor project where we have a vhost-user-net implementation
> > relying on some sort of a wrapper code similar to what all vhost-user
> > daemon implementations would reuse (libvhost-user kind of thing).
> >
> > We're planning to see this wrapper code land on Rust-VMM at some point,
> > which is why it would be interesting if you could rebase this virtio-fs
> > daemon code on top of this small library. If you don't have the
> > bandwidth, we could probably look at it if that's something you would
> > be interested in.
> >
> > Here is the code for the small wrapper crate:
> > https://github.com/intel/cloud-hypervisor/blob/master/vhost_user_backen=
d/src/lib.rs
> >
> > And here is the vhost-user-net example using it:
> > https://github.com/intel/cloud-hypervisor/blob/master/src/bin/vhost_use=
r_net.rs
> >
>=20
> Our virtio-fs server is not a vhost-user device (this was one of the
> reasons we didn't want to use virtiofsd).  It currently just runs
> directly as a child process of crosvm (like all other crosvm devices).
> So unless I'm missing something I don't think there's much to be
> gained by rebasing on vhost_user_backend.

I'm also interested in porting the server over to vhost-user so that
other VMMs like QEMU and cloud-hypervisor can use it.

=46rom a quick look at the code last night, here are things that were not
carried over from virtiofsd:
 * DAX is not supported
 * The FUSE protocol version is a bit dated, e.g. copy_file_range() is
   not supported.
 * Requests are processed synchronously for each virtqueue and therefore
   performance is limited.  The server won't saturate the queue depth
   supported by the host kernel and hardware.

Have I missed anything?  Otherwise it looks quite close to
passthrough_ll.c.

Stefan

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2nJa8ACgkQnKSrs4Gr
c8htCgf+KAAXd/BeuL16eeslYoWUszpzWfkZCKacNdyT9ulQ37CIjMeYjLoCJeuZ
GH0futraK+gtgG/kFoYD1fzgOQDSYa5Su+CnE2Bfx0eQYwBaRB3kBbWXVZ9ZkY4N
YCiyK9UWIN3gEzBAACMdnfBlQhC8Wn+WhDZ/jHiGvKKKk6qBqdh9jW3TGyZAyH+r
ULhOPGES9LROPqmw/89RY9hUs0NNJg1Z9KJNMtTHt9+Jod3PQQH4EFHimfq04E6D
juE7s1ZyxBbsAbNrRz3K9eDv5urkdgjb13PymyWIiHizExQmRRpqY5/d0wDJrto9
40yyQUElq+Jccw8BPBRi4UQYV+YSjg==
=K7mK
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--

