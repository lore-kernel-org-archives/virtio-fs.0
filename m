From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:39 +0100
Message-Id: <20201216211125.19496-3-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 02/48] ArmVirtPkg: include VirtioFsDxe in
	the ArmVirtQemu* platforms
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: devel@edk2.groups.io, virtio-fs@redhat.com, lersek@redhat.com
Cc: Leif Lindholm <leif@nuviainc.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>, Ard Biesheuvel <ard.biesheuvel@arm.com>

Include the VirtioFsDxe driver in the ArmVirtPkg platforms that include
Virtio10Dxe. (The virtio-fs device is virtio-1.0-only.)

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Leif Lindholm <leif@nuviainc.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 ArmVirtPkg/ArmVirtQemu.dsc           | 3 ++-
 ArmVirtPkg/ArmVirtQemuKernel.dsc     | 3 ++-
 ArmVirtPkg/ArmVirtQemuFvMain.fdf.inc | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/ArmVirtPkg/ArmVirtQemu.dsc b/ArmVirtPkg/ArmVirtQemu.dsc
index 365426bd7dfd..ef5d6dbeaddc 100644
--- a/ArmVirtPkg/ArmVirtQemu.dsc
+++ b/ArmVirtPkg/ArmVirtQemu.dsc
@@ -403,23 +403,24 @@ [Components.common]
   ArmVirtPkg/FdtClientDxe/FdtClientDxe.inf
   ArmVirtPkg/HighMemDxe/HighMemDxe.inf
   OvmfPkg/VirtioBlkDxe/VirtioBlk.inf
   OvmfPkg/VirtioScsiDxe/VirtioScsi.inf
   OvmfPkg/VirtioNetDxe/VirtioNet.inf
   OvmfPkg/VirtioRngDxe/VirtioRng.inf
 
   #
-  # FAT filesystem + GPT/MBR partitioning + UDF filesystem
+  # FAT filesystem + GPT/MBR partitioning + UDF filesystem + virtio-fs
   #
   MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.inf
   MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.inf
   MdeModulePkg/Universal/Disk/UnicodeCollation/EnglishDxe/EnglishDxe.inf
   FatPkg/EnhancedFatDxe/Fat.inf
   MdeModulePkg/Universal/Disk/UdfDxe/UdfDxe.inf
+  OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
 
   #
   # Bds
   #
   MdeModulePkg/Universal/DevicePathDxe/DevicePathDxe.inf {
     <LibraryClasses>
       DevicePathLib|MdePkg/Library/UefiDevicePathLib/UefiDevicePathLib.inf
       PcdLib|MdePkg/Library/BasePcdLibNull/BasePcdLibNull.inf
diff --git a/ArmVirtPkg/ArmVirtQemuKernel.dsc b/ArmVirtPkg/ArmVirtQemuKernel.dsc
index f447c62f6898..f8f5f7f4b94b 100644
--- a/ArmVirtPkg/ArmVirtQemuKernel.dsc
+++ b/ArmVirtPkg/ArmVirtQemuKernel.dsc
@@ -339,23 +339,24 @@ [Components.common]
   ArmVirtPkg/FdtClientDxe/FdtClientDxe.inf
   ArmVirtPkg/HighMemDxe/HighMemDxe.inf
   OvmfPkg/VirtioBlkDxe/VirtioBlk.inf
   OvmfPkg/VirtioScsiDxe/VirtioScsi.inf
   OvmfPkg/VirtioNetDxe/VirtioNet.inf
   OvmfPkg/VirtioRngDxe/VirtioRng.inf
 
   #
-  # FAT filesystem + GPT/MBR partitioning + UDF filesystem
+  # FAT filesystem + GPT/MBR partitioning + UDF filesystem + virtio-fs
   #
   MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.inf
   MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.inf
   MdeModulePkg/Universal/Disk/UnicodeCollation/EnglishDxe/EnglishDxe.inf
   FatPkg/EnhancedFatDxe/Fat.inf
   MdeModulePkg/Universal/Disk/UdfDxe/UdfDxe.inf
+  OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
 
   #
   # Bds
   #
   MdeModulePkg/Universal/DevicePathDxe/DevicePathDxe.inf {
     <LibraryClasses>
       DevicePathLib|MdePkg/Library/UefiDevicePathLib/UefiDevicePathLib.inf
       PcdLib|MdePkg/Library/BasePcdLibNull/BasePcdLibNull.inf
diff --git a/ArmVirtPkg/ArmVirtQemuFvMain.fdf.inc b/ArmVirtPkg/ArmVirtQemuFvMain.fdf.inc
index 6eade7e50ff7..1752fee12b79 100644
--- a/ArmVirtPkg/ArmVirtQemuFvMain.fdf.inc
+++ b/ArmVirtPkg/ArmVirtQemuFvMain.fdf.inc
@@ -72,23 +72,24 @@ [FV.FvMain]
   INF MdeModulePkg/Universal/SerialDxe/SerialDxe.inf
 
   INF ArmPkg/Drivers/ArmGic/ArmGicDxe.inf
   INF ArmPkg/Drivers/TimerDxe/TimerDxe.inf
   INF ArmPlatformPkg/Drivers/NorFlashDxe/NorFlashDxe.inf
   INF MdeModulePkg/Universal/WatchdogTimerDxe/WatchdogTimer.inf
 
   #
-  # FAT filesystem + GPT/MBR partitioning + UDF filesystem
+  # FAT filesystem + GPT/MBR partitioning + UDF filesystem + virtio-fs
   #
   INF MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.inf
   INF MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.inf
   INF FatPkg/EnhancedFatDxe/Fat.inf
   INF MdeModulePkg/Universal/Disk/UnicodeCollation/EnglishDxe/EnglishDxe.inf
   INF MdeModulePkg/Universal/Disk/UdfDxe/UdfDxe.inf
+  INF OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
 
   #
   # Status Code Routing
   #
   INF MdeModulePkg/Universal/ReportStatusCodeRouter/RuntimeDxe/ReportStatusCodeRouterRuntimeDxe.inf
 
   #
   # Platform Driver
-- 
2.19.1.3.g30247aa5d201



