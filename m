DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=A84c4hgUdxFtBSsh1SRChmmQpU42+UpUG3Lp/hwIx5E=;
	b=k3ZCQUYOgpJ5uH/BFTWwjS7d9lvAClhJ1uyX7l+I1QnoM7UTMbkTAJQaV7ibVKt5h/
	YXlWJ3UejJKkHUF2UXEvK/p3ncr98/68R23tKkrz0ooVd1dAt7epqGj+BeFvUKrhYWbx
	iP5yAU/yO6VyCcApluJT449/+wmyrWqWphpU8GKi8Sh+Gj5sGo6mYXLZo1aY7xfbIZn1
	UhPQb1MDfchJxSOx5dn3sl2+l1VZ61Gvs5t6lDxegIte1KjT7lPR+26hrGhWPc6YuTH/
	GG/ZLV+UBPX9Jkk9A89vq0gqkWm9sg79dm4A+DMqbXHcZQ8dr4v89zHDENXYSf1Rz+HR
	FJQw==
From: Hubert Jasudowicz <hubert.jasudowicz@gmail.com>
Date: Thu,  1 Jul 2021 23:11:48 +0200
Message-Id: <e5914ad202a13e9c1bc2a5efa267ff3bd4f48db6.1625173475.git.hubert.jasudowicz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH] virtiofsd: Add missing newline in error message
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, Hubert Jasudowicz <hubert.jasudowicz@gmail.com>, qemu-trivial@nongnu.org

From: Hubert Jasudowicz <hubert.jasudowicz@gmail.com>

Signed-off-by: Hubert Jasudowicz <hubert.jasudowicz@gmail.com>
---
 tools/virtiofsd/fuse_virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index fa4aff9b0e..fc2564a603 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -917,7 +917,7 @@ static bool fv_socket_lock(struct fuse_session *se)
     dir = qemu_get_local_state_pathname("run/virtiofsd");
 
     if (g_mkdir_with_parents(dir, S_IRWXU) < 0) {
-        fuse_log(FUSE_LOG_ERR, "%s: Failed to create directory %s: %s",
+        fuse_log(FUSE_LOG_ERR, "%s: Failed to create directory %s: %s\n",
                  __func__, dir, strerror(errno));
         return false;
     }
-- 
2.32.0

