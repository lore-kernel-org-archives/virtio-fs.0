Resent-Message-Id: <202104281128.13SBSDr0004159@lists01.pubmisc.prod.ext.phx2.redhat.com>
In-Reply-To: <20210428110100.27757-1-dgilbert@redhat.com>
Message-ID: <161960927380.28712.9846523327641876447@72b6d80f974b>
MIME-Version: 1.0
From: no-reply@patchew.org
Date: Wed, 28 Apr 2021 04:27:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v3 00/26] virtiofs dax patches
Reply-To: qemu-devel@nongnu.org
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: dgilbert@redhat.com
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

Patchew URL: https://patchew.org/QEMU/20210428110100.27757-1-dgilbert@redhat.com/



Hi,

This series seems to have some coding style problems. See output below for
more information:

Type: series
Message-id: 20210428110100.27757-1-dgilbert@redhat.com
Subject: [PATCH v3 00/26] virtiofs dax patches

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
 - [tag update]      patchew/20210415102321.3987935-1-philmd@redhat.com -> patchew/20210415102321.3987935-1-philmd@redhat.com
 - [tag update]      patchew/20210422145335.65814-1-mreitz@redhat.com -> patchew/20210422145335.65814-1-mreitz@redhat.com
 - [tag update]      patchew/20210427135147.111218-1-lvivier@redhat.com -> patchew/20210427135147.111218-1-lvivier@redhat.com
 - [tag update]      patchew/20210427192658.266933-1-f4bug@amsat.org -> patchew/20210427192658.266933-1-f4bug@amsat.org
 * [new tag]         patchew/20210428110100.27757-1-dgilbert@redhat.com -> patchew/20210428110100.27757-1-dgilbert@redhat.com
Switched to a new branch 'test'
ccf0714 virtiofsd: Ask qemu to drop CAP_FSETID if client asked for it
dae0067 vhost-user-fs: Implement drop CAP_FSETID functionality
addc004 vhost-user-fs: Extend VhostUserFSSlaveMsg to pass additional info
bf4ce2a DAX:virtiofsd: implement FUSE_INIT map_alignment field
188f074 DAX/unmap virtiofsd: route unmappable write to slave command
9bcd730 DAX/unmap virtiofsd: Route unmappable reads
b95bb5c DAX/unmap virtiofsd: Parse unmappable elements
e98bda0 DAX/unmap virtiofsd: Add wrappers for VHOST_USER_SLAVE_FS_IO
f8bc115 DAX/unmap: virtiofsd: Add VHOST_USER_SLAVE_FS_IO
e563a49 DAX: virtiofsd: Perform an unmap on destroy
4977fed DAX: virtiofsd: route se down to destroy method
e86d999 DAX: virtiofsd: Make lo_removemapping() work
b43ed18 DAX: virtiofsd: Wire up passthrough_ll's lo_setupmapping
80b6613 DAX: virtiofsd: Add setup/remove mapping handlers to passthrough_ll
497a551 DAX: virtiofsd: Add setup/remove mappings fuse commands
a68ac68 DAX: virtiofsd Add cache accessor functions
47fd841 DAX: virtio-fs: Fill in slave commands for mapping
e22b4f2 DAX: virtio-fs: Add vhost-user slave commands for mapping
43cefc1 DAX: virtio-fs: Add cache BAR
ee3d0da DAX: virtio: Add shared memory capability
9532b91 DAX subprojects/libvhost-user: Add virtio-fs slave types
7a510ed DAX: libvhost-user: Allow popping a queue element with bad pointers
79824d5 DAX: libvhost-user: Route slave message payload
4d503d0 DAX: vhost-user: Rework slave return values
d18fd97 virtiofsd: Don't assume header layout
301ba24 virtiofs: Fixup printf args

=== OUTPUT BEGIN ===
1/26 Checking commit 301ba247ecca (virtiofs: Fixup printf args)
2/26 Checking commit d18fd977f0c5 (virtiofsd: Don't assume header layout)
3/26 Checking commit 4d503d03bfb6 (DAX: vhost-user: Rework slave return values)
4/26 Checking commit 79824d57ac9c (DAX: libvhost-user: Route slave message payload)
5/26 Checking commit 7a510edf1169 (DAX: libvhost-user: Allow popping a queue element with bad pointers)
6/26 Checking commit 9532b917fec4 (DAX subprojects/libvhost-user: Add virtio-fs slave types)
7/26 Checking commit ee3d0daebc76 (DAX: virtio: Add shared memory capability)
8/26 Checking commit 43cefc18bd9b (DAX: virtio-fs: Add cache BAR)
9/26 Checking commit e22b4f256a22 (DAX: virtio-fs: Add vhost-user slave commands for mapping)
10/26 Checking commit 47fd84136d6f (DAX: virtio-fs: Fill in slave commands for mapping)
11/26 Checking commit a68ac68dcf41 (DAX: virtiofsd Add cache accessor functions)
12/26 Checking commit 497a5518a931 (DAX: virtiofsd: Add setup/remove mappings fuse commands)
13/26 Checking commit 80b661353cd4 (DAX: virtiofsd: Add setup/remove mapping handlers to passthrough_ll)
14/26 Checking commit b43ed18535c4 (DAX: virtiofsd: Wire up passthrough_ll's lo_setupmapping)
15/26 Checking commit e86d999fc18c (DAX: virtiofsd: Make lo_removemapping() work)
16/26 Checking commit 4977fed192e3 (DAX: virtiofsd: route se down to destroy method)
17/26 Checking commit e563a49d4b2a (DAX: virtiofsd: Perform an unmap on destroy)
18/26 Checking commit f8bc115092d8 (DAX/unmap: virtiofsd: Add VHOST_USER_SLAVE_FS_IO)
19/26 Checking commit e98bda0c581d (DAX/unmap virtiofsd: Add wrappers for VHOST_USER_SLAVE_FS_IO)
ERROR: unnecessary whitespace before a quoted newline
#100: FILE: tools/virtiofsd/fuse_virtio.c:1183:
+    fuse_log(FUSE_LOG_DEBUG, "%s: result=%" PRId64 " \n", __func__, result);

total: 1 errors, 0 warnings, 75 lines checked

Patch 19/26 has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

20/26 Checking commit b95bb5c22789 (DAX/unmap virtiofsd: Parse unmappable elements)
21/26 Checking commit 9bcd730dfe66 (DAX/unmap virtiofsd: Route unmappable reads)
22/26 Checking commit 188f074554d3 (DAX/unmap virtiofsd: route unmappable write to slave command)
23/26 Checking commit bf4ce2af375c (DAX:virtiofsd: implement FUSE_INIT map_alignment field)
24/26 Checking commit addc0047af4a (vhost-user-fs: Extend VhostUserFSSlaveMsg to pass additional info)
25/26 Checking commit dae00676a878 (vhost-user-fs: Implement drop CAP_FSETID functionality)
26/26 Checking commit ccf0714484af (virtiofsd: Ask qemu to drop CAP_FSETID if client asked for it)
ERROR: unnecessary whitespace before a quoted newline
#125: FILE: tools/virtiofsd/fuse_virtio.c:1319:
     fuse_log(FUSE_LOG_DEBUG, "%s: result=%" PRId64 " \n", __func__, result);

total: 1 errors, 0 warnings, 88 lines checked

Patch 26/26 has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

=== OUTPUT END ===

Test command exited with code: 1


The full log is available at
http://patchew.org/logs/20210428110100.27757-1-dgilbert@redhat.com/testing.checkpatch/?type=message.
---
Email generated automatically by Patchew [https://patchew.org/].
Please send your feedback to patchew-devel@redhat.com

