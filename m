From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 24 Jul 2019 17:07:18 -0400
Message-Id: <20190724210721.9185-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/3] virtio-fs: Create a read-write mapping only
	if needed
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This should apply on top of.

https://gitlab.com/virtio-fs/linux/commits/virtio-fs-dev

Do not always create a read-write mapping. Create it read-write only if
caller asked for it. Otherwise create a read-only mapping and upgrade
it to read-write later when needed.

Vivek Goyal (3):
  fuse: Get rid of file parameter from setup mapping
  fuse: Move new mapping setup code in a function
  fuse: Add logic to upgrade a read-only mapping to read-write

 fs/fuse/file.c   | 246 +++++++++++++++++++++++++++++------------------
 fs/fuse/fuse_i.h |   3 +
 2 files changed, 155 insertions(+), 94 deletions(-)

-- 
2.17.2

