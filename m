From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Mon, 26 Oct 2020 18:43:15 +0000
Message-Id: <20201026184331.272953-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 00/16] virtiofs queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, mreitz@redhat.com, misono.tomohiro@jp.fujitsu.com
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

The following changes since commit a95e0396c805735c491a049b01de6f5a713fb91b:

  Merge remote-tracking branch 'remotes/bonzini-gitlab/tags/for-upstream' into staging (2020-10-26 15:49:11 +0000)

are available in the Git repository at:

  https://gitlab.com/dagrh/qemu.git tags/pull-virtiofs-20201026

for you to fetch changes up to c93a656f7b6585d9b6f8639d1fbb74dd944be239:

  tests/acceptance: Add virtiofs_submounts.py (2020-10-26 18:35:32 +0000)

----------------------------------------------------------------
virtiofsd pull 2020-10-26

Misono
   Set default log level to info
   Explicit build option for virtiofsd

Me
   xattr name mapping

Stefan
  Alternative chroot sandbox method

Max
  Submount mechanism

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

----------------------------------------------------------------
Dr. David Alan Gilbert (5):
      tools/virtiofsd: xattr name mappings: Add option
      tools/virtiofsd: xattr name mappings: Map client xattr names
      tools/virtiofsd: xattr name mappings: Map server xattr names
      tools/virtiofsd: xattr name mapping examples
      tools/virtiofsd: xattr name mappings: Simple 'map'

Max Reitz (8):
      linux/fuse.h: Pull in from Linux
      virtiofsd: Announce FUSE_ATTR_FLAGS
      virtiofsd: Add attr_flags to fuse_entry_param
      virtiofsd: Add fuse_reply_attr_with_flags()
      virtiofsd: Store every lo_inode's parent_dev
      virtiofsd: Announce sub-mount points
      tests/acceptance/boot_linux: Accept SSH pubkey
      tests/acceptance: Add virtiofs_submounts.py

Misono Tomohiro (2):
      configure: add option for virtiofsd
      virtiofsd: passthrough_ll: set FUSE_LOG_INFO as default log_level

Stefan Hajnoczi (1):
      virtiofsd: add container-friendly -o sandbox=chroot option

 configure                                          |   8 +-
 docs/tools/virtiofsd.rst                           | 193 ++++++-
 include/standard-headers/linux/fuse.h              |  11 +-
 meson.build                                        |   1 +
 meson_options.txt                                  |   2 +
 tests/acceptance/boot_linux.py                     |  13 +-
 tests/acceptance/virtiofs_submounts.py             | 289 ++++++++++
 .../virtiofs_submounts.py.data/cleanup.sh          |  46 ++
 .../virtiofs_submounts.py.data/guest-cleanup.sh    |  30 +
 .../acceptance/virtiofs_submounts.py.data/guest.sh | 138 +++++
 .../acceptance/virtiofs_submounts.py.data/host.sh  | 127 +++++
 tools/meson.build                                  |  17 +-
 tools/virtiofsd/fuse_common.h                      |   8 +
 tools/virtiofsd/fuse_lowlevel.c                    |  34 +-
 tools/virtiofsd/fuse_lowlevel.h                    |  20 +
 tools/virtiofsd/helper.c                           |   9 +
 tools/virtiofsd/passthrough_ll.c                   | 622 ++++++++++++++++++++-
 17 files changed, 1528 insertions(+), 40 deletions(-)
 create mode 100644 tests/acceptance/virtiofs_submounts.py
 create mode 100644 tests/acceptance/virtiofs_submounts.py.data/cleanup.sh
 create mode 100644 tests/acceptance/virtiofs_submounts.py.data/guest-cleanup.sh
 create mode 100644 tests/acceptance/virtiofs_submounts.py.data/guest.sh
 create mode 100644 tests/acceptance/virtiofs_submounts.py.data/host.sh

