From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu, 25 Jul 2019 15:20:13 +0100
Message-Id: <20190725142014.1726-2-stefanha@redhat.com>
In-Reply-To: <20190725142014.1726-1-stefanha@redhat.com>
References: <20190725142014.1726-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/2] fuse: drop unused struct
	fuse_setupmapping_out
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Originally the idea was that FUSE_SETUPMAPPING returns a list of
addresses where the mmaps were made.  But then we decided to let the
FUSE client decide where to map so it already knows the address.
Consequently this struct is unused.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/uapi/linux/fuse.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 562a36add1e2..8c36aadb6294 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -824,7 +824,6 @@ struct fuse_copy_file_range_in {
 	uint64_t	flags;
 };
 
-#define FUSE_SETUPMAPPING_ENTRIES 8
 #define FUSE_SETUPMAPPING_FLAG_WRITE (1ull << 0)
 #define FUSE_SETUPMAPPING_FLAG_READ (1ull << 1)
 struct fuse_setupmapping_in {
@@ -840,13 +839,6 @@ struct fuse_setupmapping_in {
 	uint64_t	moffset;
 };
 
-struct fuse_setupmapping_out {
-	/* Offsets into the cache of mappings */
-	uint64_t	coffset[FUSE_SETUPMAPPING_ENTRIES];
-        /* Lengths of each mapping */
-        uint64_t	len[FUSE_SETUPMAPPING_ENTRIES];
-};
-
 struct fuse_removemapping_in {
         /* An already open handle */
         uint64_t	fh;
-- 
2.21.0

