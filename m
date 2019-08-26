From: piaojun <piaojun@huawei.com>
References: <5D4D0D06.1090602@huawei.com>
	<20190821153802.GB9095@stefanha-x1.localdomain>
Message-ID: <5D633104.6030000@huawei.com>
Date: Mon, 26 Aug 2019 09:08:20 +0800
MIME-Version: 1.0
In-Reply-To: <20190821153802.GB9095@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH][RFC] Support multiqueue mode by setting cpu
 affinity
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



On 2019/8/21 23:38, Stefan Hajnoczi wrote:
> On Fri, Aug 09, 2019 at 02:04:54PM +0800, piaojun wrote:
>> Set cpu affinity for each queue in multiqueue mode to improve the iops
>> performance.
>>
>> >From my test, the iops is increased by adding multiqueues as below,
>> but it has not achieved my expect yet due to some reason. So I'm
>> considering if we could drop some locks when operating vq as it is
>> binded to one vCPU. I'm very glad to have a discuss with other
>> developers.
>>
>> Further more, I modified virtiofsd to support multiqueue which just for
>> testing.
>>
>> Test Environment:
>> Guest configuration:
>> 8 vCPU
>> 8GB RAM
>> Linux 5.1 (vivek-aug-06-2019)
>>
>> Host configuration:
>> Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz (8 cores x 4 threads)
>> 32GB RAM
>> Linux 3.10.0
>> EXT4 + 4G Ramdisk
>>
>> ---
>> Single-queue:
>> # fio -direct=1 -time_based -iodepth=128 -rw=randwrite -ioengine=libaio -bs=4k -size=1G -numjob=8 -runtime=30 -group_reporting -name=file -filename=/mnt/virtiofs/file
>> file: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
>> ...
>> fio-2.13
>> Starting 8 processes
>> Jobs: 8 (f=8): [w(8)] [100.0% done] [0KB/316.5MB/0KB /s] [0/81.2K/0 iops] [eta 00m:00s]
>> file: (groupid=0, jobs=8): err= 0: pid=5808: Fri Aug  9 20:35:22 2019
>>   write: io=9499.9MB, bw=324251KB/s, iops=81062, runt= 30001msec
>>
>> Multi-queues:
>> # fio -direct=1 -time_based -iodepth=128 -rw=randwrite -ioengine=libaio -bs=4k -size=1G -numjob=8 -runtime=30 -group_reporting -name=file -filename=/mnt/virtiofs/file
>> file: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
>> ...
>> fio-2.13
>> Starting 8 processes
>> Jobs: 8 (f=8): [w(8)] [100.0% done] [0KB/444.6MB/0KB /s] [0/114K/0 iops] [eta 00m:00s]
>> file: (groupid=0, jobs=8): err= 0: pid=5704: Fri Aug  9 20:38:47 2019
>>   write: io=12967MB, bw=442582KB/s, iops=110645, runt= 30001msec
>> ---
> 
> How does the same fio command-line perform on the host when bound to 8
> CPUs?

fio has great performance on host side, so the bottleneck should be at virtiofsd.

---
Run status group 0 (all jobs):
  WRITE: bw=12.7GiB/s (13.6GB/s), 12.7GiB/s-12.7GiB/s (13.6GB/s-13.6GB/s), io=381GiB (409GB), run=30001-30001msec

> 
> What about the virtiofsd changes?  Did you implement host CPU affinity
> for the virtqueue processing threads and their workqueues?
> 
> I wonder if numbers are better if you use 8 files instead of 1 file.
> 
I implement host CPU affinity and re-design the testcase with 8 files,
the result looks better:

---
[global]
runtime=30
time_based
group_reporting
direct=1
bs=1M
size=1G
ioengine=libaio
rw=write
numjobs=8
iodepth=128
thread=1

[file1]
filename=/mnt/virtiofs/file1
numjobs=1
[file2]
filename=/mnt/virtiofs/file2
numjobs=1
[file3]
filename=/mnt/virtiofs/file3
numjobs=1
[file4]
filename=/mnt/virtiofs/file4
numjobs=1
[file5]
filename=/mnt/virtiofs/file5
numjobs=1
[file6]
filename=/mnt/virtiofs/file6
numjobs=1
[file7]
filename=/mnt/virtiofs/file7
numjobs=1
[file8]
filename=/mnt/virtiofs/file8
numjobs=1

Single-Queue:
Jobs: 8 (f=8): [W(8)] [100.0% done] [0KB/1594MB/0KB /s] [0/1594/0 iops] [eta 00m:00s]
file1: (groupid=0, jobs=8): err= 0: pid=6379: Mon Aug 26 16:24:10 2019
  write: io=46676MB, bw=1555.6MB/s, iops=1555, runt= 30007msec

