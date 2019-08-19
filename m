References: <cover.1566185612.git.gavin.dg@linux.alibaba.com>
	<09680e84da8a43ee8fa69ed4ec7d1a5a5ffa9130.1566185612.git.gavin.dg@linux.alibaba.com>
	<20190819051443.GM52397@e18g06458.et15sqa>
From: piaojun <piaojun@huawei.com>
Message-ID: <44010515-d5c9-b4dc-fa4f-ba689f27909c@huawei.com>
Date: Mon, 19 Aug 2019 22:20:23 +0800
MIME-Version: 1.0
In-Reply-To: <20190819051443.GM52397@e18g06458.et15sqa>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [RFC PATCH 1/2] virtiofsd: add stat tools
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eryu Guan <eguan@linux.alibaba.com>, Gang Deng <gavin.dg@linux.alibaba.com>
Cc: virtio-fs@redhat.com



On 2019/8/19 13:14, Eryu Guan wrote:
> On Mon, Aug 19, 2019 at 11:41:13AM +0800, Gang Deng wrote:
>> There exist two components: vtrace && vstat. vtrace is embeded in virtiofsd,
>> it will put raw statistics data into share memory. Then the vstat tool could
>> parse it and do some post processing works. The performance overhead of
>> vtrace is very small because it does very simple things.
>>
>> For example, if we call open(2)/close(2) frequently in guest, and
>> randwite a file whose length is greater than the size of dax window.
>> We'll get the output as below:
>>
>> op                        inflt         op/s     svctm/us   %util
>> FUSE_OPEN(14)                 0      8379.87         3.24   2.71%
>> FUSE_RELEASE(18)              0      8379.87         1.77   1.48%
>> FUSE_FLUSH(25)                0      8379.87         2.04   1.71%
>> FUSE_SETUPMAPPING(48)         1      6393.90        34.72  22.20%
>> FUSE_REMOVEMAPPING(49)        0      6404.90        37.61  24.09%
>> TOTAL                         1     37938.39        13.76  52.20%
>>
>> The meaning of fields:
>>
>> - op
>>   The type of fuse requests, 'TOTAL' is sum of all.
>>
>> - inflt
>>   The number of the inflight requests, it must be ethier 0 or 1 because
>>   virtiofsd can only process fuse requests serially.
>>
>> - op/s
>>   The number of fuse requests completed per second.
>>
>> - svctm/us
>>   The average service time (in microseconds) for fuse requests.
>>
>> - %util
>>   Percentage of elapsed time during which virtiofsd was processing the fuse
>>   requests.
>>
>> when virtiofsd is hang, e.g. we support flock in host (just for example,
>> this has been fxied), we'll get this:
>>
>> op                        inflt         op/s     svctm/us   %util
>> FUSE_SETLKW(33)               1         0.00         0.00 100.00%
>> TOTAL                         1         0.00         0.00 100.00%
>>
>> the utilization is 100% and op/s equals zero, it indicates hang.
>>
>> If virtiofsd is idle, then the output looks like this:
>>
>> op                        inflt         op/s     svctm/us   %util
>> TOTAL                         0         0.00         0.00   0.00%
>>
>> Signed-off-by: Gang Deng <gavin.dg@linux.alibaba.com>
> 
> This looks useful to me! Would you like to provide an example command
> line usage in commit log too? Because I find that it's not obvious how
> the vtrace/vstat are used.

Agreed, and I wonder if they could be documented somewhere?

Jun

