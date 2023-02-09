Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu,  9 Feb 2023 10:25:20 -0500
Message-Id: <20230209152520.434183-7-stefanha@redhat.com>
In-Reply-To: <20230209152520.434183-1-stefanha@redhat.com>
References: <20230209152520.434183-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 6/6] iotests/detect-zeroes-registered-buf: add
 new test
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Eric Blake <eblake@redhat.com>

This regression test demonstrates that detect-zeroes works with
registered buffers. Bug details:
https://gitlab.com/qemu-project/qemu/-/issues/1404

Reviewed-by: Eric Blake <eblake@redhat.com>
Reviewed-by: Hanna Czenczek <hreitz@redhat.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20230207203719.242926-5-stefanha@redhat.com>
---
 .../tests/detect-zeroes-registered-buf        | 58 +++++++++++++++++++
 .../tests/detect-zeroes-registered-buf.out    |  7 +++
 2 files changed, 65 insertions(+)
 create mode 100755 tests/qemu-iotests/tests/detect-zeroes-registered-buf
 create mode 100644 tests/qemu-iotests/tests/detect-zeroes-registered-buf.out

diff --git a/tests/qemu-iotests/tests/detect-zeroes-registered-buf b/tests/qemu-iotests/tests/detect-zeroes-registered-buf
new file mode 100755
index 0000000000..edb5f2cee5
--- /dev/null
+++ b/tests/qemu-iotests/tests/detect-zeroes-registered-buf
@@ -0,0 +1,58 @@
+#!/usr/bin/env bash
+# group: rw auto quick
+#
+# Check that detect-zeroes=unmap works on writes with registered I/O buffers.
+# This is a regression test for
+# https://gitlab.com/qemu-project/qemu/-/issues/1404 where I/O requests failed
+# unexpectedly.
+#
+# Copyright Red Hat
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program.  If not, see <http://www.gnu.org/licenses/>.
+#
+
+# creator
+owner=stefanha@redhat.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+status=1	# failure is the default!
+
+_cleanup()
+{
+	_cleanup_test_img
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+cd ..
+. ./common.rc
+. ./common.filter
+
+_supported_fmt qcow2
+_supported_proto generic
+
+size=128M
+_make_test_img $size
+IMGSPEC="driver=$IMGFMT,file.filename=$TEST_IMG,discard=unmap,detect-zeroes=unmap"
+
+echo
+echo "== writing zero buffer to image =="
+QEMU_IO_OPTIONS="$QEMU_IO_OPTIONS_NO_FMT" $QEMU_IO -c "write -r -P 0 0 4k" --image-opts "$IMGSPEC" | _filter_qemu_io
+
+# success, all done
+echo "*** done"
+rm -f $seq.full
+status=0
diff --git a/tests/qemu-iotests/tests/detect-zeroes-registered-buf.out b/tests/qemu-iotests/tests/detect-zeroes-registered-buf.out
new file mode 100644
index 0000000000..42c56fcc8d
--- /dev/null
+++ b/tests/qemu-iotests/tests/detect-zeroes-registered-buf.out
@@ -0,0 +1,7 @@
+QA output created by detect-zeroes-registered-buf
+Formatting 'TEST_DIR/t.IMGFMT', fmt=IMGFMT size=134217728
+
+== writing zero buffer to image ==
+wrote 4096/4096 bytes at offset 0
+4 KiB, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+*** done
-- 
2.39.1

