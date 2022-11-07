Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=3NaZXVDDvdh3ZdQweFbOyq0/SjShhLBn3jHvrWFLDRs=;
 b=yZokTe0lNTAKtpC73da0g5wQay1YkwvsEhj+TPd0g8Xa6gsX4nvpoUkBjLS54v5/cF
 YZRQcMtZKa1dzyKtbf8Ty4lqlFWPIvBdJRO3SUhvY12tRVqmKbk1Lk/ac62PSAgysZdv
 w8gpWZTtZfKvJv48u4U1kq/XhSz8Yc7GMOjPeDwdJV+JeUtBDlJgfQJ6snN4d9aN4yhF
 8EdRwehd1+CZ8qZAkqOBimVq4utPGK+rvOJR4vZRIiEh9qNDn4tRJhyooTIqS7VB3hqh
 ZRk2MzMQPLM0sdNlh4Y/dTe1cATyXtwkbkmLGlswjq46nGqhztxcBTtIP4hkuv5X51ay
 Viyw==
References: <20221010172813.204597-1-mst@redhat.com>
 <20221010172813.204597-8-mst@redhat.com>
 <20221105093645-mutt-send-email-mst@kernel.org>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 07 Nov 2022 09:21:49 +0000
In-reply-to: <20221105093645-mutt-send-email-mst@kernel.org>
Message-ID: <87y1snglt2.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PULL 07/55] hw/virtio: move vm_running check to
 virtio_device_started
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, "Dr.
 David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, virtio-fs@redhat.com, Viresh Kumar <viresh.kumar@linaro.org>


"Michael S. Tsirkin" <mst@redhat.com> writes:

> On Mon, Oct 10, 2022 at 01:29:10PM -0400, Michael S. Tsirkin wrote:
>> From: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>=20
>> All the boilerplate virtio code does the same thing (or should at
>> least) of checking to see if the VM is running before attempting to
>> start VirtIO. Push the logic up to the common function to avoid
>> getting a copy and paste wrong.
>>=20
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> Message-Id: <20220802095010.3330793-11-alex.bennee@linaro.org>
>> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
> So, looking at the resulting code, I missed the fact that this function
> is also used in virtio core.  So this patch does not do what it's saying
> it does (just refactor code).
> Instead it completely changes the meaning for virtio core.
> I thunk we should revert upstream, however, gpio has grown a
> dependency on this since then.
> Alex, could you take a look please?

So I guess we have three choices:

  new function for use by backends
  new function for use by core
  parameterise virtio_device_started to ignore vm state

I'll add some usage doc comments whichever way.

Do you have a preference?

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
>> MST
>>=20


--=20
Alex Benn=C3=A9e

