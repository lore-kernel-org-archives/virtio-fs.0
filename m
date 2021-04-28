From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Date: Wed, 28 Apr 2021 16:48:11 +0200
Message-Id: <20210428144813.417170-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/2] virtiofsd: Meson build fixes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Thomas Huth <thuth@redhat.com>, "Daniel P . Berrange" <berrange@redhat.com>, virtio-fs@redhat.com, Mahmoud Mandour <ma.mandourr@gmail.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>

A pair of fixes to allow building virtiofsd without sysemu/tools.

Should this configuration be tested in CI?

Regards,

Phil.

Philippe Mathieu-Daudé (2):
  meson: Check for seccomp/cap-ng libraries if virtiofsd is enabled
  util/meson: Build iov/hexdump/buffer_is_zero with virtiofsd

 meson.build      |  4 ++--
 util/meson.build | 10 +++++++---
 2 files changed, 9 insertions(+), 5 deletions(-)

-- 
2.26.3



