From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue,  1 Sep 2020 10:26:32 -0400
Message-Id: <20200901142634.1227109-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/2] fuse,
	dax: Couple of fixes for fuse dax support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu
Cc: vgoyal@redhat.com

Hi Miklos,

I am testing fuse dax branch now. To begin with here are couple of
simple fixes to make sure I/O is going through dax path.

Either you can roll these fixes into existing patches or apply on
top.

I ran blogbench workload and some fio mmap jobs and these seem to be
running fine after these fixes.

Thanks
Vivek


Vivek Goyal (2):
  fuse, dax: Use correct config option CONFIG_FUSE_DAX
  fuse, dax: Save dax device in fuse_conn_dax

 fs/fuse/dax.c  | 1 +
 fs/fuse/file.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
2.25.4

