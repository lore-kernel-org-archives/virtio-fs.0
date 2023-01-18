Return-Path: <dgilbert@redhat.com>
From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 18 Jan 2023 15:38:33 +0000
Message-Id: <20230118153833.102731-4-dgilbert@redhat.com>
In-Reply-To: <20230118153833.102731-1-dgilbert@redhat.com>
References: <20230118153833.102731-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/3] virtiofsd: Swing deprecated message to
 removed-features
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, hczenczek@redhat.com, gmaglione@redhat.com, virtio-fs@redhat.com, pbonzini@redhat.com, alex.bennee@linaro.org

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Move the deprecation message, since it's now gone.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 docs/about/deprecated.rst       | 18 ------------------
 docs/about/removed-features.rst | 13 +++++++++++++
 2 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
index 9f1bbc495d..8543fa3285 100644
--- a/docs/about/deprecated.rst
+++ b/docs/about/deprecated.rst
@@ -325,24 +325,6 @@ versions, aliases will point to newer CPU model versions
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
index 6c3aa5097f..9b0a212cfe 100644
--- a/docs/about/removed-features.rst
+++ b/docs/about/removed-features.rst
@@ -865,3 +865,16 @@ The VXHS code did not compile since v2.12.0. It was removed in 5.1.
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
2.39.0

