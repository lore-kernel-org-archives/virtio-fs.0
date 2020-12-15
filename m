Resent-Message-Id: <202012152251.0BFMpwY0010652@lists01.pubmisc.prod.ext.phx2.redhat.com>
In-Reply-To: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
Message-ID: <160807270606.22417.16185751154858977764@600e7e483b3a>
MIME-Version: 1.0
From: no-reply@patchew.org
Date: Tue, 15 Dec 2020 14:51:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [RFC PATCH 0/9] Support for Virtio-fs daemon crash
	reconnection
Reply-To: qemu-devel@nongnu.org
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: zhangjiachen.jaycee@bytedance.com
Cc: mst@redhat.com, qemu-devel@nongnu.org, virtio-fs@redhat.com, xieyongji@bytedance.com

Patchew URL: https://patchew.org/QEMU/20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com/



Hi,

This series seems to have some coding style problems. See output below for
more information:

Type: series
Message-id: 20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com
Subject: [RFC PATCH 0/9] Support for Virtio-fs daemon crash reconnection

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
 * [new tag]         patchew/20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com -> patchew/20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com
 * [new tag]         patchew/20201215174824.76017-1-richard.henderson@linaro.org -> patchew/20201215174824.76017-1-richard.henderson@linaro.org
Switched to a new branch 'test'
c6015f6 virtiofsd: (work around) Comment qsort in inflight I/O tracking
a285357 virtiofsd: Ensure crash consistency after reconnection
d5f69c8 virtiofsd: Persist/restore lo_map and opened fds to/from QEMU
4e0a56d virtiofsd: Add two new options for crash reconnection
d4b638e virtiofsd: Convert the struct lo_map array to a more flatten layout
6dadec2 libvhost-user: Add vhost-user message types for sending shared memory and file fds
91f265b vhost-user-fs: Support virtiofsd crash reconnection
bb587ea vhost: Add vhost-user message types for sending shared memory and file fds
ccb8eca vhost-user-fs: Add support for reconnection of vhost-user-fs backend

=== OUTPUT BEGIN ===
1/9 Checking commit ccb8eca38f55 (vhost-user-fs: Add support for reconnection of vhost-user-fs backend)
2/9 Checking commit bb587eaf556e (vhost: Add vhost-user message types for sending shared memory and file fds)
3/9 Checking commit 91f265b55b12 (vhost-user-fs: Support virtiofsd crash reconnection)
4/9 Checking commit 6dadec226d05 (libvhost-user: Add vhost-user message types for sending shared memory and file fds)
5/9 Checking commit d4b638e34242 (virtiofsd: Convert the struct lo_map array to a more flatten layout)
ERROR: use qemu_real_host_page_size instead of getpagesize()
#195: FILE: tools/virtiofsd/passthrough_ll.c:383:
+    int page_size = getpagesize();

total: 1 errors, 0 warnings, 997 lines checked

Patch 5/9 has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

6/9 Checking commit 4e0a56d0217d (virtiofsd: Add two new options for crash reconnection)
7/9 Checking commit d5f69c8465ac (virtiofsd: Persist/restore lo_map and opened fds to/from QEMU)
8/9 Checking commit a285357c7bff (virtiofsd: Ensure crash consistency after reconnection)
9/9 Checking commit c6015f602fb0 (virtiofsd: (work around) Comment qsort in inflight I/O tracking)
=== OUTPUT END ===

Test command exited with code: 1


The full log is available at
http://patchew.org/logs/20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com/testing.checkpatch/?type=message.
---
Email generated automatically by Patchew [https://patchew.org/].
Please send your feedback to patchew-devel@redhat.com

