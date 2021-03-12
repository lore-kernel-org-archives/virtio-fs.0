From: Greg Kurz <groug@kaod.org>
Date: Fri, 12 Mar 2021 10:22:05 +0100
Message-Id: <20210312092212.782255-1-groug@kaod.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 0/7] virtiofsd: Avoid potential deadlocks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

A deadlock condition potentially exists if a vhost-user process needs
to request something to QEMU on the slave channel while processing a
vhost-user message.

This doesn't seem to affect any vhost-user implementation so far, but
this is currently biting the upcoming enablement of DAX with virtio-fs.
The issue is being observed when the guest does an emergency reboot while
a mapping still exits in the DAX window, which is very easy to get with
a busy enough workload (e.g. as simulated by blogbench [1]) :

- QEMU sends VHOST_USER_GET_VRING_BASE to virtiofsd.

- In order to complete the request, virtiofsd then asks QEMU to remove
  the mapping on the slave channel.

All these dialogs are synchronous, hence the deadlock.

Another deadlock condition exists in the virtiofsd code itself, related
to the use of the vu_dispatch rwlock.

This series supercedes Vivek's previous tentative [1] to fix the deadlocks.
Basically, instead of introducing new vhost-user protocol message to
specifically shutdown the slave channel, this series introduces a nested
event loop in vhost_user_read() as suggested by Stefan Hajnoczi. This
allows to monitor and service requests on the slave channel while
waiting for virtiofsd to answer to a vhost-user request.

This was tested with the latest DAX patchset posted to the virtio-fs
list [2], rebased on top of the present series [3]. Testing scenario
is:
1) start VM with DAX capable vhost-user-fs device
2) mount -o dax in the guest
3) run Blogbench [4] in virtiofs mount
4) wait 10s, which is enough to have active mappings
5) echo b > /proc/sysrq-trigger
6) wait for the guest to reboot and start over from step 2

Without this series, only a couple of reboots ( < 5) are needed to
hit a deadlock. With this series applied, an overnight test could
reboot the guest 1500+ times without any issues.

[1] https://listman.redhat.com/archives/virtio-fs/2021-January/msg00073.html

[2] https://listman.redhat.com/archives/virtio-fs/2021-February/msg00058.html

[3] Tree with this series + DAX available at:

    https://gitlab.com/gkurz/qemu/-/commits/virtio-fs-dax-no-deadlock

[4] https://github.com/jedisct1/Blogbench

Changes since v2:
 - added some preliminary fixes and cleanups for the slave channel code
 - re-factored some code and addressed comments (see individual patches)
 - more testing

Greg Kurz (7):
  vhost-user: Drop misleading EAGAIN checks in slave_read()
  vhost-user: Fix double-close on slave_read() error path
  vhost-user: Factor out duplicated slave_fd teardown code
  vhost-user: Convert slave channel to QIOChannelSocket
  vhost-user: Introduce nested event loop in vhost_user_read()
  vhost-user: Monitor slave channel in vhost_user_read()
  virtiofsd: Release vu_dispatch_lock when stopping queue

 hw/virtio/vhost-user.c        | 217 +++++++++++++++++++++-------------
 tools/virtiofsd/fuse_virtio.c |   6 +
 2 files changed, 144 insertions(+), 79 deletions(-)

-- 
2.26.2


