Return-Path: <hreitz@redhat.com>
Message-ID: <3e26e29a-b861-deb2-b67a-5e505cf58429@redhat.com>
Date: Tue, 17 Oct 2023 10:13:34 +0200
MIME-Version: 1.0
References: <e35f9f71-8d9d-6250-cbaa-70412b5a1149@nvidia.com>
 <3f28b1a4-d618-39df-57e6-6152f61cac6e@redhat.com>
 <8f3694c1-48d4-f34b-8f91-3bc217182ffa@redhat.com>
 <e19eb113-89b1-92ed-3375-8bc93c1ff39c@redhat.com>
 <8f51f02b-4676-c566-7304-f63e76df74ba@nvidia.com>
 <9a36a319-4567-f297-f14a-2025792ae93f@redhat.com> <87lecapxi4.fsf@linaro.org>
 <fbe05651-a65a-23d0-52be-2d611cc5740d@redhat.com> <87lec6mt03.fsf@linaro.org>
 <a7c01dd0-2b41-e294-f20c-a1edf6562a78@redhat.com>
 <20231017074943.gft6f672o6xzeepa@vireshk-i7>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20231017074943.gft6f672o6xzeepa@vireshk-i7>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] (no subject)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, "Michael S. Tsirkin" <mst@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>, Parav Pandit <parav@nvidia.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Yajun Wu <yajunw@nvidia.com>

On 17.10.23 09:49, Viresh Kumar wrote:
> On 13-10-23, 20:02, Hanna Czenczek wrote:
>> On 10.10.23 16:35, Alex Bennée wrote:
>>> I was going to say there is also the rust-vmm vhost-user-master crates
>>> which we've imported:
>>>
>>>     https://github.com/vireshk/vhost
>>>
>>> for the Xen Vhost Frontend:
>>>
>>>     https://github.com/vireshk/xen-vhost-frontend
>>>
>>> but I can't actually see any handling for GET/SET_STATUS at all which
>>> makes me wonder how we actually work. Viresh?
>> As far as I know the only back-end implementation of F_STATUS is in DPDK.
>> As I said, if anyone else implemented it right now, that would be dangerous,
>> because qemu doesn’t adhere to the virtio protocol when it comes to the
>> status byte.
> Yeah, none of the Rust based Virtio backends enable `STATUS` in
> `VhostUserProtocolFeatures` and so these messages are never exchanged.
>
> The generic Rust code for the backends, doesn't even implement them.
> Not sure if they should or not.

It absolutely should not, for evidence see this whole thread.  qemu 
sends a SET_STATUS 0, which amounts to a reset, when the VM is merely 
paused[1], and when it sets status bytes, it does not set them according 
to virtio specification.  Implementing it right now means relying on and 
working around qemu’s implementation-defined spec-breaking behavior.  
Also, note that qemu ignores feature negotiation response through 
FEATURES_OK, and DEVICE_NEEDS_RESET, so unless it’s worth working around 
the problems just to get some form of DRIVER_OK information (note this 
information does not come from the driver, but qemu makes it up), I 
absolutely would not implement it.

[1] Notably, it does restore the virtio state to the best of its 
abilities when the VM is resumed, but this is all still wrong (there is 
no point in doing so much on a pause/resume, it needlessly costs time) 
and any implementation that does a reset then will rely on the 
implementation-defined behavior that qemu is actually able to restore 
all the state that the back-end would lose during a reset. Notably, 
reset is not even well-defined in the vhost-user specification.  It was 
argued, in this thread, that DPDK works just fine with this, precisely 
because it ignores SET_STATUS 0.  Finally, if virtiofsd in particular, 
as a user of the Rust crates, is reset, it would lose its internal 
state, which qemu cannot restore short of using the upcoming migration 
facilities.

