Return-Path: <armbru@redhat.com>
From: Markus Armbruster <armbru@redhat.com>
Date: Mon, 28 Nov 2022 10:41:35 +0100
Message-Id: <20221128094138.2824623-1-armbru@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 0/3] cleanup: Tweak and re-run
 return_directly.cocci
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, philmd@linaro.org, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, berrange@redhat.com, thuth@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com

v3:
* Rebased onto Greg's "[PATCH] 9pfs: Fix some return statements in the
  synth backend", which replaces my change to hw/9pfs/9p-synth.c in
  PATCH 1/3, along with a paragraph on checkpatch.pl in the commit
  message.

v2:
* Changes to imported files dropped [Philippe, Max]
* Handwritten change to vmdk_co_create() split off as PATCH 2/2 [Peter]
* New PATCH 3/2 [Zoltan]

Markus Armbruster (3):
  cleanup: Tweak and re-run return_directly.cocci
  block/vmdk: Simplify vmdk_co_create() to return directly
  ppc4xx_sdram: Simplify sdram_ddr_size() to return directly

 scripts/coccinelle/return_directly.cocci |  5 +--
 include/hw/pci/pci.h                     |  7 +--
 target/avr/cpu.h                         |  4 +-
 block/vmdk.c                             | 28 +++++-------
 hw/char/sifive_uart.c                    |  4 +-
 hw/ppc/ppc4xx_sdram.c                    | 15 ++-----
 hw/rdma/vmw/pvrdma_cmd.c                 | 57 +++++++++---------------
 hw/virtio/vhost-user.c                   |  6 +--
 migration/dirtyrate.c                    | 10 +----
 migration/tls.c                          |  6 +--
 replay/replay-time.c                     |  5 +--
 semihosting/console.c                    |  4 +-
 softmmu/memory.c                         | 11 +----
 softmmu/physmem.c                        |  9 +---
 target/loongarch/cpu.c                   |  4 +-
 target/mips/tcg/dsp_helper.c             | 15 ++-----
 target/riscv/debug.c                     |  6 +--
 target/riscv/vector_helper.c             | 28 +++---------
 tests/bench/benchmark-crypto-akcipher.c  |  6 +--
 tests/qtest/erst-test.c                  |  5 +--
 tests/qtest/hexloader-test.c             |  6 +--
 tests/qtest/pvpanic-pci-test.c           |  6 +--
 tests/qtest/pvpanic-test.c               |  6 +--
 tests/qtest/test-filter-mirror.c         |  6 +--
 tests/qtest/virtio-ccw-test.c            |  6 +--
 tests/tcg/multiarch/sha512.c             |  9 +---
 tools/virtiofsd/fuse_lowlevel.c          | 24 +++-------
 27 files changed, 80 insertions(+), 218 deletions(-)

-- 
2.37.3

