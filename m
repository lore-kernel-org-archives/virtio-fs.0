From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 29 Jul 2020 18:14:06 -0400
Message-Id: <20200729221410.147556-2-vgoyal@redhat.com>
In-Reply-To: <20200729221410.147556-1-vgoyal@redhat.com>
References: <20200729221410.147556-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/5] virtiofsd: Add notion of unprivileged mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: berrange@redhat.com, vromanso@redhat.com, virtio-fs@redhat.com, vgoyal@redhat.com

At startup if we are running as non-root user, then internall set
unpriviliged mode set. Also add a notion of sandbox NONE and set
that internally in unprivileged mode. setting up namespaces and
chroot() fails when one does not have privileges.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index e2fbc614fd..cd91c4a831 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -147,11 +147,13 @@ enum {
 enum {
     SANDBOX_NAMESPACE,
     SANDBOX_CHROOT,
+    SANDBOX_NONE,
 };
 
 struct lo_data {
     pthread_mutex_t mutex;
     int sandbox;
+    bool unprivileged;
     int debug;
     int writeback;
     int flock;
@@ -3288,6 +3290,12 @@ int main(int argc, char *argv[])
     lo_map_init(&lo.dirp_map);
     lo_map_init(&lo.fd_map);
 
+    if (geteuid() != 0) {
+       lo.unprivileged = true;
+       lo.sandbox = SANDBOX_NONE;
+       fuse_log(FUSE_LOG_DEBUG, "Running in unprivileged passthrough mode.\n");
+    }
+
     if (fuse_parse_cmdline(&args, &opts) != 0) {
         goto err_out1;
     }
-- 
2.25.4

