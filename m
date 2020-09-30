Date: Wed, 30 Sep 2020 10:03:40 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200930090340.GB201070@stefanha-x1.localdomain>
References: <20200929185015.GG220516@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <20200929185015.GG220516@redhat.com>
Subject: Re: [Virtio-fs] [RFC PATCH] fuse: update attributes on read() only
 on timeout
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Linux fsdevel mailing list <linux-fsdevel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, Brian Foster <bfoster@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2020 at 02:50:15PM -0400, Vivek Goyal wrote:
> Following commit added a flag to invalidate guest page cache automaticall=
y.
>=20
> 72d0d248ca823 fuse: add FUSE_AUTO_INVAL_DATA init flag
>=20
> Idea seemed to be that for network file systmes if client A modifies
> the file, then client B should be able to detect that mtime of file
> change and invalidate its own cache and fetch new data from server.
>=20
> There are few questions/issues with this method.
>=20
> How soon client B able to detect that file has changed. Should it
> first GETATTR from server for every READ and compare mtime. That
> will be much stronger cache coherency but very slow because every
> READ will first be preceeded by a GETATTR.
>=20
> Or should this be driven by inode timeout. That is if inode cached attrs
> (including mtime) have timed out, we fetch new mtime from server and
> invalidate cache based on that.
>=20
> Current logic calls fuse_update_attr() on every READ. But that method
> will result in GETATTR only if either attrs have timedout or if cached
> attrs have been invalidated.
>=20
> If client B is only doing READs (and not WRITEs), then attrs should be
> valid for inode timeout interval. And that means client B will detect
> mtime change only after timeout interval.
>=20
> But if client B is also doing WRITE, then once WRITE completes, we
> invalidate cached attrs. That means next READ will force GETATTR()
> and invalidate page cache. In this case client B will detect the
> change by client A much sooner but it can't differentiate between
> its own WRITEs and by another client WRITE. So every WRITE followed
> by READ will result in GETATTR, followed by page cache invalidation
> and performance suffers in mixed read/write workloads.
>=20
> I am assuming that intent of auto_inval_data is to detect changes
> by another client but it can take up to "inode timeout" seconds
> to detect that change. (And it does not guarantee an immidiate change
> detection).
>=20
> If above assumption is acceptable, then I am proposing this patch
> which will update attrs on READ only if attrs have timed out. This
> means every second we will do a GETATTR and invalidate page cache.
>=20
> This is also suboptimal because only if client B is writing, our
> cache is still valid but we will still invalidate it after 1 second.
> But we don't have a good mechanism to differentiate between our own
> changes and another client's changes. So this is probably second
> best method to reduce the extent of issue.
>=20
> I am running equivalent of following fio workload on virtiofs (cache=3Dau=
to)
> and there I see a performance improvement of roughly 12%.
>=20
> fio --direct=3D1 --gtod_reduce=3D1 --name=3Dtest --filename=3Drandom_read=
_write.fio
> +--bs=3D4k --iodepth=3D64 --size=3D4G --readwrite=3Drandrw --rwmixread=3D=
75
> +--output=3D/output/fio.txt
>=20
> NAME                    WORKLOAD                Bandwidth       IOPS
> vtfs-auto-sh		randrw-psync            43.3mb/14.4mb   10.8k/3709
> vtfs-auto-sh-invaltime  randrw-psync            48.9mb/16.3mb   12.2k/4197
>=20
> Signee-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/dir.c    |  6 ++++++
>  fs/fuse/file.c   | 21 +++++++++++++++------
>  fs/fuse/fuse_i.h |  1 +
>  3 files changed, 22 insertions(+), 6 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl90SewACgkQnKSrs4Gr
c8h0mggAoyljBPY2q3mlW+TCBJ5Ig/QXnVvLDMTgatjG0DXACJ3pWp78+LClzLZK
sXvfGi1A69uvlZyGex/CHXg3IGO+47Acy/kNBTgjF1u5Uqt8XasCmR1Vdybc8gvQ
kWBm+B3ovtmLEBd/dVOJETV6y/4ozLYum30efwMcVX55Atfn7kL4A11Way6HuSy0
yB7ZwkfyuAxtfUyrJyObskqyygEP74VVo9kKULTxestDoUzP5p4u754q1Gx40Bcn
aSuWAj0GeEcu93xkeC4xO5KyXte1yEIDVks7F1r/C9qWC8UYLW22Wm8Q+89aW8wW
hcviFP7W5vr/d/b8uzuP16iKRrlH0g==
=xSGE
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--

