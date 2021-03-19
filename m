References: <20210318135223.1342795-1-ckuehl@redhat.com>
	<20210318135223.1342795-3-ckuehl@redhat.com>
	<20210319134948.GA402287@redhat.com>
From: Connor Kuehl <ckuehl@redhat.com>
Message-ID: <6a44908d-7e2d-d239-c56a-68730c5357cd@redhat.com>
Date: Fri, 19 Mar 2021 09:16:15 -0500
MIME-Version: 1.0
In-Reply-To: <20210319134948.GA402287@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 2/3] virtiofs: split requests that exceed
	virtqueue size
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, jasowang@redhat.com, mst@redhat.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On 3/19/21 8:49 AM, Vivek Goyal wrote:
> On Thu, Mar 18, 2021 at 08:52:22AM -0500, Connor Kuehl wrote:
>> If an incoming FUSE request can't fit on the virtqueue, the request is
>> placed onto a workqueue so a worker can try to resubmit it later where
>> there will (hopefully) be space for it next time.
>>
>> This is fine for requests that aren't larger than a virtqueue's maximum
>> capacity. However, if a request's size exceeds the maximum capacity of
>> the virtqueue (even if the virtqueue is empty), it will be doomed to a
>> life of being placed on the workqueue, removed, discovered it won't fit,
>> and placed on the workqueue yet again.
>>
>> Furthermore, from section 2.6.5.3.1 (Driver Requirements: Indirect
>> Descriptors) of the virtio spec:
>>
>>    "A driver MUST NOT create a descriptor chain longer than the Queue
>>    Size of the device."
>>
>> To fix this, limit the number of pages FUSE will use for an overall
>> request. This way, each request can realistically fit on the virtqueue
>> when it is decomposed into a scattergather list and avoid violating
>> section 2.6.5.3.1 of the virtio spec.
> 
> Hi Connor,
> 
> So as of now if a request is bigger than what virtqueue can support,
> it never gets dispatched and caller waits infinitely? So this patch
> will fix it by forcing fuse to split the request. That sounds good.

Right, in theory. Certain configurations make it easier to avoid this 
from happening, such as using indirect descriptors; however, in that 
case, the virtio spec says even if indirect descriptors are used, the 
descriptor chain length shouldn't exceed the length of the queue's size 
anyways. So having FUSE split the request also helps to uphold that 
property.

This is my reading of the potential looping problem:

virtio_fs_wake_pending_and_unlock
   calls
     virtio_fs_enqueue_req
       calls
         virtqueue_add_sgs

virtqueue_add_sgs can return -ENOSPC if there aren't enough descriptors 
available.

This error gets propagated back down to 
virtio_fs_wake_pending_and_unlock which checks for this exact issue and 
places the request on a workqueue to retry submission later.

Resubmission occurs in virtio_fs_request_dispatch_work, which does a 
similar dance, where if the request fails with -ENOSPC it just puts it 
back in the queue. However, for a sufficiently large request that would 
exceed the capacity of the virtqueue (even when empty), no amount of 
retrying will ever make it fit.

> 
> 
> [..]
>> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
>> index 8868ac31a3c0..a6ffba85d59a 100644
>> --- a/fs/fuse/virtio_fs.c
>> +++ b/fs/fuse/virtio_fs.c
>> @@ -18,6 +18,12 @@
>>   #include <linux/uio.h>
>>   #include "fuse_i.h"
>>   
>> +/* Used to help calculate the FUSE connection's max_pages limit for a request's
>> + * size. Parts of the struct fuse_req are sliced into scattergather lists in
>> + * addition to the pages used, so this can help account for that overhead.
>> + */
>> +#define FUSE_HEADER_OVERHEAD    4
> 
> How did yo arrive at this overhead. Is it following.
> 
> - One sg element for fuse_in_header.
> - One sg element for input arguments.
> - One sg element for fuse_out_header.
> - One sg element for output args.

Yes, that's exactly how I got to that number.

Connor


