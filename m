From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed,  4 Dec 2019 14:08:32 -0500
Message-Id: <20191204190836.31324-2-vgoyal@redhat.com>
In-Reply-To: <20191204190836.31324-1-vgoyal@redhat.com>
References: <20191204190836.31324-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 1/5] virtiofsd: Get rid of unused fields in
	fv_QueueInfo
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org
Cc: mszeredi@redhat.com

There are some unused fields in "struct fv_QueueInfo". Get rid of these fields.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 contrib/virtiofsd/fuse_virtio.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
index 31c8542b6c..2a9cd60a01 100644
--- a/contrib/virtiofsd/fuse_virtio.c
+++ b/contrib/virtiofsd/fuse_virtio.c
@@ -50,12 +50,6 @@ struct fv_QueueInfo {
     int qidx;
     int kick_fd;
     int kill_fd; /* For killing the thread */
-
-    /* The element for the command currently being processed */
-    VuVirtqElement *qe;
-    /* If any of the qe vec elements (towards vmm) are unmappable */
-    unsigned int elem_bad_in;
-    bool reply_sent;
 };
 
 /* A FUSE request */
-- 
2.20.1

