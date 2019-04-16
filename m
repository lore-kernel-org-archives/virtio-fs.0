From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed, 17 Apr 2019 02:03:13 +0800
Message-Id: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/9] virtio-fs fixes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hi,

This set contains a few fixes collected by running xfstests.

thanks,
liubo

Liu Bo (6):
  virtio-fs: fix multiple tag support
  virtio-fs: clean up dax mapping before aborting connection
  fuse: export fuse_drop_waiting()
  virtio-fs: let dax style override directIO style when dax+cache=none
  fuse: return early if punch_hole fails
  virtio-fs: honor RLIMIT_FSIZE in fuse_file_fallocate

Xiaoguang Wang (3):
  virtio-fs: fix use-after-free against virtio_fs_vq's fuse_dev info
  fuse: do not write whole page while page straddles i_size
  fuse: fix deadlock in __fuse_file_fallocate()

 fs/fuse/dev.c       |  3 ++-
 fs/fuse/file.c      | 31 +++++++++++++++++++++++--------
 fs/fuse/fuse_i.h    |  3 +++
 fs/fuse/inode.c     |  9 +++++++++
 fs/fuse/virtio_fs.c | 13 +++++++++++--
 5 files changed, 48 insertions(+), 11 deletions(-)

-- 
1.8.3.1

