Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=2Cfn9bH7b27+UeGs7PnYSrN7hcG7yRWRpV2ezOZwKxk=;
 b=cgJruDjXPzsqjv/TJ0gzC3FI3Fm4bo8VSViEZEueKGkY6fmM3SYkUY58hfyts9kwfE
 n7CkHNU21WqajQrrU9hZXiHCyrcpCGquYd1s3722rozeW/qSMplg3fwXq4J8Q9vijB1Z
 LJmkyfVuHe5UBIckZ2ytiSzAmn4C4UJUhYvXqlI+jkl5ezYYMA30HY8q3H+hqR4PDYhx
 ieKJOBs/GqJFc0XaqOUV7aJgKQ8aR/1Zukc6WAcKMPtON5sO17EA6Kx4TuXrpMWP4Y8o
 R+GfbICpTOnHFTiQmbtSzyiJm1sFz0scBOtBxgBuGVacml7Qo84c4WqnqCVtT1FpghTt
 Ibww==
References: <20220802095010.3330793-1-alex.bennee@linaro.org>
 <20220802095010.3330793-11-alex.bennee@linaro.org>
 <20221103123856-mutt-send-email-mst@kernel.org>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Thu, 03 Nov 2022 19:18:30 +0000
In-reply-to: <20221103123856-mutt-send-email-mst@kernel.org>
Message-ID: <87o7tnkfqy.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: qemu-devel@nongnu.org, slp@redhat.com, marcandre.lureau@redhat.com, stefanha@redhat.com, mathieu.poirier@linaro.org, viresh.kumar@linaro.org, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "open list:virtiofs" <virtio-fs@redhat.com>


"Michael S. Tsirkin" <mst@redhat.com> writes:

> On Tue, Aug 02, 2022 at 10:49:58AM +0100, Alex Benn=C3=A9e wrote:
>> All the boilerplate virtio code does the same thing (or should at
>> least) of checking to see if the VM is running before attempting to
>> start VirtIO. Push the logic up to the common function to avoid
>> getting a copy and paste wrong.
>>=20
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> How bad is it if we drop this?


I assume it will break gpio. Why do we want to drop this now? It has
been merged awhile. However there was a follow-up patch which tweaked
the order of checks in virtio_device_started.

