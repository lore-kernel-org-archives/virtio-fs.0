From: Vivek Goyal <vgoyal@redhat.com>
Date: Mon, 25 Jan 2021 13:01:15 -0500
Message-Id: <20210125180115.22936-7-vgoyal@redhat.com>
In-Reply-To: <20210125180115.22936-1-vgoyal@redhat.com>
References: <20210125180115.22936-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 6/6] virtiofsd: Opt in for slave
	start/stop/shutdown functionality
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: marcandre.lureau@redhat.com, vgoyal@redhat.com, mst@redhat.com

This is an opt-in feature not enabled by default. Enable it in
protocol features by setting VHOST_USER_PROTOCOL_F_SLAVE_CH_START_STOP.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 6805d8ba01..9328c8fac6 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -103,6 +103,11 @@ static void fv_set_features(VuDev *dev, uint64_t features)
 {
 }
 
+static uint64_t fv_get_protocol_features(VuDev *dev)
+{
+    return 1ULL << VHOST_USER_PROTOCOL_F_SLAVE_CH_START_STOP;
+}
+
 /*
  * Callback from libvhost-user if there's a new fd we're supposed to listen
  * to, typically a queue kick?
@@ -902,6 +907,7 @@ static const VuDevIface fv_iface = {
     .get_features = fv_get_features,
     .set_features = fv_set_features,
 
+    .get_protocol_features = fv_get_protocol_features,
     /* Don't need process message, we've not got any at vhost-user level */
     .queue_set_started = fv_queue_set_started,
 
-- 
2.25.4

