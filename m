References: <cover.1566185612.git.gavin.dg@linux.alibaba.com>
	<20190820092816.GE2867@work-vm>
From: Gang Deng <gavin.dg@linux.alibaba.com>
Message-ID: <33fd81b3-cad5-d3a9-5634-4367bf75a4b8@linux.alibaba.com>
Date: Wed, 21 Aug 2019 09:49:53 +0800
MIME-Version: 1.0
In-Reply-To: <20190820092816.GE2867@work-vm>
Content-Type: text/plain; charset=utf-8
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
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com



On 2019/8/20 17:28, Dr. David Alan Gilbert wrote:
> * Gang Deng (gavin.dg@linux.alibaba.com) wrote:
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
>> TODO:
>>  Vstat was designed to scan VIRTIOFS_TRACE_DIR directory to get all virtiofs
>>  devices. However it's not supported yet. Because virtiofsd couldn't unlink
>>  the trace file when exited due to the sandboxing, actually we unlink the
>>  trace file when inited. Then vstat can only access the trace file through
>>  the /proc/<virtiofs-pid>/fd/<trace-file> (which needs root privilege)
>>  This should be refactored later if virtiofsd could access /dev/shm
>>  directory, then vstat can run as nobody and be able to scan all devices
>>  like iostat tool.
> 
> This looks nice - thanks!; some questions:
> 
>   a) Would it be easier to pass -o trace=/a/path  to let the caller say
> where the shared file should be?  Then the caller can do the cleanup 
> and we don't need to worry about using /proc/.../fd
> 
>   b) Then perhaps we can also simplify the code for finding trace
> files; If vstat was a lot simpler for just displaying one trace file
> then I think the simplicty would be worth it.
> 

Yes, this will make vstat simple. I'll try this in next version.

>   c) You use a rdtsc; is using clock_gettime(CLOCK_REALTIME) really much
> worse?   rdtsc is very specific.
> 

I write a simple test code to measure the cost of rdtsc && clock_gettime(2),
run it on my machine which is Broadwell microarch, freq = 2.5GHZ:

seccomp     rdtsc      clock_gettime(vDSO)  clock_gettime(kernel)
 N         10.28ns       31.36ns               76.43ns
 Y         10.19ns       31.33ns               253.22ns

I think it's acceptable if clock_gettime is implemented in user space.
The last case when vDSO has to invoke the true system call is bad, it'll be
affected by seccomp. However, I think it's rare. And CLOCK_MONOTONIC_RAW may
be more suitable, but it's still linux-specific. I'll try CLOCK_REALTIME
firstly.

Thanks,
Gang

> Dave
> 
>> Gang Deng (2):
>>   virtiofsd: add stat tools
>>   virtiofsd: support vstat&&vtrace
>>
>>  Makefile                           |   3 +
>>  Makefile.objs                      |   1 +
>>  contrib/virtiofsd/Makefile.objs    |   5 +-
>>  contrib/virtiofsd/fuse_i.h         |   1 +
>>  contrib/virtiofsd/fuse_lowlevel.c  |  11 +
>>  contrib/virtiofsd/fuse_lowlevel.h  |   1 +
>>  contrib/virtiofsd/helper.c         |   4 +-
>>  contrib/virtiofsd/passthrough_ll.c |   7 +
>>  contrib/virtiofsd/vstat.c          | 680 +++++++++++++++++++++++++++++
>>  contrib/virtiofsd/vtrace.c         |  95 ++++
>>  contrib/virtiofsd/vtrace.h         |  53 +++
>>  11 files changed, 859 insertions(+), 2 deletions(-)
>>  create mode 100644 contrib/virtiofsd/vstat.c
>>  create mode 100644 contrib/virtiofsd/vtrace.c
>>  create mode 100644 contrib/virtiofsd/vtrace.h
>>
>> -- 
>> 2.20.1.7.g153144c
>>
>> _______________________________________________
>> Virtio-fs mailing list
>> Virtio-fs@redhat.com
>> https://www.redhat.com/mailman/listinfo/virtio-fs
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 

