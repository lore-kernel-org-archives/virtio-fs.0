From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Wed, 16 Oct 2019 17:01:56 +0100
Message-Id: <20191016160157.12414-2-stefanha@redhat.com>
In-Reply-To: <20191016160157.12414-1-stefanha@redhat.com>
References: <20191016160157.12414-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/2] virtiofsd: move to an empty network
	namespace
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com

If the process is compromised there should be no network access.  Use an
empty network namespace to sandbox networking.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 84b60d85bd..c27ff7d800 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -2736,6 +2736,19 @@ static void setup_shared_versions(struct lo_data *lo)
 	lo->version_table = addr;
 }
 
+/*
+ * Called after our UNIX domain sockets have been created, now we can move to
+ * an empty network namespace to prevent TCP/IP and other network activity in
+ * case this process is compromised.
+ */
+static void setup_net_namespace(void)
+{
+	if (unshare(CLONE_NEWNET) != 0) {
+		fuse_log(FUSE_LOG_ERR, "unshare(CLONE_NEWNET): %m\n");
+		exit(1);
+	}
+}
+
 /* This magic is based on lxc's lxc_pivot_root() */
 static void setup_pivot_root(const char *source)
 {
@@ -2818,6 +2831,7 @@ static void setup_mount_namespace(const char *source)
  */
 static void setup_sandbox(struct lo_data *lo, bool enable_syslog)
 {
+	setup_net_namespace();
 	setup_mount_namespace(lo->source);
 	setup_seccomp(enable_syslog);
 }
-- 
2.21.0

