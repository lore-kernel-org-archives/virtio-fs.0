From: Connor Kuehl <ckuehl@redhat.com>
Date: Thu, 18 Mar 2021 08:52:20 -0500
Message-Id: <20210318135223.1342795-1-ckuehl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH 0/3] virtiofs: split requests that exceed
	virtqueue size
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: miklos@szeredi.hu, jasowang@redhat.com, mst@redhat.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com

I also have a patch in this series that fixes a typo I saw while I was
in there.

For testing, I have been using a toy program that performs a readv or a
writev with a large number of iovecs that exceeds the number of
descriptors available to the virtqueue and observing the number of
scattergather lists generated don't exceed the size of the virtqueue.

Connor Kuehl (3):
  virtio_ring: always warn when descriptor chain exceeds queue size
  virtiofs: split requests that exceed virtqueue size
  fuse: fix typo for fuse_conn.max_pages comment

 drivers/virtio/virtio_ring.c |  7 ++++---
 fs/fuse/fuse_i.h             |  7 ++++++-
 fs/fuse/inode.c              |  7 +++++++
 fs/fuse/virtio_fs.c          | 14 ++++++++++++++
 4 files changed, 31 insertions(+), 4 deletions(-)

-- 
2.30.2

