Return-Path: <hao.xu@linux.dev>
Message-ID: <1d1f7854-209a-a985-e266-633ca14609da@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1658846492;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=uM3CH25gIo/Rm3FI9V6Bp39HKdQs8n0Zh5ABXp6DsfA=;
 b=ZLXijxQIARPu8czQTmAusYCAz8xAvtJuHIvV87qpAeRPzKEVxb4cZvqG2jWsOzgmKpv2lT
 9WeIM92j40c10rEs8p8/d+Prujmw1bRw1T7LP6ePl3gLOipe0GWJmWI8G/f8H1TDBtHgl5
 6E2ZTGsiqcQtrj2Ra73vL7lYVFLaBVE=
Date: Tue, 26 Jul 2022 22:41:23 +0800
MIME-Version: 1.0
References: <4f2c71a4-609e-6880-04d0-2eb127c55023@linux.dev>
 <CAJSP0QUzd7GXK0XN7YBBfEqO6abQSZMdJzW8pEHnz-ZnGetUWA@mail.gmail.com>
 <Yt/pVXilvkiLgowx@redhat.com>
From: Hao Xu <hao.xu@linux.dev>
In-Reply-To: <Yt/pVXilvkiLgowx@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] Question about performance comparison between
 virtio-fs and virtio-blk
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, virtio-fs@redhat.com

On 7/26/22 21:17, Vivek Goyal wrote:
> On Tue, Jul 26, 2022 at 08:55:38AM -0400, Stefan Hajnoczi wrote:
>> On Tue, 26 Jul 2022 at 08:24, Hao Xu <hao.xu@linux.dev> wrote:
>>> I watched your presentation about virtiofs in 2020,
>>>
>>> https://www.youtube.com/watch?v=EIVOzTsGMMI&t=232s
>>>
>>> which is really helpful to me, but I have a question about the graph at
>>> 3:53, could you give
>>>
>>> me more info about the test, like what tool you use for the test, if
>>> it's fio, what is the parameters.
>>>
>>> I used fio to do randread test in a qemu box, but turns out the iops of
>>> virtio-blk and virtio-fs are similar.
>>
> 
> Hi Hao,
> 
> My impression in general is that virtio-blk is much faster than virtiofs.

When testing virtio-blk, did you use the device directly or mount it and
test against a file.

> A simple macro test is do a kernel compilation and compare time taken
> between the two.

Good idea, I just tested with single file.

Thanks,
Hao

> 
>> I have CCed Vivek Goyal, who has done more virtiofs benchmarking and
>> might have ideas to share.
>>
>> The benchmarking tool was fio with the stated blocksize and I/O
>> pattern. The benchmark was probably run with direct=1. Based on the
>> virtio-blk numbers I think iodepth was greater than 1 but I don't have
>> the exact fio job parameters.
> 
> I had basically used fio jobs. I wrote some simple wrapper scripts to
> run fio and parse and report numbers.
> 
> https://github.com/rhvgoyal/virtiofs-tests
> 
> I don't have data for virtio-blk but I do seem to have some comparison
> numbers of virtiofs and virtio-9p.
> 
> https://github.com/rhvgoyal/virtiofs-tests/tree/master/performance-results/feb-23-2021
> 
> Thanks
> Vivek
> 
> 