Multi-Queues(8):
Jobs: 8 (f=8): [W(8)] [100.0% done] [0KB/4064MB/0KB /s] [0/4064/0 iops] [eta 00m:00s]
file1: (groupid=0, jobs=8): err= 0: pid=5785: Mon Aug 26 16:26:46 2019
  write: io=115421MB, bw=3847.2MB/s, iops=3847, runt= 30002msec

I write a draft patch for virtiofsd, but the sandbox make it hard to
set affinity for each vq, as _SC_NPROCESSORS_ONLN always equals 1. So I
just delete the related code for testing. Maybe we could create a
thread pool before setup_sandbox() or some effective way. I'm glad to
help finding out the solution.

Thanks,
Jun

---
 contrib/virtiofsd/fuse_virtio.c    | 23 ++++++++++++++++++-----
 contrib/virtiofsd/passthrough_ll.c |  4 ++--
 contrib/virtiofsd/seccomp.c        |  2 ++
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
index bd50723..efc4ba7 100644
--- a/contrib/virtiofsd/fuse_virtio.c
+++ b/contrib/virtiofsd/fuse_virtio.c
@@ -748,8 +748,11 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
 {
         struct fv_VuDev *vud = container_of(dev, struct fv_VuDev, dev);
         struct fv_QueueInfo *ourqi;
+        cpu_set_t mask;
+        int num = sysconf(_SC_NPROCESSORS_ONLN);

-        fuse_info("%s: qidx=%d started=%d\n", __func__, qidx, started);
+        fuse_info("%s: nqueues %lu, qidx=%d, started=%d, cpunum %d\n",
+                  __func__, vud->nqueues, qidx, started, num);
         assert(qidx>=0);

         /*
@@ -759,9 +762,9 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
          * races yet.
          */
         if (qidx > 1) {
-                fuse_err("%s: multiple request queues not yet implemented, please only configure 1 request queue\n",
-                         __func__);
-                exit(EXIT_FAILURE);
+                //fuse_err("%s: multiple request queues not yet implemented, please only configure 1 request queue\n",
+                //         __func__);
+                //exit(EXIT_FAILURE);
         }

         if (started) {
@@ -798,6 +801,16 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
                                  __func__, qidx);
                         assert(0);
                 }
+		if (qidx > 0) {
+			fuse_info("%s: thread[%ld], set CPU[%d] affinity for vq[%d]\n", __func__, ourqi->thread, qidx, qidx);
+			/* set CPU affinity for vqs */
+			CPU_ZERO(&mask);
+			CPU_SET(qidx, &mask);
+			if (pthread_setaffinity_np(ourqi->thread, sizeof(mask), &mask) < 0) {
+				fuse_err("%s: Failed to setaffinity for vq[%d]\n", __func__, qidx);
+                        	assert(0);
+			}
+		}
         } else {
                 int ret;
                 assert(qidx < vud->nqueues);
@@ -962,7 +975,7 @@ int virtio_session_mount(struct fuse_session *se)
         se->virtio_dev = calloc(sizeof(struct fv_VuDev), 1);
         se->virtio_dev->se = se;
         pthread_rwlock_init(&se->virtio_dev->vu_dispatch_rwlock, NULL);
-        vu_init(&se->virtio_dev->dev, 2, se->vu_socketfd,
+        vu_init(&se->virtio_dev->dev, 16, se->vu_socketfd,
                 fv_panic,
                 fv_set_watch, fv_remove_watch,
                 &fv_iface);
diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index ca11764..7eabe73 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -2773,7 +2773,7 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
 	int fd, res;
 	struct stat stat;

-	fd = open("/", O_PATH);
+	fd = open(lo->source, O_PATH);
 	if (fd == -1)
 		err(1, "open(%s, O_PATH)", lo->source);

@@ -2990,7 +2990,7 @@ int main(int argc, char *argv[])
 	/* Must be after daemonize to get the right /proc/self/fd */
 	setup_proc_self_fd(&lo);

-	setup_sandbox(&lo, opts.syslog);
+	//setup_sandbox(&lo, opts.syslog);

 	setup_root(&lo, &lo.root);

diff --git a/contrib/virtiofsd/seccomp.c b/contrib/virtiofsd/seccomp.c
index 3b92c6e..e9f0737 100644
--- a/contrib/virtiofsd/seccomp.c
+++ b/contrib/virtiofsd/seccomp.c
@@ -82,6 +82,8 @@ static const int syscall_whitelist[] = {
 	SCMP_SYS(writev),
 	SCMP_SYS(capget),
 	SCMP_SYS(capset),
+	SCMP_SYS(sched_setaffinity),
+	SCMP_SYS(sched_getaffinity),
 };

 /* Syscalls used when --syslog is enabled */
-- 

