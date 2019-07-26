From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Fri, 26 Jul 2019 10:10:58 +0100
Message-Id: <20190726091103.23503-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/5] virtiofsd: multithreading preparation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org

virtiofsd is not ready for multithreading yet.  This patch series starts to
make the code capable of processing multiple FUSE requests simultaneously.  I'm
sending these fixes split into several patch series as I make progress auditing
the code for thread-safety issues.  The final patch series will use a
threadpool to process requests from a virtqueue in parallel and it will also
enable multiqueue.

Patches 1 & 2 are cleanups discovered when auditing the code.  They are not
related to multithreading.

Stefan Hajnoczi (5):
  virtiofsd: skip unnecessary vu_queue_get_avail_bytes()
  virtiofsd: prevent lo_lookup() NULL pointer dereference
  virtiofsd: make lo_release() atomic
  virtiofsd: drop lo_dirp->fd field
  virtiofsd: prevent races with lo_dirp_put()

 contrib/virtiofsd/fuse_virtio.c    | 13 +++---
 contrib/virtiofsd/passthrough_ll.c | 71 +++++++++++++++++++++++-------
 2 files changed, 60 insertions(+), 24 deletions(-)

-- 
2.21.0

