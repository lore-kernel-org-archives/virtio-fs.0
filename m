References: <cover.1566185612.git.gavin.dg@linux.alibaba.com>
	<09680e84da8a43ee8fa69ed4ec7d1a5a5ffa9130.1566185612.git.gavin.dg@linux.alibaba.com>
	<20190819051443.GM52397@e18g06458.et15sqa>
	<44010515-d5c9-b4dc-fa4f-ba689f27909c@huawei.com>
From: Gang Deng <gavin.dg@linux.alibaba.com>
Message-ID: <94e577c4-06c4-6583-5736-a9d29f56d1ac@linux.alibaba.com>
Date: Tue, 20 Aug 2019 09:24:45 +0800
MIME-Version: 1.0
In-Reply-To: <44010515-d5c9-b4dc-fa4f-ba689f27909c@huawei.com>
Content-Type: text/plain; charset=utf-8
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
To: piaojun <piaojun@huawei.com>, Eryu Guan <eguan@linux.alibaba.com>
Cc: virtio-fs@redhat.com



On 2019/8/19 22:20, piaojun wrote:
> 
> 
> On 2019/8/19 13:14, Eryu Guan wrote:
>> On Mon, Aug 19, 2019 at 11:41:13AM +0800, Gang Deng wrote:
>>> There exist two components: vtrace && vstat. vtrace is embeded in virtiofsd,
>>> it will put raw statistics data into share memory. Then the vstat tool could
>>> parse it and do some post processing works. The performance overhead of
>>> vtrace is very small because it does very simple things.
>>>
>>> For example, if we call open(2)/close(2) frequently in guest, and
>>> randwite a file whose length is greater than the size of dax window.
>>> We'll get the output as below:
>>>
>>> op                        inflt         op/s     svctm/us   %util
>>> FUSE_OPEN(14)                 0      8379.87         3.24   2.71%
>>> FUSE_RELEASE(18)              0      8379.87         1.77   1.48%
>>> FUSE_FLUSH(25)                0      8379.87         2.04   1.71%
>>> FUSE_SETUPMAPPING(48)         1      6393.90        34.72  22.20%
>>> FUSE_REMOVEMAPPING(49)        0      6404.90        37.61  24.09%
>>> TOTAL                         1     37938.39        13.76  52.20%
>>>
>>> The meaning of fields:
>>>
>>> - op
>>>   The type of fuse requests, 'TOTAL' is sum of all.
>>>
>>> - inflt
>>>   The number of the inflight requests, it must be ethier 0 or 1 because
>>>   virtiofsd can only process fuse requests serially.
>>>
>>> - op/s
>>>   The number of fuse requests completed per second.
>>>
>>> - svctm/us
>>>   The average service time (in microseconds) for fuse requests.
>>>
>>> - %util
>>>   Percentage of elapsed time during which virtiofsd was processing the fuse
>>>   requests.
>>>
>>> when virtiofsd is hang, e.g. we support flock in host (just for example,
>>> this has been fxied), we'll get this:
>>>
>>> op                        inflt         op/s     svctm/us   %util
>>> FUSE_SETLKW(33)               1         0.00         0.00 100.00%
>>> TOTAL                         1         0.00         0.00 100.00%
>>>
>>> the utilization is 100% and op/s equals zero, it indicates hang.
>>>
>>> If virtiofsd is idle, then the output looks like this:
>>>
>>> op                        inflt         op/s     svctm/us   %util
>>> TOTAL                         0         0.00         0.00   0.00%
>>>
>>> Signed-off-by: Gang Deng <gavin.dg@linux.alibaba.com>
>>
>> This looks useful to me! Would you like to provide an example command
>> line usage in commit log too? Because I find that it's not obvious how
>> the vtrace/vstat are used.
> 
> Agreed, and I wonder if they could be documented somewhere?
> 
> Jun
> 

Add the document below. It's just a skeleton currently.

vtrace
======

This document explains the usage of vtrace feature. vtrace is used for
performance diagnostics or to assist in performance optimization of virtiofsd.
It works as below:

     +----------------+
     |                |                               human readable
     | virtiofsd      |                                     ^
     |                |                                     |
     |     +----------+                               +-----+-----+
     |     |  vtrace  |-----------+         +-------->|    vstat  |
     +-----+----------+           |         |         +-----------+
                                  |         |
                                  v         |
                              +------------------+
                              |   share memory   |
                              +------------------+

