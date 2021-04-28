From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Date: Wed, 28 Apr 2021 16:48:12 +0200
Message-Id: <20210428144813.417170-2-philmd@redhat.com>
In-Reply-To: <20210428144813.417170-1-philmd@redhat.com>
References: <20210428144813.417170-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/2] meson: Check for seccomp/cap-ng libraries
	if virtiofsd is enabled
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Thomas Huth <thuth@redhat.com>, "Daniel P . Berrange" <berrange@redhat.com>, virtio-fs@redhat.com, Mahmoud Mandour <ma.mandourr@gmail.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>

When not explicitly select a sysemu target and building virtiofsd,
the seccomp/cap-ng libraries are not resolved, leading to this error:

  $ configure --target-list=i386-linux-user --disable-tools --enable-virtiofsd
  tools/meson.build:12:6: ERROR: Problem encountered: virtiofsd requires libcap-ng-devel and seccomp-devel

Fix by checking the seccomp/cap-ng libraries if virtiofsd is built.

Reported-by: Mahmoud Mandour <ma.mandourr@gmail.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 meson.build | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/meson.build b/meson.build
index c6f4b0cf5e8..b466b418fed 100644
--- a/meson.build
+++ b/meson.build
@@ -393,14 +393,14 @@
 endif
 
 seccomp = not_found
-if not get_option('seccomp').auto() or have_system or have_tools
+if not get_option('seccomp').auto() or have_system or have_tools or not get_option('virtiofsd').auto()
   seccomp = dependency('libseccomp', version: '>=2.3.0',
                        required: get_option('seccomp'),
                        method: 'pkg-config', kwargs: static_kwargs)
 endif
 
 libcap_ng = not_found
-if not get_option('cap_ng').auto() or have_system or have_tools
+if not get_option('cap_ng').auto() or have_system or have_tools or not get_option('virtiofsd').auto()
   libcap_ng = cc.find_library('cap-ng', has_headers: ['cap-ng.h'],
                               required: get_option('cap_ng'),
                               kwargs: static_kwargs)
-- 
2.26.3