>
>> ---
>>  include/hw/virtio/virtio.h   | 5 +++++
>>  hw/virtio/vhost-user-fs.c    | 6 +-----
>>  hw/virtio/vhost-user-i2c.c   | 6 +-----
>>  hw/virtio/vhost-user-rng.c   | 6 +-----
>>  hw/virtio/vhost-user-vsock.c | 6 +-----
>>  hw/virtio/vhost-vsock.c      | 6 +-----
>>  6 files changed, 10 insertions(+), 25 deletions(-)
>>=20
>> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
>> index 9bb2485415..74e7ad5a92 100644
>> --- a/include/hw/virtio/virtio.h
>> +++ b/include/hw/virtio/virtio.h
>> @@ -100,6 +100,7 @@ struct VirtIODevice
>>      VirtQueue *vq;
>>      MemoryListener listener;
>>      uint16_t device_id;
>> +    /* @vm_running: current VM running state via virtio_vmstate_change(=
) */
>>      bool vm_running;
>>      bool broken; /* device in invalid state, needs reset */
>>      bool use_disabled_flag; /* allow use of 'disable' flag when needed =
*/
>> @@ -376,6 +377,10 @@ static inline bool virtio_device_started(VirtIODevi=
ce *vdev, uint8_t status)
>>          return vdev->started;
>>      }
>> =20
>> +    if (!vdev->vm_running) {
>> +        return false;
>> +    }
>> +
>>      return status & VIRTIO_CONFIG_S_DRIVER_OK;
>>  }
>> =20
>> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
>> index e513e4fdda..d2bebba785 100644
>> --- a/hw/virtio/vhost-user-fs.c
>> +++ b/hw/virtio/vhost-user-fs.c
>> @@ -122,11 +122,7 @@ static void vuf_stop(VirtIODevice *vdev)
>>  static void vuf_set_status(VirtIODevice *vdev, uint8_t status)
>>  {
>>      VHostUserFS *fs =3D VHOST_USER_FS(vdev);
>> -    bool should_start =3D status & VIRTIO_CONFIG_S_DRIVER_OK;
>> -
>> -    if (!vdev->vm_running) {
>> -        should_start =3D false;
>> -    }
>> +    bool should_start =3D virtio_device_started(vdev, status);
>> =20
>>      if (fs->vhost_dev.started =3D=3D should_start) {
>>          return;
>> diff --git a/hw/virtio/vhost-user-i2c.c b/hw/virtio/vhost-user-i2c.c
>> index 6020eee093..b930cf6d5e 100644
>> --- a/hw/virtio/vhost-user-i2c.c
>> +++ b/hw/virtio/vhost-user-i2c.c
>> @@ -93,11 +93,7 @@ static void vu_i2c_stop(VirtIODevice *vdev)
>>  static void vu_i2c_set_status(VirtIODevice *vdev, uint8_t status)
>>  {
>>      VHostUserI2C *i2c =3D VHOST_USER_I2C(vdev);
>> -    bool should_start =3D status & VIRTIO_CONFIG_S_DRIVER_OK;
>> -
>> -    if (!vdev->vm_running) {
>> -        should_start =3D false;
>> -    }
>> +    bool should_start =3D virtio_device_started(vdev, status);
>> =20
>>      if (i2c->vhost_dev.started =3D=3D should_start) {
>>          return;
>> diff --git a/hw/virtio/vhost-user-rng.c b/hw/virtio/vhost-user-rng.c
>> index 3a7bf8e32d..a9c1c4bc79 100644
>> --- a/hw/virtio/vhost-user-rng.c
>> +++ b/hw/virtio/vhost-user-rng.c
>> @@ -90,11 +90,7 @@ static void vu_rng_stop(VirtIODevice *vdev)
>>  static void vu_rng_set_status(VirtIODevice *vdev, uint8_t status)
>>  {
>>      VHostUserRNG *rng =3D VHOST_USER_RNG(vdev);
>> -    bool should_start =3D status & VIRTIO_CONFIG_S_DRIVER_OK;
>> -
>> -    if (!vdev->vm_running) {
>> -        should_start =3D false;
>> -    }
>> +    bool should_start =3D virtio_device_started(vdev, status);
>> =20
>>      if (rng->vhost_dev.started =3D=3D should_start) {
>>          return;
>> diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
>> index 0f8ff99f85..22c1616ebd 100644
>> --- a/hw/virtio/vhost-user-vsock.c
>> +++ b/hw/virtio/vhost-user-vsock.c
>> @@ -55,11 +55,7 @@ const VhostDevConfigOps vsock_ops =3D {
>>  static void vuv_set_status(VirtIODevice *vdev, uint8_t status)
>>  {
>>      VHostVSockCommon *vvc =3D VHOST_VSOCK_COMMON(vdev);
>> -    bool should_start =3D status & VIRTIO_CONFIG_S_DRIVER_OK;
>> -
>> -    if (!vdev->vm_running) {
>> -        should_start =3D false;
>> -    }
>> +    bool should_start =3D virtio_device_started(vdev, status);
>> =20
>>      if (vvc->vhost_dev.started =3D=3D should_start) {
>>          return;
>> diff --git a/hw/virtio/vhost-vsock.c b/hw/virtio/vhost-vsock.c
>> index 0338de892f..8031c164a5 100644
>> --- a/hw/virtio/vhost-vsock.c
>> +++ b/hw/virtio/vhost-vsock.c
>> @@ -70,13 +70,9 @@ static int vhost_vsock_set_running(VirtIODevice *vdev=
, int start)
>>  static void vhost_vsock_set_status(VirtIODevice *vdev, uint8_t status)
>>  {
>>      VHostVSockCommon *vvc =3D VHOST_VSOCK_COMMON(vdev);
>> -    bool should_start =3D status & VIRTIO_CONFIG_S_DRIVER_OK;
>> +    bool should_start =3D virtio_device_started(vdev, status);
>>      int ret;
>> =20
>> -    if (!vdev->vm_running) {
>> -        should_start =3D false;
>> -    }
>> -
>>      if (vvc->vhost_dev.started =3D=3D should_start) {
>>          return;
>>      }
>> --=20
>> 2.30.2


--=20
Alex Benn=C3=A9e

