From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu,  4 Feb 2021 18:34:39 +0000
Message-Id: <20210204183439.546918-6-dgilbert@redhat.com>
In-Reply-To: <20210204183439.546918-1-dgilbert@redhat.com>
References: <20210204183439.546918-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 5/5] virtiofsd: Add restart_syscall to the
	seccomp whitelist
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com, stefanha@redhat.com, groug@kaod.org, qemu-stable@nongnu.org

From: Greg Kurz <groug@kaod.org>

This is how linux restarts some system calls after SIGSTOP/SIGCONT.
This is needed to avoid virtiofsd termination when resuming execution
under GDB for example.

Signed-off-by: Greg Kurz <groug@kaod.org>
Message-Id: <20210201193305.136390-1-groug@kaod.org>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/passthrough_seccomp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
index 1ecf5bf318..ea852e2e33 100644
--- a/tools/virtiofsd/passthrough_seccomp.c
+++ b/tools/virtiofsd/passthrough_seccomp.c
@@ -89,6 +89,7 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(renameat),
     SCMP_SYS(renameat2),
     SCMP_SYS(removexattr),
+    SCMP_SYS(restart_syscall),
     SCMP_SYS(rt_sigaction),
     SCMP_SYS(rt_sigprocmask),
     SCMP_SYS(rt_sigreturn),
-- 
2.29.2

