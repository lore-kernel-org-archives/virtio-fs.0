Return-Path: <antonkuchin@yandex-team.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
 s=default; 
 t=1679078260; bh=gZhmljQ7pzR5txJb0l7tPsQHuJDB4x1wRRl8L2r75QU=;
 h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
 b=cvd0xWkmuhYja3sygNuHVuUTacQ3TBN0L1wtC/ZuFrrni1UG4fB1SCvw8yboZO+Xw
 a1bO8/RqqYA7H/3iDQVKH6zyS/c7AERmlvWkycVq/5jgxzRNMgwzb165prfTK/XE/f
 jpxpU7d5jeqjIwAOTi9kizHsy8Mosgu5VDfSfRMU=
Message-ID: <172b000e-1776-f98e-6e22-3e805de2e8d4@yandex-team.ru>
Date: Fri, 17 Mar 2023 20:37:37 +0200
MIME-Version: 1.0
References: <20230313174833.28790-1-hreitz@redhat.com>
 <20230313174833.28790-3-hreitz@redhat.com>
 <035ba8d3-7943-ae8d-f4b2-76ac4fd74cf0@yandex-team.ru>
 <6892623a-f761-c334-b0a3-891a83e65125@redhat.com>
From: Anton Kuchin <antonkuchin@yandex-team.ru>
In-Reply-To: <6892623a-f761-c334-b0a3-891a83e65125@redhat.com>
Content-Language: en-US, ru-RU
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [RFC 2/2] vhost-user-fs: Implement stateful
 migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>

On 17/03/2023 19:52, Hanna Czenczek wrote:
> On 17.03.23 18:19, Anton Kuchin wrote:
>> On 13/03/2023 19:48, Hanna Czenczek wrote:
>>> A virtio-fs device's VM state consists of:
>>> - the virtio device (vring) state (VMSTATE_VIRTIO_DEVICE)
>>> - the back-end's (virtiofsd's) internal state
>>>
>>> We get/set the latter via the new vhost-user operations=20
>>> FS_SET_STATE_FD,
>>> FS_GET_STATE, and FS_SET_STATE.
>>>
>>> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
>>> ---
>>> =C2=A0 hw/virtio/vhost-user-fs.c | 171=20
>>> +++++++++++++++++++++++++++++++++++++-
>>> =C2=A0 1 file changed, 170 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
>>> index 83fc20e49e..df1fb02acc 100644
>>> --- a/hw/virtio/vhost-user-fs.c
>>> +++ b/hw/virtio/vhost-user-fs.c
>>> @@ -20,8 +20,10 @@
>>> =C2=A0 #include "hw/virtio/virtio-bus.h"
>>> =C2=A0 #include "hw/virtio/virtio-access.h"
>>> =C2=A0 #include "qemu/error-report.h"
>>> +#include "qemu/memfd.h"
>>> =C2=A0 #include "hw/virtio/vhost.h"
>>> =C2=A0 #include "hw/virtio/vhost-user-fs.h"
>>> +#include "migration/qemu-file-types.h"
>>> =C2=A0 #include "monitor/monitor.h"
>>> =C2=A0 #include "sysemu/sysemu.h"
>>> =C2=A0 @@ -298,9 +300,176 @@ static struct vhost_dev=20
>>> *vuf_get_vhost(VirtIODevice *vdev)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return &fs->vhost_dev;
>>> =C2=A0 }
>>> =C2=A0 +/**
>>> + * Fetch the internal state from the back-end (virtiofsd) and save it
>>> + * to `f`.
>>> + */
>>> +static int vuf_save_state(QEMUFile *f, void *pv, size_t size,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 const VMStateField *field, JSONWriter=20
>>> *vmdesc)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 VirtIODevice *vdev =3D pv;
>>> +=C2=A0=C2=A0=C2=A0 VHostUserFS *fs =3D VHOST_USER_FS(vdev);
>>> +=C2=A0=C2=A0=C2=A0 int memfd =3D -1;
>>> +=C2=A0=C2=A0=C2=A0 /* Size of the shared memory through which to trans=
fer the=20
>>> state */
>>> +=C2=A0=C2=A0=C2=A0 const size_t chunk_size =3D 4 * 1024 * 1024;
>>> +=C2=A0=C2=A0=C2=A0 size_t state_offset;
>>> +=C2=A0=C2=A0=C2=A0 ssize_t remaining;
>>> +=C2=A0=C2=A0=C2=A0 void *shm_buf;
>>> +=C2=A0=C2=A0=C2=A0 Error *local_err =3D NULL;
>>> +=C2=A0=C2=A0=C2=A0 int ret, ret2;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /* Set up shared memory through which to receive th=
e state from=20
>>> virtiofsd */
>>> +=C2=A0=C2=A0=C2=A0 shm_buf =3D qemu_memfd_alloc("vhost-fs-state", chun=
k_size,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 F_SEAL_SEAL | F_SEAL_SHRINK |=20
>>> F_SEAL_GROW,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &memfd, &local_err);
>>> +=C2=A0=C2=A0=C2=A0 if (!shm_buf) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error_report_err(local_err)=
;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOMEM;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto early_fail;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /* Share the SHM area with virtiofsd */
>>> +=C2=A0=C2=A0=C2=A0 ret =3D vhost_fs_set_state_fd(&fs->vhost_dev, memfd=
, chunk_size);
>>> +=C2=A0=C2=A0=C2=A0 if (ret < 0) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto early_fail;
>>
>> Don't we need some log message here too?
>
> Sure, why not.=C2=A0 There are other places in this patch that just retur=
n=20
> -errno but print no error, I think they could all use a verbose error=20
> message.
>
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /* Receive the virtiofsd state in chunks, and write=
 them to `f` */
