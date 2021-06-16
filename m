From: Ioannis Angelakopoulos <iangelak@redhat.com>
Date: Wed, 16 Jun 2021 12:08:33 -0400
Message-Id: <20210616160836.590206-1-iangelak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/3] Virtiofs: Support for remote blocking posix
	locks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com, miklos@szeredi.hu

Adding support for remote blocking locks in virtiofs. Initially linux
only supported the fcntl(SETLK) option. Now the fcntl(SETLKW) option
is also supported.

A guest issuing a fcntl(SETLKW) system call will block if another guest
has already acquired the lock. Once the lock is available then the
blocking guest will receive a notification, through the notification
queue. Then the guest will unblock and acquire the lock.

Vivek Goyal (3):
  virtiofs: Add an index to keep track of first request queue
  virtiofs: Add a virtqueue for notifications
  virtiofs: Support blocking posix locks (fcntl(F_SETLKW))

 fs/fuse/virtio_fs.c            | 290 +++++++++++++++++++++++++++++++--
 include/uapi/linux/fuse.h      |   7 +
 include/uapi/linux/virtio_fs.h |   5 +
 3 files changed, 288 insertions(+), 14 deletions(-)

-- 
2.27.0

