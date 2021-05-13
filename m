Date: Thu, 13 May 2021 14:44:42 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJ0tSmwRulBHGrIG@stefanha-x1.localdomain>
References: <20210215095410.85607-1-stefanha@redhat.com>
	<YJo+wCSffIZAx9aM@stefanha-x1.localdomain>
	<20210512223637.GA6241@rsjd01523.et2sqa>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="CLysp2a4mQE6o2Rw"
Content-Disposition: inline
In-Reply-To: <20210512223637.GA6241@rsjd01523.et2sqa>
Subject: Re: [Virtio-fs] [virtio-dev] [PATCH v2 0/2] virtio-fs: add
 notification queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com, virtio-dev@lists.oasis-open.org, vgoyal@redhat.com


--CLysp2a4mQE6o2Rw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 13, 2021 at 06:36:37AM +0800, Liu Bo wrote:
> Hi Stefan,
>=20
> On Tue, May 11, 2021 at 09:22:24AM +0100, Stefan Hajnoczi wrote:
> > On Mon, Feb 15, 2021 at 09:54:08AM +0000, Stefan Hajnoczi wrote:
> > > v2:
> > >  * Document empty virtqueue behavior for FUSE_NOTIFY_LOCK messages
> > >=20
> > > This patch series adds the notification queue to the VIRTIO specifica=
tion.
> > > This new virtqueue carries device->driver FUSE notify messages.  They=
 are
> > > currently unused but will be necessary for file locking, which can bl=
ock for an
> > > unbounded amount of time and therefore needs a asynchronous completio=
n event
> > > instead of a request/response buffer that consumes space in the reque=
st
> > > virtqueue until the operation completes.
> > >=20
> > > Patch 1 corrects an oversight I noticed: the file system device was n=
ot added
> > > to the Conformance chapter.
> > >=20
> > > Stefan Hajnoczi (2):
> > >   virtio-fs: add file system device to Conformance chapter
> > >   virtio-fs: add notification queue
> > >=20
> > >  conformance.tex | 23 ++++++++++++++++
> > >  virtio-fs.tex   | 71 ++++++++++++++++++++++++++++++++++++++++++-----=
--
> > >  2 files changed, 84 insertions(+), 10 deletions(-)
> >=20
> > Reminder to anyone who needs the virtio-fs notification queue: please
> > review this series.
> >
>=20
> Besides using notification queue to provide posix lock support, I've
> also managed to invalidate dentry/inode's cache with notification
> queue, it worked well.

Thank you!

Are you using dentry/inode cache invalidation to reduce the number of
file descriptors that virtiofsd needs to hold open, or are you using it
because the file system is shared by multiple systems and you want to
stronger cache coherency?

Stefan

--CLysp2a4mQE6o2Rw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCdLUoACgkQnKSrs4Gr
c8jA3gf/Q0mFGv16s7l1XxG/2mZ10SDmlpOum4x2S93qMEzsqz2l2Zmck/Y76OTx
/lkFy5EW9PDHJrl73MQ57uLceWAR2m4j9XiyRPukThn7ybjpQyIitbhZE73ug0eG
DoMi9LkXFSzknTuzrHsUMs1c+336cnA62HBAYoI4rRIyMfMU+VoenApWTYllV9sY
W5ROjRCgWm3krhayIfcEjv/AOpxJBSfHMVxWISmMWSGGvYnq4sGAhbCndpIGuSUY
/8rO0BFuDEDRs74wZNbg7OOkqizXA5nFTxjIvlbhL0f9nufWbPQkPq5o6wjq5sPr
LUrpOlLb/GucOhwMF3mS51vKPw2T0A==
=2ntM
-----END PGP SIGNATURE-----

--CLysp2a4mQE6o2Rw--

