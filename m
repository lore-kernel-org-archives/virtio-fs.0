From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 10 Nov 2021 17:55:27 -0500
Message-Id: <20211110225528.48601-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 0/1] fuse: Send file/inode security context
	during creation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: miklos@szeredi.hu
Cc: selinux@vger.kernel.org, casey@schaufler-ca.com, stephen.smalley.work@gmail.com, omosnace@redhat.com, virtio-fs@redhat.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com

Hi,

This is V3 of the patch. V2 was posted here.

https://lore.kernel.org/linux-fsdevel/20210924192442.916927-1-vgoyal@redhat.com/

I took care of feedback from Miklos. Changes since v2 are.

- Merged two patches into one. (Miklos)
- Renamed fuse_secctxs to fuse_secctx_header (Miklos)
- Added total size of all contexts (including fuse_secctx_header) field
  in fuse_secctx_header. (Miklos)
- Fixed changelogs (Casey Schaufler)
- Removed one unnecessary if condition check (Miklos)
- Removed a function argument to function create_new_entry() (Miklos)

Thanks
Vivek

Vivek Goyal (1):
  fuse: Send security context of inode on file creation

 fs/fuse/dir.c             | 103 ++++++++++++++++++++++++++++++++++++++
 fs/fuse/fuse_i.h          |   3 ++
 fs/fuse/inode.c           |   4 +-
 include/uapi/linux/fuse.h |  31 +++++++++++-
 4 files changed, 139 insertions(+), 2 deletions(-)

-- 
2.31.1

