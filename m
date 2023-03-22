Return-Path: <antonkuchin@yandex-team.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
 s=default; 
 t=1679483913; bh=UPd7HgCvNw6JdNnwCgT6gPpEcYfIIpLc4RSfNWz71Qw=;
 h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
 b=wkfHUZsfiUtF+i9STmx5Kq1R+nEcpg7Nc0gOY78b1cE2OSfRmGthSf8w14Zq6W15+
 ThmH59Ul2YyZLcP9Gwy3EeuGwLwGlK80jnqElkNQLA8yF9C0mAE4QtS2RYdE4eaOn+
 sZIouGwPEP0ubpDSXta2CJjppW5pQ5MKQ5g5+JRI=
Message-ID: <9ebadb03-553d-9d2c-9120-f3ab359d043d@yandex-team.ru>
Date: Wed, 22 Mar 2023 13:18:30 +0200
MIME-Version: 1.0
References: <20230313174833.28790-1-hreitz@redhat.com>
 <20230313174833.28790-3-hreitz@redhat.com>
 <035ba8d3-7943-ae8d-f4b2-76ac4fd74cf0@yandex-team.ru>
 <6892623a-f761-c334-b0a3-891a83e65125@redhat.com>
 <172b000e-1776-f98e-6e22-3e805de2e8d4@yandex-team.ru>
 <85b7d10f-6846-066c-026f-ce75850846f4@redhat.com>
 <06ffc2ce-8cec-139e-9c46-a6c62acb75b6@yandex-team.ru>
 <ed4deff4-b4d5-aa29-c427-1a4b9023f796@redhat.com>
From: Anton Kuchin <antonkuchin@yandex-team.ru>
In-Reply-To: <ed4deff4-b4d5-aa29-c427-1a4b9023f796@redhat.com>
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
Cc: virtio-fs@redhat.com, "Michael S . Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>

