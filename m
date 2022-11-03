Return-Path: <mst@redhat.com>
Date: Thu, 3 Nov 2022 16:30:40 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20221103162957-mutt-send-email-mst@kernel.org>
References: <20220802095010.3330793-1-alex.bennee@linaro.org>
 <20220802095010.3330793-11-alex.bennee@linaro.org>
 <20221103123856-mutt-send-email-mst@kernel.org>
 <87o7tnkfqy.fsf@linaro.org>
MIME-Version: 1.0
In-Reply-To: <87o7tnkfqy.fsf@linaro.org>
Content-Type: text/plain; charset="windows-1252"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v4 10/22] hw/virtio: move vm_running check
 to virtio_device_started
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, slp@redhat.com, marcandre.lureau@redhat.com, stefanha@redhat.com, mathieu.poirier@linaro.org, viresh.kumar@linaro.org, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "open list:virtiofs" <virtio-fs@redhat.com>

On Thu, Nov 03, 2022 at 07:18:30PM +0000, Alex Benn=E9e wrote:
>=20
> "Michael S. Tsirkin" <mst@redhat.com> writes:
>=20
> > On Tue, Aug 02, 2022 at 10:49:58AM +0100, Alex Benn=E9e wrote:
> >> All the boilerplate virtio code does the same thing (or should at
> >> least) of checking to see if the VM is running before attempting to
> >> start VirtIO. Push the logic up to the common function to avoid
> >> getting a copy and paste wrong.
> >>=20
> >> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> >
> > How bad is it if we drop this?
>=20
>=20
> I assume it will break gpio. Why do we want to drop this now? It has
> been merged awhile. However there was a follow-up patch which tweaked
> the order of checks in virtio_device_started.

And that follow up patch trips up UBSAN:

https://gitlab.com/mitsirkin/qemu/-/pipelines/684763327




