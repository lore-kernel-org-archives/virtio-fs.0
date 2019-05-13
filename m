From: Peng Tao <tao.peng@linux.alibaba.com>
Date: Mon, 13 May 2019 22:41:07 +0800
Message-Id: <20190513144109.21463-1-tao.peng@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH-v2 0/2] fuse: remove dmap when truncating inode
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

Hi Vivek,

The two patches try to remove dmap during truncation. virtiofs fuse
protocol is also modified to support removing multiple entries in
a single request. The host side virtiofsd patch will be sent separately.

Cheers,
Tao


Peng Tao (2):
  fuse: remove dmap when truncating inode
  virtiofs: FUSE_REMOVEMAPPING support multiple removing multiple
    entries

 fs/fuse/dir.c             |   5 ++
 fs/fuse/file.c            | 134 ++++++++++++++++++++++++++++++++------
 fs/fuse/fuse_i.h          |   2 +
 include/uapi/linux/fuse.h |   9 ++-
 4 files changed, 129 insertions(+), 21 deletions(-)

-- 
2.17.1

