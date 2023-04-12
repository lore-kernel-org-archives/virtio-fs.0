Return-Path: <hreitz@redhat.com>
Message-ID: <96b06766-5c4f-1d24-cea6-7c497feae44f@redhat.com>
Date: Wed, 12 Apr 2023 14:18:04 +0200
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-2-hreitz@redhat.com>
 <CAJh=p+4ki4XGEKZBQADUT5iO2NfPEyhYG4aTmaXyMPNzALpiwg@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CAJh=p+4ki4XGEKZBQADUT5iO2NfPEyhYG4aTmaXyMPNzALpiwg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 1/4] vhost: Re-enable vrings after setting
 features
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: German Maglione <gmaglione@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On 12.04.23 12:55, German Maglione wrote:
> On Tue, Apr 11, 2023 at 5:05 PM Hanna Czenczek <hreitz@redhat.com> wrote:
>> If the back-end supports the VHOST_USER_F_PROTOCOL_FEATURES feature,
>> setting the vhost features will set this feature, too.  Doing so
>> disables all vrings, which may not be intended.
>>
>> For example, enabling or disabling logging during migration requires
>> setting those features (to set or unset VHOST_F_LOG_ALL), which will
>> automatically disable all vrings.  In either case, the VM is running
>> (disabling logging is done after a failed or cancelled migration, and
>> only once the VM is running again, see comment in
>> memory_global_dirty_log_stop()), so the vrings should really be enabled.
>> As a result, the back-end seems to hang.
>>
>> To fix this, we must remember whether the vrings are supposed to be
>> enabled, and, if so, re-enable them after a SET_FEATURES call that set
>> VHOST_USER_F_PROTOCOL_FEATURES.
>>
>> It seems less than ideal that there is a short period in which the VM is
>> running but the vrings will be stopped (between SET_FEATURES and
>> SET_VRING_ENABLE).  To fix this, we would need to change the protocol,
>> e.g. by introducing a new flag or vhost-user protocol feature to disable
>> disabling vrings whenever VHOST_USER_F_PROTOCOL_FEATURES is set, or add
>> new functions for setting/clearing singular feature bits (so that
>> F_LOG_ALL can be set/cleared without touching F_PROTOCOL_FEATURES).
>>
> Could be the other way around?, I mean before commit
> 02b61f38d3574900fb4cc4c450b17c75956a6a04
>
> so until v7.2rc0 we didn't have this problem with
> VHOST_USER_F_PROTOCOL_FEATURES,
> so "it seems" it's fine to start with the vrings enabled, could be
> possible to go back to that
> behavior (reflecting that in the spec) and add a new flag to start
> with vrings disabled?

I’m not a fan of retroactively changing a public specification in an 
incompatible manner.  Also, “seems fine” isn’t enough of an argument to 
do so. :)  I’m not sure whether finding out if it’s actually fine is 
easy.  But in general, I try to abstain from retroactive spec changes...

I see the problem of qemu apparently not really caring for the specified 
meaning of the flag, indicating that this specified behavior is not 
optimal.  But the ideal way to fix this to me seems to add new flags to 
change the meaning to something more broadly useful.

But I’m not convinced either way.

Hanna

