From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 15 Nov 2019 15:55:39 -0500
Message-Id: <20191115205543.1816-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/4] [RFC] virtiofsd,
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
Cc: miklos@szeredi.hu, vgoyal@redhat.com

Hi,

Here are RFC patches for adding a notification queue to virtio-fs to
send notifications from host to guest. It also has patches to support
remote posix locks which make use of this newly introduced notification
queue.

These patches apply on top of following.

https://gitlab.com/virtio-fs/qemu/tree/virtio-fs-dev

These change require changes in spec also. I have yet to create spec
changes and that's why this is still an RFC patch series.

Any feedback is appreciated.

Thanks
Vivek

Vivek Goyal (4):
  virtiofsd: Release file locks using F_UNLCK
  virtiofd: Create a notification queue
  virtiofsd: Specify size of notification buffer using config space
  virtiofsd: Implement blocking posix locks

 contrib/virtiofsd/fuse_i.h                 |   1 +
 contrib/virtiofsd/fuse_kernel.h            |   7 +
 contrib/virtiofsd/fuse_lowlevel.c          |  23 ++-
 contrib/virtiofsd/fuse_lowlevel.h          |  25 +++
 contrib/virtiofsd/fuse_virtio.c            | 226 +++++++++++++++++++--
 contrib/virtiofsd/passthrough_ll.c         |  79 +++++--
 hw/virtio/vhost-user-fs-pci.c              |   2 +-
 hw/virtio/vhost-user-fs.c                  |  63 +++++-
 include/hw/virtio/vhost-user-fs.h          |   3 +
 include/standard-headers/linux/virtio_fs.h |   5 +
 10 files changed, 386 insertions(+), 48 deletions(-)

-- 
2.20.1

