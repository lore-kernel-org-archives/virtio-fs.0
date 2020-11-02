From: Max Reitz <mreitz@redhat.com>
Date: Mon,  2 Nov 2020 17:18:58 +0100
Message-Id: <20201102161859.156603-7-mreitz@redhat.com>
In-Reply-To: <20201102161859.156603-1-mreitz@redhat.com>
References: <20201102161859.156603-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 6/7] tests/acceptance/boot_linux: Accept SSH
	pubkey
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Eduardo Habkost <ehabkost@redhat.com>, Max Reitz <mreitz@redhat.com>, virtio-fs@redhat.com

Let download_cloudinit() take an optional pubkey, which subclasses of
BootLinux can pass through setUp().

Signed-off-by: Max Reitz <mreitz@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Reviewed-by: Willian Rampazzo <willianr@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tests/acceptance/boot_linux.py | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/tests/acceptance/boot_linux.py b/tests/acceptance/boot_linux.py
index c743e231f4..1da4a53d6a 100644
--- a/tests/acceptance/boot_linux.py
+++ b/tests/acceptance/boot_linux.py
@@ -57,7 +57,7 @@ class BootLinuxBase(Test):
             self.cancel('Failed to download/prepare boot image')
         return boot.path
 
-    def download_cloudinit(self):
+    def download_cloudinit(self, ssh_pubkey=None):
         self.log.info('Preparing cloudinit image')
         try:
             cloudinit_iso = os.path.join(self.workdir, 'cloudinit.iso')
@@ -67,7 +67,8 @@ class BootLinuxBase(Test):
                           password='password',
                           # QEMU's hard coded usermode router address
                           phone_home_host='10.0.2.2',
-                          phone_home_port=self.phone_home_port)
+                          phone_home_port=self.phone_home_port,
+                          authorized_key=ssh_pubkey)
         except Exception:
             self.cancel('Failed to prepared cloudinit image')
         return cloudinit_iso
@@ -80,19 +81,19 @@ class BootLinux(BootLinuxBase):
     timeout = 900
     chksum = None
 
-    def setUp(self):
+    def setUp(self, ssh_pubkey=None):
         super(BootLinux, self).setUp()
         self.vm.add_args('-smp', '2')
         self.vm.add_args('-m', '1024')
         self.prepare_boot()
-        self.prepare_cloudinit()
+        self.prepare_cloudinit(ssh_pubkey)
 
     def prepare_boot(self):
         path = self.download_boot()
         self.vm.add_args('-drive', 'file=%s' % path)
 
-    def prepare_cloudinit(self):
-        cloudinit_iso = self.download_cloudinit()
+    def prepare_cloudinit(self, ssh_pubkey=None):
+        cloudinit_iso = self.download_cloudinit(ssh_pubkey)
         self.vm.add_args('-drive', 'file=%s,format=raw' % cloudinit_iso)
 
     def launch_and_wait(self):
-- 
2.26.2

