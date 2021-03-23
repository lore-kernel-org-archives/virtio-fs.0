References: <20210318135223.1342795-1-ckuehl@redhat.com>
	<20210318135223.1342795-2-ckuehl@redhat.com>
	<fa4988fa-a671-0abf-f922-6b362faf10d5@redhat.com>
	<20210322041414-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Message-ID: <a6eb72e0-50be-1231-f7b5-3ebb822ee1b5@redhat.com>
Date: Tue, 23 Mar 2021 10:38:41 +0800
MIME-Version: 1.0
In-Reply-To: <20210322041414-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 1/3] virtio_ring: always warn when
 descriptor chain exceeds queue size
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com


在 2021/3/22 下午4:17, Michael S. Tsirkin 写道:
> On Mon, Mar 22, 2021 at 11:22:15AM +0800, Jason Wang wrote:
>> 在 2021/3/18 下午9:52, Connor Kuehl 写道:
>>>   From section 2.6.5.3.1 (Driver Requirements: Indirect Descriptors)
>>> of the virtio spec:
>>>
>>>     "A driver MUST NOT create a descriptor chain longer than the Queue
>>>     Size of the device."
>>>
>>> This text suggests that the warning should trigger even if
>>> indirect descriptors are in use.
>>
>> So I think at least the commit log needs some tweak.
>>
>> For split virtqueue. We had:
>>
>> 2.6.5.2 Driver Requirements: The Virtqueue Descriptor Table
>>
>> Drivers MUST NOT add a descriptor chain longer than 2^32 bytes in total;
>> this implies that loops in the descriptor chain are forbidden!
>>
>> 2.6.5.3.1 Driver Requirements: Indirect Descriptors
>>
>> A driver MUST NOT create a descriptor chain longer than the Queue Size of
>> the device.
>>
>> If I understand the spec correctly, the check is only needed for a single
>> indirect descriptor table?
>>
>> For packed virtqueue. We had:
>>
>> 2.7.17 Driver Requirements: Scatter-Gather Support
>>
>> A driver MUST NOT create a descriptor list longer than allowed by the
>> device.
>>
>> A driver MUST NOT create a descriptor list longer than the Queue Size.
>>
>> 2.7.19 Driver Requirements: Indirect Descriptors
>>
>> A driver MUST NOT create a descriptor chain longer than allowed by the
>> device.
>>
>> So it looks to me the packed part is fine.
>>
>> Note that if I understand the spec correctly 2.7.17 implies 2.7.19.
>>
>> Thanks
> It would be quite strange for packed and split to differ here:
> so for packed would you say there's no limit on # of descriptors at all?
>
> I am guessing I just forgot to move this part from
> the format specific to the common part of the spec.
>
> This needs discussion in the TC mailing list - want to start a thread
> there?


Will do.

Thanks


>
>
>
>>> Reported-by: Stefan Hajnoczi <stefanha@redhat.com>
>>> Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
>>> ---
>>>    drivers/virtio/virtio_ring.c | 7 ++++---
>>>    1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
>>> index 71e16b53e9c1..1bc290f9ba13 100644
>>> --- a/drivers/virtio/virtio_ring.c
>>> +++ b/drivers/virtio/virtio_ring.c
>>> @@ -444,11 +444,12 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>>>    	head = vq->free_head;
>>> +	WARN_ON_ONCE(total_sg > vq->split.vring.num);
>>> +
>>>    	if (virtqueue_use_indirect(_vq, total_sg))
>>>    		desc = alloc_indirect_split(_vq, total_sg, gfp);
>>>    	else {
>>>    		desc = NULL;
>>> -		WARN_ON_ONCE(total_sg > vq->split.vring.num && !vq->indirect);
>>>    	}
>>>    	if (desc) {
>>> @@ -1118,6 +1119,8 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
>>>    	BUG_ON(total_sg == 0);
>>> +	WARN_ON_ONCE(total_sg > vq->packed.vring.num);
>>> +
>>>    	if (virtqueue_use_indirect(_vq, total_sg))
>>>    		return virtqueue_add_indirect_packed(vq, sgs, total_sg,
>>>    				out_sgs, in_sgs, data, gfp);
>>> @@ -1125,8 +1128,6 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
>>>    	head = vq->packed.next_avail_idx;
>>>    	avail_used_flags = vq->packed.avail_used_flags;
>>> -	WARN_ON_ONCE(total_sg > vq->packed.vring.num && !vq->indirect);
>>> -
>>>    	desc = vq->packed.vring.desc;
>>>    	i = head;
>>>    	descs_used = total_sg;

