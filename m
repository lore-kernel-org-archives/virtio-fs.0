Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu, 20 Apr 2023 08:09:37 -0400
Message-Id: <20230420120948.436661-10-stefanha@redhat.com>
In-Reply-To: <20230420120948.436661-1-stefanha@redhat.com>
References: <20230420120948.436661-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 09/20] block/dmg: Declare a type definition for
 DMG uncompress function
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Julia Suvorova <jusual@redhat.com>, Eric Blake <eblake@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Thomas Huth <thuth@redhat.com>, qemu-block@nongnu.org, Cornelia Huck <cohuck@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Fam Zheng <fam@euphon.net>, Aarushi Mehta <mehta.aaru20@gmail.com>

From: Philippe Mathieu-Daudé <philmd@linaro.org>

Introduce the BdrvDmgUncompressFunc type defintion. To emphasis
dmg_uncompress_bz2 and dmg_uncompress_lzfse are pointer to functions,
declare them using this new typedef.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-id: 20230320152610.32052-1-philmd@linaro.org
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 block/dmg.h | 8 ++++----
 block/dmg.c | 7 ++-----
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/block/dmg.h b/block/dmg.h
index e488601b62..dcd6165e63 100644
--- a/block/dmg.h
+++ b/block/dmg.h
@@ -51,10 +51,10 @@ typedef struct BDRVDMGState {
     z_stream zstream;
 } BDRVDMGState;
 
-extern int (*dmg_uncompress_bz2)(char *next_in, unsigned int avail_in,
-                                 char *next_out, unsigned int avail_out);
+typedef int BdrvDmgUncompressFunc(char *next_in, unsigned int avail_in,
+                                  char *next_out, unsigned int avail_out);
 
-extern int (*dmg_uncompress_lzfse)(char *next_in, unsigned int avail_in,
-                                   char *next_out, unsigned int avail_out);
+extern BdrvDmgUncompressFunc *dmg_uncompress_bz2;
+extern BdrvDmgUncompressFunc *dmg_uncompress_lzfse;
 
 #endif
diff --git a/block/dmg.c b/block/dmg.c
index e10b9a2ba5..2769900359 100644
--- a/block/dmg.c
+++ b/block/dmg.c
@@ -31,11 +31,8 @@
 #include "qemu/memalign.h"
 #include "dmg.h"
 
-int (*dmg_uncompress_bz2)(char *next_in, unsigned int avail_in,
-                          char *next_out, unsigned int avail_out);
-
-int (*dmg_uncompress_lzfse)(char *next_in, unsigned int avail_in,
-                            char *next_out, unsigned int avail_out);
+BdrvDmgUncompressFunc *dmg_uncompress_bz2;
+BdrvDmgUncompressFunc *dmg_uncompress_lzfse;
 
 enum {
     /* Limit chunk sizes to prevent unreasonable amounts of memory being used
-- 
2.39.2

