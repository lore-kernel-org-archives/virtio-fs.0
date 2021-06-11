From: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Date: Fri, 11 Jun 2021 13:04:27 +0100
Message-Id: <20210611120427.49736-1-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] docs: describe the security considerations with
	virtiofsd xattr mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>

Different guest xattr prefixes have distinct access control rules applied
by the guest. When remapping a guest xattr care must be taken that the
remapping does not allow the a guest user to bypass guest kernel access
control rules.

For example if 'trusted.*' which requires CAP_SYS_ADMIN is remapped
to 'user.virtiofs.trusted.*', an unprivileged guest user which can
write to 'user.*' can bypass the CAP_SYS_ADMIN control. Thus the
target of any remapping must be explicitly blocked from read/writes
by the guest, to prevent access control bypass.

The examples shown in the virtiofsd man page already do the right
thing and ensure safety, but the security implications of getting
this wrong were not made explicit. This could lead to host admins
and apps unwittingly creating insecure configurations.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
---
 docs/tools/virtiofsd.rst | 55 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 50 insertions(+), 5 deletions(-)

diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
index 00554c75bd..6370ab927c 100644
--- a/docs/tools/virtiofsd.rst
+++ b/docs/tools/virtiofsd.rst
@@ -127,8 +127,8 @@ Options
   timeout.  ``always`` sets a long cache lifetime at the expense of coherency.
   The default is ``auto``.
 
-xattr-mapping
--------------
+Extended attribute (xattr) mapping
+----------------------------------
 
 By default the name of xattr's used by the client are passed through to the server
 file system.  This can be a problem where either those xattr names are used
@@ -136,6 +136,9 @@ by something on the server (e.g. selinux client/server confusion) or if the
 virtiofsd is running in a container with restricted privileges where it cannot
 access some attributes.
 
+Mapping syntax
+~~~~~~~~~~~~~~
+
 A mapping of xattr names can be made using -o xattrmap=mapping where the ``mapping``
 string consists of a series of rules.
 
@@ -232,8 +235,48 @@ Note: When the 'security.capability' xattr is remapped, the daemon has to do
 extra work to remove it during many operations, which the host kernel normally
 does itself.
 
-xattr-mapping Examples
-----------------------
+Security considerations
+~~~~~~~~~~~~~~~~~~~~~~~
+
+Operating systems typically partition the xattr namespace using
+well defined name prefixes. Each partition may have different
+access controls applied. For example, on Linux there are multiple
+partitions
+
+ * ``system.*`` - access varies depending on attribute & filesystem
+ * ``security.*`` - only processes with CAP_SYS_ADMIN
+ * ``trusted.*`` - only processes with CAP_SYS_ADMIN
+ * ``user.*`` - any process granted by file permissions / ownership
+
+While other OS such as FreeBSD have different name prefixes
+and access control rules.
+
+When remapping attributes on the host, it is important to
+ensure that the remapping does not allow a guest user to
+evade the guest access control rules.
+
+Consider if ``trusted.*`` from the guest was remapped to
+``user.virtiofs.trusted*`` in the host. An unprivileged
+user in a Linux guest has the ability to write to xattrs
+under ``user.*``. Thus the user can evade the access
+control restriction on ``trusted.*`` by instead writing
+to ``user.virtiofs.trusted.*``.
+
+As noted above, the partitions used and access controls
+applied, will vary across guest OS, so it is not wise to
+try to predict what the guest OS will use.
+
+The simplest way to avoid an insecure configuration is
+to remap all xattrs at once, to a given fixed prefix.
+This is shown in example (1) below.
+
+If selectively mapping only a subset of xattr prefixes,
+then rules must be added to explicitly block direct
+access to the target of the remapping. This is shown
+in example (2) below.
+
+Mapping examples
+~~~~~~~~~~~~~~~~
 
 1) Prefix all attributes with 'user.virtiofs.'
 
@@ -270,7 +313,9 @@ stripping of 'user.virtiofs.'.
 The second rule hides unprefixed 'trusted.' attributes
 on the host.
 The third rule stops a guest from explicitly setting
-the 'user.virtiofs.' path directly.
+the 'user.virtiofs.' path directly to prevent access
+control bypass on the target of the earlier prefix
+remapping.
 Finally, the fourth rule lets all remaining attributes
 through.
 
-- 
2.31.1

