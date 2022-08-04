Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu,  4 Aug 2022 15:02:58 -0400
Message-Id: <20220804190258.20226-2-stefanha@redhat.com>
In-Reply-To: <20220804190258.20226-1-stefanha@redhat.com>
References: <20220804190258.20226-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL for-7.1 1/1] virtiofsd: Fix format strings
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-block@nongnu.org, Richard Henderson <richard.henderson@linaro.org>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, Stefan Weil <sw@weilnetz.de>

From: Stefan Weil <sw@weilnetz.de>

Signed-off-by: Stefan Weil <sw@weilnetz.de>
Message-Id: <20220804074833.892604-1-sw@weilnetz.de>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tools/virtiofsd/fuse_lowlevel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 752928741d..2f08471627 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -2025,7 +2025,7 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
 
     fuse_log(FUSE_LOG_DEBUG, "INIT: %u.%u\n", arg->major, arg->minor);
     if (arg->major == 7 && arg->minor >= 6) {
-        fuse_log(FUSE_LOG_DEBUG, "flags=0x%016llx\n", flags);
+        fuse_log(FUSE_LOG_DEBUG, "flags=0x%016" PRIx64 "\n", flags);
         fuse_log(FUSE_LOG_DEBUG, "max_readahead=0x%08x\n", arg->max_readahead);
     }
     se->conn.proto_major = arg->major;
@@ -2174,7 +2174,7 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     if (se->conn.want & (~se->conn.capable)) {
         fuse_log(FUSE_LOG_ERR,
                  "fuse: error: filesystem requested capabilities "
-                 "0x%llx that are not supported by kernel, aborting.\n",
+                 "0x%" PRIx64 " that are not supported by kernel, aborting.\n",
                  se->conn.want & (~se->conn.capable));
         fuse_reply_err(req, EPROTO);
         se->error = -EPROTO;
-- 
2.37.1

