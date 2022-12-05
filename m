Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:52:01 +0100
Message-Id: <20221205095228.1314-25-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 24/51] hw/loongarch/virt: Add cfi01 pflash
 device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Fam Zheng <fam@euphon.net>, Thomas Huth <huth@tuxfamily.org>, Viresh Kumar <viresh.kumar@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Laurent Vivier <laurent@vivier.eu>, Eric Blake <eblake@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>, Thomas Huth <thuth@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Peter Maydell <peter.maydell@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Song Gao <gaosong@loongson.cn>, qemu-s390x@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Klaus Jensen <its@irrelevant.dk>, John Snow <jsnow@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Keith Busch <kbusch@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-trivial@nongnu.org, Hanna Reitz <hreitz@redhat.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>

From: Xiaojuan Yang <yangxiaojuan@loongson.cn>

Add cfi01 pflash device for LoongArch virt machine

Signed-off-by: Xiaojuan Yang <yangxiaojuan@loongson.cn>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20221130100647.398565-1-yangxiaojuan@loongson.cn>
Signed-off-by: Song Gao <gaosong@loongson.cn>
---
 include/hw/loongarch/virt.h |  5 +++
 hw/loongarch/acpi-build.c   | 18 +++++++++++
 hw/loongarch/virt.c         | 62 +++++++++++++++++++++++++++++++++++++
 hw/loongarch/Kconfig        |  1 +
 4 files changed, 86 insertions(+)

diff --git a/include/hw/loongarch/virt.h b/include/hw/loongarch/virt.h
index 45c383f5a7..f5f818894e 100644
--- a/include/hw/loongarch/virt.h
+++ b/include/hw/loongarch/virt.h
@@ -12,6 +12,7 @@
 #include "hw/boards.h"
 #include "qemu/queue.h"
 #include "hw/intc/loongarch_ipi.h"
+#include "hw/block/flash.h"
 
 #define LOONGARCH_MAX_VCPUS     4
 
@@ -20,6 +21,9 @@
 #define VIRT_FWCFG_BASE         0x1e020000UL
 #define VIRT_BIOS_BASE          0x1c000000UL
 #define VIRT_BIOS_SIZE          (4 * MiB)
+#define VIRT_FLASH_SECTOR_SIZE  (128 * KiB)
+#define VIRT_FLASH_BASE         0x1d000000UL
+#define VIRT_FLASH_SIZE         (16 * MiB)
 
 #define VIRT_LOWMEM_BASE        0
 #define VIRT_LOWMEM_SIZE        0x10000000
@@ -48,6 +52,7 @@ struct LoongArchMachineState {
     int          fdt_size;
     DeviceState *platform_bus_dev;
     PCIBus       *pci_bus;
+    PFlashCFI01  *flash;
 };
 
 #define TYPE_LOONGARCH_MACHINE  MACHINE_TYPE_NAME("virt")
diff --git a/hw/loongarch/acpi-build.c b/hw/loongarch/acpi-build.c
index 7d5f5a757d..c2b237736d 100644
--- a/hw/loongarch/acpi-build.c
+++ b/hw/loongarch/acpi-build.c
@@ -279,6 +279,23 @@ static void build_pci_device_aml(Aml *scope, LoongArchMachineState *lams)
     acpi_dsdt_add_gpex(scope, &cfg);
 }
 
+static void build_flash_aml(Aml *scope, LoongArchMachineState *lams)
+{
+    Aml *dev, *crs;
+
+    hwaddr flash_base = VIRT_FLASH_BASE;
+    hwaddr flash_size = VIRT_FLASH_SIZE;
+
+    dev = aml_device("FLS0");
+    aml_append(dev, aml_name_decl("_HID", aml_string("LNRO0015")));
+    aml_append(dev, aml_name_decl("_UID", aml_int(0)));
+
+    crs = aml_resource_template();
+    aml_append(crs, aml_memory32_fixed(flash_base, flash_size, AML_READ_WRITE));
+    aml_append(dev, aml_name_decl("_CRS", crs));
+    aml_append(scope, dev);
+}
+
 #ifdef CONFIG_TPM
 static void acpi_dsdt_add_tpm(Aml *scope, LoongArchMachineState *vms)
 {
@@ -328,6 +345,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker, MachineState *machine)
     build_uart_device_aml(dsdt);
     build_pci_device_aml(dsdt, lams);
     build_la_ged_aml(dsdt, machine);
+    build_flash_aml(dsdt, lams);
 #ifdef CONFIG_TPM
     acpi_dsdt_add_tpm(dsdt, lams);
 #endif
diff --git a/hw/loongarch/virt.c b/hw/loongarch/virt.c
index 958be74fa1..c8a495ea30 100644
--- a/hw/loongarch/virt.c
+++ b/hw/loongarch/virt.c
@@ -42,6 +42,63 @@
 #include "hw/display/ramfb.h"
 #include "hw/mem/pc-dimm.h"
 #include "sysemu/tpm.h"
