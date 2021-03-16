From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 16 Mar 2021 12:01:46 -0400
Message-Id: <20210316160147.289193-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/1] fuse: acl: Send file mode updates using
	SETATTR
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu
Cc: seth.forshee@canonical.com, Vivek Goyal <vgoyal@redhat.com>

Hi Miklos,

Please find attached a patch to fix the SGID clearing issue upon 
ACL change. 

Luis reported that currently fstests generic/375 fails on virtiofs. And
reason being that we don't clear SGID when it should be.

Setting ACL can lead to file mode change. And this in-turn also can
lead to clearing SGID bit if.

- None of caller's groups match file owner group.
AND
- Caller does not have CAP_FSETID.

Current implementation relies on server updating the mode. But file
server does not have enough information to do so. 

Initially I thought of sending CAP_FSETID information to server but
then I realized, it is just one of the pieces. What about all the
groups caller is a member of. If this has to work correctly, then
all the information will have to be sent to virtiofsd somehow. Just
sending CAP_FSETID information required adding V2 of fuse_setxattr_in
because we don't have any space for sending extra information.

https://github.com/rhvgoyal/linux/commit/681cf5bdbba9c965c3dbd4337c16e9b17f27debe

Also this approach will not work with idmapped mounts because server
does not have information about idmapped mappings.

So I started to look at the approach of sending file mode updates
using SETATTR. As filesystems like 9pfs and ceph are doing. This
seems simpler approach. Though it has its issues too.

- File mode update and setxattr(system.posix_acl_access) are not atomic.

None of the approaches seem very clean to me. But sending SETATTR
explicitly seems to be lesser of two evils to me at this point of time.
Hence I am proposing this patch. 

I have run fstests acl tests and they pass. (./check -g acl).

Corresponding virtiofsd patches are here.

https://github.com/rhvgoyal/qemu/commits/acl-sgid-setattr

What do you think.

Vivek Goyal (1):
  fuse: Add a mode where fuse client sends mode changes on ACL change

 fs/fuse/acl.c             | 54 ++++++++++++++++++++++++++++++++++++---
 fs/fuse/dir.c             | 11 ++++----
 fs/fuse/fuse_i.h          |  9 ++++++-
 fs/fuse/inode.c           |  4 ++-
 include/uapi/linux/fuse.h |  5 ++++
 5 files changed, 71 insertions(+), 12 deletions(-)

-- 
2.25.4

