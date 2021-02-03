Resent-Message-Id: <202102031201.113C1mVE030663@lists01.pubmisc.prod.ext.phx2.redhat.com>
In-Reply-To: <20210203113719.83633-1-stefanha@redhat.com>
Message-ID: <161235277962.8956.11104117114280995469@c667a6b167f6>
MIME-Version: 1.0
From: no-reply@patchew.org
Date: Wed, 3 Feb 2021 03:46:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v4 0/3] virtiofsd: prevent opening of
	special files (CVE-2020-35517)
Reply-To: qemu-devel@nongnu.org
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: stefanha@redhat.com
Cc: berrange@redhat.com, qemu-devel@nongnu.org, virtio-fs@redhat.com, alex@alxu.ca, vgoyal@redhat.com, ppandit@redhat.com, lersek@redhat.com

Patchew URL: https://patchew.org/QEMU/20210203113719.83633-1-stefanha@redhat.com/



Hi,

This series seems to have some coding style problems. See output below for
more information:

Type: series
Message-id: 20210203113719.83633-1-stefanha@redhat.com
Subject: [PATCH v4 0/3] virtiofsd: prevent opening of special files (CVE-2020-35517)

=== TEST SCRIPT BEGIN ===
#!/bin/bash
git rev-parse base > /dev/null || exit 0
git config --local diff.renamelimit 0
git config --local diff.renames True
git config --local diff.algorithm histogram
./scripts/checkpatch.pl --mailback base..
=== TEST SCRIPT END ===

Updating 3c8cf5a9c21ff8782164d1def7f44bd888713384
Switched to a new branch 'test'
9e44f0e virtiofsd: prevent opening of special files (CVE-2020-35517)
e3ddfae virtiofsd: optionally return inode pointer from lo_do_lookup()
a6c73fd virtiofsd: extract lo_do_open() from lo_open()

=== OUTPUT BEGIN ===
1/3 Checking commit a6c73fd0a630 (virtiofsd: extract lo_do_open() from lo_open())
ERROR: return of an errno should typically be -ve (return -ENOMEM)
#70: FILE: tools/virtiofsd/passthrough_ll.c:1674:
+        return ENOMEM;

total: 1 errors, 0 warnings, 114 lines checked

Patch 1/3 has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

2/3 Checking commit e3ddfaebb90a (virtiofsd: optionally return inode pointer from lo_do_lookup())
3/3 Checking commit 9e44f0e0be3a (virtiofsd: prevent opening of special files (CVE-2020-35517))
=== OUTPUT END ===

Test command exited with code: 1


The full log is available at
http://patchew.org/logs/20210203113719.83633-1-stefanha@redhat.com/testing.checkpatch/?type=message.
---
Email generated automatically by Patchew [https://patchew.org/].
Please send your feedback to patchew-devel@redhat.com

