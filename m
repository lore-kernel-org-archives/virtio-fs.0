From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 13 Aug 2019 15:29:41 -0400
Message-Id: <20190813192944.26009-2-vgoyal@redhat.com>
In-Reply-To: <20190813192944.26009-1-vgoyal@redhat.com>
References: <20190813192944.26009-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/4] virtiofsd: Fix number of padding bits in
	fuse_file_info
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Currently we have 27 padding bits while there are 6 bit fields. I suspect
this is wrong. We probably are trying to aling to 32 bits and hence padding
bits should be 26 instead.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 contrib/virtiofsd/fuse_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/contrib/virtiofsd/fuse_common.h b/contrib/virtiofsd/fuse_common.h
index 6419f66470..4d95f6f28b 100644
--- a/contrib/virtiofsd/fuse_common.h
+++ b/contrib/virtiofsd/fuse_common.h
@@ -65,7 +65,7 @@ struct fuse_file_info {
 	unsigned int flock_release : 1;
 
 	/** Padding.  Do not use*/
-	unsigned int padding : 27;
+	unsigned int padding : 26;
 
 	/** File handle.  May be filled in by filesystem in open().
 	    Available in all other file operations */
-- 
2.17.2

