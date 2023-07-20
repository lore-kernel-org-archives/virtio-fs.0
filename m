Return-Path: <hao.xu@linux.dev>
Message-ID: <d3d992ff-3d3d-1282-cdbc-f7ec1ad175cb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1689865538;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=eWlUg67Z3Vsn5yQ9TKIdMGFUVfBzXVZ37bN0NECMfDc=;
 b=Hvw22b38iCSkWA4pAsMWQ57YTqkN3/O/HRWSeJ0djGJXLhkm56t4Hb5ZdNZpTo4xW3NV+c
 NGlAV+1Zn6/xFJbthkNMMf6cs02BEhqFw8CwfFhiobiua/aVt0jS9k+ms1kziDcqtSfWbS
 DzMHmvAkCVYX+Y35NSP/p646BW4Xfxo=
Date: Thu, 20 Jul 2023 23:05:24 +0800
MIME-Version: 1.0
References: <20230712111703.28031-1-hreitz@redhat.com>
 <20230712111703.28031-3-hreitz@redhat.com>
 <d5fc7e82-3bd5-deeb-b506-5a8d10bd7112@linux.dev>
 <14677814-9707-6a08-7b07-4532fad5f7a1@redhat.com>
From: Hao Xu <hao.xu@linux.dev>
In-Reply-To: <14677814-9707-6a08-7b07-4532fad5f7a1@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v2 2/4] vhost-user: Interface for migration
 state transfer
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>


