Resent-Message-Id: <202106171840.15HIeRRH003780@lists01.pubmisc.prod.ext.phx2.redhat.com>
In-Reply-To: <20210617181213.1177835-1-vgoyal@redhat.com>
Message-ID: <162395428716.2536.16283139617440086783@7c66fb7bc3ab>
MIME-Version: 1.0
From: no-reply@patchew.org
Date: Thu, 17 Jun 2021 11:24:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v6 0/8] virtiofsd: Add support to
	enable/disable posix acls
Reply-To: qemu-devel@nongnu.org
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com
Cc: miklos@szeredi.hu, qemu-devel@nongnu.org, virtio-fs@redhat.com

Patchew URL: https://patchew.org/QEMU/20210617181213.1177835-1-vgoyal@redhat.com/



Hi,

This series seems to have some coding style problems. See output below for
more information:

Type: series
Message-id: 20210617181213.1177835-1-vgoyal@redhat.com
Subject: [PATCH v6 0/8] virtiofsd: Add support to enable/disable posix acls

=== TEST SCRIPT BEGIN ===
#!/bin/bash
git rev-parse base > /dev/null || exit 0
git config --local diff.renamelimit 0
git config --local diff.renames True
git config --local diff.algorithm histogram
./scripts/checkpatch.pl --mailback base..
=== TEST SCRIPT END ===

Updating 3c8cf5a9c21ff8782164d1def7f44bd888713384
>From https://github.com/patchew-project/qemu
 * [new tag]         patchew/20210617181213.1177835-1-vgoyal@redhat.com -> patchew/20210617181213.1177835-1-vgoyal@redhat.com
Switched to a new branch 'test'
c812c39 virtiofsd: Add an option to enable/disable posix acls
62af00e virtiofsd: Switch creds, drop FSETID for system.posix_acl_access xattr
e93c53d virtiofsd: Add capability to change/restore umask
5588053 virtiofsd: Add umask to seccom allow list
dc2337e virtiofsd: Add support for extended setxattr
65fc720 virtiofsd: Fix xattr operations overwriting errno
967e28d virtiofsd: Fix fuse setxattr() API change issue
6c3d050 linux-headers: Update linux headers to 5.13.0-rc6

=== OUTPUT BEGIN ===
1/8 Checking commit 6c3d050bd70f (linux-headers: Update linux headers to 5.13.0-rc6)
2/8 Checking commit 967e28d2e22d (virtiofsd: Fix fuse setxattr() API change issue)
ERROR: braces {} are necessary for all arms of this statement
#50: FILE: tools/virtiofsd/fuse_lowlevel.c:1424:
+    if (setxattr_ext)
[...]
+    else
[...]

total: 1 errors, 0 warnings, 25 lines checked

Patch 2/8 has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

3/8 Checking commit 65fc720e49ac (virtiofsd: Fix xattr operations overwriting errno)
4/8 Checking commit dc2337e643fc (virtiofsd: Add support for extended setxattr)
5/8 Checking commit 5588053fd40b (virtiofsd: Add umask to seccom allow list)
6/8 Checking commit e93c53dabdb7 (virtiofsd: Add capability to change/restore umask)
7/8 Checking commit 62af00ed759e (virtiofsd: Switch creds, drop FSETID for system.posix_acl_access xattr)
ERROR: suspect code indent for conditional statements (4, 7)
#83: FILE: tools/virtiofsd/passthrough_ll.c:1208:
+    if (ret) {
+       if (__cap_dropped) {

ERROR: suspect code indent for conditional statements (7, 10)
#84: FILE: tools/virtiofsd/passthrough_ll.c:1209:
+       if (__cap_dropped) {
+          if (gain_effective_cap(cap_name)) {

ERROR: suspect code indent for conditional statements (10, 14)
#85: FILE: tools/virtiofsd/passthrough_ll.c:1210:
+          if (gain_effective_cap(cap_name)) {
+              fuse_log(FUSE_LOG_ERR, "Failed to gain CAP_%s\n", cap_name);

ERROR: braces {} are necessary for all arms of this statement
#91: FILE: tools/virtiofsd/passthrough_ll.c:1216:
+    if (cap_dropped)
[...]

total: 4 errors, 0 warnings, 105 lines checked

Patch 7/8 has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

8/8 Checking commit c812c393f36a (virtiofsd: Add an option to enable/disable posix acls)
=== OUTPUT END ===

Test command exited with code: 1


The full log is available at
http://patchew.org/logs/20210617181213.1177835-1-vgoyal@redhat.com/testing.checkpatch/?type=message.
---
Email generated automatically by Patchew [https://patchew.org/].
Please send your feedback to patchew-devel@redhat.com

