From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Tue, 27 Aug 2019 10:54:37 +0100
Message-Id: <20190827095437.18819-5-stefanha@redhat.com>
In-Reply-To: <20190827095437.18819-1-stefanha@redhat.com>
References: <20190827095437.18819-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/4] virtiofsd: add vhost-user.json file
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

Install a vhost-user.json file describing virtiofsd.  This allows
libvirt and other management tools to enumerate vhost-user backend
programs.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 Makefile                                    | 1 +
 .gitignore                                  | 1 +
 contrib/virtiofsd/50-qemu-virtiofsd.json.in | 5 +++++
 3 files changed, 7 insertions(+)
 create mode 100644 contrib/virtiofsd/50-qemu-virtiofsd.json.in

diff --git a/Makefile b/Makefile
index ef6eca07cc..c6e2f4e7a0 100644
--- a/Makefile
+++ b/Makefile
@@ -318,6 +318,7 @@ HELPERS-$(call land,$(CONFIG_SOFTMMU),$(CONFIG_LINUX)) = qemu-bridge-helper$(EXE
 
 ifdef CONFIG_LINUX
 HELPERS-y += virtiofsd$(EXESUF)
+vhost-user-json-y += contrib/virtiofsd/50-qemu-virtiofsd.json
 
 ifdef CONFIG_VIRGL
 ifdef CONFIG_GBM
diff --git a/.gitignore b/.gitignore
index fd6e6c38c7..554c7abe81 100644
--- a/.gitignore
+++ b/.gitignore
@@ -6,6 +6,7 @@
 /config-target.*
 /config.status
 /config-temp
+/contrib/virtiofsd/50-qemu-virtiofsd.json
 /elf2dmp
 /trace-events-all
 /trace/generated-events.h
diff --git a/contrib/virtiofsd/50-qemu-virtiofsd.json.in b/contrib/virtiofsd/50-qemu-virtiofsd.json.in
new file mode 100644
index 0000000000..9bcd86f8dc
--- /dev/null
+++ b/contrib/virtiofsd/50-qemu-virtiofsd.json.in
@@ -0,0 +1,5 @@
+{
+  "description": "QEMU virtiofsd vhost-user-fs",
+  "type": "fs",
+  "binary": "@libexecdir@/virtiofsd"
+}
-- 
2.21.0

