From: Ioannis Angelakopoulos <iangelak@redhat.com>
Date: Wed, 16 Jun 2021 15:39:15 -0400
Message-Id: <20210616193921.608720-1-iangelak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/6] virtiofsd: Support for remote blocking
	posix locks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com

Hi,

Here is the implementation for the remote blocking posix locks in
virtiofsd.

This patch series also addresses the issues that were not fixed in:
[Virtio-fs] [PATCH v2 0/5] [RFC] virtiofsd, vhost-user-fs: Add support
for notification queue
https://patchwork.kernel.org/project/qemu-devel/cover/20191204190836.31324-1-vgoyal@redhat.com/

The main issue was that the guest could not reboot when a thread of the
virtiofsd process was blocked, waiting to acquire a lock. The
introduction of a custom threadpool dedicated to servicing only locking
requests addresses the aforementioned issue.

Description:

Through the addition of a notification queue it is possible for a
guest now to block waiting for a remote lock held by another guest.

When the lock is available virtiofsd sends a notification to the guest
that unblocks the process/thread waiting for the lock in order to
acquire it.

This implementation also handles cases where the guest that is
waiting for a lock, hard-reboots through SYSRQ
(echo "b" > /proc/sysrq-trigger). Specifically, a custom threadpool
(posix theads) in virtiofsd is used to service the locking requests.
If one of the threads is blocked waiting for a lock and the guest
hard-reboots then virtiofsd sends a signal to the blocked thread waking 
it up so that it exits and then virtiofsd cleans up its state and
re-initializes.

Finally, the custom threadpool enables virtiofsd to concurrently service
other requests that are non-blocking or block for a limited time while
the custom threadpool services locking requests that might block. This is
especially useful in the case where the GThreadPool is not utilized.

Thanks,
Ioannis

Ioannis Angelakopoulos (2):
  virtiofsd: Thread state cleanup when blocking posix locks are used
  virtiofsd: Custom threadpool for remote blocking posix locks requests

Vivek Goyal (4):
  virtiofsd: Release file locks using F_UNLCK
  virtiofsd: Create a notification queue
  virtiofsd: Specify size of notification buffer using config space
  virtiofsd: Implement blocking posix locks

 hw/virtio/vhost-user-fs.c                  |  57 +-
 include/hw/virtio/vhost-user-fs.h          |   4 +-
 include/standard-headers/linux/fuse.h      |   8 +
 include/standard-headers/linux/virtio_fs.h |   5 +
 tools/virtiofsd/fuse_i.h                   |   2 +
 tools/virtiofsd/fuse_lowlevel.c            |  40 +-
 tools/virtiofsd/fuse_lowlevel.h            |  26 +
 tools/virtiofsd/fuse_virtio.c              | 626 +++++++++++++++++++--
 tools/virtiofsd/passthrough_ll.c           |  90 ++-
 9 files changed, 804 insertions(+), 54 deletions(-)

-- 
2.27.0

