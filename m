From: Max Reitz <mreitz@redhat.com>
Date: Fri, 30 Jul 2021 17:01:24 +0200
Message-Id: <20210730150134.216126-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 00/10] virtiofsd: Allow using file handles
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
Cc: Vivek Goyal <vgoyal@redhat.com>, Max Reitz <mreitz@redhat.com>

Hi,

v1 cover letter for an overview:
https://listman.redhat.com/archives/virtio-fs/2021-June/msg00033.html

v2 cover letter:
https://listman.redhat.com/archives/virtio-fs/2021-June/msg00074.html

For v3, at first I attempted to have errors related to file handle
generation (name_to_handle_at()) be returned to the guest unless they
are cases where file name generation is simply not supported, and only
then do a fallback to an O_PATH FD, as Vivek has suggested.

However, I found that to be rather complicated.  (Always falling back is
just simpler.)  Furthermore, because we believe that name_to_handle_at()
can rarely fail except for EOPNOTSUPP, there should be little difference
in practice.

Therefore, in v3, I kept the v2 model of always falling back to an
O_PATH FD when an error occurred during handle generation.

What did change in v3 is the following:
- I added patch 1, because f1aa1774dfb happened in the meantime, and
  this is basically what we did for virtiofsd-rs in the form of
  31e7ac63944 (virtiofsd-rs commit hash)

- Patch 4: In lookup_name(), I noticed that I failed to invoke
  lo_inode_put() to match the lo_inode() from the beginning of the
  function in all error paths.  Fixed by adding a common error path.

- Patch 6: Mostly contextual rebase conflicts (partly because of patch
  1), but also one functional change: I Dropped the `assert(fd >= 0)`
  under `if (open_inode)` in lo_setxattr(), because `fd` is dropped by
  this patch (and `inode_fd` is used regardless of the value of
  `open_inode` we can’t assert anything similar on it).

- Patch 8:
  - Fixed the condition to reject results found by st_ino lookup.
    - st_ino on its own is only a valid identifier/key if we have an
      O_PATH fd for its respective lo_inode, because otherwise the inode
      may be unlinked and its st_ino might be reused by some new inode
    - It does not matter whether lo_find()’s caller has supplied a file
      handle for a prior lookup by handle or not, so drop that part of
      the condition
    - Semantically, it does not matter whether the lo_inode has a file
      handle or not – what matters is whether it has an O_PATH fd or
      not.  (The two are linked by a `handle <=> !fd` condition, so that
      part wasn’t technically wrong, just semantically.)
    - In accordance with the last point, I rewrote the comment
      explaining why we have to reject such results.
  - Rebase conflict in lookup_name() because of the fix in patch 4

- Patch 9:
  - Non-functional change in lo_do_lookup() to separate the
    get_file_handle()/openat() part from the do_statx() calls (and have
    the do_statx() calls be side by side) – as a side effect, this makes
    the diff to master slightly smaller.
  - Rebase conflict in lookup_name() because of the fix in patch 4

- Patch 10:
  - Rebase conflict in lookup_name() because of the fix in patch 4


Max Reitz (10):
  virtiofsd: Limit setxattr()'s creds-dropped region
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
 tools/virtiofsd/passthrough_ll.c      | 869 +++++++++++++++++++++-----
 tools/virtiofsd/passthrough_seccomp.c |   2 +
 3 files changed, 720 insertions(+), 154 deletions(-)

-- 
2.31.1

