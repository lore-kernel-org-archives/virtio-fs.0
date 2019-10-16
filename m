Date: Wed, 16 Oct 2019 19:38:15 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191016183815.GD14762@stefanha-x1.localdomain>
References: <20191011203647.GC13861@redhat.com>
	<20191014091108.GH22963@stefanha-x1.localdomain>
	<CAJFHJrrqfjQqMu-K99DiBYNmD1=hB710wRZ88w--SQ0GxQv9Tw@mail.gmail.com>
	<20191015155749.GH3073@work-vm>
	<CAJFHJroxYvu_cfwCCxdWV_mN-0pxZ4qBbXdjiJEzPECui-ygrA@mail.gmail.com>
	<20191015162634.GI3073@work-vm>
	<ac410eee095de0faf2e8ccd3f917e322c7d68384.camel@intel.com>
	<CAJFHJrpwkry6r9WDf=4aY2ONUvXKvm_BqWrONFfgRboqGony9g@mail.gmail.com>
	<20191016141407.GB5487@stefanha-x1.localdomain>
	<59aa4481a68fe627ee7dfa34f01f4c8f16b1e969.camel@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tEFtbjk+mNEviIIX"
Content-Disposition: inline
In-Reply-To: <59aa4481a68fe627ee7dfa34f01f4c8f16b1e969.camel@intel.com>
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


--tEFtbjk+mNEviIIX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2019 at 04:14:25PM +0000, Boeuf, Sebastien wrote:
> On Wed, 2019-10-16 at 15:14 +0100, Stefan Hajnoczi wrote:
> > On Wed, Oct 16, 2019 at 03:21:52AM +0900, Chirantan Ekbote wrote:
> > > On Wed, Oct 16, 2019 at 2:28 AM Boeuf, Sebastien
> > > <sebastien.boeuf@intel.com> wrote:
> > > > Thanks Dave for adding me to the loop here!
> > > >=20
> > > > On Tue, 2019-10-15 at 17:26 +0100, Dr. David Alan Gilbert wrote:
> > > > > * Chirantan Ekbote (chirantan@chromium.org) wrote:
> > > > > > On Wed, Oct 16, 2019 at 12:58 AM Dr. David Alan Gilbert
> > > > > > <dgilbert@redhat.com> wrote:
> > > > > > > * Chirantan Ekbote (chirantan@chromium.org) wrote:
> > > > > > > > I'm not using virtiofsd.  We have our own server for
> > > > > > > > crosvm,
> > > > > > > > which
> > > > > > > > supports multiple queues.
> > > > > > >=20
> > > > > > > Ah excellent; is that public anywhere?
> > > > > > >=20
> > > > > >=20
> > > > > > It's currently under review here:
> > > > > > https://chromium-review.googlesource.com/c/chromiumos/platform/=
crosvm/+/1758103
> > > > > >=20
> > > > > > I expect to have it merged sometime this week.
> > > >=20
> > > > Oh that's very nice to hear. We have some code from the cloud-
> > > > hypervisor project where we have a vhost-user-net implementation
> > > > relying on some sort of a wrapper code similar to what all vhost-
> > > > user
> > > > daemon implementations would reuse (libvhost-user kind of thing).
> > > >=20
> > > > We're planning to see this wrapper code land on Rust-VMM at some
> > > > point,
> > > > which is why it would be interesting if you could rebase this
> > > > virtio-fs
> > > > daemon code on top of this small library. If you don't have the
> > > > bandwidth, we could probably look at it if that's something you
> > > > would
> > > > be interested in.
> > > >=20
> > > > Here is the code for the small wrapper crate:
> > > > https://github.com/intel/cloud-hypervisor/blob/master/vhost_user_ba=
ckend/src/lib.rs
> > > >=20
> > > > And here is the vhost-user-net example using it:
> > > > https://github.com/intel/cloud-hypervisor/blob/master/src/bin/vhost=
_user_net.rs
> > > >=20
> > >=20
> > > Our virtio-fs server is not a vhost-user device (this was one of
> > > the
> > > reasons we didn't want to use virtiofsd).  It currently just runs
> > > directly as a child process of crosvm (like all other crosvm
> > > devices).
> > > So unless I'm missing something I don't think there's much to be
> > > gained by rebasing on vhost_user_backend.
> >=20
> > I'm also interested in porting the server over to vhost-user so that
> > other VMMs like QEMU and cloud-hypervisor can use it.
>=20
> Yes I agree that'd be awesome!
> Are you planning to start working on this soon? Just asking as I want
> to avoid potential duplicated efforts :)

Not immediately.  If you are ready to work on it and make your branch
public then we can follow along.

Stefan

--tEFtbjk+mNEviIIX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2nY5YACgkQnKSrs4Gr
c8gS6Qf/SbSAUndy/HycXjOFaprxKl+NZhqSM7dSHKlCtoZtefV2gyQhRNN9936i
Lazjq82b2zKJiBdgNo9ygfexVCI3kePd16EDwh7TUxJCUqooGw+By9JxIE1ljtKe
C8JZPT0mRDhkqfCPvdSZ55mO4bU7W7hefrWprUI0q6HZi7WQ2pRjNQOMGZEHM1j/
3Q88acgcJ+wVRi/vh7ab8KBcUkmdIHgDmEOJyaO4X+O/Vi/mQ8BNlu19mT+WXpRW
oSvso+HC67FIbpeaqzbOjbhQKjlckEiqHNJNi3ym4Z8i63Wqi4TTQSgPfenUC096
wTUuRStU+wqqNFOnaGm34e2kdYYNZw==
=4EOz
-----END PGP SIGNATURE-----

--tEFtbjk+mNEviIIX--

