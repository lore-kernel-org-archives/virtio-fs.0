From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu, 25 Jul 2019 15:20:12 +0100
Message-Id: <20190725142014.1726-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/2] virtio-fs: fuse.h cleanups
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

These are minor fixes that should be squashed down for the virtio-fs patch
series being sent upstream.

Stefan Hajnoczi (2):
  fuse: drop unused struct fuse_setupmapping_out
  fuse: make FUSE_REMOVEMAPPING_MAX_ENTRY private

 include/uapi/linux/fuse.h | 11 -----------
 fs/fuse/file.c            |  3 +++
 2 files changed, 3 insertions(+), 11 deletions(-)

-- 
2.21.0

