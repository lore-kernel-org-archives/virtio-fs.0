Date: Mon, 17 May 2021 11:06:37 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YKJALYI3rFrZsj0W@stefanha-x1.localdomain>
References: <20210215095410.85607-1-stefanha@redhat.com>
	<YJo+wCSffIZAx9aM@stefanha-x1.localdomain>
	<20210512223637.GA6241@rsjd01523.et2sqa>
	<YJ0tSmwRulBHGrIG@stefanha-x1.localdomain>
	<20210513174956.GA105474@rsjd01523.et2sqa>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="kDVtodiKzfNvz6vo"
Content-Disposition: inline
In-Reply-To: <20210513174956.GA105474@rsjd01523.et2sqa>
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


--kDVtodiKzfNvz6vo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 14, 2021 at 01:50:06AM +0800, Liu Bo wrote:
> On Thu, May 13, 2021 at 02:44:42PM +0100, Stefan Hajnoczi wrote:
> > On Thu, May 13, 2021 at 06:36:37AM +0800, Liu Bo wrote:
> > > Hi Stefan,
> > >=20
> > > On Tue, May 11, 2021 at 09:22:24AM +0100, Stefan Hajnoczi wrote:
> > > > On Mon, Feb 15, 2021 at 09:54:08AM +0000, Stefan Hajnoczi wrote:
> > > > > v2:
> > > > >  * Document empty virtqueue behavior for FUSE_NOTIFY_LOCK messages
> > > > >=20
> > > > > This patch series adds the notification queue to the VIRTIO speci=
fication.
> > > > > This new virtqueue carries device->driver FUSE notify messages.  =
They are
> > > > > currently unused but will be necessary for file locking, which ca=
n block for an
> > > > > unbounded amount of time and therefore needs a asynchronous compl=
etion event
> > > > > instead of a request/response buffer that consumes space in the r=
equest
> > > > > virtqueue until the operation completes.
> > > > >=20
> > > > > Patch 1 corrects an oversight I noticed: the file system device w=
as not added
> > > > > to the Conformance chapter.
> > > > >=20
> > > > > Stefan Hajnoczi (2):
> > > > >   virtio-fs: add file system device to Conformance chapter
> > > > >   virtio-fs: add notification queue
> > > > >=20
> > > > >  conformance.tex | 23 ++++++++++++++++
> > > > >  virtio-fs.tex   | 71 ++++++++++++++++++++++++++++++++++++++++++-=
------
> > > > >  2 files changed, 84 insertions(+), 10 deletions(-)
> > > >=20
> > > > Reminder to anyone who needs the virtio-fs notification queue: plea=
se
> > > > review this series.
> > > >
> > >=20
> > > Besides using notification queue to provide posix lock support, I've
> > > also managed to invalidate dentry/inode's cache with notification
> > > queue, it worked well.
> >=20
> > Thank you!
> >=20
> > Are you using dentry/inode cache invalidation to reduce the number of
> > file descriptors that virtiofsd needs to hold open, or are you using it
> > because the file system is shared by multiple systems and you want to
> > stronger cache coherency?
> >
>=20
> The former one is one of the problems I've come across, but I worked
> around it by set_rlimit'ing a large enough number of fds.
>=20
> My scenario is that
>=20
> a) a bind mount point was shared as a sub-directory of virtiofs's shared =
directory,
>=20
> b) and I needed to umount the bind mount point on the host side but I
> was not able to because virtiofsd enables cache=3Dalways,
>=20
> So basically it was used as a preciser "drop_cache".
>=20
> Besides that, I'm going to do some experiements with notification
> queue to give a warm up for fuse's metadata in order to have less
> metadata requests.  Although this may be done with ebpf as well, the
> idea with notification queue seems more straightforward.

Thanks for sharing. I was curious because I shared the NFSv4
FH4_NOEXPIRE_WITH_OPEN approach in a previous virtio-fs bi-weekly call:
https://www.rfc-editor.org/rfc/rfc7530.html#section-4.2.3

This approach does not involve the notification queue. It's lazy in the
sense that the client is unaware which inode have expired until it
accesses them. An advantage is that no host<->guest communication is
required (fewer CPU cycles), but the disadvantage is that the client may
have expired inode/dentry cache structures allocated so it will end up
throwing them away but was unable to use the memory for something else
in the meantime.

Stefan

--kDVtodiKzfNvz6vo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCiQC0ACgkQnKSrs4Gr
c8iudwgAq87juv5HQv9KesJJQNUpxhCV6JOVUfjkRR68z6MeBtiiHrju8+DsxPsk
dTuqeJEaMLNgLFbbxMu8J8M1oKXIndBDOCNYgyxQMLC602dnDs/iy1BwbdXkOv6g
o77ObFKJyiYWozHtEWyUYRdIBWxqK2xOoRLhfTMe5DcrVSy94V+f9HzU8doTKBft
DVQHNHWVS5ioeqoj6/IpDGIqQNsMXs5VuAq0v33svShlMsSCf56teEdiZJOB5bIa
eYZ16MK+gYTKIWoGVvZxD0f8fRHZtwLtCIzPCCyanLmOWe8alwtagQxufy9MtcVX
orp+atGRPow7wQkx1YQWGh927RYOZw==
=y46f
-----END PGP SIGNATURE-----

--kDVtodiKzfNvz6vo--