There exist two components: vtrace && vstat. vtrace is embeded in virtiofsd,
it will put raw statistics data into share memory. Then the vstat tool could
parse it directly without communicating with virtiofsd, and do some post
processing works, output human readable format.

What's the difference between vtrace and virtiofsd's debug output? Vtrace was
designed to be used online when we run some real workloads, because the
performance overhead of vtrace is small. It does very simple things, only
calls virtiofs_trace_account_op_begin() && void virtiofs_trace_account_op_end()
in data plane. And we can get more detailed statistics, see it in later section.


Basic Usage
-----------
To view the statistics, run virtiofsd with vtrace enabled, add the '-o trace'
option, e.g.

 $ sudo ./virtiofsd -o vhost_user_socket=$SOCKET_PATH -o source=$DIR -o trace

After qemu was connected and we mounted the filesystem in guest, then we can
run vstat to view the output, command as below:

 $ sudo ./vstat /proc/<virtiofs-pid>/fd/<trace-file> 1

the <trace-file> fd points to the share memory path, it looks like
"/dev/shm/vtrace35117 (deleted)". The output was refreshed every second.

Fist, there is no workload running, the output looks like this:

op                        inflt         op/s     svctm/us   %util
TOTAL                         0         0.00         0.00   0.00%

It means the virtiofsd was idle.

The meaning of fields:

- op
  The type of fuse requests, 'TOTAL' is sum of all.

- inflt
  The number of the inflight requests, it must be ethier 0 or 1 because
  virtiofsd can only process fuse requests serially.

- op/s
  The number of fuse requests completed per second.

- svctm/us
  The average service time (in microseconds) for fuse requests which didn't
  include the time of parsing fuse requests from virtqueue.

- %util
  Percentage of elapsed time during which virtiofsd was processing the fuse
  requests. Note it's different from CPU utilization of virtiofsd.

Now we run some workloads in guest. We call open(2)/close(2) frequently in
guest, it works like this:

      while (true) {
        fd = open("testfile", O_RDONLY);
        close(fd);
      }

And run fio to randwrite a file whose length is greater than the size of dax
window. We'll get the output as below:

op                        inflt         op/s     svctm/us   %util
FUSE_OPEN(14)                 0      8379.87         3.24   2.71%
FUSE_RELEASE(18)              0      8379.87         1.77   1.48%
FUSE_FLUSH(25)                0      8379.87         2.04   1.71%
FUSE_SETUPMAPPING(48)         1      6393.90        34.72  22.20%
FUSE_REMOVEMAPPING(49)        0      6404.90        37.61  24.09%
TOTAL                         1     37938.39        13.76  52.20%

The FUSE_OPEN/RELEASE/FLUSE requests are mainly due to the open(2)/close(2)
syscalls in guest. Guest executed 8379.87 open(2) syscalls every second, each
FUSE_OPEN consumed 3.24us in virtiofsd.

The FUSE_SETUPMAPPING/REMOVEMAPPING are expensive, they consumed ten times
more than FUSE_OPEN. If we observe this in host (no need to login to guest),
it may indicates the size of dax window was not properly set.

When virtiofsd is hang, e.g. we support flock in host (just for example,
this has been fixed), we'll get this:

op                        inflt         op/s     svctm/us   %util
FUSE_SETLKW(33)               1         0.00         0.00 100.00%
TOTAL                         1         0.00         0.00 100.00%

the utilization is 100% and op/s equals zero, it indicates hang.


TODO
----
Vstat was designed to scan /dev/shm directory to get all virtiofs devices.
However it's not supported yet. Because virtiofsd couldn't unlink
the trace file when exited due to the sandboxing, actually we unlink the
trace file when inited. Then vstat can only access the trace file through
the /proc/<virtiofs-pid>/fd/<trace-file> (which needs root privilege)
This should be refactored later if virtiofsd could access /dev/shm
directory, then vstat can run as nobody and be able to scan all devices
like iostat tool.


Thanks,
Gang

