From: Ioannis Angelakopoulos <iangelak@redhat.com>
Date: Wed, 16 Jun 2021 15:39:20 -0400
Message-Id: <20210616193921.608720-6-iangelak@redhat.com>
In-Reply-To: <20210616193921.608720-1-iangelak@redhat.com>
References: <20210616193921.608720-1-iangelak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 5/6] virtiofsd: Thread state cleanup when
	blocking posix locks are used
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

Stop virtiofsd thread from sending any notifications/messages through
the virtqueue while the guest hard-reboots.

If a guest attempts to hard reboot while a virtiofsd thread blocks
waiting for a lock held by another guest's virtiofsd process, then
QEMU will block the guest from rebooting until the lock is released.

When the virtiofsd thread acquires the lock it will not attempt to
send a message to the notification virtqueue since the queue is
now destroyed, due to the hard-reboot attempt of the guest. The thread
will only release the lock, without sending any notifications through the
virtqueue.

Then the cleanup process can proceed normally.

Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
---
 tools/virtiofsd/fuse_i.h         |  1 +
 tools/virtiofsd/fuse_lowlevel.c  |  2 ++
 tools/virtiofsd/fuse_virtio.c    | 10 ++++++++++
 tools/virtiofsd/passthrough_ll.c | 23 +++++++++++++++++++----
 4 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/tools/virtiofsd/fuse_i.h b/tools/virtiofsd/fuse_i.h
index 4942d080da..269fd5e77b 100644
--- a/tools/virtiofsd/fuse_i.h
+++ b/tools/virtiofsd/fuse_i.h
@@ -62,6 +62,7 @@ struct fuse_session {
     pthread_mutex_t lock;
     pthread_rwlock_t init_rwlock;
     int got_destroy;
+    int in_cleanup;
     int broken_splice_nonblock;
     uint64_t notify_ctr;
     struct fuse_notify_req notify_list;
diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 4b03ec2f9f..a9f6ea61dc 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -1905,6 +1905,7 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     se->conn.proto_minor = arg->minor;
     se->conn.capable = 0;
     se->conn.want = 0;
+    se->in_cleanup = 0;
 
     memset(&outarg, 0, sizeof(outarg));
     outarg.major = FUSE_KERNEL_VERSION;
@@ -2397,6 +2398,7 @@ void fuse_session_process_buf_int(struct fuse_session *se,
             fuse_log(FUSE_LOG_DEBUG, "%s: reinit\n", __func__);
             se->got_destroy = 1;
             se->got_init = 0;
+            se->in_cleanup = 0;
             if (se->op.destroy) {
                 se->op.destroy(se->userdata);
             }
diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index cb4dbafd91..7efaf9ae68 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -839,11 +839,14 @@ static void fv_queue_cleanup_thread(struct fv_VuDev *vud, int qidx)
         if (eventfd_write(ourqi->kill_fd, 1)) {
             fuse_log(FUSE_LOG_ERR, "Eventfd_read for queue: %m\n");
         }
+
         ret = pthread_join(ourqi->thread, NULL);
+
         if (ret) {
             fuse_log(FUSE_LOG_ERR, "%s: Failed to join thread idx %d err"
                      " %d\n", __func__, qidx, ret);
         }
+
         close(ourqi->kill_fd);
     }
     pthread_mutex_destroy(&ourqi->vq_lock);
@@ -929,6 +932,13 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
          * the queue thread doesn't block in virtio_send_msg().
          */
         vu_dispatch_unlock(vud);
+        /*
+         * Indicate to any thread that was blocked and wakes up
+         * that we are in the thread cleanup process
+         */
+        if (!vud->se->in_cleanup) {
+            vud->se->in_cleanup = 1;
+        }
         fv_queue_cleanup_thread(vud, qidx);
         vu_dispatch_wrlock(vud);
     }
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 8f24954a00..8a2aa10b9c 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -1971,9 +1971,6 @@ static struct lo_inode_plock *lookup_create_plock_ctx(struct lo_data *lo,
     plock =
         g_hash_table_lookup(inode->posix_locks, GUINT_TO_POINTER(lock_owner));
 
-    fuse_log(FUSE_LOG_DEBUG, "lookup_create_plock_ctx():"
-             " Inserted element in posix_locks hash table"
-             " with value pointer %p\n", plock);
     if (plock) {
         return plock;
     }
@@ -1997,6 +1994,10 @@ static struct lo_inode_plock *lookup_create_plock_ctx(struct lo_data *lo,
     plock->fd = fd;
     g_hash_table_insert(inode->posix_locks, GUINT_TO_POINTER(plock->lock_owner),
                         plock);
+    fuse_log(FUSE_LOG_DEBUG, "lookup_create_plock_ctx():"
+             " Inserted element in posix_locks hash table"
+             " with value pointer %p\n", plock);
+
     return plock;
 }
 
@@ -2133,7 +2134,21 @@ out:
     if (!async_lock) {
         fuse_reply_err(req, saverr);
     } else {
-        fuse_lowlevel_notify_lock(se, unique, saverr);
+        /*
+         * Before attempting to send any message through
+         * the thread should check if the queue actually
+         * exists
+         */
+        if (!se->in_cleanup) {
+            fuse_lowlevel_notify_lock(se, unique, saverr);
+        } else {
+            /* Release the locks */
+            lock->l_type = F_UNLCK;
+            lock->l_whence = SEEK_SET;
+            /* Unlock whole file */
+            lock->l_start = lock->l_len = 0;
+            fcntl(ofd, F_OFD_SETLKW, lock);
+        }
     }
 }
 
-- 
2.27.0

