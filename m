Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:51:41 +0100
Message-Id: <20221205095228.1314-5-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 04/51] hw/display/qxl: Have qxl_log_command
 Return early if no log_cmd handler
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Fam Zheng <fam@euphon.net>, Thomas Huth <huth@tuxfamily.org>, Viresh Kumar <viresh.kumar@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Laurent Vivier <laurent@vivier.eu>, Eric Blake <eblake@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>, Thomas Huth <thuth@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Peter Maydell <peter.maydell@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Song Gao <gaosong@loongson.cn>, qemu-s390x@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Klaus Jensen <its@irrelevant.dk>, John Snow <jsnow@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Keith Busch <kbusch@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-trivial@nongnu.org, Hanna Reitz <hreitz@redhat.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>

From: Philippe Mathieu-Daudé <philmd@linaro.org>

Only 3 command types are logged: no need to call qxl_phys2virt()
for the other types. Using different cases will help to pass
different structure sizes to qxl_phys2virt() in a pair of commits.

Reviewed-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20221128202741.4945-2-philmd@linaro.org>
---
 hw/display/qxl-logger.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/hw/display/qxl-logger.c b/hw/display/qxl-logger.c
index 68bfa47568..1bcf803db6 100644
--- a/hw/display/qxl-logger.c
+++ b/hw/display/qxl-logger.c
@@ -247,6 +247,16 @@ int qxl_log_command(PCIQXLDevice *qxl, const char *ring, QXLCommandExt *ext)
             qxl_name(qxl_type, ext->cmd.type),
             compat ? "(compat)" : "");
 
+    switch (ext->cmd.type) {
+    case QXL_CMD_DRAW:
+        break;
+    case QXL_CMD_SURFACE:
+        break;
+    case QXL_CMD_CURSOR:
+        break;
+    default:
+        goto out;
+    }
     data = qxl_phys2virt(qxl, ext->cmd.data, ext->group_id);
     if (!data) {
         return 1;
@@ -269,6 +279,7 @@ int qxl_log_command(PCIQXLDevice *qxl, const char *ring, QXLCommandExt *ext)
         qxl_log_cmd_cursor(qxl, data, ext->group_id);
         break;
     }
+out:
     fprintf(stderr, "\n");
     return 0;
 }
-- 
2.38.1

