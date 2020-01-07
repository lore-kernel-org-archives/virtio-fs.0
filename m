Date: Tue, 7 Jan 2020 16:58:02 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200107165802.GC410801@stefanha-x1.localdomain>
References: <20200107041521.75833-1-eguan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="B4IIlcmfBL/1gGOG"
Content-Disposition: inline
In-Reply-To: <20200107041521.75833-1-eguan@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH v3] virtiofsd: stop all queue threads on
 exit in virtio_loop()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eryu Guan <eguan@linux.alibaba.com>
Cc: virtio-fs@redhat.com, qingming.su@linux.alibaba.com


--B4IIlcmfBL/1gGOG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 07, 2020 at 12:15:21PM +0800, Eryu Guan wrote:
> On guest graceful shutdown, virtiofsd receives VHOST_USER_GET_VRING_BASE
> request from VMM and shuts down virtqueues by calling fv_set_started(),
> which joins fv_queue_thread() threads. So when virtio_loop() returns,
> there should be no thread is still accessing data in fuse session and/or
> virtio dev.
>=20
> But on abnormal exit, e.g. guest got killed for whatever reason,
> vhost-user socket is closed and virtio_loop() breaks out the main loop
> and returns to main(). But it's possible fv_queue_worker()s are still
> working and accessing fuse session and virtio dev, which results in
> crash or use-after-free.
>=20
> Fix it by stopping fv_queue_thread()s before virtio_loop() returns,
> to make sure there's no-one could access fuse session and virtio dev.
>=20
> Reported-by: Qingming Su <qingming.su@linux.alibaba.com>
> Signed-off-by: Eryu Guan <eguan@linux.alibaba.com>
> ---
> v3:
> - stopping fv_queue_thread by writing to qi->kill_fd instead of
>   cancelling thread, as suggested by Stefan Hajnoczi
>=20
> v2:
> - cancelling fv_queue_thread before exit
>=20
> v1: virtiofsd: sync FUSE_DESTROY with session destroy
> https://www.redhat.com/archives/virtio-fs/2019-December/msg00051.html
>=20
>  tools/virtiofsd/fuse_virtio.c | 56 +++++++++++++++++++++++++++++--------=
------
>  1 file changed, 38 insertions(+), 18 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--B4IIlcmfBL/1gGOG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl4UuJoACgkQnKSrs4Gr
c8g5KAf+MpoPnPV2VnWYRCGY++bfVuNs/Bm+rpZv4uHLSyZ/U7ldFTfOTrbXUrIi
xEx5qWoh/yCE/u16IEdNRKORMcKPqP3vgRjn4P0wqvFHbe5Kn0pCEmFCfvu8oNjF
ChtSekuil9L6gP5Y7G1jZ9mZNQ7heXfTFht12hO4piaY5ICFXvgegS8g6orU9385
TgayhzGWd1wOS2pWei9gyu1YeN/Au3WrxF/zcMkZUgCeR4n/DHGtvnV3t9sL2lNZ
EfZUQA7VvTQ0QeUNJ/6Y/LVGbjicMFUvM3wgE2Bj0hIgwxRdW7AQywKgyn5wXHo6
jNBZ/aSNA517Yw1gVrzVGpFI2lJTUg==
=/WcL
-----END PGP SIGNATURE-----

--B4IIlcmfBL/1gGOG--

