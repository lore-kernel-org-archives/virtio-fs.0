From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 30 Jul 2020 15:47:36 -0400
Message-Id: <20200730194736.173994-6-vgoyal@redhat.com>
In-Reply-To: <20200730194736.173994-1-vgoyal@redhat.com>
References: <20200730194736.173994-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 5/5] virtiofsd: Skip setup_capabilities() in
	sandbox=NONE mode
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

setup_capabilites() tries to give some of the required capabilities
to act as a full fledged file server in priviliged mode. In unpriviliged
mode we can't get those capabilities and setup_capabilities() will fail.

So don't setup capabilities when sandbox=NONE.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index a6fa816b6c..1a0b24cbf2 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3030,7 +3030,8 @@ static void setup_sandbox(struct lo_data *lo, struct fuse_session *se,
     }
 
     setup_seccomp(enable_syslog);
-    setup_capabilities(g_strdup(lo->modcaps));
+    if (lo->sandbox != SANDBOX_NONE)
+       setup_capabilities(g_strdup(lo->modcaps));
 }
 
 /* Set the maximum number of open file descriptors */
-- 
2.25.4

