From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Date: Thu, 27 Feb 2020 14:59:25 +0900
Message-ID: <20200227055927.24566-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 0/2] virtiofsd: Fix xattr operations
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: qemu-devel@nongnu.org, vgoyal@redhat.com

Currently xattr operations on virtiofs does not work properly in some case:
 - directory ... cannot set
 - special files (pipe) ... cause hang

This fixes these problems and now xfstests generic/062 passes on virtiofs
with -o xattr option (I tested with xfs).

v3 -> v4:
 - No logic change
 - Some code style fix/update comments and commit log as suggested by Vivek
 - CC qemu-devel ML too

Previous versions can be found in virtiofs ML:
 v3: https://www.redhat.com/archives/virtio-fs/2020-February/msg00032.html

Thanks,
Misono Tomohiro (2):
  virtiofsd: passthrough_ll: cleanup getxattr/listxattr
  virtiofsd: Fix xattr operations

 tools/virtiofsd/fuse_virtio.c    |  13 +++
 tools/virtiofsd/passthrough_ll.c | 139 ++++++++++++++++---------------
 tools/virtiofsd/seccomp.c        |   6 ++
 3 files changed, 89 insertions(+), 69 deletions(-)

-- 
2.21.1