+#include "sysemu/block-backend.h"
+#include "hw/block/flash.h"
+
+static void virt_flash_create(LoongArchMachineState *lams)
+{
+    DeviceState *dev = qdev_new(TYPE_PFLASH_CFI01);
+
+    qdev_prop_set_uint64(dev, "sector-length", VIRT_FLASH_SECTOR_SIZE);
+    qdev_prop_set_uint8(dev, "width", 4);
+    qdev_prop_set_uint8(dev, "device-width", 2);
+    qdev_prop_set_bit(dev, "big-endian", false);
+    qdev_prop_set_uint16(dev, "id0", 0x89);
+    qdev_prop_set_uint16(dev, "id1", 0x18);
+    qdev_prop_set_uint16(dev, "id2", 0x00);
+    qdev_prop_set_uint16(dev, "id3", 0x00);
+    qdev_prop_set_string(dev, "name", "virt.flash");
+    object_property_add_child(OBJECT(lams), "virt.flash", OBJECT(dev));
+    object_property_add_alias(OBJECT(lams), "pflash",
+                              OBJECT(dev), "drive");
+
+    lams->flash = PFLASH_CFI01(dev);
+}
+
+static void virt_flash_map(LoongArchMachineState *lams,
+                           MemoryRegion *sysmem)
+{
+    PFlashCFI01 *flash = lams->flash;
+    DeviceState *dev = DEVICE(flash);
+    hwaddr base = VIRT_FLASH_BASE;
+    hwaddr size = VIRT_FLASH_SIZE;
+
+    assert(QEMU_IS_ALIGNED(size, VIRT_FLASH_SECTOR_SIZE));
+    assert(size / VIRT_FLASH_SECTOR_SIZE <= UINT32_MAX);
+
+    qdev_prop_set_uint32(dev, "num-blocks", size / VIRT_FLASH_SECTOR_SIZE);
+    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
+    memory_region_add_subregion(sysmem, base,
+                                sysbus_mmio_get_region(SYS_BUS_DEVICE(dev), 0));
+
+}
+
+static void fdt_add_flash_node(LoongArchMachineState *lams)
+{
+    MachineState *ms = MACHINE(lams);
+    char *nodename;
+
+    hwaddr flash_base = VIRT_FLASH_BASE;
+    hwaddr flash_size = VIRT_FLASH_SIZE;
+
+    nodename = g_strdup_printf("/flash@%" PRIx64, flash_base);
+    qemu_fdt_add_subnode(ms->fdt, nodename);
+    qemu_fdt_setprop_string(ms->fdt, nodename, "compatible", "cfi-flash");
+    qemu_fdt_setprop_sized_cells(ms->fdt, nodename, "reg",
+                                 2, flash_base, 2, flash_size);
+    qemu_fdt_setprop_cell(ms->fdt, nodename, "bank-width", 4);
+    g_free(nodename);
+}
 
 static void fdt_add_rtc_node(LoongArchMachineState *lams)
 {
@@ -596,6 +653,9 @@ static void loongarch_firmware_init(LoongArchMachineState *lams)
     int bios_size;
 
     lams->bios_loaded = false;
+
+    virt_flash_map(lams, get_system_memory());
+
     if (filename) {
         bios_name = qemu_find_file(QEMU_FILE_TYPE_BIOS, filename);
         if (!bios_name) {
@@ -779,6 +839,7 @@ static void loongarch_init(MachineState *machine)
             loongarch_direct_kernel_boot(lams);
         }
     }
+    fdt_add_flash_node(lams);
     /* register reset function */
     for (i = 0; i < machine->smp.cpus; i++) {
         lacpu = LOONGARCH_CPU(qemu_get_cpu(i));
@@ -838,6 +899,7 @@ static void loongarch_machine_initfn(Object *obj)
     lams->acpi = ON_OFF_AUTO_AUTO;
     lams->oem_id = g_strndup(ACPI_BUILD_APPNAME6, 6);
     lams->oem_table_id = g_strndup(ACPI_BUILD_APPNAME8, 8);
+    virt_flash_create(lams);
 }
 
 static bool memhp_type_supported(DeviceState *dev)
diff --git a/hw/loongarch/Kconfig b/hw/loongarch/Kconfig
index 17d15b6c90..eb112af990 100644
--- a/hw/loongarch/Kconfig
+++ b/hw/loongarch/Kconfig
@@ -20,3 +20,4 @@ config LOONGARCH_VIRT
     select ACPI_HW_REDUCED
     select FW_CFG_DMA
     select DIMM
+    select PFLASH_CFI01
-- 
2.38.1

