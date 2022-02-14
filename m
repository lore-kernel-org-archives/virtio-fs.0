From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Mon, 14 Feb 2022 17:15:42 +0000
Message-Id: <20220214171545.10242-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 0/3] Block patches
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc: Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, libvir-list@redhat.com, virtio-fs@redhat.com, Hanna Reitz <hreitz@redhat.com>

The following changes since commit cc5ce8b8b6be83e5fe3b668dbd061ad97c534e3f:

  Merge remote-tracking branch 'remotes/legoater/tags/pull-ppc-20220210' into staging (2022-02-13 20:33:28 +0000)

are available in the Git repository at:

  https://gitlab.com/stefanha/qemu.git tags/block-pull-request

for you to fetch changes up to 4c41c69e05fe28c0f95f8abd2ebf407e95a4f04b:

  util: adjust coroutine pool size to virtio block queue (2022-02-14 17:11:25 +0000)

----------------------------------------------------------------
Pull request

This contains coroutine poll size scaling, virtiofsd rseq seccomp for new glibc
versions, and the QEMU C virtiofsd deprecation notice.

----------------------------------------------------------------

Christian Ehrhardt (1):
  tools/virtiofsd: Add rseq syscall to the seccomp allowlist

Dr. David Alan Gilbert (1):
  Deprecate C virtiofsd

Hiroki Narukawa (1):
  util: adjust coroutine pool size to virtio block queue

 docs/about/deprecated.rst             | 17 +++++++++++++++++
 include/qemu/coroutine.h              | 10 ++++++++++
 hw/block/virtio-blk.c                 |  5 +++++
 tools/virtiofsd/passthrough_seccomp.c |  3 +++
 util/qemu-coroutine.c                 | 20 ++++++++++++++++----
 5 files changed, 51 insertions(+), 4 deletions(-)

-- 
2.34.1


