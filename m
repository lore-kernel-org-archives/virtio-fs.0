From: Max Reitz <mreitz@redhat.com>
Date: Wed,  9 Sep 2020 20:45:54 +0200
Message-Id: <20200909184603.263700-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/9] fuse: Mirror virtio-fs submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: fuse-devel@lists.sourceforge.net, Max Reitz <mreitz@redhat.com>

RFC: https://www.redhat.com/archives/virtio-fs/2020-May/msg00018.html

Branch: https://github.com/XanClic/linux.git virtiofs-submounts-v2


(Note that there is an accompanying QEMU series
“virtiofsd: Announce submounts to the guest”;
https://www.redhat.com/archives/virtio-fs/2020-September/msg00016.html)



Hi,

When using virtio-fs, we want all nodes that have a unique st_dev/st_ino
combination on the host to have such a unique combination in the guest
as well.  To do so, we introduce a flags field to fuse_attr, where
virtiofsd can announce submounts.  All such entries are then translated
to auto-mounts by the FUSE driver in the guest.

Because this is something that we probably do not want to enable
unconditionally for traditional FUSE servers, it is currently limited to
virtio-fs.

(For virtio-fs, we can leave the decision of whether to enable this
feature or not to virtiofsd, because with it residing on the host, it
has higher privileges than the guest anyway.)

For this to do something useful, you need to apply the “virtiofsd:
Announce submounts to the guest” series to qemu (which also provides a
test there).


Implementation-wise, this series splits off everything that is
superblock-specific from fuse_conn into a new fuse_mount structure, so
that a single fuse_conn can have multiple fuse_mounts and thus multiple
superblocks.  Each submount’s superblock then gets its own anonymous
block device so the filesystem receives a unique st_dev value.


Max Reitz (9):
  fuse: Add fuse_attr.flags
  fuse: Add FUSE_ATTR_SUBMOUNT
  fuse: Add FUSE_ATTR_FLAGS
  fuse: Announce FUSE_ATTR_FLAGS
  fuse: Store fuse_conn in fuse_req
  fuse: Drop fuse_conn parameter where possible
  fuse: Split fuse_mount off of fuse_conn
  fuse: Allow fuse_fill_super_common() for submounts
  fuse: Implement crossmounts

 fs/fuse/fuse_i.h          | 136 ++++++++++++++----
 include/uapi/linux/fuse.h |  11 +-
 fs/fuse/control.c         |  28 +++-
 fs/fuse/dev.c             | 161 ++++++++++-----------
 fs/fuse/dir.c             | 198 +++++++++++++++++++-------
 fs/fuse/file.c            | 211 ++++++++++++++--------------
 fs/fuse/inode.c           | 288 +++++++++++++++++++++++++++++---------
 fs/fuse/readdir.c         |  10 +-
 fs/fuse/virtio_fs.c       |  73 ++++++----
 fs/fuse/xattr.c           |  34 ++---
 10 files changed, 765 insertions(+), 385 deletions(-)

-- 
2.26.2

