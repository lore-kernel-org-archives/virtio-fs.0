From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Tue, 27 Aug 2019 10:54:36 +0100
Message-Id: <20190827095437.18819-4-stefanha@redhat.com>
In-Reply-To: <20190827095437.18819-1-stefanha@redhat.com>
References: <20190827095437.18819-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/4] virtiofsd: install virtiofsd in libexec
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org
Cc: =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>

Build and install virtiofsd on Linux hosts.  This is also how
vhost-user-gpu is handled.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index a3dfdd6fa8..ef6eca07cc 100644
--- a/Makefile
+++ b/Makefile
@@ -317,6 +317,8 @@ HELPERS-y =
 HELPERS-$(call land,$(CONFIG_SOFTMMU),$(CONFIG_LINUX)) = qemu-bridge-helper$(EXESUF)
 
 ifdef CONFIG_LINUX
+HELPERS-y += virtiofsd$(EXESUF)
+
 ifdef CONFIG_VIRGL
 ifdef CONFIG_GBM
 HELPERS-y += vhost-user-gpu$(EXESUF)
-- 
2.21.0

