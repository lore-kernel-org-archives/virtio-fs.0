From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Mon, 26 Oct 2020 18:43:22 +0000
Message-Id: <20201026184331.272953-8-dgilbert@redhat.com>
In-Reply-To: <20201026184331.272953-1-dgilbert@redhat.com>
References: <20201026184331.272953-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 07/16] tools/virtiofsd: xattr name mapping
	examples
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, mreitz@redhat.com, misono.tomohiro@jp.fujitsu.com
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Add a few examples of xattrmaps to the documentation.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20201023165812.36028-5-dgilbert@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 docs/tools/virtiofsd.rst | 50 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
index 67c16f9df0..d80c078d80 100644
--- a/docs/tools/virtiofsd.rst
+++ b/docs/tools/virtiofsd.rst
@@ -219,6 +219,56 @@ e.g.:
 
   would hide 'security.' xattr's in listxattr from the server.
 
+xattr-mapping Examples
+----------------------
+
+1) Prefix all attributes with 'user.virtiofs.'
+
+::
+
+-o xattrmap=":prefix:all::user.virtiofs.::bad:all:::"
+
+
+This uses two rules, using : as the field separator;
+the first rule prefixes and strips 'user.virtiofs.',
+the second rule hides any non-prefixed attributes that
+the host set.
+
+2) Prefix 'trusted.' attributes, allow others through
+
+::
+
+   "/prefix/all/trusted./user.virtiofs./
+    /bad/server//trusted./
+    /bad/client/user.virtiofs.//
+    /ok/all///"
+
+
+Here there are four rules, using / as the field
+separator, and also demonstrating that new lines can
+be included between rules.
+The first rule is the prefixing of 'trusted.' and
+stripping of 'user.virtiofs.'.
+The second rule hides unprefixed 'trusted.' attributes
+on the host.
+The third rule stops a guest from explicitly setting
+the 'user.virtiofs.' path directly.
+Finally, the fourth rule lets all remaining attributes
+through.
+
+3) Hide 'security.' attributes, and allow everything else
+
+::
+
+    "/bad/all/security./security./
+     /ok/all///'
+
+The first rule combines what could be separate client and server
+rules into a single 'all' rule, matching 'security.' in either
+client arguments or lists returned from the host.  This stops
+the client seeing any 'security.' attributes on the server and
+stops it setting any.
+
 Examples
 --------
 
-- 
2.28.0