> >
> >> ---
> >>  include/hw/virtio/virtio.h   | 5 +++++
> >>  hw/virtio/vhost-user-fs.c    | 6 +-----
> >>  hw/virtio/vhost-user-i2c.c   | 6 +-----
> >>  hw/virtio/vhost-user-rng.c   | 6 +-----
> >>  hw/virtio/vhost-user-vsock.c | 6 +-----
> >>  hw/virtio/vhost-vsock.c      | 6 +-----
> >>  6 files changed, 10 insertions(+), 25 deletions(-)
> >>=20
> >> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> >> index 9bb2485415..74e7ad5a92 100644
> >> --- a/include/hw/virtio/virtio.h
> >> +++ b/include/hw/virtio/virtio.h
> >> @@ -100,6 +100,7 @@ struct VirtIODevice
> >>      VirtQueue *vq;
> >>      MemoryListener listener;
> >>      uint16_t device_id;
> >> +    /* @vm_running: current VM running state via virtio_vmstate_chang=
e() */
> >>      bool vm_running;
> >>      bool broken; /* device in invalid state, needs reset */
> >>      bool use_disabled_flag; /* allow use of 'disable' flag when neede=
d */
> >> @@ -376,6 +377,10 @@ static inline bool virtio_device_started(VirtIODe=
vice *vdev, uint8_t status)
> >>          return vdev->started;
> >>      }
> >> =20
> >> +    if (!vdev->vm_running) {
> >> +        return false;
> >> +    }
> >> +
> >>      return status & VIRTIO_CONFIG_S_DRIVER_OK;
> >>  }
> >> =20
> >> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> >> index e513e4fdda..d2bebba785 100644
> >> --- a/hw/virtio/vhost-user-fs.c
> >> +++ b/hw/virtio/vhost-user-fs.c
> >> @@ -122,11 +122,7 @@ static void vuf_stop(VirtIODevice *vdev)
> >>  static void vuf_set_status(VirtIODevice *vdev, uint8_t status)
> >>  {
> >>      VHostUserFS *fs =3D VHOST_USER_FS(vdev);
> >> -    bool should_start =3D status & VIRTIO_CONFIG_S_DRIVER_OK;
> >> -
> >> -    if (!vdev->vm_running) {
> >> -        should_start =3D false;
> >> -    }
> >> +    bool should_start =3D virtio_device_started(vdev, status);
> >> =20
> >>      if (fs->vhost_dev.started =3D=3D should_start) {
> >>          return;
> >> diff --git a/hw/virtio/vhost-user-i2c.c b/hw/virtio/vhost-user-i2c.c
> >> index 6020eee093..b930cf6d5e 100644
> >> --- a/hw/virtio/vhost-user-i2c.c
> >> +++ b/hw/virtio/vhost-user-i2c.c
> >> @@ -93,11 +93,7 @@ static void vu_i2c_stop(VirtIODevice *vdev)
> >>  static void vu_i2c_set_status(VirtIODevice *vdev, uint8_t status)
> >>  {
> >>      VHostUserI2C *i2c =3D VHOST_USER_I2C(vdev);
> >> -    bool should_start =3D status & VIRTIO_CONFIG_S_DRIVER_OK;
> >> -
> >> -    if (!vdev->vm_running) {
> >> -        should_start =3D false;
> >> -    }
> >> +    bool should_start =3D virtio_device_started(vdev, status);
> >> =20
> >>      if (i2c->vhost_dev.started =3D=3D should_start) {
> >>          return;
> >> diff --git a/hw/virtio/vhost-user-rng.c b/hw/virtio/vhost-user-rng.c
> >> index 3a7bf8e32d..a9c1c4bc79 100644
> >> --- a/hw/virtio/vhost-user-rng.c
> >> +++ b/hw/virtio/vhost-user-rng.c
> >> @@ -90,11 +90,7 @@ static void vu_rng_stop(VirtIODevice *vdev)
> >>  static void vu_rng_set_status(VirtIODevice *vdev, uint8_t status)
> >>  {
> >>      VHostUserRNG *rng =3D VHOST_USER_RNG(vdev);
> >> -    bool should_start =3D status & VIRTIO_CONFIG_S_DRIVER_OK;
> >> -
> >> -    if (!vdev->vm_running) {
> >> -        should_start =3D false;
> >> -    }
> >> +    bool should_start =3D virtio_device_started(vdev, status);
> >> =20
> >>      if (rng->vhost_dev.started =3D=3D should_start) {
> >>          return;
> >> diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock=
.c
> >> index 0f8ff99f85..22c1616ebd 100644
> >> --- a/hw/virtio/vhost-user-vsock.c
> >> +++ b/hw/virtio/vhost-user-vsock.c
> >> @@ -55,11 +55,7 @@ const VhostDevConfigOps vsock_ops =3D {
> >>  static void vuv_set_status(VirtIODevice *vdev, uint8_t status)
> >>  {
> >>      VHostVSockCommon *vvc =3D VHOST_VSOCK_COMMON(vdev);
> >> -    bool should_start =3D status & VIRTIO_CONFIG_S_DRIVER_OK;
> >> -
> >> -    if (!vdev->vm_running) {
> >> -        should_start =3D false;
> >> -    }
> >> +    bool should_start =3D virtio_device_started(vdev, status);
> >> =20
> >>      if (vvc->vhost_dev.started =3D=3D should_start) {
> >>          return;
> >> diff --git a/hw/virtio/vhost-vsock.c b/hw/virtio/vhost-vsock.c
> >> index 0338de892f..8031c164a5 100644
> >> --- a/hw/virtio/vhost-vsock.c
> >> +++ b/hw/virtio/vhost-vsock.c
> >> @@ -70,13 +70,9 @@ static int vhost_vsock_set_running(VirtIODevice *vd=
ev, int start)
> >>  static void vhost_vsock_set_status(VirtIODevice *vdev, uint8_t status)
> >>  {
> >>      VHostVSockCommon *vvc =3D VHOST_VSOCK_COMMON(vdev);
> >> -    bool should_start =3D status & VIRTIO_CONFIG_S_DRIVER_OK;
> >> +    bool should_start =3D virtio_device_started(vdev, status);
> >>      int ret;
> >> =20
> >> -    if (!vdev->vm_running) {
> >> -        should_start =3D false;
> >> -    }
> >> -
> >>      if (vvc->vhost_dev.started =3D=3D should_start) {
> >>          return;
> >>      }
> >> --=20
> >> 2.30.2
>=20
>=20
> --=20
> Alex Benn=E9e

