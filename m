From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue, 16 Feb 2021 18:37:31 +0000
Message-Id: <20210216183734.57810-4-dgilbert@redhat.com>
In-Reply-To: <20210216183734.57810-1-dgilbert@redhat.com>
References: <20210216183734.57810-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 3/6] tools/virtiofsd: Replace the word 'whitelist'
List-Id: Development discussions about virtio-fs <virtio-fs.listman.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@listman.redhat.com>
List-Help: <mailto:virtio-fs-request@listman.redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, wainersm@redhat.com, groug@kaod.org, philmd@redhat.com, vgoyal@redhat.com
Cc: virtio-fs@redhat.com

From: Philippe Mathieu-Daudé <philmd@redhat.com>

Follow the inclusive terminology from the "Conscious Language in your
Open Source Projects" guidelines [*] and replace the words "whitelist"
appropriately.

[*] https://github.com/conscious-lang/conscious-lang-docs/blob/main/faq.md

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <20210205171817.2108907-3-philmd@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c      |  6 +++---
 tools/virtiofsd/passthrough_seccomp.c | 12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 147b59338a..5f3afe8557 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3204,7 +3204,7 @@ static void setup_mounts(const char *source)
 }
 
 /*
- * Only keep whitelisted capabilities that are needed for file system operation
+ * Only keep capabilities in allowlist that are needed for file system operation
  * The (possibly NULL) modcaps_in string passed in is free'd before exit.
  */
 static void setup_capabilities(char *modcaps_in)
@@ -3214,8 +3214,8 @@ static void setup_capabilities(char *modcaps_in)
     capng_restore_state(&cap.saved);
 
     /*
-     * Whitelist file system-related capabilities that are needed for a file
-     * server to act like root.  Drop everything else like networking and
+     * Add to allowlist file system-related capabilities that are needed for a
+     * file server to act like root.  Drop everything else like networking and
      * sysadmin capabilities.
      *
      * Exclusions:
diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
index ea852e2e33..62441cfcdb 100644
--- a/tools/virtiofsd/passthrough_seccomp.c
+++ b/tools/virtiofsd/passthrough_seccomp.c
@@ -21,7 +21,7 @@
 #endif
 #endif
 
-static const int syscall_whitelist[] = {
+static const int syscall_allowlist[] = {
     /* TODO ireg sem*() syscalls */
     SCMP_SYS(brk),
     SCMP_SYS(capget), /* For CAP_FSETID */
@@ -117,12 +117,12 @@ static const int syscall_whitelist[] = {
 };
 
 /* Syscalls used when --syslog is enabled */
-static const int syscall_whitelist_syslog[] = {
+static const int syscall_allowlist_syslog[] = {
     SCMP_SYS(send),
     SCMP_SYS(sendto),
 };
 
-static void add_whitelist(scmp_filter_ctx ctx, const int syscalls[], size_t len)
+static void add_allowlist(scmp_filter_ctx ctx, const int syscalls[], size_t len)
 {
     size_t i;
 
@@ -153,10 +153,10 @@ void setup_seccomp(bool enable_syslog)
         exit(1);
     }
 
-    add_whitelist(ctx, syscall_whitelist, G_N_ELEMENTS(syscall_whitelist));
+    add_allowlist(ctx, syscall_allowlist, G_N_ELEMENTS(syscall_allowlist));
     if (enable_syslog) {
-        add_whitelist(ctx, syscall_whitelist_syslog,
-                      G_N_ELEMENTS(syscall_whitelist_syslog));
+        add_allowlist(ctx, syscall_allowlist_syslog,
+                      G_N_ELEMENTS(syscall_allowlist_syslog));
     }
 
     /* libvhost-user calls this for post-copy migration, we don't need it */
-- 
2.29.2

