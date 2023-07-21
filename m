Return-Path: <hao.xu@linux.dev>
Message-ID: <130f1169-7ff6-1f8d-c416-90a0bfa3a6dd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1689927815;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=fUDUWK+so5TMLl2RSbEHrsL6g7/lD6FkvaTpUyXuIKU=;
 b=lqG38qNnKP1yCSjwbNwwBXSlWIYYALKbaJgplO0ukeXBxWhfmxxcsAEf+AIQafNFVs593b
 sqNrQzzNWd+wNwFTURQ5nzo/WeUZ/2mJ6gYr2c0ruuKcBAC/erQt51RVatD8zVsJHPckf0
 LM8vnAhCFE7SBxjemNe4OeoGF+Omvng=
Date: Fri, 21 Jul 2023 16:23:23 +0800
MIME-Version: 1.0
References: <20230712111703.28031-1-hreitz@redhat.com>
 <20230712111703.28031-3-hreitz@redhat.com>
 <d5fc7e82-3bd5-deeb-b506-5a8d10bd7112@linux.dev>
 <14677814-9707-6a08-7b07-4532fad5f7a1@redhat.com>
 <d3d992ff-3d3d-1282-cdbc-f7ec1ad175cb@linux.dev>
 <f07af821-a667-f2c5-3cec-a2f3e2b31ee2@redhat.com>
From: Hao Xu <hao.xu@linux.dev>
In-Reply-To: <f07af821-a667-f2c5-3cec-a2f3e2b31ee2@redhat.com>
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


