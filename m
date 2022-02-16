From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 16 Feb 2022 17:36:14 +0000
Message-Id: <20220216173625.128109-2-dgilbert@redhat.com>
In-Reply-To: <20220216173625.128109-1-dgilbert@redhat.com>
References: <20220216173625.128109-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 01/12] virtiofsd: Do not support blocking flock
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, groug@kaod.org, sebastian.hasler@stuvus.uni-stuttgart.de
Cc: virtio-fs@redhat.com

From: Sebastian Hasler <sebastian.hasler@stuvus.uni-stuttgart.de>

With the current implementation, blocking flock can lead to
deadlock. Thus, it's better to return EOPNOTSUPP if a user attempts
to perform a blocking flock request.

Signed-off-by: Sebastian Hasler <sebastian.hasler@stuvus.uni-stuttgart.de>
Message-Id: <20220113153249.710216-1-sebastian.hasler@stuvus.uni-stuttgart.de>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Greg Kurz <groug@kaod.org>
---
 tools/virtiofsd/passthrough_ll.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index b3d0674f6d..3e56d1cd95 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2467,6 +2467,15 @@ static void lo_flock(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
     int res;
     (void)ino;
 
+    if (!(op & LOCK_NB)) {
+        /*
+         * Blocking flock can deadlock as there is only one thread
+         * serving the queue.
+         */
+        fuse_reply_err(req, EOPNOTSUPP);
+        return;
+    }
+
     res = flock(lo_fi_fd(req, fi), op);
 
     fuse_reply_err(req, res == -1 ? errno : 0);
-- 
2.35.1

