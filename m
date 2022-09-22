Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu, 22 Sep 2022 13:14:46 -0400
Message-Id: <20220922171447.166958-1-stefanha@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 0/1] Block patches
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Stefan Hajnoczi <stefanha@redhat.com>, qemu-block@nongnu.org, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, virtio-fs@redhat.com

The following changes since commit 6338c30111d596d955e6bc933a82184a0b910c43:

  Merge tag 'm68k-for-7.2-pull-request' of https://github.com/vivier/qemu-m68k into staging (2022-09-21 13:12:36 -0400)

are available in the Git repository at:

  https://gitlab.com/stefanha/qemu.git tags/block-pull-request

for you to fetch changes up to f16d15c9276bd8f501f861c39cbd4adc812d0c1d:

  virtiofsd: use g_date_time_get_microsecond to get subsecond (2022-09-22 13:13:47 -0400)

----------------------------------------------------------------
Pull request

----------------------------------------------------------------

Yusuke Okada (1):
  virtiofsd: use g_date_time_get_microsecond to get subsecond

 tools/virtiofsd/passthrough_ll.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
2.37.3

