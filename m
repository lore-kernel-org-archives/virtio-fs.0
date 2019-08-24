References: <5abd7616-5351-761c-0c14-21d511251006@huawei.com>
	<20190820091650.GE9855@stefanha-x1.localdomain>
	<CAJfpegs8fSLoUaWKhC1543Hoy9821vq8=nYZy-pw1+95+Yv4gQ@mail.gmail.com>
	<20190821160551.GD9095@stefanha-x1.localdomain>
	<954b5f8a-4007-f29c-f38e-dd5585879541@huawei.com>
	<CAJfpegtBYLJLWM8GJ1h66PMf2J9o38FG6udcd2hmamEEQddf5w@mail.gmail.com>
	<0e8090c7-0c7c-bcbe-af75-33054d3a3efb@huawei.com>
	<CAJfpegurYLAApon5Ai6Q33vEy+GPxtOTUwDCCbJ2JAbg4csDSg@mail.gmail.com>
	<a19866be-3693-648e-ee6c-8d302c830834@huawei.com>
	<CAOssrKd7bKts2tCAZaXLJt+BVoQtqWoJV6HfT76-qxg7W4g9PQ@mail.gmail.com>
	<CAJfpegt574w1Rzge-59-1dRVtfPgCrFuCpJ5DjLQwSWg+G3ArA@mail.gmail.com>
From: wangyan <wangyan122@huawei.com>
Message-ID: <fd7a2791-d95c-3bd9-e387-b8778a9eca83@huawei.com>
Date: Sat, 24 Aug 2019 16:44:09 +0800
MIME-Version: 1.0
In-Reply-To: <CAJfpegt574w1Rzge-59-1dRVtfPgCrFuCpJ5DjLQwSWg+G3ArA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [QUESTION] A performance problem for buffer write
 compared with 9p
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>, Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>

On 2019/8/22 22:02, Miklos Szeredi wrote:
> c int virtio_fs_fill_super(struct s
>  	if (err < 0)
>  		goto err_free_init_req;
>
> +	/* No strict accounting needed for virtio-fs */
> +	sb->s_bdi->capabilities = BDI_CAP_NO_ACCT_WB;
> +	bdi_set_max_ratio(sb->s_bdi, 100);
> +

Your patch works to some degree. The guest's memory is 8G, and the dirty
configure is:
	/proc/sys/vm/dirty_background_ratio	10
	/proc/sys/vm/dirty_ratio 30

	Test model：
		fio -filename=/mnt/virtiofs/test -rw=write -bs=4K -size=1G -iodepth=1 \
			-ioengine=psync -numjobs=1 -group_reporting -name=4K -time_based 
-runtime=30
	
Fio test cmd for "-size=1G":
	Test model：
		fio -filename=/mnt/virtiofs/test -rw=write -bs=4K/1M -size=1G -iodepth=1 \
			-ioengine=psync -numjobs=1 -group_reporting -name=4K/1M -time_based 
-runtime=30

	1. Latency
		virtiofs: avg-lat is 10.55 usec, bigger than before(6.64 usec).
		4K: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
		fio-2.13
		Starting 1 process
		Jobs: 1 (f=1): [W(1)] [100.0% done] [0KB/305.6MB/0KB /s] [0/78.3K/0 
iops] [eta 00m:00s]
		4K: (groupid=0, jobs=1): err= 0: pid=5970: Sat Aug 24 11:45:58 2019
		  write: io=9016.5MB, bw=307737KB/s, iops=76934, runt= 30001msec
			clat (usec): min=2, max=2083, avg= 9.85, stdev= 8.15
			 lat (usec): min=3, max=2084, avg=10.55, stdev= 8.30


	2. Bandwidth
		virtiofs: bandwidth is 302200KB/s, lower than before(691894KB/s).
		1M: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=psync, iodepth=1
		fio-2.13
		Starting 1 process
		Jobs: 1 (f=1): [f(1)] [100.0% done] [0KB/26865KB/0KB /s] [0/26/0 iops] 
[eta 00m:00s]
		1M: (groupid=0, jobs=1): err= 0: pid=5860: Sat Aug 24 11:38:41 2019
		  write: io=8855.0MB, bw=302200KB/s, iops=295, runt= 30005msec
			clat (usec): min=307, max=7423, avg=3318.96, stdev=1373.63
			 lat (usec): min=351, max=7474, avg=3372.53, stdev=1374.60


Fio test cmd for "-size=700M":
	Test model：
		fio -filename=/mnt/virtiofs/test -rw=write -bs=4K/1M -size=700M 
-iodepth=1 \
			-ioengine=psync -numjobs=1 -group_reporting -name=4K/1M -time_based 
-runtime=30

	1. Latency
		virtiofs: avg-lat is 3.89 usec, lower than before(6.64 usec).
		4K: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
		fio-2.13
		Starting 1 process
		Jobs: 1 (f=1): [W(1)] [100.0% done] [0KB/707.6MB/0KB /s] [0/181K/0 
iops] [eta 00m:00s]
		4K: (groupid=0, jobs=1): err= 0: pid=6528: Sat Aug 24 15:10:21 2019
		  write: io=19667MB, bw=671275KB/s, iops=167818, runt= 30001msec
			clat (usec): min=2, max=957, avg= 3.28, stdev= 3.31
			 lat (usec): min=3, max=958, avg= 3.89, stdev= 3.37

	2. Bandwidth
		virtiofs: bandwidth is 2436.3MB/s, much bigger than before(691894KB/s).
		1M: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=psync, iodepth=1
		fio-2.13
		Starting 1 process
		Jobs: 1 (f=1): [W(1)] [100.0% done] [0KB/2642MB/0KB /s] [0/2642/0 
iops] [eta 00m:00s]
		1M: (groupid=0, jobs=1): err= 0: pid=6510: Sat Aug 24 15:07:55 2019
		  write: io=73089MB, bw=2436.3MB/s, iops=2436, runt= 30001msec
			clat (usec): min=306, max=5107, avg=355.21, stdev=301.86
			 lat (usec): min=349, max=5155, avg=405.99, stdev=302.06

According to the result, for "-size=1G", it maybe exceed the dirty pages'
upper limit, and it frequently triggered pdflush for write-back. And for
"-size=700M", it maybe didn't exceed the dirty pages' upper limit, so no
extra pdflush was triggered.

But for 9p using "-size=1G", the latency 3.94 usec, and the bandwidth is
2305.5MB/s. It is better than virtiofs using "-size=1G". It seems that
it is not affected by the dirty pages' upper limit.

Thanks,
Yan Wang

