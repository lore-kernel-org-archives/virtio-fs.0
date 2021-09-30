From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 30 Sep 2021 10:38:42 -0400
Message-Id: <20210930143850.1188628-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/8] virtiofs: Notification queue and blocking
	posix locks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com
Cc: vgoyal@redhat.com

Hi,

As of now we do not support blocking remote posix locks with virtiofs.
Well fuse client does not care but server returns -EOPNOTSUPP.

There are couple of reasons to not support it yet.

- If virtiofsd is single threaded or does not have a thread pool just
  to handle requests which can block for a long time, virtiofsd will
  stop processing new requests and virtiofs will come to a halt.
  To the extent that further unlock request will not make progress
  and deadlock will result. This can be taken care of by creating
  a custom thread pool in virtiofsd just to hanlde lock requests.

- If client sends a blocking lock request and blocks, then it will
  consume descriptors in vring. If enough processes block, it is
  possible that vring does not have capacity to send more requests
  till some response comes back and descriptors are free. This can
  also lead to deadlock where an unlock request can't be sent to
  virtiofsd now. Also this will stop virtiofs operation as well as
  new filesystem requests can't be sent.

To avoid this issue, idea was suggested thatn when a blocking
lock request is sent by client, do not block it. Immediately
send a reply saying client process should wait for a notification
which will let it know once lock is available. This will make
sure descriptors in virtqueue are not kept busy while we are
waiting for lock and future unlock and other file system requests
can continue to make progress.

This first requires a notion of notification queue and virtiosfd
being able to send notifications to client. This patch series
implements that as well.

As of now only one notification type has been implemented but now
infrastructure is in place and other use cases should be easily
add more type of notifications as need be.

We don't yet have the capability to interrupt the process which
is waiting for the posix lock. And reason for that is that virtiofs
does not support capability to interrupt yet. That's a TODO item
for later.

Please have a look.

Thanks
Vivek

Vivek Goyal (8):
  virtiofs: Disable interrupt requests properly
  virtiofs: Fix a comment about fuse_dev allocation
  virtiofs: Add an index to keep track of first request queue
  virtiofs: Decouple queue index and queue type
  virtiofs: Add a virtqueue for notifications
  virtiofs: Add a helper to end request and decrement inflight number
  virtiofs: Add new notification type FUSE_NOTIFY_LOCK
  virtiofs: Handle reordering of reply and notification event

 fs/fuse/virtio_fs.c            | 438 ++++++++++++++++++++++++++++++---
 include/uapi/linux/fuse.h      |  11 +-
 include/uapi/linux/virtio_fs.h |   5 +
 3 files changed, 412 insertions(+), 42 deletions(-)

-- 
2.31.1

