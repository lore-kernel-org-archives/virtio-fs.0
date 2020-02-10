DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=ddbC+
	+BEd/v48OAzjYgM48YCyx3BqQgaXIAaVjmuskw=; b=fsa/A3q8uS/Ut5vOq+sLW
	D/ESn6WMOAtNsvU29sIdi91nmjJnvrJrJ9pFgVdj2dy2SsYTo97fO3Q5olCPR21T
	uHOLDlFkjwhO+Lypfq1DhX5AiX1a5v4+oP1TDcwL5PvwB/8cVypPlW+gtYbOv/fW
	EtZ593XOimCkx6WoL+F7kY=
From: Xiao Yang <ice_yangxiao@163.com>
Date: Mon, 10 Feb 2020 18:44:51 +0800
Message-Id: <20200210104451.20036-1-ice_yangxiao@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofsd/helper: Add shared/no_shared options
	to help message
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

From: Xiao Yang <yangx.jy@cn.fujitsu.com>

Also add a hint that user should start 'ireg' daemon before using shared cache.

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 tools/virtiofsd/helper.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
index 819c2bc13c..0aa02b99b0 100644
--- a/tools/virtiofsd/helper.c
+++ b/tools/virtiofsd/helper.c
@@ -171,6 +171,10 @@ void fuse_cmdline_help(void)
            "                               default: no_writeback\n"
            "    -o xattr|no_xattr          enable/disable xattr\n"
            "                               default: no_xattr\n"
+           "    -o shared|no_shared        enable/disable shared cache\n"
+           "                               default: no_shared\n"
+           "                               please start 'ireg' daemon before "
+           "using shared cache\n"
            );
 }
 
-- 
2.21.0



