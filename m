From: Greg Kurz <groug@kaod.org>
Date: Thu, 24 Jun 2021 12:18:09 +0200
Message-Id: <20210624101809.48032-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2] virtiofsd: Don't allow file creation with
	FUSE_OPEN
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Miklos Szeredi <miklos@szeredi.hu>, virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

A well behaved FUSE client uses FUSE_CREATE to create files. It isn't
supposed to pass O_CREAT along a FUSE_OPEN request, as documented in
the "fuse_lowlevel.h" header :

    /**
     * Open a file
     *
     * Open flags are available in fi->flags. The following rules
     * apply.
     *
     *  - Creation (O_CREAT, O_EXCL, O_NOCTTY) flags will be
     *    filtered out / handled by the kernel.

But if the client happens to do it anyway, the server ends up passing
this flag to open() without the mandatory mode_t 4th argument. Since
open() is a variadic function, glibc will happily pass whatever it
finds on the stack to the syscall. If this file is compiled with
-D_FORTIFY_SOURCE=2, glibc will even detect that and abort:

*** invalid openat64 call: O_CREAT or O_TMPFILE without mode ***: terminated

Specifying O_CREAT with FUSE_OPEN is a protocol violation. Check this
in do_open(), print out a message and return an error to the client,
EINVAL like we already do when fuse_mbuf_iter_advance() fails.

The FUSE filesystem doesn't currently support O_TMPFILE, but the very
same would happen if O_TMPFILE was passed in a FUSE_OPEN request. Check
that as well.

Signed-off-by: Greg Kurz <groug@kaod.org>
---

v2:
 - do the check in core FUSE code instead of passthrough_ll (libfuse folks)


 tools/virtiofsd/fuse_lowlevel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 7fe2cef1eb3b..3d725bcba2ca 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -1084,6 +1084,12 @@ static void do_open(fuse_req_t req, fuse_ino_t nodeid,
         return;
     }
 
+    /* File creation is handled by do_create() or do_mknod() */
+    if (arg->flags & (O_CREAT | O_TMPFILE)) {
+        fuse_reply_err(req, EINVAL);
+        return;
+    }
+
     memset(&fi, 0, sizeof(fi));
     fi.flags = arg->flags;
     fi.kill_priv = arg->open_flags & FUSE_OPEN_KILL_SUIDGID;
-- 
2.31.1

