From: Max Reitz <mreitz@redhat.com>
Date: Wed,  6 May 2020 17:35:29 +0200
Message-Id: <20200506153529.239939-1-mreitz@redhat.com>
In-Reply-To: <20200506153258.238687-1-mreitz@redhat.com>
References: <20200506153258.238687-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC 0/5] fuse: Auto-mounted submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Max Reitz <mreitz@redhat.com>

Hi,

As explained in the common cover letter
(<20200506153258.238687-1-mreitz@redhat.com>),
we want the Linux FUSE driver to be able to create auto-mounted
submounts for every submount on the host.

To do so, we need to allow multiple super blocks per fuse_conn, which is
done by splitting an SB-specific fuse_mount structure off of fuse_conn,
so there can be multiple fuse_mounts per fuse_conn.

We can then create new super blocks (with anonymous block devices
backing them) for every submount point, letting them point to a shared
fuse_conn structure.


Max Reitz (5):
  fuse: Store fuse_conn in fuse_req
  fuse: Drop fuse_conn parameter where possible
  fuse: Split fuse_mount off of fuse_conn
  fuse: Allow fuse_fill_super_common() for submounts
  fuse: Implement crossmounts

 fs/fuse/fuse_i.h    | 131 ++++++++++++++++++--------
 fs/fuse/control.c   | 194 +++++++++++++++++++-------------------
 fs/fuse/dev.c       | 215 ++++++++++++++++++++++++------------------
 fs/fuse/dir.c       | 191 +++++++++++++++++++++++++++-----------
 fs/fuse/file.c      | 212 +++++++++++++++++++++---------------------
 fs/fuse/inode.c     | 221 ++++++++++++++++++++++++++++++--------------
 fs/fuse/readdir.c   |  10 +-
 fs/fuse/virtio_fs.c |  40 +++++---
 fs/fuse/xattr.c     |  34 +++----
 9 files changed, 766 insertions(+), 482 deletions(-)

-- 
2.26.2

