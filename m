From: Hanna Reitz <hreitz@redhat.com>
Date: Thu, 16 Sep 2021 10:40:33 +0200
Message-Id: <20210916084045.31684-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 00/12] virtiofsd: Allow using file handles
	instead of O_PATH FDs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Hanna Reitz <hreitz@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

Hi,

v1 cover letter for an overview:
https://listman.redhat.com/archives/virtio-fs/2021-June/msg00033.html

v2 cover letter:
https://listman.redhat.com/archives/virtio-fs/2021-June/msg00074.html

v3 cover letter:
https://listman.redhat.com/archives/virtio-fs/2021-July/msg00050.html


Here in v4, there are two main changes:

First, for turning a mount ID into a mount FD, we no longer use the
first inode that’s looked up on the respective mount, but instead look
into /proc/self/mountinfo to get the mount’s root directory and open
that.  Wel also refcount mount FDs now.

In theory, the advantage is that before the mount root directory can be
deleted, all files on the mount must be closed (and deleted), so the
refcounting will lead to the mount FD being closed.  Then, deleting the
mount root would actually result in the inode being deleted, and so with
inotify, the guest could receive a notification about it.

In practice, this is still a mount root (on the host), so it cannot be
deleted (rmdir returns EBUSY).  But that’s effectively just as well,
because this way we open a mount FD that cannot be deleted, and so, we
won’t have to worry about missing guest notifications.

Note that unmounting the virtiofs mount in the guest will lead to all
mount FDs correctly being closed, so the refcounting does work.


Second, I’ve renamed the TempFd objects to reflect what kind of FDs they
contain; i.e. they’re no longer called “inode_fd” or “dir_fd”, but
“path_fd”, “rw_fd”, or “dir_path_fd” instead.
p


Minor changes:
- -o inode_file_handles now auto-adds +dac_read_search to modcaps
- Some fixes


(Quick note: I’ll be on PTO from Sep 20 to Oct 3, so I’ll only be able
to respond to potential reviews after then.)


Exact changes per patch:

Patch 1:
- Added, we want to use the respective mount point as a mount FD, and we
  have to read /proc/self/mountinfo to translate mount IDs to mount
  points

Patch 2:
- Moved the FCHDIR_NOFAIL(lo->root.fd) (changing the CWD back to what it
  was) into the cleanup path, and added a bool `changed_cwd` to keep
  track of when we need to invoke it
- Dropped `open_inode` (`changed_cwd` kind of makes it obsolete)

Patch 3:
- Added temp_fd_copy() to (shallow-)copy a TempFd

Patch 4:
- Forgot an lo_inode_put() in lo_opendir()’s successful return path
- lo_setxattr(): Moved procname[] into the block where it’s used (now
  that it’s generated and used within a single `else` block)

Patch 5:
- Give TempFds a name that reflects what kind of FDs they are, e.g.
  `path_fd` instead of `inode_fd`
- lo_link(): Don’t overwrite errno for the error path, but store such
  values in saverr instead and add a new error path label below the
  existing `saverr = errno;`
- xattr functions: Moved TempFds into local blocks where they are
  actually used (to generate a filename in /proc/self/fd)
  (with the renaming of `inode_fd` to `path_fd`, we are going to need
  distinct variables for both conditional blocks here – one with an
  O_RDONLY FD (`rd_fd`), and one with an O_PATH FD (`path_fd`))

Patch 6:
- Like in patch 5, give TempFds a name to reflect what they are

Patch 7:
- Like in patches 5 and 6, give TempFds a name to reflect what they are
- `lo_setattr` thus has two TempFds now, which sometimes are the same FD
  (and we use `temp_fd_copy()` to copy one into the other)
- lo_opendir(): Close the FD if `fdopendir()` failed

Patch 8:
- Added: We want the mount FD collection to be in lo_data instead of in
  a static global variable, so we need to pass lo_data wherever we might
  need a mount FD

Patch 9:
- Put mount_fds and mount_fds_lock into lo_data
- Have mount_fds values be lo_mount_fd objects (FD + refcount) instead
  of just pure FDs
- Refcount mount FDs (so releasing a file handle now has to go through a
  dedicated function)
- Having a file handle and an O_PATH FD in an lo_inode object is no
  longer mutually exclusive

Patch 10:
- Destroying the inodes_by_handle hash map should depend on whether
  inodes_by_handle is non-NULL, not whether inodes_by_ids is non-NULL
  (i.e. fixed a code typo)

Patch 11:
- Auto-add CAP_DAC_READ_SEARCH with -o inode_file_handles instead of
  requiring the user to do so
- get_file_handle(): Use /proc/self/mountinfo to get a mount’s root
  point and open that as the mount FD instead of using the first inode
  that’s looked up on that mount
- Refcount mount FDs
- Have get_file_handle() return a file handle even if creating a
  corresponding mount FD failed, and so the file handle will not be
  open-able; we can still use this file handle for lookups

Patch 12:
- Rebase conflicts


git-backport-diff against v3:

Key:
[----] : patches are identical
[####] : number of functional differences between upstream/downstream patch
[down] : patch is downstream-only
The flags [FC] indicate (F)unctional and (C)ontextual differences, respectively

001/12:[down] 'virtiofsd: Keep /proc/self/mountinfo open'
002/12:[0012] [FC] 'virtiofsd: Limit setxattr()'s creds-dropped region'
003/12:[0014] [FC] 'virtiofsd: Add TempFd structure'
004/12:[0004] [FC] 'virtiofsd: Use lo_inode_open() instead of openat()'
005/12:[0109] [FC] 'virtiofsd: Add lo_inode_fd() helper'
006/12:[0030] [FC] 'virtiofsd: Let lo_fd() return a TempFd'
007/12:[0076] [FC] 'virtiofsd: Let lo_inode_open() return a TempFd'
008/12:[down] 'virtiofsd: Pass lo_data to lo_inode_{fd,open}()'
009/12:[0111] [FC] 'virtiofsd: Add lo_inode.fhandle'
010/12:[0002] [FC] 'virtiofsd: Add inodes_by_handle hash table'
011/12:[0235] [FC] 'virtiofsd: Optionally fill lo_inode.fhandle'
012/12:[0006] [FC] 'virtiofsd: Add lazy lo_do_find()'


Hanna Reitz (12):
  virtiofsd: Keep /proc/self/mountinfo open
  virtiofsd: Limit setxattr()'s creds-dropped region
  virtiofsd: Add TempFd structure
  virtiofsd: Use lo_inode_open() instead of openat()
  virtiofsd: Add lo_inode_fd() helper
  virtiofsd: Let lo_fd() return a TempFd
  virtiofsd: Let lo_inode_open() return a TempFd
  virtiofsd: Pass lo_data to lo_inode_{fd,open}()
  virtiofsd: Add lo_inode.fhandle
  virtiofsd: Add inodes_by_handle hash table
  virtiofsd: Optionally fill lo_inode.fhandle
  virtiofsd: Add lazy lo_do_find()

 tools/virtiofsd/helper.c              |    3 +
 tools/virtiofsd/passthrough_ll.c      | 1102 +++++++++++++++++++++----
 tools/virtiofsd/passthrough_seccomp.c |    2 +
 3 files changed, 951 insertions(+), 156 deletions(-)

-- 
2.31.1

