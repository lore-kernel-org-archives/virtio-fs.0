From: Max Reitz <mreitz@redhat.com>
Date: Fri,  4 Jun 2021 18:13:28 +0200
Message-Id: <20210604161337.16048-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/9] virtiofsd: Allow using file handles instead
	of O_PATH FDs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Max Reitz <mreitz@redhat.com>

Hi,

This is the C virtiofsd equivalent to
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/26.  As such,
the summary is pretty much the same:

Storing an O_PATH file descriptor in every lo_inode object means we have
a lot of FDs open, which is sometimes bad.  This series adds an option
(-o inode_file_handles) that will make virtiofsd attempt to generate a
file handle for new inodes and store that instead of an FD.  When an FD
is needed for a given inode, we open the handle.

To accomplish this, lo_inode.fd is should not be accessed directly
anymore, but only through helper functions (mainly lo_inode_fd() and
lo_inode_open()).  A TempFd object is added to hide the difference
between FDs that are bound to the lo_inode object (and so need not be
closed after use) and temporary FDs from open_by_handle_at() (which do
need to be closed after use).

To prevent the problem I spent a long time talking about (if we don’t
have an FD open for every inode, the inode can be deleted, its ID
reused, and then the lookup in lo_data.inodes will find the old deleted
inode), patch 7 adds a second hash table lo_data.inodes_by_handle that
maps file handles to lo_inode objects.  (Because file handles include a
generation ID, so we can discern between the old and the new inode.)

Patch 9 is completely optional, but I just really felt compelled to
write it.


Max Reitz (9):
  virtiofsd: Add TempFd structure
  virtiofsd: Use lo_inode_open() instead of openat()
  virtiofsd: Add lo_inode_fd() helper
  virtiofsd: Let lo_fd() return a TempFd
  virtiofsd: Let lo_inode_open() return a TempFd
  virtiofsd: Add lo_inode.fhandle
  virtiofsd: Add inodes_by_handle hash table
  virtiofsd: Optionally fill lo_inode.fhandle
  virtiofsd: Add lazy lo_do_find()

 tools/virtiofsd/helper.c              |   3 +
 tools/virtiofsd/passthrough_ll.c      | 809 +++++++++++++++++++++-----
 tools/virtiofsd/passthrough_seccomp.c |   2 +
 3 files changed, 667 insertions(+), 147 deletions(-)

-- 
2.31.1

