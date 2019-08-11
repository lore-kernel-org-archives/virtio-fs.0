References: <20190801165409.20121-1-stefanha@redhat.com>
	<20190807180355.GA22758@stefanha-x1.localdomain>
	<20190807205715.GE18557@redhat.com>
	<20190808090213.GD31476@stefanha-x1.localdomain>
	<20190808095316.GC2852@work-vm>
	<20190809082102.GB25286@stefanha-x1.localdomain>
From: piaojun <piaojun@huawei.com>
Message-ID: <277d9cd6-a8fa-fa1f-9cbc-7a7cd0897c84@huawei.com>
Date: Sun, 11 Aug 2019 10:26:18 +0800
MIME-Version: 1.0
In-Reply-To: <20190809082102.GB25286@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 0/4] virtiofsd: multithreading preparation
 part 3
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>



On 2019/8/9 16:21, Stefan Hajnoczi wrote:
> On Thu, Aug 08, 2019 at 10:53:16AM +0100, Dr. David Alan Gilbert wrote:
>> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
>>> On Wed, Aug 07, 2019 at 04:57:15PM -0400, Vivek Goyal wrote:
>>> 2. Can MAP/UNMAP be performed directly in QEMU via a separate virtqueue?
>>
>> I think there's two things to solve here that I don't currently know the
>> answer to:
>>   2a) We'd need to get the fd to qemu for the thing to mmap;
>>       we might be able to cache the fd on the qemu side for existing
>>       mappings, so when asking for a new mapping for an existing file then
>>       it would already have the fd.
>>
>>   2b) Running a device with a mix of queues inside QEMU and on
>>       vhost-user; I don't think we have anything with that mix
> 
> vhost-user-net works in the same way.  The ctrl queue is handled by QEMU
> and the rx/tx queues by the vhost device.  This is in fact how vhost was
> initially designed: the vhost device is not a full virtio device, only
> the dataplane.

Agreed.

> 
>>> 3. Can READ/WRITE be performed directly in QEMU via a separate virtqueue
>>>    to eliminate the bad address problem?
>>
>> Are you thinking of doing all read/writes that way, or just the corner
>> cases? It doesn't seem worth it for the corner cases unless you're
>> finding them cropping up in real work loads.
> 
> Send all READ/WRITE requests to QEMU instead of virtiofsd.
> 
> Only handle metadata requests in virtiofsd (OPEN, RELEASE, READDIR,
> MKDIR, etc).
> 

Sorry for not catching your point, and I like the virtiofsd to do
READ/WRITE requests and qemu handle metadata requests, as virtiofsd is
good at processing dataplane things due to thread-pool and CPU
affinity(maybe in the future). As you said, virtiofsd is just acting as
a vhost-user device which should care less about ctrl request.

If our concern is improving mmap/write/read performance, why not adding
a delay worker for unmmap which could decrease the ummap times. Maybe
virtiofsd could still handle both data and meta requests by this way.

Jun