On 7/21/23 16:07, Hanna Czenczek wrote:
> On 20.07.23 17:05, Hao Xu wrote:
>>
>> On 7/20/23 21:20, Hanna Czenczek wrote:
>>> On 20.07.23 14:13, Hao Xu wrote:
>>>>
>>>> On 7/12/23 19:17, Hanna Czenczek wrote:
>>>>> Add the interface for transferring the back-end's state during=20
>>>>> migration
>>>>> as defined previously in vhost-user.rst.
>>>>>
>>>>> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
>>>>> ---
>>>>> =C2=A0 include/hw/virtio/vhost-backend.h |=C2=A0 24 +++++
>>>>> =C2=A0 include/hw/virtio/vhost.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 79 ++++++++++++++++
>>>>> =C2=A0 hw/virtio/vhost-user.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 147=20
>>>>> ++++++++++++++++++++++++++++++
>>>>> =C2=A0 hw/virtio/vhost.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 37 ++++++++
>>>>> =C2=A0 4 files changed, 287 insertions(+)
>>>>>
>>>>> diff --git a/include/hw/virtio/vhost-backend.h=20
>>>>> b/include/hw/virtio/vhost-backend.h
>>>>> index 31a251a9f5..e59d0b53f8 100644
>>>>> --- a/include/hw/virtio/vhost-backend.h
>>>>> +++ b/include/hw/virtio/vhost-backend.h
>>>>> @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VHOST_SET_CONFIG_TYPE_MIGRATION =3D 1,
>>>>> =C2=A0 } VhostSetConfigType;
>>>>> =C2=A0 +typedef enum VhostDeviceStateDirection {
>>>>> +=C2=A0=C2=A0=C2=A0 /* Transfer state from back-end (device) to front=
-end */
>>>>> +=C2=A0=C2=A0=C2=A0 VHOST_TRANSFER_STATE_DIRECTION_SAVE =3D 0,
>>>>> +=C2=A0=C2=A0=C2=A0 /* Transfer state from front-end to back-end (dev=
ice) */
>>>>> +=C2=A0=C2=A0=C2=A0 VHOST_TRANSFER_STATE_DIRECTION_LOAD =3D 1,
>>>>> +} VhostDeviceStateDirection;
>>>>> +
>>>>> +typedef enum VhostDeviceStatePhase {
>>>>> +=C2=A0=C2=A0=C2=A0 /* The device (and all its vrings) is stopped */
>>>>> +=C2=A0=C2=A0=C2=A0 VHOST_TRANSFER_STATE_PHASE_STOPPED =3D 0,
>>>>> +} VhostDeviceStatePhase;
>>>>> +
>>>>> =C2=A0 struct vhost_inflight;
>>>>> =C2=A0 struct vhost_dev;
>>>>> =C2=A0 struct vhost_log;
>>>>> @@ -133,6 +145,15 @@ typedef int=20
>>>>> (*vhost_set_config_call_op)(struct vhost_dev *dev,
>>>>> =C2=A0 =C2=A0 typedef void (*vhost_reset_status_op)(struct vhost_dev =
*dev);
>>>>> =C2=A0 +typedef bool (*vhost_supports_migratory_state_op)(struct=20
>>>>> vhost_dev *dev);
>>>>> +typedef int (*vhost_set_device_state_fd_op)(struct vhost_dev *dev,
>>>>> + VhostDeviceStateDirection direction,
>>>>> + VhostDeviceStatePhase phase,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int fd,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int *reply_fd,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Error **errp);
>>>>> +typedef int (*vhost_check_device_state_op)(struct vhost_dev *dev,=20
>>>>> Error **errp);
>>>>> +
>>>>> =C2=A0 typedef struct VhostOps {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VhostBackendType backend_type;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vhost_backend_init vhost_backend_init;
>>>>> @@ -181,6 +202,9 @@ typedef struct VhostOps {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vhost_force_iommu_op vhost_force_iommu=
;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vhost_set_config_call_op vhost_set_con=
fig_call;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vhost_reset_status_op vhost_reset_stat=
us;
>>>>> +=C2=A0=C2=A0=C2=A0 vhost_supports_migratory_state_op=20
>>>>> vhost_supports_migratory_state;
>>>>> +=C2=A0=C2=A0=C2=A0 vhost_set_device_state_fd_op vhost_set_device_sta=
te_fd;
>>>>> +=C2=A0=C2=A0=C2=A0 vhost_check_device_state_op vhost_check_device_st=
ate;
>>>>> =C2=A0 } VhostOps;
>>>>> =C2=A0 =C2=A0 int vhost_backend_update_device_iotlb(struct vhost_dev =
*dev,
>>>>> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
>>>>> index 69bf59d630..d8877496e5 100644
>>>>> --- a/include/hw/virtio/vhost.h
>>>>> +++ b/include/hw/virtio/vhost.h
>>>>> @@ -346,4 +346,83 @@ int vhost_dev_set_inflight(struct vhost_dev=20
>>>>> *dev,
>>>>> =C2=A0 int vhost_dev_get_inflight(struct vhost_dev *dev, uint16_t=20
>>>>> queue_size,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 struct vhost_inflight *inflight);
>>>>> =C2=A0 bool vhost_dev_has_iommu(struct vhost_dev *dev);
>>>>> +
>>>>> +/**
>>>>> + * vhost_supports_migratory_state(): Checks whether the back-end
>>>>> + * supports transferring internal state for the purpose of=20
>>>>> migration.
>>>>> + * Support for this feature is required for=20
>>>>> vhost_set_device_state_fd()
>>>>> + * and vhost_check_device_state().
>>>>> + *
>>>>> + * @dev: The vhost device
>>>>> + *
>>>>> + * Returns true if the device supports these commands, and false=20
>>>>> if it
>>>>> + * does not.
>>>>> + */
>>>>> +bool vhost_supports_migratory_state(struct vhost_dev *dev);
>>>>> +
>>>>> +/**
>>>>> + * vhost_set_device_state_fd(): Begin transfer of internal state=20
>>>>> from/to
>>>>> + * the back-end for the purpose of migration.=C2=A0 Data is to be=20
>>>>> transferred
>>>>> + * over a pipe according to @direction and @phase.=C2=A0 The sending=
=20
>>>>> end must
>>>>> + * only write to the pipe, and the receiving end must only read=20
>>>>> from it.
>>>>> + * Once the sending end is done, it closes its FD.=C2=A0 The receivi=
ng=20
>>>>> end
>>>>> + * must take this as the end-of-transfer signal and close its FD,=20
>>>>> too.
>>>>> + *
>>>>> + * @fd is the back-end's end of the pipe: The write FD for SAVE,=20
>>>>> and the
>>>>> + * read FD for LOAD.=C2=A0 This function transfers ownership of @fd =
to=20
>>>>> the
>>>>> + * back-end, i.e. closes it in the front-end.
>>>>> + *
>>>>> + * The back-end may optionally reply with an FD of its own, if this
>>>>> + * improves efficiency on its end.=C2=A0 In this case, the returned =
FD is
>>>>
>>>>
>>>> Hi Hanna,
>>>>
>>>> In what case/situation, the back-end will have a more efficient fd?
>>>
>>> Hi Hao,
>>>
>>> There is no example yet.
>>>
>>>> Here my understanding of this "FD of its own" is as same type as
>>>>
>>>> the given fd(e.g. both pipe files), why the fd from back-end makes
>>>>
>>>> difference? Do I miss anything here?
>>>
>>> Maybe it makes more sense in the context of how we came up with the=20
>>> idea: Specifically, Stefan and me were asking which end should=20
>>> provide the FD.=C2=A0 In the context of vhost-user, it makes sense to=
=20
>>> have it be the front-end, because it controls vhost-user=20
>>> communication, but that=E2=80=99s just the natural protocol choice, not=
=20
>>> necessarily the most efficient one.
>>>
>>> It is imaginable that the front-end (e.g. qemu) could create a file=20
>>> descriptor whose data is directly spliced (automatically) into the=20
>>> migration stream, and then hand this FD to the back-end. In=20
>>> practice, this doesn=E2=80=99t work for qemu (at this point), because i=
t=20
>>> doesn=E2=80=99t use simple read/write into the migration stream, but ha=
s an=20
>>> abstraction layer for that.=C2=A0 It might be possible to make this wor=
k=20
>>> in some cases, depending on what is used as a transport, but (1) not=20
>>> generally, and (2) not now.=C2=A0 But this would be efficient.
>>
>>
>> I'm thinking one thing, we now already have a channel(a unix domain=20
>> socket) between front-end and back-end, why not delivering the state=20
>> file (as an fd) to/from back-end directly rathen than negotiating
>>
>> a new pipe as data channel.(since we already assume they can share fd=20
>> of pipe, why not fd of normal file?)
>
> I don=E2=80=99t quite understand.=C2=A0 We do deliver the FD to the back-=
end=20
> through this new command to the back-end, rather directly.=C2=A0 The=20
> back-end can disagree and send another FD back, but it doesn=E2=80=99t ha=
ve=20
> to.=C2=A0 It can just simply always take the FD that it=E2=80=99s been gi=
ven.
>
> The FD also doesn=E2=80=99t need to be a pipe, it can be any FD that the=
=20
> back-end can read the state from (see my discussion with Stefan on=20
> patch 1).=C2=A0 In the practical implementation, it=E2=80=99s difficult f=
or qemu to=20
> provide anything that is not a pipe, because the migration state can=20
> be sent over many channels, and the respective FD (if any) is not=20
> exposed on the high level (for devices).
>
>>
>>>
>>> The model we=E2=80=99d implement in qemu with this series is comparativ=
ely=20
>>> not efficient, because it manually copies data from the FD (which by=20
>>> default is a pipe) into the migration stream.
>>>
>>> But it is possible that the front-end can provide a zero-copy FD=20
>>> into the migration stream, and for that reason we want to allow the=20
>>> front-end to provide the transfer FD.
>>>
>>> In contrast, the back-end might have a more efficient implementation=20
>>> on its side, too, though.=C2=A0 It is difficult to imagine, but it may =
be=20
>>> possible that it has an FD already where the data needs to written=20
>>> to/read from, e.g. because it=E2=80=99s connected to a physical device =
that=20
>>> wants to get/send its state this way.=C2=A0 Admittedly, we have=20
>>> absolutely no concrete example for such a back-end at this point,=20
>>> but it=E2=80=99s hard to rule out that it is possible that there will b=
e=20
>>> back-ends that could make use of zero-copy if only they are allowed=20
>>> to dictate the transfer FD.
>>>
>>> So because we in qemu can=E2=80=99t (at least not generally) provide an=
=20
>>> efficient (zero-copy) implementation, we don=E2=80=99t want to rule out=
 that=20
>>> the back-end might be able to, so we also want to allow it to=20
>>> provide the transfer FD.
>>>
>>> In the end, we decided that we don=E2=80=99t want to preclude either si=
de of=20
>>> providing the FD.=C2=A0 If one side knows it can do better than a plain=
=20
>>> pipe with copying on both ends, it should provide the FD. That=20
>>> doesn=E2=80=99t complicate the implementation much.
>>>
>>> (So, notably, we measure =E2=80=9Cimproves efficiency=E2=80=9D based on=
 =E2=80=9Cis it=20
>>> better than a plain pipe with copying on both ends=E2=80=9D.=C2=A0 A pi=
pe with=20
>>> copying is the default implementation, but as Stefan has pointed out=20
>>> in his review, it doesn=E2=80=99t need to be a pipe.=C2=A0 More efficie=
nt FDs,=20
>>> like the back-end can provide in its reply, would actually likely=20
>>> not be pipes.)
>>
>>
>> Yea, but the vhost-user protocol in this patchset defines these FDs=20
>> as data transfer channel not the data itself, how about the latter?
>
> I don=E2=80=99t quite understand this either.=C2=A0 Perhaps you=E2=80=99r=
e suggesting that=20
> we should just transfer the data over the vhost-user socket. There are=20
> two reasons why I don=E2=80=99t think we should do that: First, the vhost=
-user=20
> socket is currently only used for a small amount of data.=C2=A0 For=20
> example, the Rust vhost crate will reject any message longer than 4096=20
> bytes.=C2=A0 So if I were to use it for more data, I feel like I=E2=80=99=
d be=20
> abusing it.=C2=A0 Second, if/when we add other transfer phases (i.e. whil=
e=20
> the VM is still running, to transfer larger amounts of state), it will=20
> be important that the vhost-user socket is open for messages from the=20
> front-end at any time.=C2=A0 So then, at the latest, would we need a=20
> separate data channel.=C2=A0 I don=E2=80=99t feel like there is harm in m=
aking the=20
> interface have this separate channel now already.
>
> Or maybe you suggest that the separate FD is OK, but it shouldn=E2=80=99t=
 be=20
> defined to be a data transfer channel, but just data, i.e. not=20
> necessarily a pipe.=C2=A0 I think that=E2=80=99s basically the discussion=
 I had=20
> with Stefan on patch 1: That the important thing is just that the=20
> receiving end can read data out of the FD until EOF, and the writing=20
> end can write data and close the FD to signal the end of data. Whether=20
> they actually do that is not important, only that anything they do=20
> will let the other end do that.


I re-read the discussion of patch1, I now see what I suggested is=20
already included in the protocol design.


>
> Hanna
>

