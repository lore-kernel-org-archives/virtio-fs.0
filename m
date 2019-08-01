From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu,  1 Aug 2019 17:54:05 +0100
Message-Id: <20190801165409.20121-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/4] virtiofsd: multithreading preparation part 3
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org

This patch series introduces the virtiofsd --thread-pool-size=NUM and sets the
default value to 64.  Each virtqueue has its own thread pool for processing
requests.  Blocking requests no longer pause virtqueue processing and I/O
performance should be greatly improved when the queue depth is greater than 1.

Linux boot and pjdfstest have been tested with these patches and the default
thread pool size of 64.

I have now concluded the thread-safety code audit.  Please let me know if you
have concerns about things I missed.

Performance
-----------
Please try these patches out and share your results.

Scalability
-----------
There are several synchronization primitives that are taken by the virtqueue
processing thread or the thread pool worker.  Unfortunately this is necessary
to protect shared state.  It means that thread pool workers contend on or at
least access thread synchronization primitives.  If anyone has suggestions for
improving this situation, please discuss.

1. vu_dispatch_rwlock - libvhost-user from races between the vhost-user
   protocol thread and the virtqueue processing and thread pool worker threads.

2. vq_lock - protects the virtqueue from races between the virtqueue processing
   thread and thread pool workers.

3. init_rwlock - protects FUSE_INIT/FUSE_DESTROY from races with other
   requests.

4. se->lock - protects se->list and the FUSE_INTERRUPT shared state.

Ideally we could avoid hitting all of these locks on each request.  That would
make the code scale better.

Future work
-----------
This series does not complete the multithreading effort yet.  Two items are
still missing:
1. Multiqueue support
2. CPU affinity for virtqueue processing threads and thread pools

Stefan Hajnoczi (4):
  virtiofsd: process requests in a thread pool
  virtiofsd: prevent FUSE_INIT/FUSE_DESTROY races
  virtiofsd: fix lo_destroy() resource leaks
  virtiofsd: add --thread-pool-size=NUM option

 contrib/virtiofsd/fuse_i.h         |   2 +
 contrib/virtiofsd/fuse_lowlevel.c  |  25 +-
 contrib/virtiofsd/fuse_virtio.c    | 491 ++++++++++++++++-------------
 contrib/virtiofsd/passthrough_ll.c |  43 ++-
 contrib/virtiofsd/seccomp.c        |   1 +
 5 files changed, 318 insertions(+), 244 deletions(-)

-- 
2.21.0

