Return-Path: <dgilbert@redhat.com>
From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu, 16 Feb 2023 18:26:28 +0000
Message-Id: <20230216182628.126139-5-dgilbert@redhat.com>
In-Reply-To: <20230216182628.126139-1-dgilbert@redhat.com>
References: <20230216182628.126139-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 4/4] virtiofsd: Swing deprecated message to
 removed-features
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, gmaglione@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Move the deprecation message, since it's now gone.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 docs/about/deprecated.rst       | 18 ------------------
 docs/about/removed-features.rst | 13 +++++++++++++
 2 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
index 2827b0c0be..ee95bcb1a6 100644
--- a/docs/about/deprecated.rst
+++ b/docs/about/deprecated.rst
@@ -330,24 +330,6 @@ versions, aliases will point to newer CPU model versions
 depending on the machine type, so management software must
 resolve CPU model aliases before starting a virtual machine.
 
-Tools
------
-
-virtiofsd
-'''''''''
-
-There is a new Rust implementation of ``virtiofsd`` at
-``https://gitlab.com/virtio-fs/virtiofsd``;
-since this is now marked stable, new development should be done on that
-rather than the existing C version in the QEMU tree.
-The C version will still accept fixes and patches that
-are already in development for the moment, but will eventually
-be deleted from this tree.
-New deployments should use the Rust version, and existing systems
-should consider moving to it.  The command line and feature set
-is very close and moving should be simple.
-
-
 QEMU guest agent
 ----------------
 
diff --git a/docs/about/removed-features.rst b/docs/about/removed-features.rst
index e901637ce5..5b258b446b 100644
--- a/docs/about/removed-features.rst
+++ b/docs/about/removed-features.rst
@@ -889,3 +889,16 @@ The VXHS code did not compile since v2.12.0. It was removed in 5.1.
 The corresponding upstream server project is no longer maintained.
 Users are recommended to switch to an alternative distributed block
 device driver such as RBD.
+
+Tools
+-----
+
+virtiofsd (removed in 8.0)
+''''''''''''''''''''''''''
+
+There is a newer Rust implementation of ``virtiofsd`` at
+``https://gitlab.com/virtio-fs/virtiofsd``; this has been
+stable for some time and is now widely used.
+The command line and feature set is very close to the removed
+C implementation.
+
-- 
2.39.2

