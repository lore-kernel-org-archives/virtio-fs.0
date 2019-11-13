Date: Wed, 13 Nov 2019 11:39:20 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191113113920.GA538417@stefanha-x1.localdomain>
References: <CAJFHJroxYvu_cfwCCxdWV_mN-0pxZ4qBbXdjiJEzPECui-ygrA@mail.gmail.com>
	<20191015162634.GI3073@work-vm>
	<ac410eee095de0faf2e8ccd3f917e322c7d68384.camel@intel.com>
	<CAJFHJrpwkry6r9WDf=4aY2ONUvXKvm_BqWrONFfgRboqGony9g@mail.gmail.com>
	<20191016141407.GB5487@stefanha-x1.localdomain>
	<59aa4481a68fe627ee7dfa34f01f4c8f16b1e969.camel@intel.com>
	<20191016183815.GD14762@stefanha-x1.localdomain>
	<923a5ab7b17371fe1b702717c125d89f7e76bf5b.camel@intel.com>
	<20191112094514.GA463128@stefanha-x1.localdomain>
	<5238b860a8d544e59c9a827fbc26418d53482ccf.camel@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <5238b860a8d544e59c9a827fbc26418d53482ccf.camel@intel.com>
Subject: Re: [Virtio-fs] xfstest results for virtio-fs on aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Cc: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "Bradford,
	Robert" <robert.bradford@intel.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "Ortiz,
	Samuel" <samuel.ortiz@intel.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 13, 2019 at 06:40:54AM +0000, Boeuf, Sebastien wrote:
> On Tue, 2019-11-12 at 09:45 +0000, Stefan Hajnoczi wrote:
> > On Fri, Nov 01, 2019 at 10:26:54PM +0000, Boeuf, Sebastien wrote:
> > > +Samuel
> > > +Rob
> > >=20
> > > Hi Stefan, Dave,
> > >=20
> > > I had some time to get started on the virtiofsd in Rust, based on
> > > the
> > > code from Chirantan. So basically I relied on the following Crosvm
> > > branch (code not merged yet):
> > > https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm=
/+/1705654
> > >=20
> > > From there I have ported the code that was needed to rely on the
> > > nice
> > > implementation from Chirantan. I had to make it fit the vm-virtio
> > > crate
> > > from Cloud-Hypervisor (since it's not yet complete on rust-vmm),
> > > and
> > > also the vm-memory crate from rust-vmm.
> > >=20
> > > Once the porting done, I created a dedicated vhost-user-fs daemon
> > > binary relying on the vhost_user_backend crate. I connected all the
> > > dots together and the result is here:
> > > https://github.com/intel/cloud-hypervisor/pull/404
> > >=20
> > > I have listed the remaining tasks here:=20
> > > https://github.com/intel/cloud-hypervisor/pull/404#issue-335636924
> > > (some can be quite big and should come as a follow up PR IMO).
> > >=20
> > > I'll be in vacation next week, but if you have some time, it'd be
> > > very
> > > nice to get everybody's feedback on this.
> > >=20
> > > And of course, if you have more time to continue working on this,
> > > feel
> > > free to reuse my branch 'vhost_user_fs_daemon' from my forked repo=20
> > > https://github.com/sboeuf/cloud-hypervisor-1.git
> >=20
> > Awesome, thanks!
>=20
> I've been trying to make this work today, unfortunately I'm running
> into some issues. Basically what happens is that I don't get a writable
> descriptor, which means the reply to the FUSE init() cannot be sent.
>=20
> Chirantan, I was wondering if your code in Crosvm is working properly
> with virtio-fs? And if that's the case, have you ever get the problem
> I'm describing where the virtio descriptor does not have the write only
> flag, which prevents the Writer from being provisioned with buffers.
>=20
> Stefan, do you know if the virtio-fs driver actually tags some
> descriptor as write_only? I'm trying to understand what is missing
> here.

A vring descriptor is either driver->device ("out") or device->driver
("in").

A virtio-fs request typically contains both descriptor types because it
consists of a request (e.g. struct fuse_in_header + struct fuse_init_in)
and a response (e.g.  struct fuse_out_header + struct fuse_init_out).

By the way, VIRTIO and FUSE use the terms "in"/"out" in the opposite
sense.  VIRTIO "out" is driver->device and "in" is device->driver.  FUSE
"out" is device->driver and "in" is driver->device.  Just wanted to
point that out to prevent confusion :-).

If you are only seeing a driver->device descriptor but not the
device->driver descriptor, then something is wrong with the vring
processing code in the device.

The guest driver places requests into the virtqueue in
fs/fuse/virtio_fs.c:virtio_fs_enqueue_req().

Stefan

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3L62gACgkQnKSrs4Gr
c8hY2Qf+PvTVrRPWYO/IXWOl+Gc4bs9KPv1CJy1ihwHjUAQWHpAYRaqyOjEHcCIV
5Wn3zCUsfkZJcCES0KusZCTlQK4twvcU19AZEdH62jARpvvNJgoqMRYcZet1Hpx/
k7yVZm6yhwj3N34vkVFL7Yn9Ibohoiyao7MwHK86wf3X9NMkc5Vyv/Pk8xiDJgBm
6zdb1kk8rLZy3/YpY2BWgG6/Cmd77t8IikrscSEEhwZggbR2l8goXXuvWZZLTayF
t93LWjOCWyhp7lpeDrPlse8Y215BeLou0C3jcFJVUrAwdxtvqAggaGeY4chkgFWY
RNkKz+DLb8uzzcr0GKtxU70pl+2PbA==
=jvU7
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--