>>> +=C2=A0=C2=A0=C2=A0 state_offset =3D 0;
>>> +=C2=A0=C2=A0=C2=A0 do {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t this_chunk_size;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 remaining =3D vhost_fs_get_=
state(&fs->vhost_dev, state_offset,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 chunk_size);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (remaining < 0) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret=
 =3D remaining;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 got=
o fail;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Prefix the whole state b=
y its total length */
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (state_offset =3D=3D 0) =
{
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 qem=
u_put_be64(f, remaining);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 this_chunk_size =3D MIN(rem=
aining, chunk_size);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 qemu_put_buffer(f, shm_buf,=
 this_chunk_size);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 state_offset +=3D this_chun=
k_size;
>>> +=C2=A0=C2=A0=C2=A0 } while (remaining >=3D chunk_size);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ret =3D 0;
>>> +fail:
>>> +=C2=A0=C2=A0=C2=A0 /* Have virtiofsd close the shared memory */
>>> +=C2=A0=C2=A0=C2=A0 ret2 =3D vhost_fs_set_state_fd(&fs->vhost_dev, -1, =
0);
>>> +=C2=A0=C2=A0=C2=A0 if (ret2 < 0) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error_report("Failed to rem=
ove state FD from the=20
>>> vhost-user-fs back "
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "end: %s", strerror(-re=
t));
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D 0) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret=
 =3D ret2;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +early_fail:
