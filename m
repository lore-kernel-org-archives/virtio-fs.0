From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Wed,  4 Aug 2021 15:06:45 +0800
Message-Id: <20210804070653.118123-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v3 0/8] fuse,virtiofs: support per-file DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, virtualization@lists.linux-foundation.org

changes since v2:
- modify fuse_show_options() accordingly to make it compatible with
  new tri-state mount option (patch 2)
- extract FUSE protocol changes into one seperate patch (patch 3)
- FUSE server/client need to negotiate if they support per-file DAX
  (patch 4)
- extract DONT_CACHE logic into patch 6/7


This patchset adds support of per-file DAX for virtiofs, which is
inspired by Ira Weiny's work on ext4[1] and xfs[2].

Any comment is welcome.

[1] commit 9cb20f94afcd ("fs/ext4: Make DAX mount option a tri-state")
[2] commit 02beb2686ff9 ("fs/xfs: Make DAX mount option a tri-state")

v2: https://www.spinics.net/lists/linux-fsdevel/msg199584.html
v1: https://www.spinics.net/lists/linux-virtualization/msg51008.html

Jeffle Xu (8):
  fuse: add fuse_should_enable_dax() helper
  fuse: Make DAX mount option a tri-state
  fuse: support per-file DAX
  fuse: negotiate if server/client supports per-file DAX
  fuse: enable per-file DAX
  fuse: mark inode DONT_CACHE when per-file DAX indication changes
  fuse: support changing per-file DAX flag inside guest
  fuse: show '-o dax=inode' option only when FUSE server supports

 fs/fuse/dax.c             | 32 ++++++++++++++++++++++++++++++--
 fs/fuse/file.c            |  4 ++--
 fs/fuse/fuse_i.h          | 22 ++++++++++++++++++----
 fs/fuse/inode.c           | 27 ++++++++++++++++++---------
 fs/fuse/ioctl.c           | 15 +++++++++++++--
 fs/fuse/virtio_fs.c       | 16 ++++++++++++++--
 include/uapi/linux/fuse.h |  9 ++++++++-
 7 files changed, 103 insertions(+), 22 deletions(-)

-- 
2.27.0

