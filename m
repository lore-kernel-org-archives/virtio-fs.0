From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 15 Nov 2019 15:57:01 -0500
Message-Id: <20191115205705.2046-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/4] [RFC] virtiofs: Add a notification queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, vgoyal@redhat.com

Hi,

These are RFC patches for adding a notification queue to allow sending
notifications from host to guest.

It also adds support for blocking remote posix locks using the newly
introduced notification queue.

These patches apply on top of 5.4-rc8 plus following patch series I had
posted a while back.

https://lkml.org/lkml/2019/10/30/493

These changes require virtio spec changes as well. I have yet to do
that.

Thanks
Vivek

Vivek Goyal (4):
  virtiofs: Provide a helper function for virtqueue initialization
  virtiofs: Add an index to keep track of first request queue
  virtiofs: Add a virtqueue for notifications
  virtiofs: Support blocking posix locks (fcntl(F_SETLKW))

 fs/fuse/virtio_fs.c            | 328 ++++++++++++++++++++++++++++++---
 include/uapi/linux/fuse.h      |   7 +
 include/uapi/linux/virtio_fs.h |   5 +
 3 files changed, 310 insertions(+), 30 deletions(-)

-- 
2.20.1

