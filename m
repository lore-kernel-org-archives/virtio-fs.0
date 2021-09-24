From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 24 Sep 2021 15:24:40 -0400
Message-Id: <20210924192442.916927-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/2] fuse: Send file/inode security context
	during creation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, selinux@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: stephen.smalley.work@gmail.com, vgoyal@redhat.com, miklos@szeredi.hu

Hi,

When a file is created (create, mknod, mkdir, symlink), typically file
systems call  ecurity_inode_init_security() to initialize security
context of an inode. But this does not very well with remote filesystems
as inode is not there yet. Client will send a creation request to
server and once server has created the file, client will instantiate
the inode.

So filesystems like nfs and ceph use security_dentry_init_security()
instead. This takes in a dentry and returns the security context of
file if any. 

These patches call security_dentry_init_security() and send security
label of file along with creation request (FUSE_CREATE, FUSE_MKDIR,
FUSE_MKNOD, FUSE_SYMLINK). This will give server an opportunity
to create new file and also set security label (possibly atomically
where possible).

These patches are based on the work Chirantan Ekbote did some time
back but it never got upstreamed. So I have taken his patches,
made some modifications and posting again.

https://listman.redhat.com/archives/virtio-fs/2020-July/msg00014.html
https://listman.redhat.com/archives/virtio-fs/2020-July/msg00015.html

These patches will allow us to support SELinux on virtiofs.

Vivek Goyal (2):
  fuse: Add a flag FUSE_SECURITY_CTX
  fuse: Send security context of inode on file creation

 fs/fuse/dir.c             | 114 ++++++++++++++++++++++++++++++++++++--
 fs/fuse/fuse_i.h          |   3 +
 fs/fuse/inode.c           |   4 +-
 include/uapi/linux/fuse.h |  20 ++++++-
 4 files changed, 134 insertions(+), 7 deletions(-)

-- 
2.31.1

