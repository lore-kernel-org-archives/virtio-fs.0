From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 29 Jul 2020 18:14:09 -0400
Message-Id: <20200729221410.147556-5-vgoyal@redhat.com>
In-Reply-To: <20200729221410.147556-1-vgoyal@redhat.com>
References: <20200729221410.147556-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/5] virtiofsd: Open lo->source while setting up
	root in sandbox=NONE mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: berrange@redhat.com, vromanso@redhat.com, virtio-fs@redhat.com, vgoyal@redhat.com

In sandbox=NONE mode, lo->source points to the directory which is being
exported. We have not done any chroot()/pivot_root(). So open lo->source.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 76ef891105..a6fa816b6c 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3209,7 +3209,10 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
     int fd, res;
     struct stat stat;
 
-    fd = open("/", O_PATH);
+    if (lo->sandbox == SANDBOX_NONE)
+        fd = open(lo->source, O_PATH);
+    else
+        fd = open("/", O_PATH);
     if (fd == -1) {
         fuse_log(FUSE_LOG_ERR, "open(%s, O_PATH): %m\n", lo->source);
         exit(1);
-- 
2.25.4

