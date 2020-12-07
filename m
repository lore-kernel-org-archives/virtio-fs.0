Resent-Message-Id: <202012071912.0B7JCwlR013536@lists01.pubmisc.prod.ext.phx2.redhat.com>
In-Reply-To: <20201207183021.22752-1-vgoyal@redhat.com>
Message-ID: <160736836218.30250.12305333017578341080@600e7e483b3a>
MIME-Version: 1.0
From: no-reply@patchew.org
Date: Mon, 7 Dec 2020 11:12:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 0/3] virtiofsd: Fix lo_flush() and
	inode->posix_lock init
Reply-To: qemu-devel@nongnu.org
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, lersek@redhat.com

Patchew URL: https://patchew.org/QEMU/20201207183021.22752-1-vgoyal@redhat.com/



Hi,

This series seems to have some coding style problems. See output below for
more information:

Type: series
Message-id: 20201207183021.22752-1-vgoyal@redhat.com
Subject: [PATCH 0/3] virtiofsd: Fix lo_flush() and inode->posix_lock init

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
 * [new tag]         patchew/20201207183021.22752-1-vgoyal@redhat.com -> patchew/20201207183021.22752-1-vgoyal@redhat.com
Switched to a new branch 'test'
86f3bb1 virtiofsd: Check file type in lo_flush()
92a5c9d virtiofsd: Disable posix_lock hash table if remote locks are not enabled
fbdcaf1 virtiofsd: Set up posix_lock hash table for root inode

=== OUTPUT BEGIN ===
1/3 Checking commit fbdcaf172aed (virtiofsd: Set up posix_lock hash table for root inode)
ERROR: suspect code indent for conditional statements (4, 7)
#40: FILE: tools/virtiofsd/passthrough_ll.c:3401:
+    if (lo->root.posix_locks)
+       g_hash_table_destroy(lo->root.posix_locks);

ERROR: braces {} are necessary for all arms of this statement
#40: FILE: tools/virtiofsd/passthrough_ll.c:3401:
+    if (lo->root.posix_locks)
[...]

total: 2 errors, 0 warnings, 19 lines checked

Patch 1/3 has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

2/3 Checking commit 92a5c9d35c7d (virtiofsd: Disable posix_lock hash table if remote locks are not enabled)
3/3 Checking commit 86f3bb1cf5b8 (virtiofsd: Check file type in lo_flush())
=== OUTPUT END ===

Test command exited with code: 1


The full log is available at
http://patchew.org/logs/20201207183021.22752-1-vgoyal@redhat.com/testing.checkpatch/?type=message.
---
Email generated automatically by Patchew [https://patchew.org/].
Please send your feedback to patchew-devel@redhat.com

