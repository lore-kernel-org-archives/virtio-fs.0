From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 12 Nov 2020 13:24:16 -0500
Message-Id: <20201112182418.25395-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 0/2] viritofsd: Add support for
	FUSE_HANDLE_KILLPRIV_V2
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com

Hi,

This is V2 of patches to add support for FUSE_HANDLE_KILLPRIV_V2. This
is basically a feature file server can opt-in. And with xattr enabled,
this improves write performance many fold (jumps from 50MB/s to
300MB/s approx).

kernel patches have now been staged in for-next branch of fuse tree by Miklos.

https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git/log/?h=for-next

I tested virtiofsd with these patches and things look good to me.
Posting now for review and inclusion as soon as kernel patches are
merged in 5.11.

Thanks
Vivek

Vivek Goyal (2):
  virtiofsd: Save error code early at the failure callsite
  viriofsd: Add support for FUSE_HANDLE_KILLPRIV_V2

 include/standard-headers/linux/fuse.h |  28 ++++++-
 tools/virtiofsd/fuse_common.h         |  15 ++++
 tools/virtiofsd/fuse_lowlevel.c       |  11 ++-
 tools/virtiofsd/fuse_lowlevel.h       |   1 +
 tools/virtiofsd/passthrough_ll.c      | 116 +++++++++++++++++++++++---
 5 files changed, 153 insertions(+), 18 deletions(-)

-- 
2.25.4

