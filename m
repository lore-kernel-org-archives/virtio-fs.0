Return-Path: <stefan@weilnetz.de>
From: Stefan Weil <sw@weilnetz.de>
Date: Thu,  4 Aug 2022 09:48:33 +0200
Message-Id: <20220804074833.892604-1-sw@weilnetz.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH for-7.1] virtiofsd: Fix format strings
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, David Alan Gilbert <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, Stefan Weil <sw@weilnetz.de>

Signed-off-by: Stefan Weil <sw@weilnetz.de>
---

I have also several patches which add missing G_GNUC_PRINTF.
Would such changes still be wanted for 7.1?

Regards,
Stefan Weil

 tools/virtiofsd/fuse_lowlevel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowleve=
l.c
index 752928741d..2f08471627 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -2025,7 +2025,7 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid=
,
=20
     fuse_log(FUSE_LOG_DEBUG, "INIT: %u.%u\n", arg->major, arg->minor);
     if (arg->major =3D=3D 7 && arg->minor >=3D 6) {
-        fuse_log(FUSE_LOG_DEBUG, "flags=3D0x%016llx\n", flags);
+        fuse_log(FUSE_LOG_DEBUG, "flags=3D0x%016" PRIx64 "\n", flags);
         fuse_log(FUSE_LOG_DEBUG, "max_readahead=3D0x%08x\n", arg->max_read=
ahead);
     }
     se->conn.proto_major =3D arg->major;
@@ -2174,7 +2174,7 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid=
,
     if (se->conn.want & (~se->conn.capable)) {
         fuse_log(FUSE_LOG_ERR,
                  "fuse: error: filesystem requested capabilities "
-                 "0x%llx that are not supported by kernel, aborting.\n",
+                 "0x%" PRIx64 " that are not supported by kernel, aborting=
.\n",
                  se->conn.want & (~se->conn.capable));
         fuse_reply_err(req, EPROTO);
         se->error =3D -EPROTO;
--=20
2.30.2

