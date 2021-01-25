From: Vivek Goyal <vgoyal@redhat.com>
Date: Mon, 25 Jan 2021 13:01:09 -0500
Message-Id: <20210125180115.22936-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH 0/6] vhost-user: Shutdown/Flush slave
	channel properly
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: marcandre.lureau@redhat.com, vgoyal@redhat.com, mst@redhat.com

Hi,

We are working on DAX support in virtiofs and have some patches out of
the tree hosted here.

https://gitlab.com/virtio-fs/qemu/-/commits/virtio-fs-dev

These patches have not been proposed for merge yet, becasue David
Gilbert noticed that we can run into a deadlock during an emergency
reboot of guest kernel. (echo b > /proc/sysrq-trigger).

I have provided details of deadlock in 4th path of the series with
subject "qemu, vhost-user: Extend protocol to start/stop/flush slave
channel".

Basic problem seems to be that we don't have a proper mechanism to
shutdown slave channel when vhost-user device is stopping. This means
there might be pending messages in slave channel and slave is blocked
and waiting for response.

This is an RFC patch series to enhance vhost-user protocol to 
properly shutdown/flush slave channel and avoid the deadlock. Though
we faced the issue in the context of virtiofs, any vhost-user
device using slave channel can potentially run into issues and
can benefit from these patches.

Any feedback is welcome. Currently patches are based on out of
tree code but after I get some feedback, I can only take pieces
which are relevant to upstream and post separately.

Thanks
Vivek

Vivek Goyal (6):
  virtiofsd: Drop ->vu_dispatch_rwlock while waiting for thread to exit
  libvhost-user: Use slave_mutex in all slave messages
  vhost-user: Return error code from slave_read()
  qemu, vhost-user: Extend protocol to start/stop/flush slave channel
  libvhost-user: Add support to start/stop/flush slave channel
  virtiofsd: Opt in for slave start/stop/shutdown functionality

 hw/virtio/vhost-user.c                    | 151 +++++++++++++++++++++-
 subprojects/libvhost-user/libvhost-user.c | 147 +++++++++++++++++----
 subprojects/libvhost-user/libvhost-user.h |   8 +-
 tools/virtiofsd/fuse_virtio.c             |  20 +++
 4 files changed, 294 insertions(+), 32 deletions(-)

-- 
2.25.4

