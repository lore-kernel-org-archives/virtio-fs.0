From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Mon, 29 Jun 2020 12:54:18 +0100
Message-Id: <20200629115420.98443-2-dgilbert@redhat.com>
In-Reply-To: <20200629115420.98443-1-dgilbert@redhat.com>
References: <20200629115420.98443-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 1/3] virtiofsd: Terminate capability list
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com, stefanha@redhat.com, vgoyal@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

capng_updatev is a varargs function that needs a -1 to terminate it,
but it was missing.

In practice what seems to have been happening is that it's added the
capabilities we asked for, then runs into junk on the stack, so if
we're unlucky it might be adding some more, but in reality it's
failing - but after adding the capabilities we asked for.

Fixes: a59feb483b8 ("virtiofsd: only retain file system capabilities")
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 2ce7c96085..e373e3b36e 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2598,7 +2598,9 @@ static void setup_capabilities(void)
             CAP_SETGID,
             CAP_SETUID,
             CAP_MKNOD,
-            CAP_SETFCAP);
+            CAP_SETFCAP,
+            -1);
+
     capng_apply(CAPNG_SELECT_BOTH);
 
     cap.saved = capng_save_state();
-- 
2.26.2

