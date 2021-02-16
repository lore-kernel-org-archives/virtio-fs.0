Resent-Message-Id: <202102162346.11GNk2Hi029547@lists01.pubmisc.prod.ext.phx2.redhat.com>
In-Reply-To: <20210216233611.33400-1-vgoyal@redhat.com>
Message-ID: <161351914495.372.17420007914971008741@c667a6b167f6>
MIME-Version: 1.0
From: no-reply@patchew.org
Date: Tue, 16 Feb 2021 15:45:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 0/3] virtiofsd: Add options to
	enable/disable posix acl
Reply-To: qemu-devel@nongnu.org
List-Id: Development discussions about virtio-fs <virtio-fs.listman.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@listman.redhat.com>
List-Help: <mailto:virtio-fs-request@listman.redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=subscribe>
To: vgoyal@redhat.com
Cc: miklos@szeredi.hu, qemu-devel@nongnu.org, virtio-fs@redhat.com

Patchew URL: https://patchew.org/QEMU/20210216233611.33400-1-vgoyal@redhat.com/



Hi,

This series seems to have some coding style problems. See output below for
more information:

Type: series
Message-id: 20210216233611.33400-1-vgoyal@redhat.com
Subject: [PATCH 0/3] virtiofsd: Add options to enable/disable posix acl

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
 * [new tag]         patchew/20210216233611.33400-1-vgoyal@redhat.com -> patchew/20210216233611.33400-1-vgoyal@redhat.com
Switched to a new branch 'test'
599c357 virtiofsd: Change umask if posix acls are enabled
599cc19 virtiofsd: Add umask to seccom allow list
72ea185 virtiofsd: Add an option to enable/disable posix acls

=== OUTPUT BEGIN ===
1/3 Checking commit 72ea185ac754 (virtiofsd: Add an option to enable/disable posix acls)
WARNING: Block comments should align the * on each line
#56: FILE: tools/virtiofsd/passthrough_ll.c:648:
+         * Either user specified to disable posix_acl, or did not specify
+          * anything. In both the cases do not enable posix acl.

WARNING: Block comments should align the * on each line
#57: FILE: tools/virtiofsd/passthrough_ll.c:649:
+          * anything. In both the cases do not enable posix acl.
+         */

total: 0 errors, 2 warnings, 45 lines checked

Patch 1/3 has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
2/3 Checking commit 599cc19faf56 (virtiofsd: Add umask to seccom allow list)
3/3 Checking commit 599c3575ec83 (virtiofsd: Change umask if posix acls are enabled)
ERROR: braces {} are necessary for all arms of this statement
#95: FILE: tools/virtiofsd/passthrough_ll.c:1072:
+    if (change_umask)
[...]

total: 1 errors, 0 warnings, 96 lines checked

Patch 3/3 has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

=== OUTPUT END ===

Test command exited with code: 1


The full log is available at
http://patchew.org/logs/20210216233611.33400-1-vgoyal@redhat.com/testing.checkpatch/?type=message.
---
Email generated automatically by Patchew [https://patchew.org/].
Please send your feedback to patchew-devel@redhat.com

