Return-Path: <liuyd.fnst@fujitsu.com>
From: Liu Yiding <liuyd.fnst@fujitsu.com>
Date: Thu, 21 Apr 2022 17:51:51 +0800
Message-ID: <20220421095151.2231099-1-liuyd.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Subject: [Virtio-fs] [PATCH] virtiofsd: Add docs/helper for
 killpriv_v2/no_killpriv_v2 option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Liu Yiding <liuyd.fnst@fujitsu.com>

virtiofsd has introduced killpriv_v2/no_killpriv_v2 for a while. Add
description of it to docs/helper.

Signed-off-by: Liu Yiding <liuyd.fnst@fujitsu.com>
---
 docs/tools/virtiofsd.rst | 5 +++++
 tools/virtiofsd/helper.c | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
index 0c0560203c..85398cce09 100644
--- a/docs/tools/virtiofsd.rst
+++ b/docs/tools/virtiofsd.rst
@@ -111,6 +111,11 @@ Options
     label. Server will try to set that label on newly created file
     atomically wherever possible.
 
+  * killpriv_v2|no_killpriv_v2 -
+    Enable/disable ``FUSE_HANDLE_KILLPRIV_V2`` support. KILLPRIV_V2 is enabled
+    by default as long as client supports it.  Enabling this option helps with
+    performance in write path.
+
 .. option:: --socket-path=PATH
 
   Listen on vhost-user UNIX domain socket at PATH.
diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
index e226fc590f..f8981e5bdf 100644
--- a/tools/virtiofsd/helper.c
+++ b/tools/virtiofsd/helper.c
@@ -188,6 +188,9 @@ void fuse_cmdline_help(void)
            "    -o announce_submounts      Announce sub-mount points to the guest\n"
            "    -o posix_acl/no_posix_acl  Enable/Disable posix_acl. (default: disabled)\n"
            "    -o security_label/no_security_label  Enable/Disable security label. (default: disabled)\n"
+           "    -o killpriv_v2/no_killpriv_v2\n"
+           "                               Enable/Disable FUSE_HANDLE_KILLPRIV_V2.\n"
+           "                               (default: enabled as long as client supports it)\n"
            );
 }
 
-- 
2.31.1



