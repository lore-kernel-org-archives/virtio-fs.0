From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 16 Feb 2021 18:36:10 -0500
Message-Id: <20210216233611.33400-3-vgoyal@redhat.com>
In-Reply-To: <20210216233611.33400-1-vgoyal@redhat.com>
References: <20210216233611.33400-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/3] virtiofsd: Add umask to seccom allow list
List-Id: Development discussions about virtio-fs <virtio-fs.listman.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@listman.redhat.com>
List-Help: <mailto:virtio-fs-request@listman.redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: miklos@szeredi.hu, vgoyal@redhat.com

Next patch is going to make use of "umask" syscall. So allow it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/passthrough_seccomp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
index ea852e2e33..f0313c5ce4 100644
--- a/tools/virtiofsd/passthrough_seccomp.c
+++ b/tools/virtiofsd/passthrough_seccomp.c
@@ -114,6 +114,7 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(utimensat),
     SCMP_SYS(write),
     SCMP_SYS(writev),
+    SCMP_SYS(umask),
 };
 
 /* Syscalls used when --syslog is enabled */
-- 
2.25.4

