References: <20210507221527.699516-1-ckuehl@redhat.com>
	<20210510152506.GC150402@horse>
From: Connor Kuehl <ckuehl@redhat.com>
Message-ID: <ddbc96c7-655c-e563-e26e-6550a0cdd7c1@redhat.com>
Date: Mon, 10 May 2021 11:15:21 -0500
MIME-Version: 1.0
In-Reply-To: <20210510152506.GC150402@horse>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH] virtiofs: Enable multiple request queues
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On 5/10/21 10:25 AM, Vivek Goyal wrote:
> On Fri, May 07, 2021 at 03:15:27PM -0700, Connor Kuehl wrote:
>> Distribute requests across the multiqueue complex automatically based
>> on the IRQ affinity.
> 
> Hi Connor,
> 
> Thanks for the patch. I will look into it and also test it.
> 
> How did you test it? Did you modify vitiofsd to support multiqueue. Did
> you also run some performance numbers. Does it provide better/worse
> performance as compared to single queue.

Thanks, Vivek! I need to NACK this version of the patch for inclusion
though since I think the way I did per-CPU state will not work for
multiple virtio-fs mounts because it will be overwritten with each new
mount, but for testing purposes this should be OK with just one mount.

I need to do more benchmarking on this.

I had to hack multiqueue support into virtiofsd, which runs against the
warning in the virtiofsd source code that instructs people to *not*
enable multiqueue due to thread-safety concerns. I didn't audit
virtiofsd for correctness, so I also worry this has the potential of
affecting benchmarks if there are races.

For testing, QEMU needs to be invoked with `num-request-queues` like
this:

	-device vhost-user-fs-pci,chardev=char0,tag=myfs,num-request-queues=2 

And obviously you can choose any value >= 1 for num-request-queues.

and I also made a quick-and-dirty hack to let me pass in the number of
total queues to virtiofsd on the command line:

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 58e32fc963..cf8f132efd 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -2565,9 +2565,9 @@ out1:
     return NULL;
 }
 
-int fuse_session_mount(struct fuse_session *se)
+int fuse_session_mount(struct fuse_session *se, unsigned int num_queues)
 {
-    return virtio_session_mount(se);
+    return virtio_session_mount(se, num_queues);
 }
 
 int fuse_session_fd(struct fuse_session *se)
diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index 3bf786b034..50bf86113d 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -1842,7 +1842,7 @@ struct fuse_session *fuse_session_new(struct fuse_args *args,
  *
  * @return 0 on success, -1 on failure.
  **/
-int fuse_session_mount(struct fuse_session *se);
+int fuse_session_mount(struct fuse_session *se, unsigned int num_queues);
 
 /**
  * Enter a single threaded, blocking event loop.
diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 3e13997406..8622c3dce6 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -747,20 +747,6 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
              started);
     assert(qidx >= 0);
 
-    /*
-     * Ignore additional request queues for now.  passthrough_ll.c must be
-     * audited for thread-safety issues first.  It was written with a
-     * well-behaved client in mind and may not protect against all types of
-     * races yet.
-     */
-    if (qidx > 1) {
-        fuse_log(FUSE_LOG_ERR,
-                 "%s: multiple request queues not yet implemented, please only "
-                 "configure 1 request queue\n",
-                 __func__);
-        exit(EXIT_FAILURE);
-    }
-
     if (started) {
         /* Fire up a thread to watch this queue */
         if (qidx >= vud->nqueues) {
@@ -997,7 +983,7 @@ static int fv_create_listen_socket(struct fuse_session *se)
     return 0;
 }
 
-int virtio_session_mount(struct fuse_session *se)
+int virtio_session_mount(struct fuse_session *se, unsigned int num_queues)
 {
     int ret;
 
@@ -1048,8 +1034,8 @@ int virtio_session_mount(struct fuse_session *se)
     se->vu_socketfd = data_sock;
     se->virtio_dev->se = se;
     pthread_rwlock_init(&se->virtio_dev->vu_dispatch_rwlock, NULL);
-    if (!vu_init(&se->virtio_dev->dev, 2, se->vu_socketfd, fv_panic, NULL,
-                 fv_set_watch, fv_remove_watch, &fv_iface)) {
+    if (!vu_init(&se->virtio_dev->dev, num_queues, se->vu_socketfd,
+		 fv_panic, NULL, fv_set_watch, fv_remove_watch, &fv_iface)) {
         fuse_log(FUSE_LOG_ERR, "%s: vu_init failed\n", __func__);
         return -1;
     }
diff --git a/tools/virtiofsd/fuse_virtio.h b/tools/virtiofsd/fuse_virtio.h
index 111684032c..a0e78b9b84 100644
--- a/tools/virtiofsd/fuse_virtio.h
+++ b/tools/virtiofsd/fuse_virtio.h
@@ -18,7 +18,7 @@
 
 struct fuse_session;
 
-int virtio_session_mount(struct fuse_session *se);
+int virtio_session_mount(struct fuse_session *se, unsigned int num_queues);
 void virtio_session_close(struct fuse_session *se);
 int virtio_loop(struct fuse_session *se);
 
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 1553d2ef45..9fd4e34980 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -161,6 +161,7 @@ struct lo_data {
     int allow_direct_io;
     int announce_submounts;
     bool use_statx;
+    int num_vqs;
     struct lo_inode root;
     GHashTable *inodes; /* protected by lo->mutex */
     struct lo_map ino_map; /* protected by lo->mutex */
@@ -204,6 +205,7 @@ static const struct fuse_opt lo_opts[] = {
     { "announce_submounts", offsetof(struct lo_data, announce_submounts), 1 },
     { "killpriv_v2", offsetof(struct lo_data, user_killpriv_v2), 1 },
     { "no_killpriv_v2", offsetof(struct lo_data, user_killpriv_v2), 0 },
+    { "num_queues=%d", offsetof(struct lo_data, num_vqs), 2 },
     FUSE_OPT_END
 };
 static bool use_syslog = false;
@@ -3848,6 +3850,12 @@ int main(int argc, char *argv[])
         exit(1);
     }
 
+    if (lo.num_vqs < 2) {
+        fuse_log(FUSE_LOG_ERR, "num_queues must be at least 2 (got %d)\n",
+                 lo.num_vqs);
+        exit(1);
+    }
+
     lo.use_statx = true;
 
     se = fuse_session_new(&args, &lo_oper, sizeof(lo_oper), &lo);
@@ -3859,7 +3867,7 @@ int main(int argc, char *argv[])
         goto err_out2;
     }
 
-    if (fuse_session_mount(se) != 0) {
+    if (fuse_session_mount(se, lo.num_vqs) != 0) {
         goto err_out3;
     }
 

