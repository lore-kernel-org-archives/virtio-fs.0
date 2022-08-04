Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu,  4 Aug 2022 15:02:57 -0400
Message-Id: <20220804190258.20226-1-stefanha@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL for-7.1 0/1] Block patches
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-block@nongnu.org, Richard Henderson <richard.henderson@linaro.org>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>

The following changes since commit 2480f3bbd03814b0651a1f74959f5c6631ee5819:

  Merge tag 'linux-user-for-7.1-pull-request' of https://gitlab.com/laurent_vivier/qemu into staging (2022-08-03 08:32:44 -0700)

are available in the Git repository at:

  https://gitlab.com/stefanha/qemu.git tags/block-pull-request

for you to fetch changes up to 7b0ca313647532a2c7007379ff800c9a2415c95d:

  virtiofsd: Fix format strings (2022-08-04 14:44:25 -0400)

----------------------------------------------------------------
Pull request

- Format string portability fix in virtiofsd

----------------------------------------------------------------

Stefan Weil (1):
  virtiofsd: Fix format strings

 tools/virtiofsd/fuse_lowlevel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.37.1