On 7/20/23 21:20, Hanna Czenczek wrote:
> On 20.07.23 14:13, Hao Xu wrote:
>>
>> On 7/12/23 19:17, Hanna Czenczek wrote:
>>> Add the interface for transferring the back-end's state during=20
>>> migration
>>> as defined previously in vhost-user.rst.
>>>
>>> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
>>> ---
>>> =C2=A0 include/hw/virtio/vhost-backend.h |=C2=A0 24 +++++
>>> =C2=A0 include/hw/virtio/vhost.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0 79 ++++++++++++++++
>>> =C2=A0 hw/virtio/vhost-user.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 | 147=20
>>> ++++++++++++++++++++++++++++++
>>> =C2=A0 hw/virtio/vhost.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 37 ++++++++
>>> =C2=A0 4 files changed, 287 insertions(+)
>>>
>>> diff --git a/include/hw/virtio/vhost-backend.h=20
>>> b/include/hw/virtio/vhost-backend.h
>>> index 31a251a9f5..e59d0b53f8 100644
>>> --- a/include/hw/virtio/vhost-backend.h
>>> +++ b/include/hw/virtio/vhost-backend.h
>>> @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VHOST_SET_CONFIG_TYPE_MIGRATION =3D 1,
>>> =C2=A0 } VhostSetConfigType;
>>> =C2=A0 +typedef enum VhostDeviceStateDirection {
>>> +=C2=A0=C2=A0=C2=A0 /* Transfer state from back-end (device) to front-e=
nd */
>>> +=C2=A0=C2=A0=C2=A0 VHOST_TRANSFER_STATE_DIRECTION_SAVE =3D 0,
>>> +=C2=A0=C2=A0=C2=A0 /* Transfer state from front-end to back-end (devic=
e) */
>>> +=C2=A0=C2=A0=C2=A0 VHOST_TRANSFER_STATE_DIRECTION_LOAD =3D 1,
>>> +} VhostDeviceStateDirection;
>>> +
>>> +typedef enum VhostDeviceStatePhase {
>>> +=C2=A0=C2=A0=C2=A0 /* The device (and all its vrings) is stopped */
>>> +=C2=A0=C2=A0=C2=A0 VHOST_TRANSFER_STATE_PHASE_STOPPED =3D 0,
>>> +} VhostDeviceStatePhase;
>>> +
>>> =C2=A0 struct vhost_inflight;
>>> =C2=A0 struct vhost_dev;
>>> =C2=A0 struct vhost_log;
>>> @@ -133,6 +145,15 @@ typedef int (*vhost_set_config_call_op)(struct=20
>>> vhost_dev *dev,
>>> =C2=A0 =C2=A0 typedef void (*vhost_reset_status_op)(struct vhost_dev *d=
ev);
>>> =C2=A0 +typedef bool (*vhost_supports_migratory_state_op)(struct=20
>>> vhost_dev *dev);
>>> +typedef int (*vhost_set_device_state_fd_op)(struct vhost_dev *dev,
>>> + VhostDeviceStateDirection direction,
>>> + VhostDeviceStatePhase phase,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int fd,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int *reply_fd,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Error **errp);
>>> +typedef int (*vhost_check_device_state_op)(struct vhost_dev *dev,=20
>>> Error **errp);
>>> +
>>> =C2=A0 typedef struct VhostOps {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VhostBackendType backend_type;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vhost_backend_init vhost_backend_init;
>>> @@ -181,6 +202,9 @@ typedef struct VhostOps {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vhost_force_iommu_op vhost_force_iommu;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vhost_set_config_call_op vhost_set_confi=
g_call;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vhost_reset_status_op vhost_reset_status=
;
>>> +=C2=A0=C2=A0=C2=A0 vhost_supports_migratory_state_op vhost_supports_mi=
gratory_state;
>>> +=C2=A0=C2=A0=C2=A0 vhost_set_device_state_fd_op vhost_set_device_state=
_fd;
>>> +=C2=A0=C2=A0=C2=A0 vhost_check_device_state_op vhost_check_device_stat=
e;
>>> =C2=A0 } VhostOps;
>>> =C2=A0 =C2=A0 int vhost_backend_update_device_iotlb(struct vhost_dev *d=
ev,
>>> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
>>> index 69bf59d630..d8877496e5 100644
>>> --- a/include/hw/virtio/vhost.h
>>> +++ b/include/hw/virtio/vhost.h
>>> @@ -346,4 +346,83 @@ int vhost_dev_set_inflight(struct vhost_dev *dev,
>>> =C2=A0 int vhost_dev_get_inflight(struct vhost_dev *dev, uint16_t=20
>>> queue_size,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 struct vhost_inflight *inflight);
>>> =C2=A0 bool vhost_dev_has_iommu(struct vhost_dev *dev);
>>> +
>>> +/**
>>> + * vhost_supports_migratory_state(): Checks whether the back-end
>>> + * supports transferring internal state for the purpose of migration.
>>> + * Support for this feature is required for=20
>>> vhost_set_device_state_fd()
>>> + * and vhost_check_device_state().
>>> + *
>>> + * @dev: The vhost device
>>> + *
>>> + * Returns true if the device supports these commands, and false if it
>>> + * does not.
>>> + */
>>> +bool vhost_supports_migratory_state(struct vhost_dev *dev);
>>> +
>>> +/**
>>> + * vhost_set_device_state_fd(): Begin transfer of internal state=20
>>> from/to
>>> + * the back-end for the purpose of migration.=C2=A0 Data is to be=20
>>> transferred
>>> + * over a pipe according to @direction and @phase.=C2=A0 The sending e=
nd=20
>>> must
>>> + * only write to the pipe, and the receiving end must only read=20
>>> from it.
>>> + * Once the sending end is done, it closes its FD.=C2=A0 The receiving=
 end
>>> + * must take this as the end-of-transfer signal and close its FD, too.
>>> + *
>>> + * @fd is the back-end's end of the pipe: The write FD for SAVE,=20
>>> and the
>>> + * read FD for LOAD.=C2=A0 This function transfers ownership of @fd to=
 the
>>> + * back-end, i.e. closes it in the front-end.
>>> + *
>>> + * The back-end may optionally reply with an FD of its own, if this
>>> + * improves efficiency on its end.=C2=A0 In this case, the returned FD=
 is
>>
>>
>> Hi Hanna,
>>
>> In what case/situation, the back-end will have a more efficient fd?
>
> Hi Hao,
>
> There is no example yet.
>
>> Here my understanding of this "FD of its own" is as same type as
>>
>> the given fd(e.g. both pipe files), why the fd from back-end makes
>>
>> difference? Do I miss anything here?
>
> Maybe it makes more sense in the context of how we came up with the=20
> idea: Specifically, Stefan and me were asking which end should provide=20
> the FD.=C2=A0 In the context of vhost-user, it makes sense to have it be=
=20
> the front-end, because it controls vhost-user communication, but=20
> that=E2=80=99s just the natural protocol choice, not necessarily the most=
=20
> efficient one.
>
> It is imaginable that the front-end (e.g. qemu) could create a file=20
> descriptor whose data is directly spliced (automatically) into the=20
> migration stream, and then hand this FD to the back-end. In practice,=20
> this doesn=E2=80=99t work for qemu (at this point), because it doesn=E2=
=80=99t use=20
> simple read/write into the migration stream, but has an abstraction=20
> layer for that.=C2=A0 It might be possible to make this work in some case=
s,=20
> depending on what is used as a transport, but (1) not generally, and=20
> (2) not now.=C2=A0 But this would be efficient.


I'm thinking one thing, we now already have a channel(a unix domain=20
socket) between front-end and back-end, why not delivering the state=20
file (as an fd) to/from back-end directly rathen than negotiating

a new pipe as data channel.(since we already assume they can share fd of=20
pipe, why not fd of normal file?)



>
> The model we=E2=80=99d implement in qemu with this series is comparativel=
y not=20
> efficient, because it manually copies data from the FD (which by=20
> default is a pipe) into the migration stream.
>
> But it is possible that the front-end can provide a zero-copy FD into=20
> the migration stream, and for that reason we want to allow the=20
> front-end to provide the transfer FD.
>
> In contrast, the back-end might have a more efficient implementation=20
> on its side, too, though.=C2=A0 It is difficult to imagine, but it may be=
=20
> possible that it has an FD already where the data needs to written=20
> to/read from, e.g. because it=E2=80=99s connected to a physical device th=
at=20
> wants to get/send its state this way.=C2=A0 Admittedly, we have absolutel=
y=20
> no concrete example for such a back-end at this point, but it=E2=80=99s h=
ard=20
> to rule out that it is possible that there will be back-ends that=20
> could make use of zero-copy if only they are allowed to dictate the=20
> transfer FD.
>
> So because we in qemu can=E2=80=99t (at least not generally) provide an=
=20
> efficient (zero-copy) implementation, we don=E2=80=99t want to rule out t=
hat=20
> the back-end might be able to, so we also want to allow it to provide=20
> the transfer FD.
>
> In the end, we decided that we don=E2=80=99t want to preclude either side=
 of=20
> providing the FD.=C2=A0 If one side knows it can do better than a plain=
=20
> pipe with copying on both ends, it should provide the FD. That doesn=E2=
=80=99t=20
> complicate the implementation much.
>
> (So, notably, we measure =E2=80=9Cimproves efficiency=E2=80=9D based on =
=E2=80=9Cis it better=20
> than a plain pipe with copying on both ends=E2=80=9D.=C2=A0 A pipe with c=
opying is=20
> the default implementation, but as Stefan has pointed out in his=20
> review, it doesn=E2=80=99t need to be a pipe.=C2=A0 More efficient FDs, l=
ike the=20
> back-end can provide in its reply, would actually likely not be pipes.)


Yea, but the vhost-user protocol in this patchset defines these FDs as=20
data transfer channel not the data itself, how about the latter?




>
> Hanna
>

