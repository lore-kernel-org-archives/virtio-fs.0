DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id:in-reply-to:references;
	bh=JUQWNdqvXaR9CisJRzGQ0NQKqVojyOo+nCZzrizmZWw=;
	b=EG84c2TAsK5p6E3B+1i9n5+lhbDSeYtgVLbFig99oHUbkLmaMc5SIpk9yD5awkLYE5
	uQR5Oj/ehS6wCknb6Ts7wExNHru/LfB0vM5D41pjyenqXqQD9r2Hxn2ErJUueVK1TfWg
	KHkrcg64EfjWj/BHLrtD/+b2fjAzGWMBFzOlbcEckHFKn6g84tp++Bg+KFYpsFgoB3+X
	3d2MUCCclWtRuCNeDSpJvuVbAcMwXeE74xEyiVwlijAHo4l32v7FTKPhUZ61Yqlk7Q5c
	P21P0/dktrfErUnPHL+BnKTh6zmVMSkx0VgGArU1x0WJTmGH/nGDo3gAAT0CbsnuvSpi
	hT1w==
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Date: Mon, 12 Aug 2019 17:04:53 -0400
Message-Id: <20190812210455.12540-2-msys.mizuma@gmail.com>
In-Reply-To: <20190812210455.12540-1-msys.mizuma@gmail.com>
References: <20190812210455.12540-1-msys.mizuma@gmail.com>
Subject: [Virtio-fs] [PATCH 1/3] fuse: add some macros for ftrace
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

Add some macros for ftrace. These macros is useful for generic fuse.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 include/trace/events/fuse_common.h | 67 ++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)
 create mode 100644 include/trace/events/fuse_common.h

diff --git a/include/trace/events/fuse_common.h b/include/trace/events/fuse_common.h
new file mode 100644
index 000000000..0805ec4ab
--- /dev/null
+++ b/include/trace/events/fuse_common.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <uapi/linux/fuse.h>
+
+#define fuse_opcode_name(opcode)	{ opcode, #opcode }
+#define show_opcode_name(val)				\
+	__print_symbolic(val,				\
+		fuse_opcode_name(FUSE_LOOKUP),		\
+		fuse_opcode_name(FUSE_FORGET),		\
+		fuse_opcode_name(FUSE_GETATTR),		\
+		fuse_opcode_name(FUSE_SETATTR),		\
+		fuse_opcode_name(FUSE_READLINK),	\
+		fuse_opcode_name(FUSE_SYMLINK),		\
+		fuse_opcode_name(FUSE_MKNOD),		\
+		fuse_opcode_name(FUSE_MKDIR),		\
+		fuse_opcode_name(FUSE_UNLINK),		\
+		fuse_opcode_name(FUSE_RMDIR),		\
+		fuse_opcode_name(FUSE_RENAME),		\
+		fuse_opcode_name(FUSE_LINK),		\
+		fuse_opcode_name(FUSE_OPEN),		\
+		fuse_opcode_name(FUSE_READ),		\
+		fuse_opcode_name(FUSE_WRITE),		\
+		fuse_opcode_name(FUSE_STATFS),		\
+		fuse_opcode_name(FUSE_RELEASE),		\
+		fuse_opcode_name(FUSE_FSYNC),		\
+		fuse_opcode_name(FUSE_SETXATTR),	\
+		fuse_opcode_name(FUSE_GETXATTR),	\
+		fuse_opcode_name(FUSE_LISTXATTR),	\
+		fuse_opcode_name(FUSE_REMOVEXATTR),	\
+		fuse_opcode_name(FUSE_FLUSH),		\
+		fuse_opcode_name(FUSE_INIT),		\
+		fuse_opcode_name(FUSE_OPENDIR),		\
+		fuse_opcode_name(FUSE_READDIR),		\
+		fuse_opcode_name(FUSE_RELEASEDIR),	\
+		fuse_opcode_name(FUSE_FSYNCDIR),	\
+		fuse_opcode_name(FUSE_GETLK),		\
+		fuse_opcode_name(FUSE_SETLK),		\
+		fuse_opcode_name(FUSE_SETLKW),		\
+		fuse_opcode_name(FUSE_ACCESS),		\
+		fuse_opcode_name(FUSE_CREATE),		\
+		fuse_opcode_name(FUSE_INTERRUPT),	\
+		fuse_opcode_name(FUSE_BMAP),		\
+		fuse_opcode_name(FUSE_DESTROY),		\
+		fuse_opcode_name(FUSE_IOCTL),		\
+		fuse_opcode_name(FUSE_POLL),		\
+		fuse_opcode_name(FUSE_NOTIFY_REPLY),	\
+		fuse_opcode_name(FUSE_BATCH_FORGET),	\
+		fuse_opcode_name(FUSE_FALLOCATE),	\
+		fuse_opcode_name(FUSE_READDIRPLUS),	\
+		fuse_opcode_name(FUSE_RENAME2),		\
+		fuse_opcode_name(FUSE_LSEEK),		\
+		fuse_opcode_name(FUSE_COPY_FILE_RANGE),	\
+		fuse_opcode_name(FUSE_SETUPMAPPING),	\
+		fuse_opcode_name(FUSE_REMOVEMAPPING))
+
+#define show_req_flag(flags) __print_flags(flags, "|",	\
+	{ (1UL << FR_ISREPLY),		"ISREPLY"},	\
+	{ (1UL << FR_FORCE),		"FORCE"},	\
+	{ (1UL << FR_BACKGROUND),	"BACKGROUND"},	\
+	{ (1UL << FR_WAITING),		"WAITING"},	\
+	{ (1UL << FR_ABORTED),		"ABORTED"},	\
+	{ (1UL << FR_INTERRUPTED),	"INTERRUPTED"},	\
+	{ (1UL << FR_LOCKED),		"LOCKED"},	\
+	{ (1UL << FR_PENDING),		"PENDING"},	\
+	{ (1UL << FR_SENT),		"SENT"},	\
+	{ (1UL << FR_FINISHED),		"FINISHED"},	\
+	{ (1UL << FR_PRIVATE),		"PRIVATE"})
-- 
2.18.1

