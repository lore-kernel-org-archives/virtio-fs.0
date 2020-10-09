From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri,  9 Oct 2020 14:15:06 -0400
Message-Id: <20201009181512.65496-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 0/6] fuse: Implement FUSE_HANDLE_KILLPRIV_V2
	and enable SB_NOSEC
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

Hi All,

Please find attached V3 of the patches to enable SB_NOSEC for fuse. I
posted V1 and V2 here.

v2:
https://lore.kernel.org/linux-fsdevel/20200916161737.38028-1-vgoyal@redhat.com/
v1:
https://lore.kernel.org/linux-fsdevel/20200724183812.19573-1-vgoyal@redhat.com/

Changes since v2:

- Based on Miklos's feedback, dropped a patch where we send ATTR_MODE as
  that's racy. To help the case of writeback_cache with killpriv_v2, I
  fallback to a synchronous WRITE if suid/sgid is set on file.

I have generated these patches on top of.

https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git/log/?h=for-nex
+t

I have taken care of feedback from last round. For the case of random
write peformance has jumped from 50MB/s to 250MB/s. So I am really
looking forward to these changes so that fuse/virtiofs performance
can be improved for direct random writes.

Thanks
Vivek


Vivek Goyal (6):
  fuse: Introduce the notion of FUSE_HANDLE_KILLPRIV_V2
  fuse: Set FUSE_WRITE_KILL_PRIV in cached write path
  fuse: setattr should set FATTR_KILL_PRIV upon size change
  fuse: Don't send ATTR_MODE to kill suid/sgid for handle_killpriv_v2
  fuse: Add a flag FUSE_OPEN_KILL_PRIV for open() request
  fuse: Support SB_NOSEC flag to improve direct write performance

 fs/fuse/dir.c             |  4 +++-
 fs/fuse/file.c            | 16 +++++++++++++++-
 fs/fuse/fuse_i.h          |  6 ++++++
 fs/fuse/inode.c           | 17 ++++++++++++++++-
 include/uapi/linux/fuse.h | 18 +++++++++++++++++-
 5 files changed, 57 insertions(+), 4 deletions(-)

-- 
2.25.4

