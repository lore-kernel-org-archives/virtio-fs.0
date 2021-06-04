From: Greg Kurz <groug@kaod.org>
Date: Fri,  4 Jun 2021 18:11:49 +0200
Message-Id: <20210604161156.408496-1-groug@kaod.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 0/7] fuse: Some fixes for submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Max Reitz <mreitz@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

v2:

- add an extra fix (patch 2) : mount is now added to the list before
  unlocking sb->s_umount
- set SB_BORN just before unlocking sb->s_umount, just like it would
  happen when using fc_mount() (Max)
- don't allocate a FUSE context for the submounts (Max)
- introduce a dedicated context ops for submounts
- add a extra cleanup : simplify the code even more with fc_mount()

v1:

While working on adding syncfs() support in FUSE, I've hit some severe
bugs with submounts (a crash and an infinite loop). The fix for the
crash is straightforward (patch 1), but the fix for the infinite loop
is more invasive : as suggested by Miklos, a simple bug fix is applied
first (patch 2) and the final fix (patch 3) is applied on top.

Greg Kurz (7):
  fuse: Fix crash in fuse_dentry_automount() error path
  fuse: Fix crash if superblock of submount gets killed early
  fuse: Fix infinite loop in sget_fc()
  fuse: Add dedicated filesystem context ops for submounts
  fuse: Call vfs_get_tree() for submounts
  fuse: Switch to fc_mount() for submounts
  fuse: Make fuse_fill_super_submount() static

 fs/fuse/dir.c       | 58 ++++++---------------------------------------
 fs/fuse/fuse_i.h    | 14 ++++-------
 fs/fuse/inode.c     | 56 +++++++++++++++++++++++++++++++++++++++++--
 fs/fuse/virtio_fs.c |  3 +++
 4 files changed, 69 insertions(+), 62 deletions(-)

-- 
2.31.1


