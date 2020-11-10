From: Haotian Li <lihaotian9@huawei.com>
Message-ID: <4bfe8bbd-282f-f271-735d-8892791327e1@huawei.com>
Date: Tue, 10 Nov 2020 14:32:17 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] [PATCH v2 0/2] virtiofsd: fix some accessing NULL
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

Haotian Li (2):
  tools/virtiofsd/buffer.c: check whether buf is NULL in
    fuse_bufvec_advance func
  virtiofsd/passthrough_ll.c: check whether lo_map_reserve returns NULL
    in main func

 tools/virtiofsd/buffer.c         |  4 ++++
 tools/virtiofsd/passthrough_ll.c | 10 +++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

-- 

