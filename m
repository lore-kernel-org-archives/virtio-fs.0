From: Max Reitz <mreitz@redhat.com>
Date: Wed,  9 Sep 2020 20:40:20 +0200
Message-Id: <20200909184028.262297-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/8] virtiofsd: Announce submounts to the guest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, Max Reitz <mreitz@redhat.com>

RFC: https://www.redhat.com/archives/virtio-fs/2020-May/msg00024.html

Branch: https://github.com/XanClic/qemu.git virtiofs-submounts-v2
Branch: https://git.xanclic.moe/XanClic/qemu.git virtiofs-submounts-v2


(Note that there is an accompanying Linux (kernel) series
“fuse: Mirror virtio-fs submounts”.)


Hi,

We want to (be able to) announce the host mount structure of the shared
directory to the guest so it can replicate that structure.  This ensures
that whenever the combination of st_dev and st_ino is unique on the
host, it will be unique in the guest as well.

This feature is optional and needs to be enabled explicitly, so that the
mount structure isn’t leaked to the guest if the user doesn’t want it to
be.

The last patch in this series adds a test script.  For it to pass, you
need to compile a kernel with the accompanying “fuse: Mirror virtio-fs
submounts” patch series, and provide it to the test (as described in the
test patch).


Known caveats:
- stat(2) doesn’t trigger auto-mounting.  Therefore, issuing a stat() on
  a sub-mountpoint before it’s been auto-mounted will show its parent’s
  st_dev together with the st_ino it has in the sub-mounted filesystem.

  For example, imagine you want to share a whole filesystem with the
  guest, which on the host first looks like this:

    root/           (st_dev=64, st_ino=128)
      sub_fs/       (st_dev=64, st_ino=234)

  And then you mount another filesystem under sub_fs, so it looks like
  this:

    root/           (st_dev=64, st_ino=128)
      sub_fs/       (st_dev=96, st_ino=128)
        ...

  As you can see, sub_fs becomes a mount point, so its st_dev and st_ino
  change from what they were on root’s filesystem to what they are in
  the sub-filesystem.  In fact, root and sub_fs now have the same
  st_ino, which is not unlikely given that both are root nodes in their
  respective filesystems.

  Now, this filesystem is shared with the guest through virtiofsd.
  There is no way for virtiofsd to uncover sub_fs’s original st_ino
  value of 234, so it will always provide st_ino=128 to the guest.
  However, virtiofsd does notice that sub_fs is a mount point and
  announces this fact to the guest.

  We want this to result in something like the following tree in the
  guest:

    root/           (st_dev=32, st_ino=128)
      sub_fs/       (st_dev=33, st_ino=128)
        ...

  That is, sub_fs should be a different filesystem that’s auto-mounted.
  However, as stated above, stat(2) doesn’t trigger auto-mounting, so
  before it happens, the following structure will be visible:

    root/           (st_dev=32, st_ino=128)
      sub_fs/       (st_dev=32, st_ino=128)

  That is, sub_fs and root will have the same st_dev/st_ino combination.

  This can easily be seen by executing find(1) on root in the guest,
  which will subsequently complain about an alleged filesystem loop.

  To properly fix this problem, we probably would have to be able to
  uncover sub_fs’s original st_ino value (i.e. 234) and let the guest
  use that until the auto-mount happens.  However, there is no way to
  get that value (from userspace at least).

  Note that NFS with crossmnt has the exact same issue.


- You can unmount auto-mounted submounts in the guest, but then you
  still cannot unmount them on the host.  The guest still holds a
  reference to the submount’s root directory, because that’s just a
  normal entry in its parent directory (on the submount’s parent
  filesystem).

  This is kind of related to the issue noted above: When the submount is
  unmounted, the guest shouldn’t have a reference to sub_fs as the
  submount’s root directory (host’s st_dev=96, st_ino=128), but to it as
  a normal entry in its parent filesystem (st_dev=64, st_ino=234).

  (When you have multiple nesting levels, you can unmount inner mounts
  when the outer ones have been unmounted in the guest.  For example,
  say you have a structure A/B/C/D, where each is a mount point, then
  unmounting D, C, and B in the guest will allow the host to unmount D
  and C.)


Max Reitz (8):
  linux/fuse.h: Pull in from Linux
  virtiofsd: Announce FUSE_ATTR_FLAGS
  virtiofsd: Add attr_flags to fuse_entry_param
  virtiofsd: Add fuse_reply_attr_with_flags()
  virtiofsd: Store every lo_inode's parent_dev
  virtiofsd: Announce sub-mount points
  tests/acceptance/boot_linux: Accept SSH pubkey
  tests/acceptance: Add virtiofs_submounts.py

 include/standard-headers/linux/fuse.h         |  11 +-
 tools/virtiofsd/fuse_common.h                 |   8 +
 tools/virtiofsd/fuse_lowlevel.h               |  20 ++
 tools/virtiofsd/fuse_lowlevel.c               |  34 ++-
 tools/virtiofsd/helper.c                      |   1 +
 tools/virtiofsd/passthrough_ll.c              |  84 ++++-
 tests/acceptance/boot_linux.py                |  13 +-
 tests/acceptance/virtiofs_submounts.py        | 289 ++++++++++++++++++
 .../virtiofs_submounts.py.data/cleanup.sh     |  46 +++
 .../guest-cleanup.sh                          |  30 ++
 .../virtiofs_submounts.py.data/guest.sh       | 138 +++++++++
 .../virtiofs_submounts.py.data/host.sh        | 127 ++++++++
 12 files changed, 780 insertions(+), 21 deletions(-)
 create mode 100644 tests/acceptance/virtiofs_submounts.py
 create mode 100644 tests/acceptance/virtiofs_submounts.py.data/cleanup.sh
 create mode 100644 tests/acceptance/virtiofs_submounts.py.data/guest-cleanup.sh
 create mode 100644 tests/acceptance/virtiofs_submounts.py.data/guest.sh
 create mode 100644 tests/acceptance/virtiofs_submounts.py.data/host.sh

-- 
2.26.2