On 21/03/2023 19:49, Hanna Czenczek wrote:
> On 20.03.23 13:39, Anton Kuchin wrote:
>> On 20/03/2023 11:33, Hanna Czenczek wrote:
>>> On 17.03.23 19:37, Anton Kuchin wrote:
>>>> On 17/03/2023 19:52, Hanna Czenczek wrote:
>>>>> On 17.03.23 18:19, Anton Kuchin wrote:
>>>>>> On 13/03/2023 19:48, Hanna Czenczek wrote:
>>>>>>> A virtio-fs device's VM state consists of:
>>>>>>> - the virtio device (vring) state (VMSTATE_VIRTIO_DEVICE)
>>>>>>> - the back-end's (virtiofsd's) internal state
>>>>>>>
>>>>>>> We get/set the latter via the new vhost-user operations=20
>>>>>>> FS_SET_STATE_FD,
>>>>>>> FS_GET_STATE, and FS_SET_STATE.
>>>>>>>
>>>
>>> [...]
>>>
>>>>>>> =C2=A0 static const VMStateDescription vuf_vmstate =3D {
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .name =3D "vhost-user-fs",
>>>>>>> -=C2=A0=C2=A0=C2=A0 .unmigratable =3D 1,
>>>>>>> +=C2=A0=C2=A0=C2=A0 .version_id =3D 1,
>>>>>>> +=C2=A0=C2=A0=C2=A0 .fields =3D (VMStateField[]) {
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VMSTATE_VIRTIO_DEVICE,
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 {
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 .name =3D "back-end",
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 .info =3D &(const VMStateInfo) {
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 .name =3D "virtio-fs back-end state",
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 .get =3D vuf_load_state,
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 .put =3D vuf_save_state,
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 },
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 },
>>>>>>
>>>>>> I've been working on stateless migration patch [1] and there was=20
>>>>>> discussed that we
>>>>>> need to keep some kind of blocker by default if orchestrators=20
>>>>>> rely on unmigratable
>>>>>> field in virtio-fs vmstate to block the migration.
>>>>>> For this purpose I've implemented flag that selects "none" or=20
>>>>>> "external" and is checked
>>>>>> in pre_save, so it could be extended with "internal" option.
>>>>>> We didn't come to conclusion if we also need to check incoming=20
>>>>>> migration, the discussion
>>>>>> has stopped for a while but I'm going back to it now.
>>>>>>
>>>>>> I would appreciate if you have time to take a look at the=20
>>>>>> discussion and consider the idea
>>>>>> proposed there to store internal state as a subsection of vmstate=20
>>>>>> to make it as an option
>>>>>> but not mandatory.
>>>>>>
>>>>>> [1]=20
>>>>>> https://patchew.org/QEMU/20230217170038.1273710-1-antonkuchin@yandex=
-team.ru/
>>>>>
>>>>> So far I=E2=80=99ve mostly considered these issues orthogonal.=C2=A0 =
If your=20
>>>>> stateless migration goes in first, then state is optional and I=E2=80=
=99ll=20
>>>>> adjust this series.
>>>>> If stateful migration goes in first, then your series can simply=20
>>>>> make state optional by introducing the external option, no?
>>>>
>>>> Not really. State can be easily extended by subsections but not=20
>>>> trimmed. Maybe this can be worked around by defining two types of=20
>>>> vmstate and selecting the correct one at migration, but I'm not sure.
>>>
>>> I thought your patch included a switch on the vhost-user-fs device=20
>>> (on the qemu side) to tell qemu what migration data to expect. Can=20
>>> we not transfer a 0-length state for 'external', and assert this on=20
>>> the destination side?
>>
>> Looks like I really need to make the description of my patch and the=20
>> documentation more clear :) My patch proposes switch on _source_ side=20
>> to select which data to save in the stream mostly to protect old=20
>> orchestrators that don't expect virtio-fs to be migratable (and for=20
>> internal case it can be extended to select if qemu needs to request=20
>> state from backend), Michael insists that we also need to check on=20
>> destination but I disagree because I believe that we can figure this=20
>> out from stream data without additional device flags.
>>
>>>
>>>>>
>>>>> But maybe we could also consider making stateless migration a=20
>>>>> special case of stateful migration; if we had stateful migration,=20
>>>>> can=E2=80=99t we just implement stateless migration by telling virtio=
fsd=20
>>>>> that it should submit a special =E2=80=9CI have no state=E2=80=9D pse=
udo-state,=20
>>>>> i.e. by having a switch on virtiofsd instead?
>>>>
>>>> Sure. Backend can send empty state (as your patch treats 0 length=20
>>>> as a valid response and not error) or dummy state that can be=20
>>>> recognized as stateless. The only potential problem is that then we=20
>>>> need support in backend for new commands even to return dummy=20
>>>> state, and if backend can support both types then we'll need some=20
>>>> switch in backend to reply with real or empty state.
>>>
>>> Yes, exactly.
>>>
>>>>>
>>>>> Off the top of my head, some downsides of that approach would be
>>>>> (1) it=E2=80=99d need a switch on the virtiofsd side, not on the qemu=
 side=20
