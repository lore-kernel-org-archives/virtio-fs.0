From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Date: Mon, 20 Jan 2020 21:43:06 +0900
Message-ID: <20200120124307.20020-2-misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <20200120124307.20020-1-misono.tomohiro@jp.fujitsu.com>
References: <20200120124307.20020-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/2] virtiofsd: fuse_lowevel: remove call of
	fuse_chan_{get, put}
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This is a cleanup patch.

fuse_chan_{get,put} manages allocated fuse_chan and free it when its
counter reaches zero. This came from original libfuse code but virtiofs
will not malloc fuse_chan itself and therefore these function is not
needed.

Currently there is no issue in calling them since
 1. ch.ctr is set to 1 in fv_queue_worker.
 2. ch.ctr is incremented by fuse_chan_get() in
    fuse_session_process_buf_int()
 3. ch.ctr is decremented by fuse_chan_put() in fuse_free_req()
So, ch.ctr never reaches zero and free() is not called.

Let's remove unnecessary code for better readability.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 tools/virtiofsd/fuse_lowlevel.c | 3 +--
 tools/virtiofsd/fuse_virtio.c   | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 09a7b23726..69f00fc0a6 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -128,7 +128,6 @@ void fuse_free_req(fuse_req_t req)
     req->u.ni.data = NULL;
     list_del_req(req);
     ctr = --req->ctr;
-    fuse_chan_put(req->ch);
     req->ch = NULL;
     pthread_mutex_unlock(&se->lock);
     if (!ctr) {
@@ -2430,7 +2429,7 @@ void fuse_session_process_buf_int(struct fuse_session *se,
     req->ctx.uid = in->uid;
     req->ctx.gid = in->gid;
     req->ctx.pid = in->pid;
-    req->ch = ch ? fuse_chan_get(ch) : NULL;
+    req->ch = ch;
 
     /*
      * INIT and DESTROY requests are serialized, all other request types
diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 7bc6ff2f19..84491fd47d 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -448,7 +448,6 @@ static void fv_queue_worker(gpointer data, gpointer user_data)
 
     fuse_mutex_init(&req->ch.lock);
     req->ch.fd = (int)0xdaff0d111;
-    req->ch.ctr = 1;
     req->ch.qi = qi;
 
     /* The 'out' part of the elem is from qemu */
-- 
2.21.1


