From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Tue,  7 May 2019 13:58:09 +0800
Message-Id: <1557208691-43817-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH 0/2] guest hang fixes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This is trying to fix guest hang issue due to full host fs, more
details are available at patch 2.

Liu Bo (2):
  virtio-fs: send setupmapping with write flag only if IOMAP_WRITE
  virtiofs: add dmap flags to differentiate write mapping from read
    mapping

 fs/fuse/file.c   | 83 ++++++++++++++++++++++++++++++++++++++++++++++----------
 fs/fuse/fuse_i.h |  3 ++
 2 files changed, 72 insertions(+), 14 deletions(-)

-- 
1.8.3.1

