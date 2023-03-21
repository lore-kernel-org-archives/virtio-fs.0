Return-Path: <hreitz@redhat.com>
Message-ID: <ed4deff4-b4d5-aa29-c427-1a4b9023f796@redhat.com>
Date: Tue, 21 Mar 2023 18:49:48 +0100
MIME-Version: 1.0
References: <20230313174833.28790-1-hreitz@redhat.com>
 <20230313174833.28790-3-hreitz@redhat.com>
 <035ba8d3-7943-ae8d-f4b2-76ac4fd74cf0@yandex-team.ru>
 <6892623a-f761-c334-b0a3-891a83e65125@redhat.com>
 <172b000e-1776-f98e-6e22-3e805de2e8d4@yandex-team.ru>
 <85b7d10f-6846-066c-026f-ce75850846f4@redhat.com>
 <06ffc2ce-8cec-139e-9c46-a6c62acb75b6@yandex-team.ru>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <06ffc2ce-8cec-139e-9c46-a6c62acb75b6@yandex-team.ru>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
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
To: Anton Kuchin <antonkuchin@yandex-team.ru>
Cc: virtio-fs@redhat.com, "Michael S . Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>

On 20.03.23 13:39, Anton Kuchin wrote:
> On 20/03/2023 11:33, Hanna Czenczek wrote:
>> On 17.03.23 19:37, Anton Kuchin wrote:
>>> On 17/03/2023 19:52, Hanna Czenczek wrote:
>>>> On 17.03.23 18:19, Anton Kuchin wrote:
>>>>> On 13/03/2023 19:48, Hanna Czenczek wrote:
>>>>>> A virtio-fs device's VM state consists of:
>>>>>> - the virtio device (vring) state (VMSTATE_VIRTIO_DEVICE)
>>>>>> - the back-end's (virtiofsd's) internal state
>>>>>>
>>>>>> We get/set the latter via the new vhost-user operations 
>>>>>> FS_SET_STATE_FD,
>>>>>> FS_GET_STATE, and FS_SET_STATE.
>>>>>>
>>
>> [...]
>>
>>>>>>   static const VMStateDescription vuf_vmstate = {
>>>>>>       .name = "vhost-user-fs",
>>>>>> -    .unmigratable = 1,
>>>>>> +    .version_id = 1,
>>>>>> +    .fields = (VMStateField[]) {
>>>>>> +        VMSTATE_VIRTIO_DEVICE,
>>>>>> +        {
>>>>>> +            .name = "back-end",
>>>>>> +            .info = &(const VMStateInfo) {
>>>>>> +                .name = "virtio-fs back-end state",
>>>>>> +                .get = vuf_load_state,
>>>>>> +                .put = vuf_save_state,
>>>>>> +            },
>>>>>> +        },
>>>>>
>>>>> I've been working on stateless migration patch [1] and there was 
>>>>> discussed that we
>>>>> need to keep some kind of blocker by default if orchestrators rely 
>>>>> on unmigratable
>>>>> field in virtio-fs vmstate to block the migration.
>>>>> For this purpose I've implemented flag that selects "none" or 
>>>>> "external" and is checked
>>>>> in pre_save, so it could be extended with "internal" option.
>>>>> We didn't come to conclusion if we also need to check incoming 
>>>>> migration, the discussion
>>>>> has stopped for a while but I'm going back to it now.
>>>>>
>>>>> I would appreciate if you have time to take a look at the 
>>>>> discussion and consider the idea
>>>>> proposed there to store internal state as a subsection of vmstate 
>>>>> to make it as an option
>>>>> but not mandatory.
>>>>>
>>>>> [1] 
>>>>> https://patchew.org/QEMU/20230217170038.1273710-1-antonkuchin@yandex-team.ru/
>>>>
>>>> So far I’ve mostly considered these issues orthogonal.  If your 
>>>> stateless migration goes in first, then state is optional and I’ll 
>>>> adjust this series.
>>>> If stateful migration goes in first, then your series can simply 
>>>> make state optional by introducing the external option, no?
>>>
>>> Not really. State can be easily extended by subsections but not 
>>> trimmed. Maybe this can be worked around by defining two types of 
>>> vmstate and selecting the correct one at migration, but I'm not sure.
>>
>> I thought your patch included a switch on the vhost-user-fs device 
>> (on the qemu side) to tell qemu what migration data to expect. Can we 
>> not transfer a 0-length state for 'external', and assert this on the 
>> destination side?
>
> Looks like I really need to make the description of my patch and the 
> documentation more clear :) My patch proposes switch on _source_ side 
> to select which data to save in the stream mostly to protect old 
> orchestrators that don't expect virtio-fs to be migratable (and for 
> internal case it can be extended to select if qemu needs to request 
> state from backend), Michael insists that we also need to check on 
> destination but I disagree because I believe that we can figure this 
> out from stream data without additional device flags.
>
>>
>>>>
>>>> But maybe we could also consider making stateless migration a 
>>>> special case of stateful migration; if we had stateful migration, 
>>>> can’t we just implement stateless migration by telling virtiofsd 
>>>> that it should submit a special “I have no state” pseudo-state, 
>>>> i.e. by having a switch on virtiofsd instead?
>>>
>>> Sure. Backend can send empty state (as your patch treats 0 length as 
>>> a valid response and not error) or dummy state that can be 
>>> recognized as stateless. The only potential problem is that then we 
>>> need support in backend for new commands even to return dummy state, 
>>> and if backend can support both types then we'll need some switch in 
>>> backend to reply with real or empty state.
>>
>> Yes, exactly.
>>
>>>>
>>>> Off the top of my head, some downsides of that approach would be
>>>> (1) it’d need a switch on the virtiofsd side, not on the qemu side 
>>>> (not sure if that’s a downside, but a difference for sure),
>>>
>>> Why would you? It seems to me that this affects only how qemu treats 
>>> the vmstate of device. If the state was requested backend sends it 
>>> to qemu. If state subsection is present in stream qemu sends it to 
>>> the backend for loading. Stateless one just doesn't request state 
>>> from the backend. Or am I missing something?
>>>
>>>> and (2) we’d need at least some support for this on the virtiofsd 
>>>> side, i.e. practically can’t come quicker than stateful migration 
>>>> support.
>>>
>>> Not much, essentially this is just a reconnect. I've sent a draft of 
>>> a reconnect patch for old C-virtiofsd, for rust version it takes 
>>> much longer because I'm learning rust and I'm not really good at it 
>>> yet.
>>
>> I meant these two downsides not for your proposal, but instead if we 
>> implemented stateless migration only in the back-end; i.e. the 
>> front-end would only implement stateful migration, and the back-end 
>> would send and accept an empty state.
>>
>> Then, qemu would always request a “state” (even if it turns out empty 
>> for stateless migration), and qemu would always treat it the same, so 
>> there wouldn’t be a switch on the qemu side, but only on the 
>> virtiofsd side.  Doesn’t really matter, but what does matter is that 
>> we’d need to implement the migration interface in virtiofsd, even if 
>> in the end no state is transferred.
>>
>> So exactly what you’ve said above (“The only potential problem is 
>> […]”). :)
>>
>> Hanna
>>
>
> Oh, yes, we were talking about the same thing. So do you agree that 
> storing internal state data in subsection will allow backend code to 
> be more straightforward without additional switches?

