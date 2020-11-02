From: Max Reitz <mreitz@redhat.com>
Date: Mon,  2 Nov 2020 17:18:52 +0100
Message-Id: <20201102161859.156603-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 0/7] virtiofsd: Announce submounts to the
	guest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Eduardo Habkost <ehabkost@redhat.com>, Max Reitz <mreitz@redhat.com>, virtio-fs@redhat.com

RFC: https://www.redhat.com/archives/virtio-fs/2020-May/msg00024.html
v1: https://lists.nongnu.org/archive/html/qemu-devel/2020-09/msg03598.html
v2: https://lists.nongnu.org/archive/html/qemu-devel/2020-10/msg09117.html

Branch: https://github.com/XanClic/qemu.git virtiofs-submounts-v4
Branch: https://git.xanclic.moe/XanClic/qemu.git virtiofs-submounts-v4


Hi,

In an effort to cut this cover letter shorter, I’ll defer to the cover
letter of v2 linked above concerning the general description of this
series, and limit myself to describing the differences from v2:


v3:
- Patch 7:
  - Replace specific has_passwordless_sudo() function by a generic
    has_cmd() function that can check for any shell command whether it
    works or not

  - Let this function catch exceptions, too, so if sudo is not present
    altogether, the test doesn’t fail but is skipped as intended
    [Eduardo]

  - (Add has_cmds() to run multiple instances of has_cmd() in a
    decorator)

  - Skip the test not only if “sudo -n true” doesn’t work, but also
    check for ssh-keygen, bash, losetup, mkfs.xfs, and mount, which are
    some other tools we need that might not be present on the host


git-backport-diff against v2:

Key:
[----] : patches are identical
[####] : number of functional differences between upstream/downstream patch
[down] : patch is downstream-only
The flags [FC] indicate (F)unctional and (C)ontextual differences, respectively

001/7:[----] [--] 'virtiofsd: Check FUSE_SUBMOUNTS'
002/7:[----] [--] 'virtiofsd: Add attr_flags to fuse_entry_param'
003/7:[----] [--] 'meson.build: Check for statx()'
004/7:[----] [--] 'virtiofsd: Add mount ID to the lo_inode key'
005/7:[----] [--] 'virtiofsd: Announce sub-mount points'
006/7:[----] [--] 'tests/acceptance/boot_linux: Accept SSH pubkey'
007/7:[0042] [FC] 'tests/acceptance: Add virtiofs_submounts.py'


Max Reitz (7):
  virtiofsd: Check FUSE_SUBMOUNTS
  virtiofsd: Add attr_flags to fuse_entry_param
  meson.build: Check for statx()
  virtiofsd: Add mount ID to the lo_inode key
  virtiofsd: Announce sub-mount points
  tests/acceptance/boot_linux: Accept SSH pubkey
  tests/acceptance: Add virtiofs_submounts.py

 meson.build                                   |  16 +
 tools/virtiofsd/fuse_common.h                 |   7 +
 tools/virtiofsd/fuse_lowlevel.h               |   5 +
 tools/virtiofsd/fuse_lowlevel.c               |   5 +
 tools/virtiofsd/helper.c                      |   1 +
 tools/virtiofsd/passthrough_ll.c              | 117 ++++++-
 tools/virtiofsd/passthrough_seccomp.c         |   1 +
 tests/acceptance/boot_linux.py                |  13 +-
 tests/acceptance/virtiofs_submounts.py        | 321 ++++++++++++++++++
 .../virtiofs_submounts.py.data/cleanup.sh     |  46 +++
 .../guest-cleanup.sh                          |  30 ++
 .../virtiofs_submounts.py.data/guest.sh       | 138 ++++++++
 .../virtiofs_submounts.py.data/host.sh        | 127 +++++++
 13 files changed, 811 insertions(+), 16 deletions(-)
 create mode 100644 tests/acceptance/virtiofs_submounts.py
 create mode 100644 tests/acceptance/virtiofs_submounts.py.data/cleanup.sh
 create mode 100644 tests/acceptance/virtiofs_submounts.py.data/guest-cleanup.sh
 create mode 100644 tests/acceptance/virtiofs_submounts.py.data/guest.sh
 create mode 100644 tests/acceptance/virtiofs_submounts.py.data/host.sh

-- 
2.26.2

