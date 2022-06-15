Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Wed, 15 Jun 2022 16:51:12 +0100
Message-Id: <20220615155129.1025811-2-stefanha@redhat.com>
In-Reply-To: <20220615155129.1025811-1-stefanha@redhat.com>
References: <20220615155129.1025811-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 01/18] MAINTAINERS: update Vladimir's address and
 repositories
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Thomas Huth <thuth@redhat.com>, Jagannathan Raman <jag.raman@oracle.com>, Aarushi Mehta <mehta.aaru20@gmail.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>, Elena Ufimtseva <elena.ufimtseva@oracle.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Stefan Hajnoczi <stefanha@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, virtio-fs@redhat.com, Hanna Reitz <hreitz@redhat.com>, David Hildenbrand <david@redhat.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Eric Blake <eblake@redhat.com>, Kevin Wolf <kwolf@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Beraldo Leal <bleal@redhat.com>, Peter Xu <peterx@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Qiuhao Li <Qiuhao.Li@outlook.com>, Paolo Bonzini <pbonzini@redhat.com>, Markus Armbruster <armbru@redhat.com>, Bandan Das <bsd@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Alexander Bulekov <alxndr@bu.edu>, Julia Suvorova <jusual@redhat.com>, Darren Kenny <darren.kenny@oracle.com>, Wainer dos Santos Moschetta <wainersm@redhat.com>, John G Johnson <john.g.johnson@oracle.com>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>

From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>

Signed-off-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Message-id: 20220526115432.138384-1-vsementsov@yandex-team.ru
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 MAINTAINERS | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4cf6174f9f..5ba93348aa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2546,7 +2546,7 @@ F: scsi/*
 
 Block Jobs
 M: John Snow <jsnow@redhat.com>
-M: Vladimir Sementsov-Ogievskiy <v.sementsov-og@mail.ru>
+M: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
 L: qemu-block@nongnu.org
 S: Supported
 F: blockjob.c
@@ -2571,7 +2571,7 @@ F: block/aio_task.c
 F: util/qemu-co-shared-resource.c
 F: include/qemu/co-shared-resource.h
 T: git https://gitlab.com/jsnow/qemu.git jobs
-T: git https://src.openvz.org/scm/~vsementsov/qemu.git jobs
+T: git https://gitlab.com/vsementsov/qemu.git block
 
 Block QAPI, monitor, command line
 M: Markus Armbruster <armbru@redhat.com>
@@ -2592,7 +2592,7 @@ F: include/hw/cxl/
 
 Dirty Bitmaps
 M: Eric Blake <eblake@redhat.com>
-M: Vladimir Sementsov-Ogievskiy <v.sementsov-og@mail.ru>
+M: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
 R: John Snow <jsnow@redhat.com>
 L: qemu-block@nongnu.org
 S: Supported
@@ -2606,6 +2606,7 @@ F: util/hbitmap.c
 F: tests/unit/test-hbitmap.c
 F: docs/interop/bitmaps.rst
 T: git https://repo.or.cz/qemu/ericb.git bitmaps
+T: git https://gitlab.com/vsementsov/qemu.git block
 
 Character device backends
 M: Marc-André Lureau <marcandre.lureau@redhat.com>
@@ -2816,16 +2817,17 @@ F: scripts/*.py
 F: tests/*.py
 
 Benchmark util
-M: Vladimir Sementsov-Ogievskiy <v.sementsov-og@mail.ru>
+M: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
 S: Maintained
 F: scripts/simplebench/
-T: git https://src.openvz.org/scm/~vsementsov/qemu.git simplebench
+T: git https://gitlab.com/vsementsov/qemu.git simplebench
 
 Transactions helper
-M: Vladimir Sementsov-Ogievskiy <v.sementsov-og@mail.ru>
+M: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
 S: Maintained
 F: include/qemu/transactions.h
 F: util/transactions.c
+T: git https://gitlab.com/vsementsov/qemu.git block
 
 QAPI
 M: Markus Armbruster <armbru@redhat.com>
@@ -3402,7 +3404,7 @@ F: block/iscsi-opts.c
 
 Network Block Device (NBD)
 M: Eric Blake <eblake@redhat.com>
-M: Vladimir Sementsov-Ogievskiy <v.sementsov-og@mail.ru>
+M: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
 L: qemu-block@nongnu.org
 S: Maintained
 F: block/nbd*
@@ -3414,7 +3416,7 @@ F: docs/interop/nbd.txt
 F: docs/tools/qemu-nbd.rst
 F: tests/qemu-iotests/tests/*nbd*
 T: git https://repo.or.cz/qemu/ericb.git nbd
-T: git https://src.openvz.org/scm/~vsementsov/qemu.git nbd
+T: git https://gitlab.com/vsementsov/qemu.git block
 
 NFS
 M: Peter Lieven <pl@kamp.de>
@@ -3499,13 +3501,13 @@ F: block/dmg.c
 parallels
 M: Stefan Hajnoczi <stefanha@redhat.com>
 M: Denis V. Lunev <den@openvz.org>
-M: Vladimir Sementsov-Ogievskiy <v.sementsov-og@mail.ru>
+M: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
 L: qemu-block@nongnu.org
 S: Supported
 F: block/parallels.c
 F: block/parallels-ext.c
 F: docs/interop/parallels.txt
-T: git https://src.openvz.org/scm/~vsementsov/qemu.git parallels
+T: git https://gitlab.com/vsementsov/qemu.git block
 
 qed
 M: Stefan Hajnoczi <stefanha@redhat.com>
-- 
2.36.1

