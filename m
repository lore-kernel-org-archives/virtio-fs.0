From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed,  5 Jun 2019 08:42:31 +0800
Message-Id: <1559695356-75503-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH 0/5] leak fixes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Patch 1-4 fixes memory/fd/hashmap leakage.
Patch 5 is a cleanup.

Liu Bo (5):
  virtiofsd: cleanup allocated resource in se
  virtiofsd: fix memory leak on lo.source
  virtiofsd: fix memory leak on lo.inodes hashmap
  virtiofsd: fix error handling in main()
  virtiofsd: add helper for lo_data cleanup

 contrib/virtiofsd/fuse_lowlevel.c  |  6 ++++++
 contrib/virtiofsd/passthrough_ll.c | 38 +++++++++++++++++++++++++-------------
 2 files changed, 31 insertions(+), 13 deletions(-)

-- 
1.8.3.1

