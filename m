Resent-Message-Id: <202103251619.12PGJHFY031403@lists01.pubmisc.prod.ext.phx2.redhat.com>
In-Reply-To: <20210325153852.572927-1-vgoyal@redhat.com>
Message-ID: <161668822522.4923.8894988516068860139@72b6d80f974b>
MIME-Version: 1.0
From: no-reply@patchew.org
Date: Thu, 25 Mar 2021 09:03:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v5 0/5] virtiofsd: Add support to
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

Patchew URL: https://patchew.org/QEMU/20210325153852.572927-1-vgoyal@redhat.com/



Hi,

This series seems to have some coding style problems. See output below for
more information:

Type: series
Message-id: 20210325153852.572927-1-vgoyal@redhat.com
Subject: [PATCH v5 0/5] virtiofsd: Add support to enable/disable posix acls

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
 * [new tag]         patchew/20210325153852.572927-1-vgoyal@redhat.com -> patchew/20210325153852.572927-1-vgoyal@redhat.com
Switched to a new branch 'test'
ea606d9 virtiofsd: Switch creds, drop FSETID for system.posix_acl_access xattr
bc9a877 virtiofsd: Add support for setxattr_v2
d28413e virtiofsd: Add an option to enable/disable posix acls
1eeb11f virtiofsd: Add capability to change/restore umask
0b02a25 virtiofsd: Add umask to seccom allow list

=== OUTPUT BEGIN ===
1/5 Checking commit 0b02a2507048 (virtiofsd: Add umask to seccom allow list)
2/5 Checking commit 1eeb11f00fdb (virtiofsd: Add capability to change/restore umask)
3/5 Checking commit d28413e66e58 (virtiofsd: Add an option to enable/disable posix acls)
WARNING: line over 80 characters
#239: FILE: tools/virtiofsd/passthrough_ll.c:3957:
+        fuse_log(FUSE_LOG_ERR, "Can't enable posix ACLs. xattrs are disabled.\n");

total: 0 errors, 1 warnings, 185 lines checked

Patch 3/5 has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
4/5 Checking commit bc9a8776c947 (virtiofsd: Add support for setxattr_v2)
5/5 Checking commit ea606d9de8f0 (virtiofsd: Switch creds, drop FSETID for system.posix_acl_access xattr)
ERROR: braces {} are necessary for all arms of this statement
#137: FILE: tools/virtiofsd/passthrough_ll.c:3135:
+            if (gain_effective_cap("FSETID"))
[...]

total: 1 errors, 0 warnings, 86 lines checked

Patch 5/5 has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

=== OUTPUT END ===

Test command exited with code: 1


The full log is available at
http://patchew.org/logs/20210325153852.572927-1-vgoyal@redhat.com/testing.checkpatch/?type=message.
---
Email generated automatically by Patchew [https://patchew.org/].
Please send your feedback to patchew-devel@redhat.com

