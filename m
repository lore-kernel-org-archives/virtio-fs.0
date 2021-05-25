From: Greg Kurz <groug@kaod.org>
Date: Tue, 25 May 2021 17:02:26 +0200
Message-Id: <20210525150230.157586-1-groug@kaod.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/4] fuse: Some fixes for submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

While working on adding syncfs() support in FUSE, I've hit some severe
bugs with submounts (a crash and an infinite loop). The fix for the
crash is straightforward (patch 1), but the fix for the infinite loop
is more invasive : as suggested by Miklos, a simple bug fix is applied
first (patch 2) and the final fix (patch 3) is applied on top.

Greg Kurz (4):
  fuse: Fix crash in fuse_dentry_automount() error path
  fuse: Fix infinite loop in sget_fc()
  fuse: Call vfs_get_tree() for submounts
  fuse: Make fuse_fill_super_submount() static

 fs/fuse/dir.c       | 46 ++++++++++---------------------------------
 fs/fuse/fuse_i.h    |  9 +++------
 fs/fuse/inode.c     | 48 +++++++++++++++++++++++++++++++++++++++++++--
 fs/fuse/virtio_fs.c |  3 +++
 4 files changed, 62 insertions(+), 44 deletions(-)

-- 
2.31.1


