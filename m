References: <5D4CC344.7030706@huawei.com>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D53AFF8.9030206@huawei.com>
Date: Wed, 14 Aug 2019 14:53:44 +0800
MIME-Version: 1.0
In-Reply-To: <5D4CC344.7030706@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v4 0/2] virtiofsd: Improve io bandwidth by
 replacing pwrite with pwritev
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Ping, any comments on this patch?

On 2019/8/9 8:50, piaojun wrote:
>>From my test, write bandwidth will be improved greatly by replacing
> pwrite with pwritev, and the test result as below:
> 
> ---
> pwrite:
> # fio -direct=1 -time_based -iodepth=64 -rw=randwrite -ioengine=libaio -bs=1M -size=1G -numjob=16 -runtime=30 -group_reporting -name=file -filename=/mnt/virtiofs/file
> file: (g=0): rw=randwrite, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=64
> ...
> fio-2.13
> Starting 16 processes
> Jobs: 16 (f=16): [w(16)] [100.0% done] [0KB/886.0MB/0KB /s] [0/886/0 iops] [eta 00m:00s]
> file: (groupid=0, jobs=16): err= 0: pid=5799: Tue Aug 6 18:48:26 2019
> write: io=26881MB, bw=916988KB/s, iops=895, runt= 30018msec
> 
> pwritev:
> # fio -direct=1 -time_based -iodepth=64 -rw=randwrite -ioengine=libaio -bs=1M -size=1G -numjob=16 -runtime=30 -group_reporting -name=file -filename=/mnt/virtiofs/file
> file: (g=0): rw=randwrite, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=64
> ...
> fio-2.13
> Starting 16 processes
> Jobs: 16 (f=16): [w(16)] [100.0% done] [0KB/1793MB/0KB /s] [0/1793/0 iops] [eta 00m:00s]
> file: (groupid=0, jobs=16): err= 0: pid=6328: Tue Aug 6 18:22:17 2019
> write: io=52775MB, bw=1758.7MB/s, iops=1758, runt= 30009msec
> ---
> 
> This patch introduces writev and pwritev for lo_write_buf(). I tried my
> best not doing harm to the origin code construct, and there will be
> some *useless* branches in fuse_buf_copy_one() which are hard to judge
> if they will be useful in the future. So I just leave them alone
> safely. If the cleanup work is necessary, please let me know.
> 
> v2
>   - Split into two patches
>   - Add the lost flags support, such as FUSE_BUF_PHYS_ADDR
> 
> v3
>   - use git send-email to make the patch set in one thread
>   - move fuse_buf_writev() into fuse_buf_copy()
>   - use writev for the src buffers when they're alread already mapped by the daemon process
>   - use calloc to replace malloc
>   - set res 0 if writev() returns 0
> 
> v4
>   - iterate from in_buf->buf[0] rather than buf[1]
>   - optimize the code to make it more elegant
> 
> Jun Piao (2):
>   add definition of fuse_buf_writev().
>   use fuse_buf_writev to replace fuse_buf_write for better performance
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> Suggested-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  buffer.c      |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fuse_common.h |   14 ++++++++++++++
>  seccomp.c     |    2 ++
>  3 files changed, 64 insertions(+)
> --
> 

