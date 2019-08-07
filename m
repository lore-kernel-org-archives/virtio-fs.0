References: <5D4A7641.9080400@huawei.com>
	<20190807091817.GA13267@stefanha-x1.localdomain>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D4A97F8.6090307@huawei.com>
Date: Wed, 7 Aug 2019 17:20:56 +0800
MIME-Version: 1.0
In-Reply-To: <20190807091817.GA13267@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v2 0/2][RFC] virtiofsd: Improve io bandwidth
 by replacing pwrite with pwritev
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

Hi Stefan,

On 2019/8/7 17:18, Stefan Hajnoczi wrote:
> On Wed, Aug 07, 2019 at 02:57:05PM +0800, piaojun wrote:
> 
> Hi,
> Please use git send-email --thread so that each patch is part of the
> same email thread.  This makes it easier to locate the entire patch
> series in an email client and to apply the patches together.

Good suggestion, I will try using 'git send-email'.

Thanks,
Jun

> 
>> >From my test, write bandwidth will be improved greatly by replacing
>> pwrite with pwritev, and the test result as below:
>>
>> ---
>> pwrite:
>> # fio -direct=1 -time_based -iodepth=64 -rw=randwrite -ioengine=libaio -bs=1M -size=1G -numjob=16 -runtime=30 -group_reporting -name=file -filename=/mnt/virtiofs/file
>> file: (g=0): rw=randwrite, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=64
>> ...
>> fio-2.13
>> Starting 16 processes
>> Jobs: 16 (f=16): [w(16)] [100.0% done] [0KB/886.0MB/0KB /s] [0/886/0 iops] [eta 00m:00s]
>> file: (groupid=0, jobs=16): err= 0: pid=5799: Tue Aug 6 18:48:26 2019
>> write: io=26881MB, bw=916988KB/s, iops=895, runt= 30018msec
>>
>> pwritev:
>> # fio -direct=1 -time_based -iodepth=64 -rw=randwrite -ioengine=libaio -bs=1M -size=1G -numjob=16 -runtime=30 -group_reporting -name=file -filename=/mnt/virtiofs/file
>> file: (g=0): rw=randwrite, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=64
>> ...
>> fio-2.13
>> Starting 16 processes
>> Jobs: 16 (f=16): [w(16)] [100.0% done] [0KB/1793MB/0KB /s] [0/1793/0 iops] [eta 00m:00s]
>> file: (groupid=0, jobs=16): err= 0: pid=6328: Tue Aug 6 18:22:17 2019
>> write: io=52775MB, bw=1758.7MB/s, iops=1758, runt= 30009msec
> 
> Nice performance improvement!
> .
> 

