From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 31 May 2019 14:57:06 -0400
Message-Id: <20190531185709.10267-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/3] virtio-fs: Flush forget requests before
	sending destroy
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, tao.peng@linux.alibaba.com
Cc: vgoyal@redhat.com

Hi Peng Tao,

Can you plase try following patches and see if it helps with the issue
you are facing.

One of the patch is cleanup. Rest of the two patches make sure all
forget requests requests are flushed and no forget reuqest is sent
after destroy has been sent.

Thanks
Vivek

Vivek Goyal (3):
  Use helper function to get forget requests from fuse
  Do not dispatch forget requests once queue is disconnected
  virtio-fs: Waiting for pending forget requests to finish

 fs/fuse/dev.c       |  9 +++---
 fs/fuse/fuse_i.h    |  3 ++
 fs/fuse/virtio_fs.c | 70 ++++++++++++++++++++++++++++++++++++---------
 3 files changed, 65 insertions(+), 17 deletions(-)

-- 
2.20.1

