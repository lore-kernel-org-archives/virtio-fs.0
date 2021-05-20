From: Greg Kurz <groug@kaod.org>
Date: Thu, 20 May 2021 17:46:49 +0200
Message-Id: <20210520154654.1791183-1-groug@kaod.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 0/5] virtiofs: propagate sync() to file server
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, Max Reitz <mreitz@redhat.com>, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>

This was a single patch until v3. Some preliminary cleanups were
introduced for submounts in this v4.

This can be tested with a custom virtiofsd implementing FUSE_SYNCFS, here:

https://gitlab.com/gkurz/qemu/-/tree/fuse-sync

v4: - submount fixes
    - set nodeid of the superblock in the request (Miklos)

v3: - just keep a 64-bit padding field in the arg struct (Vivek)

v2: - clarify compatibility with older servers in changelog (Vivek)
    - ignore the wait == 0 case (Miklos)
    - 64-bit aligned argument structure (Vivek, Miklos)

Greg Kurz (5):
  fuse: Fix leak in fuse_dentry_automount() error path
  fuse: Call vfs_get_tree() for submounts
  fuse: Make fuse_fill_super_submount() static
  virtiofs: Skip submounts in sget_fc()
  virtiofs: propagate sync() to file server

 fs/fuse/dir.c             | 45 +++++---------------
 fs/fuse/fuse_i.h          | 12 +++---
 fs/fuse/inode.c           | 87 ++++++++++++++++++++++++++++++++++++++-
 fs/fuse/virtio_fs.c       |  9 ++++
 include/uapi/linux/fuse.h | 10 ++++-
 5 files changed, 120 insertions(+), 43 deletions(-)

-- 
2.26.3


