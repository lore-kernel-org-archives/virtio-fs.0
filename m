Return-Path: <hreitz@redhat.com>
Message-ID: <f1b1f5b4-cb0b-2799-6e61-c645571fad2c@redhat.com>
Date: Fri, 17 Mar 2023 18:53:22 +0100
MIME-Version: 1.0
References: <20230313174833.28790-1-hreitz@redhat.com>
 <20230313174833.28790-2-hreitz@redhat.com>
 <8dc9cba8-b6fa-f0e7-8ec8-3d4152ad7a5e@yandex-team.ru>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <8dc9cba8-b6fa-f0e7-8ec8-3d4152ad7a5e@yandex-team.ru>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [RFC 1/2] vhost-user: Add interface for virtio-fs
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
Cc: Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>

On 17.03.23 18:39, Anton Kuchin wrote:
> On 13/03/2023 19:48, Hanna Czenczek wrote:
>> Add a virtio-fs-specific vhost-user interface to facilitate migrating
>> back-end-internal state.  We plan to migrate the internal state simply
>> as a binary blob after the streaming phase, so all we need is a way to
>> transfer such a blob from and to the back-end.  We do so by using a
>> dedicated area of shared memory through which the blob is transferred in
>> chunks.
>>
>> This patch adds the following vhost operations (and implements them for
>> vhost-user):
>>
>> - FS_SET_STATE_FD: The front-end passes a dedicated shared memory area
>>    to the back-end.  This area will be used to transfer state via the
>>    other two operations.
>>    (After the transfer FS_SET_STATE_FD detaches the shared memory area
>>    again.)
>>
>> - FS_GET_STATE: The front-end asks the back-end to place a chunk of
>>    internal state into the shared memory area.
>>
>> - FS_SET_STATE: The front-end puts a chunk of internal state into the
>>    shared memory area, and asks the back-end to fetch it.
>>
>> On the source side, the back-end is expected to serialize its internal
>> state either when FS_SET_STATE_FD is invoked, or when FS_GET_STATE is
>> invoked the first time.  On subsequent FS_GET_STATE calls, it memcpy()s
>> parts of that serialized state into the shared memory area.
>>
>> On the destination side, the back-end is expected to collect the state
>> blob over all FS_SET_STATE calls, and then deserialize and apply it once
>> FS_SET_STATE_FD detaches the shared memory area.
>>
>> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
>> ---
>>   include/hw/virtio/vhost-backend.h |   9 ++
>>   include/hw/virtio/vhost.h         |  68 +++++++++++++++
>>   hw/virtio/vhost-user.c            | 138 ++++++++++++++++++++++++++++++
>>   hw/virtio/vhost.c                 |  29 +++++++
>>   4 files changed, 244 insertions(+)
>>

[...]

>> +static ssize_t vhost_user_fs_get_state(struct vhost_dev *dev,
>> +                                       uint64_t state_offset,
>> +                                       size_t size)
>> +{
>
> Am I right to assume that vrings are supposed to be stopped to get/set 
> state?
> If I am shouldn't we check it before sending message or do you believe 
> it is
> better to return error from backend in these cases?

Good point!  Yes, the vrings should be stopped.  I don’t verify this 
currently, but it makes sense to do so both on the qemu and the 
virtiofsd side.

Hanna

