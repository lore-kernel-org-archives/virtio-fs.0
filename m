References: <cover.1566185612.git.gavin.dg@linux.alibaba.com>
	<20190822134018.GJ20491@stefanha-x1.localdomain>
	<d9757234-dacd-9366-bcc7-19afe5af84a6@linux.alibaba.com>
	<20190823102624.GF12092@stefanha-x1.localdomain>
	<20190827133347.GA6901@stefanha-x1.localdomain>
From: Gang Deng <gavin.dg@linux.alibaba.com>
Message-ID: <fe321051-f57d-0215-49f0-ec6b61e0df42@linux.alibaba.com>
Date: Wed, 28 Aug 2019 19:29:23 +0800
MIME-Version: 1.0
In-Reply-To: <20190827133347.GA6901@stefanha-x1.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [RFC PATCH 0/2] add stat tools for virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com



On 2019/8/27 21:33, Stefan Hajnoczi wrote:
> On Fri, Aug 23, 2019 at 11:26:24AM +0100, Stefan Hajnoczi wrote:
>> On Thu, Aug 22, 2019 at 10:41:48PM +0800, Gang Deng wrote:
>>> On 2019/8/22 21:40, Stefan Hajnoczi wrote:
>>>> On Mon, Aug 19, 2019 at 11:41:12AM +0800, Gang Deng wrote:
>>> I think the difference of vtrae && qemu's tracing infrastructure looks like
>>> that of /proc/diskstats(iostat) && blktrace(blkparse) for linux kernel's block
>>> device. It depends on the use case. I'll measure the cost later to see whether
>>> qemu's tracer can meet our needs and whether it's enough to get statistics.
>>
>> Tracetool supports multiple tracers.  I suggest trying LTTng Userspace
>> Tracer because it is the lowest overhead tracer (using shared memory).
>>
>> https://lttng.org/docs/v2.10/#doc-lttng-ust
>>
>> I don't use LTTng much so I'm not sure how to consume a live trace from
>> a custom tool like vstat.  I've asked on the LTTng IRC channel and will
>> let you know what the answer is.
> 
> I asked on the LTTng IRC channel and it seems they currently don't offer
> a public API for processing trace events in shared memory.  This makes
> writing an efficient vstat tool using LTTng harder and there probably
> won't be much difference compared to other tracers.
> 
> Stefan
> 

Thanks for your confirmation :)  I'll refactor the code.

Gang

