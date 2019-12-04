From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed,  4 Dec 2019 14:08:31 -0500
Message-Id: <20191204190836.31324-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 0/5] [RFC] virtiofsd,
	vhost-user-fs: Add support for notification queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org
Cc: mszeredi@redhat.com

Hi,

Here is V2 of RFC patches for adding a notification queue to
vhost-user-fs device to send notifications from host to guest.
It also has patches to support remote posix locks which make use of this
newly introduced notification queue.

I have taken care of most of the comments from last iteration. Still one
major TODO item is to be able to interrupt/stop blocked thrads for locks
when guest reboots. 

Patches are also available here.

https://github.com/rhvgoyal/qemu/commits/blocking-locks-v2

Associated kernel changes are available here.

https://github.com/rhvgoyal/linux/commits/blocking-locks-v2

Thanks
Vivek

Vivek Goyal (5):
  virtiofsd: Get rid of unused fields in fv_QueueInfo
  virtiofsd: Release file locks using F_UNLCK
  virtiofd: Create a notification queue
  virtiofsd: Specify size of notification buffer using config space
  virtiofsd: Implement blocking posix locks

 contrib/virtiofsd/fuse_i.h                 |   1 +
 contrib/virtiofsd/fuse_kernel.h            |   7 +
 contrib/virtiofsd/fuse_lowlevel.c          |  23 ++-
 contrib/virtiofsd/fuse_lowlevel.h          |  25 +++
 contrib/virtiofsd/fuse_virtio.c            | 208 +++++++++++++++++----
 contrib/virtiofsd/passthrough_ll.c         |  80 ++++++--
 hw/virtio/vhost-user-fs-pci.c              |   2 +-
 hw/virtio/vhost-user-fs.c                  |  63 ++++++-
 include/hw/virtio/vhost-user-fs.h          |   3 +
 include/standard-headers/linux/virtio_fs.h |   5 +
 10 files changed, 354 insertions(+), 63 deletions(-)

-- 
2.20.1

