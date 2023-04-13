Return-Path: <hreitz@redhat.com>
Message-ID: <db66184c-a6ab-f4e0-2740-e4bcd6a65993@redhat.com>
Date: Thu, 13 Apr 2023 19:53:53 +0200
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230413120554-mutt-send-email-mst@kernel.org>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20230413120554-mutt-send-email-mst@kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 0/4] vhost-user-fs: Internal migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Anton Kuchin <antonkuchin@yandex-team.ru>

On 13.04.23 18:11, Michael S. Tsirkin wrote:
> On Tue, Apr 11, 2023 at 05:05:11PM +0200, Hanna Czenczek wrote:
>> RFC:
>> https://lists.nongnu.org/archive/html/qemu-devel/2023-03/msg04263.html
>>
>> Hi,
>>
>> Patch 2 of this series adds new vhost methods (only for vhost-user at
>> this point) for transferring the back-end’s internal state to/from qemu
>> during migration, so that this state can be stored in the migration
>> stream.  (This is what we call “internal migration”, because the state
>> is internally available to qemu; this is in contrast to “external
>> migration”, which Anton is working on, where the back-end’s state is
>> handled by the back-end itself without involving qemu.)
>>
>> For this, the state is handled as a binary blob by qemu, and it is
>> transferred over a pipe that is established via a new vhost method.
>>
>> Patch 3 adds two high-level helper functions to (A) fetch any vhost
>> back-end’s internal state and store it in a migration stream (a
>> `QEMUFile`), and (B) load such state from a migrations stream and send
>> it to a vhost back-end.  These build on the low-level interface
>> introduced in patch 2.
>>
>> Patch 4 then uses these functions to implement internal migration for
>> vhost-user-fs.  Note that this of course depends on support in the
>> back-end (virtiofsd), which is not yet ready.
>>
>> Finally, patch 1 fixes a bug around migrating vhost-user devices: To
>> enable/disable logging[1], the VHOST_F_LOG_ALL feature must be
>> set/cleared, via the SET_FEATURES call.  Another, technically unrelated,
>> feature exists, VHOST_USER_F_PROTOCOL_FEATURES, which indicates support
>> for vhost-user protocol features.  Naturally, qemu wants to keep that
>> other feature enabled, so it will set it (when possible) in every
>> SET_FEATURES call.  However, a side effect of setting
>> VHOST_USER_F_PROTOCOL_FEATURES is that all vrings are disabled.
>
> I didn't get this part.
> Two questions:
> 	Rings can be enabled or disabled by ``VHOST_USER_SET_VRING_ENABLE``.
>
> 	If ``VHOST_USER_F_PROTOCOL_FEATURES`` has not been negotiated, the
> 	ring starts directly in the enabled state.
>
> 	If ``VHOST_USER_F_PROTOCOL_FEATURES`` has been negotiated, the ring is
> 	initialized in a disabled state and is enabled by
> 	``VHOST_USER_SET_VRING_ENABLE`` with parameter 1.
>
> so VHOST_USER_F_PROTOCOL_FEATURES only controls initial state of rings,
> it does not disable rings.

Oh.  Thanks. :)

That’s indeed a valid and more sensible interpretation.  I know that the 
vhost-user-backend crate virtiofsd uses has interpreted it differently.  
Looking into libvhost-user and DPDK, both have decided to instead have 
all vrings be disabled at reset, and enable them only when a 
SET_FEATURES with F_PROTOCOL_FEATURES comes in.  Doesn’t sound quite 
literally to spec either, but adheres to the interpretation of not 
disabling any rings just because F_PROTOCOL_FEATURES appears.

(I thought of proposing this (“only disable vrings for a `false` -> 
`true` flag state transition”), but thought that’d be too complicated.  
Oh, well. :))

So, the fix will go to the vhost-user-backend crate instead of qemu.  
That’s good!

Still, I will also prepare a patch to vhost-user.rst for this, because I 
still don’t find the specification clear on this.  The thing is, nobody 
interprets it as “negotiating this feature will decide whether, when all 
rings are initialized, they will be initialized in disabled or enabled 
state”, which is how I think you’ve interpreted it.  The problem is that 
“initialization” isn’t well-defined here.

Even libvhost-user and DPDK initialize the rings always in disabled 
state, regardless of this feature, but will put them into an enabled 
state later on if the feature isn’t negotiated.  I think this exact 
behavior should be precisely described in the spec, like:

Between initialization and ``VHOST_USER_SET_FEATURES``, it is 
implementation-defined whether each ring is enabled or disabled.

If ``VHOST_USER_F_PROTOCOL_FEATURES`` has not been negotiated, each 
ring, when started, will be enabled immediately.

If ``VHOST_USER_F_PROTOCOL_FEATURES`` has been negotiated, each ring 
will remain in the disabled state until ``VHOST_USER_SET_VRING_ENABLE`` 
enables it with parameter 1.

Hanna

