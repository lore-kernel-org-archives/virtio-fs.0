Date: Wed, 3 Mar 2021 14:53:39 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210303195339.GB3793@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PATCH] virtiofsd: Add qemu version and copyright info
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

Option "-V" currently displays the fuse protocol version virtiofsd is
using. For example, I see this.

$ ./virtiofsd -V
"using FUSE kernel interface version 7.33"

People also want to know software version of virtiofsd so that they can
figure out if a certain fix is part of currently running virtiofsd or
not. Eric Ernst ran into this issue.

David Gilbert thinks that it probably is best that we simply carry the
qemu version and display that information given we are part of qemu
tree. 

So this patch enhances version information and also adds qemu version
and copyright info. Not sure if copyright information is supposed
to be displayed along with version info. Given qemu-storage-daemon
and other utilities are doing it, so I continued with same pattern.
This is how now output looks like.

$ ./virtiofsd -V
virtiofsd version 5.2.50 (v5.2.0-2357-gcbcf09872a-dirty)
Copyright (c) 2003-2020 Fabrice Bellard and the QEMU Project developers
using FUSE kernel interface version 7.33

Reported-by: Eric Ernst <eric.g.ernst@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c
===================================================================
--- rhvgoyal-qemu.orig/tools/virtiofsd/passthrough_ll.c	2021-03-03 14:28:04.893672524 -0500
+++ rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c	2021-03-03 14:37:29.381712706 -0500
@@ -37,6 +37,8 @@
 
 #include "qemu/osdep.h"
 #include "qemu/timer.h"
+#include "qemu-version.h"
+#include "qemu-common.h"
 #include "fuse_virtio.h"
 #include "fuse_log.h"
 #include "fuse_lowlevel.h"
@@ -3591,6 +3593,11 @@ static void fuse_lo_data_cleanup(struct
     free(lo->source);
 }
 
+static void qemu_version(void)
+{
+    printf("virtiofsd version " QEMU_FULL_VERSION "\n" QEMU_COPYRIGHT "\n");
+}
+
 int main(int argc, char *argv[])
 {
     struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
@@ -3662,6 +3669,7 @@ int main(int argc, char *argv[])
         ret = 0;
         goto err_out1;
     } else if (opts.show_version) {
+        qemu_version();
         fuse_lowlevel_version();
         ret = 0;
         goto err_out1;

