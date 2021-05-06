From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu,  6 May 2021 19:56:37 +0100
Message-Id: <20210506185641.284821-9-dgilbert@redhat.com>
In-Reply-To: <20210506185641.284821-1-dgilbert@redhat.com>
References: <20210506185641.284821-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 08/12] virtiofsd: Changed allocations of
	fuse_session to GLib's functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, groug@kaod.org, jose.carlos.venegas.munoz@intel.com, ma.mandourr@gmail.com
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

From: Mahmoud Mandour <ma.mandourr@gmail.com>

Replaced the allocation and deallocation of fuse_session structs
from calloc() and free() calls to g_try_new0() and g_free().

Signed-off-by: Mahmoud Mandour <ma.mandourr@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20210420154643.58439-4-ma.mandourr@gmail.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/fuse_lowlevel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 88496f9560..7fe2cef1eb 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -2470,7 +2470,7 @@ void fuse_session_destroy(struct fuse_session *se)
     free(se->vu_socket_path);
     se->vu_socket_path = NULL;
 
-    free(se);
+    g_free(se);
 }
 
 
@@ -2493,7 +2493,7 @@ struct fuse_session *fuse_session_new(struct fuse_args *args,
         return NULL;
     }
 
-    se = (struct fuse_session *)calloc(1, sizeof(struct fuse_session));
+    se = g_try_new0(struct fuse_session, 1);
     if (se == NULL) {
         fuse_log(FUSE_LOG_ERR, "fuse: failed to allocate fuse object\n");
         goto out1;
@@ -2553,7 +2553,7 @@ struct fuse_session *fuse_session_new(struct fuse_args *args,
 out4:
     fuse_opt_free_args(args);
 out2:
-    free(se);
+    g_free(se);
 out1:
     return NULL;
 }
-- 
2.31.1

