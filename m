From: Vivek Goyal <vgoyal@redhat.com>
Date: Mon,  8 Feb 2021 17:40:22 -0500
Message-Id: <20210208224024.43555-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 0/2] viritofsd: Add support for
	FUSE_HANDLE_KILLPRIV_V2
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com

Hi,

This is V3 of the patches. V2 had been posted here.

https://listman.redhat.com/archives/virtio-fs/2020-November/msg00084.html

These patches add support for FUSE_HANDLE_KILLPRIV_V2. This is basically
a feature file server can opt-in. And with xattr enabled, this improves
write performance many fold. Ran following fio command while virtiofsd is
running with options "-o cache=auto" and "-o xattr".

fio libaio random writes
------------------------
fio --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=/mnt/virtiofs/random_read_write.fio --bs=4k --iodepth=64 --size=4G --readwrite=randwrite

Without patches:
 WRITE: bw=84.6MiB/s (88.7MB/s), 84.6MiB/s-84.6MiB/s (88.7MB/s-88.7MB/s), io=4096MiB (4295MB), run=48436-48436msec

With patches:
  WRITE: bw=273MiB/s (286MB/s), 273MiB/s-273MiB/s (286MB/s-286MB/s), io=4096MiB (4295MB), run=15003-15003msec

So with these patches, for this particular workload, there is roughly
more than 200% improvement.

fio psync random writes
-----------------------
Even, single queue depth writes with ioengine=psync, how significant
improvement. Performance jumps from roughly 35MiB/s to 70MiB/s.

fio --ioengine=psync --name=test --filename=/mnt/virtiofs/random_read_write.fio --bs=4k --size=4G --readwrite=randwrite

Without patches:
  WRITE: bw=35.0MiB/s (36.7MB/s), 35.0MiB/s-35.0MiB/s (36.7MB/s-36.7MB/s), io=4096MiB (4295MB), run=116932-116932msec

With patches:
 WRITE: bw=69.9MiB/s (73.3MB/s), 69.9MiB/s-69.9MiB/s (73.3MB/s-73.3MB/s), io=4096MiB (4295MB), run=58596-58596msec

In V3 I rebased these patches to latest upstream. There were few
conflicts due to recent security fixes from Stefan. Resolved these
conflicts.

Thanks
Vivek

Vivek Goyal (2):
  virtiofsd: Save error code early at the failure callsite
  viriofsd: Add support for FUSE_HANDLE_KILLPRIV_V2

 tools/virtiofsd/fuse_common.h    | 15 ++++++
 tools/virtiofsd/fuse_lowlevel.c  | 11 +++-
 tools/virtiofsd/fuse_lowlevel.h  |  1 +
 tools/virtiofsd/passthrough_ll.c | 93 ++++++++++++++++++++++++++++----
 4 files changed, 108 insertions(+), 12 deletions(-)

-- 
2.25.4

