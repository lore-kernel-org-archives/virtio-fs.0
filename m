Date: Wed, 16 Oct 2019 19:37:00 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191016183700.GC14762@stefanha-x1.localdomain>
References: <CAJFHJrq6bQo=yvO0tAxH7RWg=U=ftpsePs3c7y-AcE90Wh4afg@mail.gmail.com>
	<20191011203647.GC13861@redhat.com>
	<20191014091108.GH22963@stefanha-x1.localdomain>
	<CAJFHJrrqfjQqMu-K99DiBYNmD1=hB710wRZ88w--SQ0GxQv9Tw@mail.gmail.com>
	<20191015155749.GH3073@work-vm>
	<CAJFHJroxYvu_cfwCCxdWV_mN-0pxZ4qBbXdjiJEzPECui-ygrA@mail.gmail.com>
	<20191015162634.GI3073@work-vm>
	<ac410eee095de0faf2e8ccd3f917e322c7d68384.camel@intel.com>
	<CAJFHJrpwkry6r9WDf=4aY2ONUvXKvm_BqWrONFfgRboqGony9g@mail.gmail.com>
	<2d69ee09a42387241f027af2f75356f375058df5.camel@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uh9ZiVrAOUUm9fzH"
Content-Disposition: inline
In-Reply-To: <2d69ee09a42387241f027af2f75356f375058df5.camel@intel.com>
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
Cc: "slp@redhat.com" <slp@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>


--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2019 at 04:11:48PM +0000, Boeuf, Sebastien wrote:
> On Wed, 2019-10-16 at 03:21 +0900, Chirantan Ekbote wrote:
> > On Wed, Oct 16, 2019 at 2:28 AM Boeuf, Sebastien
> > <sebastien.boeuf@intel.com> wrote:
> > > Thanks Dave for adding me to the loop here!
> > >=20
> > > On Tue, 2019-10-15 at 17:26 +0100, Dr. David Alan Gilbert wrote:
> > > > * Chirantan Ekbote (chirantan@chromium.org) wrote:
> > > > > On Wed, Oct 16, 2019 at 12:58 AM Dr. David Alan Gilbert
> > > > > <dgilbert@redhat.com> wrote:
> > > > > > * Chirantan Ekbote (chirantan@chromium.org) wrote:
> > > > > > > I'm not using virtiofsd.  We have our own server for
> > > > > > > crosvm,
> > > > > > > which
> > > > > > > supports multiple queues.
> > > > > >=20
> > > > > > Ah excellent; is that public anywhere?
> > > > > >=20
> > > > >=20
> > > > > It's currently under review here:
> > > > > https://chromium-review.googlesource.com/c/chromiumos/platform/cr=
osvm/+/1758103
> > > > >=20
> > > > > I expect to have it merged sometime this week.
> > >=20
> > > Oh that's very nice to hear. We have some code from the cloud-
> > > hypervisor project where we have a vhost-user-net implementation
> > > relying on some sort of a wrapper code similar to what all vhost-
> > > user
> > > daemon implementations would reuse (libvhost-user kind of thing).
> > >=20
> > > We're planning to see this wrapper code land on Rust-VMM at some
> > > point,
> > > which is why it would be interesting if you could rebase this
> > > virtio-fs
> > > daemon code on top of this small library. If you don't have the
> > > bandwidth, we could probably look at it if that's something you
> > > would
> > > be interested in.
> > >=20
> > > Here is the code for the small wrapper crate:
> > > https://github.com/intel/cloud-hypervisor/blob/master/vhost_user_back=
end/src/lib.rs
> > >=20
> > > And here is the vhost-user-net example using it:
> > > https://github.com/intel/cloud-hypervisor/blob/master/src/bin/vhost_u=
ser_net.rs
> > >=20
> >=20
> > Our virtio-fs server is not a vhost-user device (this was one of the
> > reasons we didn't want to use virtiofsd).  It currently just runs
> > directly as a child process of crosvm (like all other crosvm
> > devices).
> > So unless I'm missing something I don't think there's much to be
> > gained by rebasing on vhost_user_backend.
>=20
> Oh I didn't realize it was not a separate daemon. So yes, from your
> perspective, there's no point in rebasing on top of vhost_user_backend.
> I still believe it might be interesting for us to share as much code as
> possible between projects, which is why we might reuse your code to
> create a standalone daemon in Rust.

I think the server code can be shared and it can live in rust-vmm.

I haven't looked in detail but crosvm just has a slightly different
out-of-process device model from vhost-user, but effectively they are
both doing the same thing.  We'll need a bit of vhost-user glue but the
core server code should be the same.

Stefan

--uh9ZiVrAOUUm9fzH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2nY0wACgkQnKSrs4Gr
c8g1Dwf/dmJZh9wKtwB0Z3fugzBEhctYJi5g4fXLRtAAskp+XOUcgSYPuvBkmpg5
5I139lv26i2umH9qgvebCI0pXMG2NxOHsZ8q4NInI/2ZMWW6sNzYtjQFmn0KAFVi
xSb+LzxeBgL+omd3BE1DqhEiiT6H9lY/hFhqRzbvucNAt3X/go5oP0TC7vHFIX0k
RLFxvZjLU19bCFYduiyjfBh9+k4ZsEsmMEq4hesajsEWT0y0z1lr2ZpRA8S+Tq/s
oaPZ3waaiZpb4by42g+K8MMDzx+YAkCp6qHBXKzeC+AZEbsfl5H+JRfuwhi6q8tq
SmSEcmoiTHQKEhTZRI3wGtdEj+GmqA==
=QiVB
-----END PGP SIGNATURE-----

--uh9ZiVrAOUUm9fzH--

