From: Eric Ren <renzhen@linux.alibaba.com>
Date: Mon, 15 Jul 2019 11:09:51 +0800
Message-Id: <690c7f0afc449d8e843cc3b271035966628df450.1563159705.git.renzhen@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH v2] virtiofsd: remove SCMP_FLTATTR_CTL_TSYNC flag
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

SCMP_FLTATTR_CTL_TSYNC flag is only available on
Linux Kernel 3.17 or greater. Older host kernel
fails virtiofsd, limiting virtiofsd use.

And, confirmed from Stefan Hajnoczi:
"""
There are no threads when setup_seccomp() is invoked so the TSYNC
attribute is not required.

Please remove the TSYNC call.  Then we don't need to worry about version
or feature checks.
"""

Signed-off-by: Eric Ren <renzhen@linux.alibaba.com>
---
 contrib/virtiofsd/seccomp.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/contrib/virtiofsd/seccomp.c b/contrib/virtiofsd/seccomp.c
index 4e388adc9c..28b2bbf0cf 100644
--- a/contrib/virtiofsd/seccomp.c
+++ b/contrib/virtiofsd/seccomp.c
@@ -92,10 +92,6 @@ void setup_seccomp(void)
 		err(1, "seccomp_init()");
 	}
 
-	if (seccomp_attr_set(ctx, SCMP_FLTATR_CTL_TSYNC, 1) != 0) {
-		err(1, "seccomp_attr_set(ctx, SCMP_FLTATTR_CTL_TSYNC, 1)");
-	}
-
 	for (i = 0; i < G_N_ELEMENTS(syscall_whitelist); i++) {
 		if (seccomp_rule_add(ctx, SCMP_ACT_ALLOW,
 				     syscall_whitelist[i], 0) != 0) {
-- 
2.17.2 (Apple Git-113)

