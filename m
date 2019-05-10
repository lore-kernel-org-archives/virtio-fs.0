From: Peng Tao <tao.peng@linux.alibaba.com>
Date: Fri, 10 May 2019 18:29:55 +0800
Message-Id: <20190510102957.8705-1-tao.peng@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH 0/2] virtiofs: remove dmap when truncating inode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Peng Tao <tao.peng@linux.alibaba.com>

Hi,

The first patch is a simple cleanup. The second patch removes
dmaps when truncating a file since they are no longer valid
and we can return them to free pool directly. Otherwise they are
cleaned up by the reclaim code that might try to reclaim valid
dmaps first.


Peng Tao (2):
  fuse: remove unnecessary allocated_ranges
  fuse: remove dmap when truncating inode

 fs/fuse/dir.c    |  5 ++++
 fs/fuse/file.c   | 69 +++++++++++++++++++++++++++++++++++++++---------
 fs/fuse/fuse_i.h |  2 ++
 fs/fuse/inode.c  |  7 +++--
 4 files changed, 66 insertions(+), 17 deletions(-)

-- 
2.17.1