>>>>> (not sure if that=E2=80=99s a downside, but a difference for sure),
>>>>
>>>> Why would you? It seems to me that this affects only how qemu=20
>>>> treats the vmstate of device. If the state was requested backend=20
>>>> sends it to qemu. If state subsection is present in stream qemu=20
>>>> sends it to the backend for loading. Stateless one just doesn't=20
>>>> request state from the backend. Or am I missing something?
>>>>
>>>>> and (2) we=E2=80=99d need at least some support for this on the virti=
ofsd=20
>>>>> side, i.e. practically can=E2=80=99t come quicker than stateful migra=
tion=20
>>>>> support.
>>>>
>>>> Not much, essentially this is just a reconnect. I've sent a draft=20
>>>> of a reconnect patch for old C-virtiofsd, for rust version it takes=20
>>>> much longer because I'm learning rust and I'm not really good at it=20
>>>> yet.
>>>
>>> I meant these two downsides not for your proposal, but instead if we=20
>>> implemented stateless migration only in the back-end; i.e. the=20
>>> front-end would only implement stateful migration, and the back-end=20
>>> would send and accept an empty state.
>>>
>>> Then, qemu would always request a =E2=80=9Cstate=E2=80=9D (even if it t=
urns out=20
>>> empty for stateless migration), and qemu would always treat it the=20
>>> same, so there wouldn=E2=80=99t be a switch on the qemu side, but only =
on=20
>>> the virtiofsd side.=C2=A0 Doesn=E2=80=99t really matter, but what does =
matter is=20
>>> that we=E2=80=99d need to implement the migration interface in virtiofs=
d,=20
>>> even if in the end no state is transferred.
>>>
>>> So exactly what you=E2=80=99ve said above (=E2=80=9CThe only potential =
problem is=20
>>> [=E2=80=A6]=E2=80=9D). :)
>>>
>>> Hanna
>>>
>>
>> Oh, yes, we were talking about the same thing. So do you agree that=20
>> storing internal state data in subsection will allow backend code to=20
>> be more straightforward without additional switches?
>
> Sounds good.=C2=A0 I think we should rename VHOST_USER_MIGRATION_TYPE_NON=
E=20
> to ..._INTERNAL, though, and then use that (default) mode for stateful=20
> migration (via VMState), because I think that should be the default=20
> migration type (and while there=E2=80=99s no support for it, it will just=
=20
> continue to block migration).

My plan was to add new ..._INTERNAL option and keep ..._NONE as default=20
one that blocks migration unless orchestrator explicitly selects=20
migration type to avoid accidental migrations of old orchestrators that=20
expect blocker for virtio-fs. But if INTERNAL blocks migration when=20
backend doesn't support new commands your idea to make it default may be=20
even better.

>
>
> So I suppose you mean something like this, where=20
> vuf_stateful_migration() basically returns `fs->migration_type =3D=3D=20
> VHOST_USER_MIGRATION_TYPE_INTERNAL`, and on the destination, you=E2=80=99=
d=20
> check whether the subsection is present to decide which kind of=20
> migration it is, right?

Yes, exactly.

>
>
> static const VMStateDescription vuf_backend_vmstate;
>
> static const VMStateDescription vuf_vmstate =3D {
> =C2=A0=C2=A0=C2=A0 .name =3D "vhost-user-fs",
> =C2=A0=C2=A0=C2=A0 .version_id =3D 0,
> =C2=A0=C2=A0=C2=A0 .fields =3D (VMStateField[]) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VMSTATE_VIRTIO_DEVICE,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VMSTATE_END_OF_LIST()
> =C2=A0=C2=A0=C2=A0 },
> =C2=A0=C2=A0=C2=A0 .subsections =3D (const VMStateDescription*[]) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &vuf_backend_vmstate,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 NULL,
> =C2=A0=C2=A0=C2=A0 }
> };
>
> static const VMStateDescription vuf_backend_vmstate =3D {
> =C2=A0=C2=A0=C2=A0 .name =3D "vhost-user-fs-backend",
> =C2=A0=C2=A0=C2=A0 .version_id =3D 0,
> =C2=A0=C2=A0=C2=A0 .needed =3D vuf_stateful_migration,
> =C2=A0=C2=A0=C2=A0 .fields =3D (VMStateField[]) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .name =
=3D "back-end",
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .info =
=3D &(const VMStateInfo) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 .name =3D "virtio-fs back-end state",
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 .get =3D vuf_load_state,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 .put =3D vuf_save_state,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 },
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 },
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VMSTATE_END_OF_LIST()
> =C2=A0=C2=A0=C2=A0 },
> };
>

