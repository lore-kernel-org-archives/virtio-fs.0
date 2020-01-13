From: Xiao Yang <yangx.jy@cn.fujitsu.com>
Date: Mon, 13 Jan 2020 17:37:35 +0800
Message-ID: <20200113093735.4610-2-yangx.jy@cn.fujitsu.com>
In-Reply-To: <20200113093735.4610-1-yangx.jy@cn.fujitsu.com>
References: <20200113093735.4610-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/2] virtiofsd/passthrough_ll: Only call
	posix_fallocate() when it is supported
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

passthrough_ll sets HAVE_POSIX_FALLOCATE macro compulsively so posix_fallocate()
is always called even if it is not supported.  Replace HAVE_POSIX_FALLOCATE with
CONFIG_POSIX_FALLOCATE.

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 tools/virtiofsd/passthrough_ll.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index a19823caaf..196664d52b 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -72,8 +72,6 @@
 #include "passthrough_helpers.h"
 #include "seccomp.h"
 
-#define HAVE_POSIX_FALLOCATE 1
-
 /* Keep track of inode posix locks for each owner. */
 struct lo_inode_plock {
     uint64_t lock_owner;
@@ -2319,7 +2317,7 @@ static void lo_fallocate(fuse_req_t req, fuse_ino_t ino, int mode, off_t offset,
         err = errno;
     }
 
-#elif defined(HAVE_POSIX_FALLOCATE)
+#elif defined(CONFIG_POSIX_FALLOCATE)
     if (mode) {
         fuse_reply_err(req, EOPNOTSUPP);
         return;
-- 
2.21.0




