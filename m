From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Date: Wed, 28 Apr 2021 16:48:13 +0200
Message-Id: <20210428144813.417170-3-philmd@redhat.com>
In-Reply-To: <20210428144813.417170-1-philmd@redhat.com>
References: <20210428144813.417170-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/2] util/meson: Build
	iov/hexdump/buffer_is_zero with virtiofsd
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

When not explicitly select a sysemu target or the QEMU tools and
building virtiofsd, libqemuutil.a has missing symbols:

  /usr/bin/ld: tools/virtiofsd/virtiofsd.p/fuse_virtio.c.o: in function `virtio_send_msg':
  tools/virtiofsd/fuse_virtio.c:236: undefined reference to `iov_size'

  /usr/bin/ld: libqemuutil.a(util_iov.c.o): in function `iov_hexdump':
  util/iov.c:240: undefined reference to `qemu_hexdump'

  /usr/bin/ld: libqemuutil.a(util_iov.c.o): in function `qemu_iovec_is_zero':
  util/iov.c:494: undefined reference to `buffer_is_zero'

Fix by linking bufferiszero/hexdump/iov objects when building
virtiofsd (regardless of sysemu / tools).

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 util/meson.build | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/util/meson.build b/util/meson.build
index 510765cde46..c2eda2d1374 100644
--- a/util/meson.build
+++ b/util/meson.build
@@ -59,12 +59,10 @@
   util_ss.add(files('aiocb.c', 'async.c', 'aio-wait.c'))
   util_ss.add(files('base64.c'))
   util_ss.add(files('buffer.c'))
-  util_ss.add(files('bufferiszero.c'))
   util_ss.add(files('coroutine-@0@.c'.format(config_host['CONFIG_COROUTINE_BACKEND'])))
   util_ss.add(files('hbitmap.c'))
-  util_ss.add(files('hexdump.c'))
   util_ss.add(files('iova-tree.c'))
-  util_ss.add(files('iov.c', 'qemu-sockets.c', 'uri.c'))
+  util_ss.add(files('qemu-sockets.c', 'uri.c'))
   util_ss.add(files('lockcnt.c'))
   util_ss.add(files('main-loop.c'))
   util_ss.add(files('nvdimm-utils.c'))
@@ -83,3 +81,9 @@
                                         if_false: files('filemonitor-stub.c'))
   util_ss.add(when: 'CONFIG_LINUX', if_true: files('vfio-helpers.c'))
 endif
+
+if have_block or config_host.has_key('CONFIG_VHOST_USER_FS')
+  util_ss.add(files('hexdump.c'))
+  util_ss.add(files('bufferiszero.c'))
+  util_ss.add(files('iov.c'))
+endif
-- 
2.26.3

