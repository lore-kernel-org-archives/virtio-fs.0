DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id:in-reply-to:references;
	bh=XcXhnjDtLeci5FzdcHV9yR2H+etKGniJFzKwX/1YuTo=;
	b=KyOw63lJEddWxqzM2Fbv7Q6PWyCqf++dMc1+B9CJGS7dJNGxyNc+sk+46vfMcTLSOi
	FRdAn2EuRkWd1SN8lM+C7IPsm/dSvX4CagYPyjjpEjymrDxe40wEvJ/ZfokjN02slrm1
	2wMwM5BJEsnsgeQnyP+VtS2t7ePWrTlcEDF7rIotmYuvj8sUEJKM+p38rkCjBpsUHkWO
	0gFu5WgcW/4sGqgwEqhxEqDhwB18H9vVa8YM4gb+pc8eUsOfjSzh/WYRUTrdGVoTWNxB
	EcXQoFo1+sorjaCayarTOYHLZydILkKlDpvEG7ygjnGSjiEFM9IGWu9yVw+VAZDC2Kp8
	hp4A==
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Date: Wed,  6 Nov 2019 14:06:02 -0500
Message-Id: <20191106190602.14522-3-msys.mizuma@gmail.com>
In-Reply-To: <20191106190602.14522-1-msys.mizuma@gmail.com>
References: <20191106190602.14522-1-msys.mizuma@gmail.com>
Subject: [Virtio-fs] [PATCH 2/2] virtiofsd: Add timestamp to the log with
	FUSE_LOG_DEBUG level
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

virtiofsd has some threads, so we see a lot of logs with debug option.
It would be useful for debugging if we can see the timestamp.

Add nano second timestamp, which got by get_clock(), to the log with
FUSE_LOG_DEBUG level if the syslog option isn't set.

The log is like as:

  ]# ./virtiofsd -d -o vhost_user_socket=/tmp/vhostqemu0 -o source=/tmp/share0 -o cache=auto
  ...
  [5365943125463727] [ID: 00000002] fv_queue_thread: Start for queue 0 kick_fd 9
  [5365943125568644] [ID: 00000002] fv_queue_thread: Waiting for Queue 0 event
  [5365943125573561] [ID: 00000002] fv_queue_thread: Got queue event on Queue 0

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 contrib/virtiofsd/passthrough_ll.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 0e85d5ea74..406f62ab37 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -37,6 +37,8 @@
 #include "fuse_virtio.h"
 #include "fuse_lowlevel.h"
 #include "fuse_log.h"
+#include "qemu/osdep.h"
+#include "qemu/timer.h"
 #include <unistd.h>
 #include <stdlib.h>
 #include <stdio.h>
@@ -2856,9 +2858,14 @@ static void log_func(enum fuse_log_level level,
 	if (current_log_level < level)
 		return;
 
-	if (current_log_level == FUSE_LOG_DEBUG)
-		fmt = g_strdup_printf("[ID: %08ld] %s",
+	if (current_log_level == FUSE_LOG_DEBUG) {
+		if (!use_syslog)
+			fmt = g_strdup_printf("[%ld] [ID: %08ld] %s",
+				get_clock(), syscall(__NR_gettid), _fmt);
+		else
+			fmt = g_strdup_printf("[ID: %08ld] %s",
 				syscall(__NR_gettid), _fmt);
+	}
 
 	if (use_syslog) {
 		int priority = LOG_ERR;
-- 
2.18.1