>>> +=C2=A0=C2=A0=C2=A0 if (shm_buf) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 qemu_memfd_free(shm_buf, ch=
unk_size, memfd);
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return ret;
>>> +}
>>> +
>>> +/**
>>> + * Load the back-end's (virtiofsd's) internal state from `f` and send
>>> + * it over to that back-end.
>>> + */
>>> +static int vuf_load_state(QEMUFile *f, void *pv, size_t size,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 const VMStateField *field)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 VirtIODevice *vdev =3D pv;
>>> +=C2=A0=C2=A0=C2=A0 VHostUserFS *fs =3D VHOST_USER_FS(vdev);
>>> +=C2=A0=C2=A0=C2=A0 int memfd =3D -1;
>>> +=C2=A0=C2=A0=C2=A0 /* Size of the shared memory through which to trans=
fer the=20
>>> state */
>>> +=C2=A0=C2=A0=C2=A0 const size_t chunk_size =3D 4 * 1024 * 1024;
>>> +=C2=A0=C2=A0=C2=A0 size_t state_offset;
>>> +=C2=A0=C2=A0=C2=A0 uint64_t remaining;
>>> +=C2=A0=C2=A0=C2=A0 void *shm_buf;
>>> +=C2=A0=C2=A0=C2=A0 Error *local_err =3D NULL;
>>> +=C2=A0=C2=A0=C2=A0 int ret, ret2;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /* The state is prefixed by its total length, read =
that first */
>>> +=C2=A0=C2=A0=C2=A0 remaining =3D qemu_get_be64(f);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /* Set up shared memory through which to send the s=
tate to=20
>>> virtiofsd */
>>> +=C2=A0=C2=A0=C2=A0 shm_buf =3D qemu_memfd_alloc("vhost-fs-state", chun=
k_size,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 F_SEAL_SEAL | F_SEAL_SHRINK |=20
>>> F_SEAL_GROW,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &memfd, &local_err);
>>> +=C2=A0=C2=A0=C2=A0 if (!shm_buf) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error_report_err(local_err)=
;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOMEM;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto early_fail;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /* Share the SHM area with virtiofsd */
>>> +=C2=A0=C2=A0=C2=A0 ret =3D vhost_fs_set_state_fd(&fs->vhost_dev, memfd=
, chunk_size);
>>> +=C2=A0=C2=A0=C2=A0 if (ret < 0) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto early_fail;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /*
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Read the virtiofsd state in chunks from `f`=
, and send them over
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * to virtiofsd
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> +=C2=A0=C2=A0=C2=A0 state_offset =3D 0;
>>> +=C2=A0=C2=A0=C2=A0 do {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t this_chunk_size =3D =
MIN(remaining, chunk_size);
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (qemu_get_buffer(f, shm_=
buf, this_chunk_size) <=20
>>> this_chunk_size) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret=
 =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 got=
o fail;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D vhost_fs_set_state(=
&fs->vhost_dev, state_offset,=20
>>> this_chunk_size);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret < 0) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 got=
o fail;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 state_offset +=3D this_chun=
k_size;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 remaining -=3D this_chunk_s=
ize;
>>> +=C2=A0=C2=A0=C2=A0 } while (remaining > 0);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ret =3D 0;
>>> +fail:
>>> +=C2=A0=C2=A0=C2=A0 ret2 =3D vhost_fs_set_state_fd(&fs->vhost_dev, -1, =
0);
>>> +=C2=A0=C2=A0=C2=A0 if (ret2 < 0) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error_report("Failed to rem=
ove state FD from the=20
>>> vhost-user-fs back "
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "end -- perhaps it fail=
ed to deserialize/apply=20
>>> the state: "
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "%s", strerror(-ret2));
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D 0) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret=
 =3D ret2;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +early_fail:
>>> +=C2=A0=C2=A0=C2=A0 if (shm_buf) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 qemu_memfd_free(shm_buf, ch=
unk_size, memfd);
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return ret;
>>> +}
>>> +
>>> =C2=A0 static const VMStateDescription vuf_vmstate =3D {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .name =3D "vhost-user-fs",
>>> -=C2=A0=C2=A0=C2=A0 .unmigratable =3D 1,
>>> +=C2=A0=C2=A0=C2=A0 .version_id =3D 1,
>>> +=C2=A0=C2=A0=C2=A0 .fields =3D (VMStateField[]) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VMSTATE_VIRTIO_DEVICE,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .na=
me =3D "back-end",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .in=
fo =3D &(const VMStateInfo) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 .name =3D "virtio-fs back-end state",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 .get =3D vuf_load_state,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 .put =3D vuf_save_state,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 },
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 },
>>
>> I've been working on stateless migration patch [1] and there was=20
>> discussed that we
>> need to keep some kind of blocker by default if orchestrators rely on=20
>> unmigratable
>> field in virtio-fs vmstate to block the migration.
>> For this purpose I've implemented flag that selects "none" or=20
>> "external" and is checked
>> in pre_save, so it could be extended with "internal" option.
>> We didn't come to conclusion if we also need to check incoming=20
>> migration, the discussion
>> has stopped for a while but I'm going back to it now.
>>
>> I would appreciate if you have time to take a look at the discussion=20
>> and consider the idea
>> proposed there to store internal state as a subsection of vmstate to=20
>> make it as an option
>> but not mandatory.
>>
>> [1]=20
>> https://patchew.org/QEMU/20230217170038.1273710-1-antonkuchin@yandex-tea=
m.ru/
>
> So far I=E2=80=99ve mostly considered these issues orthogonal.=C2=A0 If y=
our=20
> stateless migration goes in first, then state is optional and I=E2=80=99l=
l=20
> adjust this series.
> If stateful migration goes in first, then your series can simply make=20
> state optional by introducing the external option, no?

Not really. State can be easily extended by subsections but not trimmed.=20
Maybe this can be worked around by defining two types of vmstate and=20
selecting the correct one at migration, but I'm not sure.

>
> But maybe we could also consider making stateless migration a special=20
> case of stateful migration; if we had stateful migration, can=E2=80=99t w=
e=20
> just implement stateless migration by telling virtiofsd that it should=20
> submit a special =E2=80=9CI have no state=E2=80=9D pseudo-state, i.e. by =
having a=20
> switch on virtiofsd instead?

Sure. Backend can send empty state (as your patch treats 0 length as a=20
valid response and not error) or dummy state that can be recognized as=20
stateless. The only potential problem is that then we need support in=20
backend for new commands even to return dummy state, and if backend can=20
support both types then we'll need some switch in backend to reply with=20
real or empty state.

>
> Off the top of my head, some downsides of that approach would be
> (1) it=E2=80=99d need a switch on the virtiofsd side, not on the qemu sid=
e=20
> (not sure if that=E2=80=99s a downside, but a difference for sure),

Why would you? It seems to me that this affects only how qemu treats the=20
vmstate of device. If the state was requested backend sends it to qemu.=20
If state subsection is present in stream qemu sends it to the backend=20
for loading. Stateless one just doesn't request state from the backend.=20
Or am I missing something?

> and (2) we=E2=80=99d need at least some support for this on the virtiofsd=
=20
> side, i.e. practically can=E2=80=99t come quicker than stateful migration=
=20
> support.

Not much, essentially this is just a reconnect. I've sent a draft of a=20
reconnect patch for old C-virtiofsd, for rust version it takes much=20
longer because I'm learning rust and I'm not really good at it yet.

>
> Hanna
>