Sounds good.  I think we should rename VHOST_USER_MIGRATION_TYPE_NONE to 
..._INTERNAL, though, and then use that (default) mode for stateful 
migration (via VMState), because I think that should be the default 
migration type (and while there’s no support for it, it will just 
continue to block migration).

So I suppose you mean something like this, where 
vuf_stateful_migration() basically returns `fs->migration_type == 
VHOST_USER_MIGRATION_TYPE_INTERNAL`, and on the destination, you’d check 
whether the subsection is present to decide which kind of migration it 
is, right?

static const VMStateDescription vuf_backend_vmstate;

static const VMStateDescription vuf_vmstate = {
     .name = "vhost-user-fs",
     .version_id = 0,
     .fields = (VMStateField[]) {
         VMSTATE_VIRTIO_DEVICE,
         VMSTATE_END_OF_LIST()
     },
     .subsections = (const VMStateDescription*[]) {
         &vuf_backend_vmstate,
         NULL,
     }
};

static const VMStateDescription vuf_backend_vmstate = {
     .name = "vhost-user-fs-backend",
     .version_id = 0,
     .needed = vuf_stateful_migration,
     .fields = (VMStateField[]) {
         {
             .name = "back-end",
             .info = &(const VMStateInfo) {
                 .name = "virtio-fs back-end state",
                 .get = vuf_load_state,
                 .put = vuf_save_state,
             },
         },
         VMSTATE_END_OF_LIST()
     },
};

