From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed, 17 Apr 2019 03:08:54 +0800
Message-Id: <20190416190858.16833-1-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/4] virtiofsd fixes
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

This set contains a few fixes against virtiofsd.

Patch 1 fixes dio read hang.

Patch 2 adds ns support for file timestamp in stat(2).

Patch 3 fixes a problem found by generic/413 which shows vhost-user
backend doesn't include all memory mappings in use.

Patch 4 uses fallocate(2) instead to support more modes.

thanks,
liubo

Eryu Guan (1):
  virtiofsd: send reply correctly on read failure

Jiufei Xue (1):
  virtiofsd: support nanosecond resolution for file timestamp

Xiaoguang Wang (2):
  virtiofsd: use file-backend memory region for virtiofsd's cache area
  virtiofsd: use fallocate(2) instead posix_fallocate(3)

 configure                          | 16 +++++++++++
 contrib/virtiofsd/fuse_lowlevel.c  |  4 +--
 contrib/virtiofsd/fuse_misc.h      |  1 +
 contrib/virtiofsd/fuse_virtio.c    | 12 ++++++--
 contrib/virtiofsd/passthrough_ll.c | 11 ++-----
 hw/virtio/vhost-user-fs.c          | 59 +++++++++++++++++++++++++++++++-------
 6 files changed, 80 insertions(+), 23 deletions(-)

-- 
1.8.3.1

