Return-Path: <armbru@redhat.com>
From: Markus Armbruster <armbru@redhat.com>
Date: Mon, 28 Nov 2022 10:41:38 +0100
Message-Id: <20221128094138.2824623-4-armbru@redhat.com>
In-Reply-To: <20221128094138.2824623-1-armbru@redhat.com>
References: <20221128094138.2824623-1-armbru@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 3/3] ppc4xx_sdram: Simplify sdram_ddr_size()
 to return directly
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, philmd@linaro.org, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, berrange@redhat.com, thuth@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com, BALATON Zoltan <balaton@eik.bme.hu>

Suggested-by: BALATON Zoltan <balaton@eik.bme.hu>
Signed-off-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: BALATON Zoltan <balaton@eik.bme.hu>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/ppc/ppc4xx_sdram.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/hw/ppc/ppc4xx_sdram.c b/hw/ppc/ppc4xx_sdram.c
index 54bf9a2b44..a24c80b1d2 100644
--- a/hw/ppc/ppc4xx_sdram.c
+++ b/hw/ppc/ppc4xx_sdram.c
@@ -192,17 +192,13 @@ static inline hwaddr sdram_ddr_base(uint32_t bcr)
 
 static hwaddr sdram_ddr_size(uint32_t bcr)
 {
-    hwaddr size;
-    int sh;
+    int sh = (bcr >> 17) & 0x7;
 
-    sh = (bcr >> 17) & 0x7;
     if (sh == 7) {
-        size = -1;
-    } else {
-        size = (4 * MiB) << sh;
+        return -1;
     }
 
-    return size;
+    return (4 * MiB) << sh;
 }
 
 static uint32_t sdram_ddr_dcr_read(void *opaque, int dcrn)
-- 
2.37.3

