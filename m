From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue, 16 Feb 2021 18:37:28 +0000
Message-Id: <20210216183734.57810-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 0/6] virtiofs queue
List-Id: Development discussions about virtio-fs <virtio-fs.listman.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@listman.redhat.com>
List-Help: <mailto:virtio-fs-request@listman.redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, wainersm@redhat.com, groug@kaod.org, philmd@redhat.com, vgoyal@redhat.com
Cc: virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

The following changes since commit 18543229fd7a2c79dcd6818c7b1f0f62512b5220:

  Merge remote-tracking branch 'remotes/cleber-gitlab/tags/python-next-pull-request' into staging (2021-02-16 14:37:57 +0000)

are available in the Git repository at:

  https://gitlab.com/dagrh/qemu.git tags/pull-virtiofs-20210216

for you to fetch changes up to 26ec1909648e0c06ff06ebc3ddb2f88ebeeaa6a9:

  virtiofsd: Do not use a thread pool by default (2021-02-16 17:54:18 +0000)

----------------------------------------------------------------
virtiofsd pull 2021-02-16

Vivek's support for new FUSE KILLPRIV_V2
and some smaller cleanups.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

----------------------------------------------------------------
Greg Kurz (1):
      virtiofsd: vu_dispatch locking should never fail

Philippe Mathieu-Daudé (1):
      tools/virtiofsd: Replace the word 'whitelist'

Vivek Goyal (3):
      virtiofsd: Save error code early at the failure callsite
      viriofsd: Add support for FUSE_HANDLE_KILLPRIV_V2
      virtiofsd: Do not use a thread pool by default

Wainer dos Santos Moschetta (1):
      virtiofsd: Allow to build it without the tools

 tools/meson.build                     |  7 ++-
 tools/virtiofsd/fuse_common.h         | 15 ++++++
 tools/virtiofsd/fuse_lowlevel.c       | 13 ++++-
 tools/virtiofsd/fuse_lowlevel.h       |  1 +
 tools/virtiofsd/fuse_virtio.c         | 49 ++++++++++++-----
 tools/virtiofsd/passthrough_ll.c      | 99 ++++++++++++++++++++++++++++++-----
 tools/virtiofsd/passthrough_seccomp.c | 12 ++---
 7 files changed, 158 insertions(+), 38 deletions(-)

