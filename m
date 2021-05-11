Resent-Message-Id: <202105112149.14BLn1qv007368@lists01.pubmisc.prod.ext.phx2.redhat.com>
In-Reply-To: <20210511213736.281016-1-vgoyal@redhat.com>
Message-ID: <162076972559.29161.8308372976372965130@d887ba82c771>
MIME-Version: 1.0
From: no-reply@patchew.org
Date: Tue, 11 May 2021 14:48:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 0/7] virtiofsd: Few cleanups in
	virtio_send_data_iov()
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
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

Patchew URL: https://patchew.org/QEMU/20210511213736.281016-1-vgoyal@redhat.com/



Hi,

This series seems to have some coding style problems. See output below for
more information:

Type: series
Message-id: 20210511213736.281016-1-vgoyal@redhat.com
Subject: [PATCH 0/7] virtiofsd: Few cleanups in virtio_send_data_iov()

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
 - [tag update]      patchew/20210511132641.1022161-1-berrange@redhat.com -> patchew/20210511132641.1022161-1-berrange@redhat.com
 * [new tag]         patchew/20210511213736.281016-1-vgoyal@redhat.com -> patchew/20210511213736.281016-1-vgoyal@redhat.com
Switched to a new branch 'test'
b6ced9e virtiofsd: Set req->reply_sent right after sending reply
c866cc2 virtiofsd: Check EOF before short read
8d45f07 virtiofsd: Simplify skip byte logic
b7afa17 virtiofsd: get rid of in_sg_left variable
37ba755 virtiofsd: Use iov_discard_front() to skip bytes
f87fbd3 virtiofsd: Get rid of unreachable code in read
cc6fb4a virtiofsd: Check for EINTR in preadv() and retry

=== OUTPUT BEGIN ===
1/7 Checking commit cc6fb4a9cf99 (virtiofsd: Check for EINTR in preadv() and retry)
2/7 Checking commit f87fbd364bcd (virtiofsd: Get rid of unreachable code in read)
3/7 Checking commit 37ba755df99d (virtiofsd: Use iov_discard_front() to skip bytes)
ERROR: code indent should never use tabs
#44: FILE: tools/virtiofsd/fuse_virtio.c:400:
+^I    iov_discard_front(&in_sg_ptr, &in_sg_cpy_count, skip_size);$

total: 1 errors, 0 warnings, 26 lines checked

Patch 3/7 has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

4/7 Checking commit b7afa17acdc2 (virtiofsd: get rid of in_sg_left variable)
5/7 Checking commit 8d45f07e917d (virtiofsd: Simplify skip byte logic)
6/7 Checking commit c866cc21d91c (virtiofsd: Check EOF before short read)
7/7 Checking commit b6ced9e49587 (virtiofsd: Set req->reply_sent right after sending reply)
=== OUTPUT END ===

Test command exited with code: 1


The full log is available at
http://patchew.org/logs/20210511213736.281016-1-vgoyal@redhat.com/testing.checkpatch/?type=message.
---
Email generated automatically by Patchew [https://patchew.org/].
Please send your feedback to patchew-devel@redhat.com

