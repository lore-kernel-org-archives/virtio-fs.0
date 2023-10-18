Return-Path: <hreitz@redhat.com>
Message-ID: <cc513d48-bf05-557c-2e93-fb26480cd83c@redhat.com>
Date: Wed, 18 Oct 2023 18:17:45 +0200
MIME-Version: 1.0
References: <20231018081336-mutt-send-email-mst@kernel.org>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20231018081336-mutt-send-email-mst@kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v4 3/8] vhost-user.rst: Clarify
 enabling/disabling vrings
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>

On 18.10.23 14:14, Michael S. Tsirkin wrote:
> On Wed, Oct 04, 2023 at 02:58:59PM +0200, Hanna Czenczek wrote:
>> Currently, the vhost-user documentation says that rings are to be
>> initialized in a disabled state when VHOST_USER_F_PROTOCOL_FEATURES is
>> negotiated.  However, by the time of feature negotiation, all rings have
>> already been initialized, so it is not entirely clear what this means.
>>
>> At least the vhost-user-backend Rust crate's implementation interpreted
>> it to mean that whenever this feature is negotiated, all rings are to
>> put into a disabled state, which means that every SET_FEATURES call
>> would disable all rings, effectively halting the device.  This is
>> problematic because the VHOST_F_LOG_ALL feature is also set or cleared
>> this way, which happens during migration.  Doing so should not halt the
>> device.
>>
>> Other implementations have interpreted this to mean that the device is
>> to be initialized with all rings disabled, and a subsequent SET_FEATURES
>> call that does not set VHOST_USER_F_PROTOCOL_FEATURES will enable all of
>> them.  Here, SET_FEATURES will never disable any ring.
>>
>> This interpretation does not suffer the problem of unintentionally
>> halting the device whenever features are set or cleared, so it seems
>> better and more reasonable.
>>
>> We can clarify this in the documentation by making it explicit that the
>> enabled/disabled state is tracked even while the vring is stopped.
>> Every vring is initialized in a disabled state, and SET_FEATURES without
>> VHOST_USER_F_PROTOCOL_FEATURES simply becomes one way to enable all
>> vrings.
>>
>> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
>
> OK so I am expecting v5. My advice is to move patch 1 to end of patchset
> so we can defer it if we want to.

Already sent – I’ve just dropped patch 1, since it doesn’t add anything 
to the objective of the patch series itself:

https://lists.nongnu.org/archive/html/qemu-devel/2023-10/msg04727.html

Hanna

