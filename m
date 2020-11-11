From: Haotian Li <lihaotian9@huawei.com>
Message-ID: <3477d902-ace9-1aa1-531a-9d20d6e93a05@huawei.com>
Date: Wed, 11 Nov 2020 09:04:20 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] [PATCH v3 0/3] virtiofsd: fix some accessing NULL
	pointer problem
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: linfeilong@huawei.com

Hi,
  We find some potential NULL pointer bugs on tools/virtiofsd.
Three patches are made to fix them

Haotian Li (3):
  tools/virtiofsd/buffer.c: check whether buf is NULL in
    fuse_bufvec_advance func
  virtiofsd: check whether lo_map_reserve returns NULL in main func
  virtiofsd: check whether strdup lo.source return NULL in main func.

 tools/virtiofsd/buffer.c         |  4 ++++
 tools/virtiofsd/passthrough_ll.c | 16 +++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

-- 

