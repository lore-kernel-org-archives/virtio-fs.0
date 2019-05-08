Date: Wed, 8 May 2019 11:27:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190508152704.GC16971@redhat.com>
References: <1557208691-43817-1-git-send-email-bo.liu@linux.alibaba.com>
	<1557208691-43817-3-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557208691-43817-3-git-send-email-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH 2/2] virtiofs: add dmap flags to
 differentiate write mapping from read mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com

On Tue, May 07, 2019 at 01:58:11PM +0800, Liu Bo wrote:
> There're 2 problems in dax rw path which were found by [1][2],
> 
> a) setupmapping always sends a RW mapping message to virtiofs daemon side
> no matter it's doing reads or writes, the end result is that guest reads
> on a mapping will cause a write page fault on host, which is unnecessary.
> 
> b) After a successful setupmapping, it doesn't guarantee the following
> writes can land on host, e.g. page fault on host may fail because of
> ENOSPC.
> 
> This is trying to solve the problems by
> a) marking a dmap as RO or RW to indicate it's being used for reads or
>    writes,
> b) setting up a RO dmap for reads
> c) setting up a RW dmap for writes
> d) using an existing dmap for reads if it's availalbe in the interval tree
> e) converting an existing dmap from RO to RW for writes if it's available
>    in the interval tree
> 
> The downside of the above approach is write amplification.

Another downside of using fallocate() is performance overhead. I wrote
a problem to do small 16K file extending writes and measure total time
with and without fallocate. Fallocate version seems to be much slower.

With fallocate()
===============
# ./file-extending-writes /mnt/virtio-fs/foo.txt
16384 extending writes took 14 secs and 647210 us
16384 extending writes took 11 secs and 571941 us
16384 extending writes took 11 secs and 981329 us

With dax + direct write (FUSE_WRITE)
==============================
# ./file-extending-writes /mnt/virtio-fs/foo.txt
16384 extending writes took 2 secs and 477642 us
16384 extending writes took 2 secs and 352413 us
16384 extending writes took 2 secs and 347223 us

I ran your test script as well and that does not show much difference.
I think part of the problem is that every write launches new xfs_io
process. So overhead of launching process, opening fd again hides the
fallocate overhead.

Here is my C program.

===========================================================
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/time.h>

void drop_caches(void)
{
	system("sync");
	system("echo 3 > /proc/sys/vm/drop_caches");
}

void run_test(int fd)
{
	int nr_writes = 16 * 1024;
	struct timeval tv_start, tv_end, tv_elapsed;
	char *buf = "Hello";
	int buf_len = strlen(buf);
	ssize_t written = 0;
	int i;

	drop_caches();

	/* Extend file in a loop */		
	gettimeofday(&tv_start, NULL);
	for (i = 0; i < nr_writes; i++) {
		written += write(fd, buf, buf_len);
		if (written == -1) {
			fprintf(stderr, "Failed to write %d bytes:%s,"
				" errorno=%d\n", strlen(buf), strerror(errno),
				errno);
			exit(1);
		}
	}
	gettimeofday(&tv_end, NULL);
	timersub(&tv_end, &tv_start, &tv_elapsed);	
	printf("%d extending writes took %d secs and %d us\n", nr_writes, tv_elapsed.tv_sec, tv_elapsed.tv_usec);
}

int main(int argc, char *argv[])
{
	int fd, flags = 0;
	mode_t mode = 0;
	int i, nr_runs = 3;

	if (argc != 2) {
		printf("Usage:%s <file-to-open>\n", argv[0]);
		exit(1);
	}

	fd = open(argv[1], O_RDWR | O_CREAT | O_APPEND | O_TRUNC);
	if (fd == -1) {
		fprintf(stderr, "Failed to open file %s:%s, errorno=%d\n",
			argv[0], strerror(errno), errno);
		exit(1);
	}

	for(i = 0; i < nr_runs; i++)
		run_test(fd);
	close(fd);
}

==========================================================================

