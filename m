From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue, 16 Feb 2021 18:37:29 +0000
Message-Id: <20210216183734.57810-2-dgilbert@redhat.com>
In-Reply-To: <20210216183734.57810-1-dgilbert@redhat.com>
References: <20210216183734.57810-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 1/6] virtiofsd: Allow to build it without the
	tools
List-Id: Development discussions about virtio-fs <virtio-fs.listman.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@listman.redhat.com>
List-Help: <mailto:virtio-fs-request@listman.redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, wainersm@redhat.com, groug@kaod.org, philmd@redhat.com, vgoyal@redhat.com
Cc: virtio-fs@redhat.com

From: Wainer dos Santos Moschetta <wainersm@redhat.com>

This changed the Meson build script to allow virtiofsd be built even
though the tools build is disabled, thus honoring the --enable-virtiofsd
option.

Fixes: cece116c939d219070b250338439c2d16f94e3da (configure: add option for virtiofsd)
Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
Message-Id: <20210201211456.1133364-2-wainersm@redhat.com>
Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/meson.build | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/meson.build b/tools/meson.build
index fdce66857d..3e5a0abfa2 100644
--- a/tools/meson.build
+++ b/tools/meson.build
@@ -10,8 +10,11 @@ if get_option('virtiofsd').enabled()
       error('virtiofsd requires Linux')
     elif not seccomp.found() or not libcap_ng.found()
       error('virtiofsd requires libcap-ng-devel and seccomp-devel')
-    elif not have_tools or 'CONFIG_VHOST_USER' not in config_host
-      error('virtiofsd needs tools and vhost-user support')
+    elif 'CONFIG_VHOST_USER' not in config_host
+      error('virtiofsd needs vhost-user support')
+    else
+      # Disabled all the tools but virtiofsd.
+      have_virtiofsd = true
     endif
   endif
 elif get_option('virtiofsd').disabled() or not have_system
-- 
2.29.2

