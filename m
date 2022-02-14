From: Greg Kurz <groug@kaod.org>
Date: Mon, 14 Feb 2022 14:58:17 +0100
Message-Id: <20220214135820.43897-1-groug@kaod.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v5 0/3] virtiofsd: Add support for FUSE_SYNCFS
	request
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

FUSE_SYNCFS allows the client to flush the host page cache.

v5: - split announce_submounts and ! announce_submounts to separate patches
      for easier review (but could be squashed together)
    - track submounts directly in lo_inode structure following the same
      logic as FUSE_ATTR_SUBMOUNT (i.e. directory with either st_dev or
      stx_mnt_id different from parent)

v4: - based on upstream linux FUSE_SYNCFS
    - added support for the '-o announce_submounts' case, i.e. client sends
      a FUSE_SYNCFS request for each submount (identified by its root inode)
    - adapted the case without '-o announce_submounts' so that syncfs() is
      no longer called with lo->mutex held

v3: - track submounts and do per-submount syncfs() (Vivek)
    - based on new version of FUSE_SYNCFS (still not upstream)
      https://listman.redhat.com/archives/virtio-fs/2021-May/msg00025.html

v2: - based on new version of FUSE_SYNCFS
      https://listman.redhat.com/archives/virtio-fs/2021-April/msg00166.html
    - propagate syncfs() errors to client (Vivek)

Greg Kurz (3):
  virtiofsd: Add support for FUSE_SYNCFS request with announce_submounts
  virtiofsd: Track submounts
  virtiofsd: Add support for FUSE_SYNCFS request without
    announce_submounts

 tools/virtiofsd/fuse_lowlevel.c       | 11 ++++
 tools/virtiofsd/fuse_lowlevel.h       | 13 ++++
 tools/virtiofsd/passthrough_ll.c      | 93 +++++++++++++++++++++++++--
 tools/virtiofsd/passthrough_seccomp.c |  1 +
 4 files changed, 114 insertions(+), 4 deletions(-)

-- 
2.34.1


