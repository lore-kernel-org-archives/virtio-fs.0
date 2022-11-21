Return-Path: <armbru@redhat.com>
From: Markus Armbruster <armbru@redhat.com>
Date: Mon, 21 Nov 2022 15:01:21 +0100
Message-Id: <20221121140121.1079100-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] cleanup: Tweak and re-run return_directly.cocci
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: fam@euphon.net, kwolf@redhat.com, hreitz@redhat.com, groug@kaod.org, qemu_oss@crudebyte.com, Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, philmd@linaro.org, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, jcmvbkbc@gmail.com, berrange@redhat.com, thuth@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-block@nongnu.org, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com

Tweak the semantic patch to drop redundant parenthesis around the
return expression.

Coccinelle drops comments in hw/rdma/vmw/pvrdma_cmd.c; restored
manually.

Coccinelle messes up vmdk_co_create(), not sure why.  Transformed
manually.

Line breaks in target/avr/cpu.h and hw/rdma/vmw/pvrdma_cmd.c tidied up
manually.

Whitespace in fuse_reply_iov() tidied up manually.

checkpatch.pl complains "return of an errno should typically be -ve"
two times for hw/9pfs/9p-synth.c.  Preexisting, the patch merely makes
it visible to checkpatch.pl.

checkpatch.pl complains "return is not a function, parentheses are not
required" three times for target/mips/tcg/dsp_helper.c.  False
positives.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 scripts/coccinelle/return_directly.cocci      |   5 +-
 include/hw/pci/pci.h                          |   7 +-
 target/avr/cpu.h                              |   4 +-
 block/vmdk.c                                  |  28 ++--
 hw/9pfs/9p-synth.c                            |  14 +-
 hw/char/sifive_uart.c                         |   4 +-
 hw/ppc/ppc4xx_sdram.c                         |   5 +-
 hw/rdma/vmw/pvrdma_cmd.c                      |  57 +++-----
 hw/virtio/vhost-user.c                        |   6 +-
 migration/dirtyrate.c                         |  10 +-
 migration/tls.c                               |   6 +-
 replay/replay-time.c                          |   5 +-
 semihosting/console.c                         |   4 +-
 softmmu/memory.c                              |  11 +-
 softmmu/physmem.c                             |   9 +-
 target/loongarch/cpu.c                        |   4 +-
 target/mips/tcg/dsp_helper.c                  |  15 +-
 target/riscv/debug.c                          |   6 +-
 target/riscv/vector_helper.c                  |  28 +---
 tests/bench/benchmark-crypto-akcipher.c       |   6 +-
 tests/qtest/erst-test.c                       |   5 +-
 tests/qtest/hexloader-test.c                  |   6 +-
 tests/qtest/pvpanic-pci-test.c                |   6 +-
 tests/qtest/pvpanic-test.c                    |   6 +-
 tests/qtest/test-filter-mirror.c              |   6 +-
 tests/qtest/virtio-ccw-test.c                 |   6 +-
 .../user/ase/msa/bit-count/test_msa_nloc_b.c  |   9 +-
 .../user/ase/msa/bit-count/test_msa_nloc_d.c  |   9 +-
 .../user/ase/msa/bit-count/test_msa_nloc_h.c  |   9 +-
 .../user/ase/msa/bit-count/test_msa_nloc_w.c  |   9 +-
 .../user/ase/msa/bit-count/test_msa_nlzc_b.c  |   9 +-
 .../user/ase/msa/bit-count/test_msa_nlzc_d.c  |   9 +-
 .../user/ase/msa/bit-count/test_msa_nlzc_h.c  |   9 +-
 .../user/ase/msa/bit-count/test_msa_nlzc_w.c  |   9 +-
 .../user/ase/msa/bit-count/test_msa_pcnt_b.c  |   9 +-
 .../user/ase/msa/bit-count/test_msa_pcnt_d.c  |   9 +-
 .../user/ase/msa/bit-count/test_msa_pcnt_h.c  |   9 +-
 .../user/ase/msa/bit-count/test_msa_pcnt_w.c  |   9 +-
 .../user/ase/msa/bit-move/test_msa_binsl_b.c  |   9 +-
 .../user/ase/msa/bit-move/test_msa_binsl_d.c  |   9 +-
 .../user/ase/msa/bit-move/test_msa_binsl_h.c  |   9 +-
 .../user/ase/msa/bit-move/test_msa_binsl_w.c  |   9 +-
 .../user/ase/msa/bit-move/test_msa_binsr_b.c  |   9 +-
 .../user/ase/msa/bit-move/test_msa_binsr_d.c  |   9 +-
 .../user/ase/msa/bit-move/test_msa_binsr_h.c  |   9 +-
 .../user/ase/msa/bit-move/test_msa_binsr_w.c  |   9 +-
 .../user/ase/msa/bit-move/test_msa_bmnz_v.c   |   9 +-
 .../user/ase/msa/bit-move/test_msa_bmz_v.c    |   9 +-
 .../user/ase/msa/bit-move/test_msa_bsel_v.c   |   9 +-
 .../user/ase/msa/bit-set/test_msa_bclr_b.c    |   9 +-
 .../user/ase/msa/bit-set/test_msa_bclr_d.c    |   9 +-
 .../user/ase/msa/bit-set/test_msa_bclr_h.c    |   9 +-
 .../user/ase/msa/bit-set/test_msa_bclr_w.c    |   9 +-
 .../user/ase/msa/bit-set/test_msa_bneg_b.c    |   9 +-
 .../user/ase/msa/bit-set/test_msa_bneg_d.c    |   9 +-
 .../user/ase/msa/bit-set/test_msa_bneg_h.c    |   9 +-
 .../user/ase/msa/bit-set/test_msa_bneg_w.c    |   9 +-
 .../user/ase/msa/bit-set/test_msa_bset_b.c    |   9 +-
 .../user/ase/msa/bit-set/test_msa_bset_d.c    |   9 +-
 .../user/ase/msa/bit-set/test_msa_bset_h.c    |   9 +-
 .../user/ase/msa/bit-set/test_msa_bset_w.c    |   9 +-
 .../msa/fixed-multiply/test_msa_madd_q_h.c    |   9 +-
 .../msa/fixed-multiply/test_msa_madd_q_w.c    |   9 +-
 .../msa/fixed-multiply/test_msa_maddr_q_h.c   |   9 +-
 .../msa/fixed-multiply/test_msa_maddr_q_w.c   |   9 +-
 .../msa/fixed-multiply/test_msa_msub_q_h.c    |   9 +-
 .../msa/fixed-multiply/test_msa_msub_q_w.c    |   9 +-
 .../msa/fixed-multiply/test_msa_msubr_q_h.c   |   9 +-
 .../msa/fixed-multiply/test_msa_msubr_q_w.c   |   9 +-
 .../ase/msa/fixed-multiply/test_msa_mul_q_h.c |   9 +-
 .../ase/msa/fixed-multiply/test_msa_mul_q_w.c |   9 +-
 .../msa/fixed-multiply/test_msa_mulr_q_h.c    |   9 +-
 .../msa/fixed-multiply/test_msa_mulr_q_w.c    |   9 +-
 .../ase/msa/float-max-min/test_msa_fmax_a_d.c |   9 +-
 .../ase/msa/float-max-min/test_msa_fmax_a_w.c |   9 +-
 .../ase/msa/float-max-min/test_msa_fmax_d.c   |   9 +-
 .../ase/msa/float-max-min/test_msa_fmax_w.c   |   9 +-
 .../ase/msa/float-max-min/test_msa_fmin_a_d.c |   9 +-
 .../ase/msa/float-max-min/test_msa_fmin_a_w.c |   9 +-
 .../ase/msa/float-max-min/test_msa_fmin_d.c   |   9 +-
 .../ase/msa/float-max-min/test_msa_fmin_w.c   |   9 +-
 .../user/ase/msa/int-add/test_msa_add_a_b.c   |   9 +-
 .../user/ase/msa/int-add/test_msa_add_a_d.c   |   9 +-
 .../user/ase/msa/int-add/test_msa_add_a_h.c   |   9 +-
 .../user/ase/msa/int-add/test_msa_add_a_w.c   |   9 +-
 .../user/ase/msa/int-add/test_msa_adds_a_b.c  |   9 +-
 .../user/ase/msa/int-add/test_msa_adds_a_d.c  |   9 +-
 .../user/ase/msa/int-add/test_msa_adds_a_h.c  |   9 +-
 .../user/ase/msa/int-add/test_msa_adds_a_w.c  |   9 +-
 .../user/ase/msa/int-add/test_msa_adds_s_b.c  |   9 +-
 .../user/ase/msa/int-add/test_msa_adds_s_d.c  |   9 +-
 .../user/ase/msa/int-add/test_msa_adds_s_h.c  |   9 +-
 .../user/ase/msa/int-add/test_msa_adds_s_w.c  |   9 +-
 .../user/ase/msa/int-add/test_msa_adds_u_b.c  |   9 +-
 .../user/ase/msa/int-add/test_msa_adds_u_d.c  |   9 +-
 .../user/ase/msa/int-add/test_msa_adds_u_h.c  |   9 +-
 .../user/ase/msa/int-add/test_msa_adds_u_w.c  |   9 +-
 .../user/ase/msa/int-add/test_msa_addv_b.c    |   9 +-
 .../user/ase/msa/int-add/test_msa_addv_d.c    |   9 +-
 .../user/ase/msa/int-add/test_msa_addv_h.c    |   9 +-
 .../user/ase/msa/int-add/test_msa_addv_w.c    |   9 +-
 .../user/ase/msa/int-add/test_msa_hadd_s_d.c  |   9 +-
 .../user/ase/msa/int-add/test_msa_hadd_s_h.c  |   9 +-
 .../user/ase/msa/int-add/test_msa_hadd_s_w.c  |   9 +-
 .../user/ase/msa/int-add/test_msa_hadd_u_d.c  |   9 +-
 .../user/ase/msa/int-add/test_msa_hadd_u_h.c  |   9 +-
 .../user/ase/msa/int-add/test_msa_hadd_u_w.c  |   9 +-
 .../ase/msa/int-average/test_msa_ave_s_b.c    |   9 +-
 .../ase/msa/int-average/test_msa_ave_s_d.c    |   9 +-
 .../ase/msa/int-average/test_msa_ave_s_h.c    |   9 +-
 .../ase/msa/int-average/test_msa_ave_s_w.c    |   9 +-
 .../ase/msa/int-average/test_msa_ave_u_b.c    |   9 +-
 .../ase/msa/int-average/test_msa_ave_u_d.c    |   9 +-
 .../ase/msa/int-average/test_msa_ave_u_h.c    |   9 +-
 .../ase/msa/int-average/test_msa_ave_u_w.c    |   9 +-
 .../ase/msa/int-average/test_msa_aver_s_b.c   |   9 +-
 .../ase/msa/int-average/test_msa_aver_s_d.c   |   9 +-
 .../ase/msa/int-average/test_msa_aver_s_h.c   |   9 +-
 .../ase/msa/int-average/test_msa_aver_s_w.c   |   9 +-
 .../ase/msa/int-average/test_msa_aver_u_b.c   |   9 +-
 .../ase/msa/int-average/test_msa_aver_u_d.c   |   9 +-
 .../ase/msa/int-average/test_msa_aver_u_h.c   |   9 +-
 .../ase/msa/int-average/test_msa_aver_u_w.c   |   9 +-
 .../user/ase/msa/int-compare/test_msa_ceq_b.c |   9 +-
 .../user/ase/msa/int-compare/test_msa_ceq_d.c |   9 +-
 .../user/ase/msa/int-compare/test_msa_ceq_h.c |   9 +-
 .../user/ase/msa/int-compare/test_msa_ceq_w.c |   9 +-
 .../ase/msa/int-compare/test_msa_cle_s_b.c    |   9 +-
 .../ase/msa/int-compare/test_msa_cle_s_d.c    |   9 +-
 .../ase/msa/int-compare/test_msa_cle_s_h.c    |   9 +-
 .../ase/msa/int-compare/test_msa_cle_s_w.c    |   9 +-
 .../ase/msa/int-compare/test_msa_cle_u_b.c    |   9 +-
 .../ase/msa/int-compare/test_msa_cle_u_d.c    |   9 +-
 .../ase/msa/int-compare/test_msa_cle_u_h.c    |   9 +-
 .../ase/msa/int-compare/test_msa_cle_u_w.c    |   9 +-
 .../ase/msa/int-compare/test_msa_clt_s_b.c    |   9 +-
 .../ase/msa/int-compare/test_msa_clt_s_d.c    |   9 +-
 .../ase/msa/int-compare/test_msa_clt_s_h.c    |   9 +-
 .../ase/msa/int-compare/test_msa_clt_s_w.c    |   9 +-
 .../ase/msa/int-compare/test_msa_clt_u_b.c    |   9 +-
 .../ase/msa/int-compare/test_msa_clt_u_d.c    |   9 +-
 .../ase/msa/int-compare/test_msa_clt_u_h.c    |   9 +-
 .../ase/msa/int-compare/test_msa_clt_u_w.c    |   9 +-
 .../ase/msa/int-divide/test_msa_div_s_b.c     |   9 +-
 .../ase/msa/int-divide/test_msa_div_s_d.c     |   9 +-
 .../ase/msa/int-divide/test_msa_div_s_h.c     |   9 +-
 .../ase/msa/int-divide/test_msa_div_s_w.c     |   9 +-
 .../ase/msa/int-divide/test_msa_div_u_b.c     |   9 +-
 .../ase/msa/int-divide/test_msa_div_u_d.c     |   9 +-
 .../ase/msa/int-divide/test_msa_div_u_h.c     |   9 +-
 .../ase/msa/int-divide/test_msa_div_u_w.c     |   9 +-
 .../msa/int-dot-product/test_msa_dotp_s_d.c   |   9 +-
 .../msa/int-dot-product/test_msa_dotp_s_h.c   |   9 +-
 .../msa/int-dot-product/test_msa_dotp_s_w.c   |   9 +-
 .../msa/int-dot-product/test_msa_dotp_u_d.c   |   9 +-
 .../msa/int-dot-product/test_msa_dotp_u_h.c   |   9 +-
 .../msa/int-dot-product/test_msa_dotp_u_w.c   |   9 +-
 .../msa/int-dot-product/test_msa_dpadd_s_d.c  |   9 +-
 .../msa/int-dot-product/test_msa_dpadd_s_h.c  |   9 +-
 .../msa/int-dot-product/test_msa_dpadd_s_w.c  |   9 +-
 .../msa/int-dot-product/test_msa_dpadd_u_d.c  |   9 +-
 .../msa/int-dot-product/test_msa_dpadd_u_h.c  |   9 +-
 .../msa/int-dot-product/test_msa_dpadd_u_w.c  |   9 +-
 .../msa/int-dot-product/test_msa_dpsub_s_d.c  |   9 +-
 .../msa/int-dot-product/test_msa_dpsub_s_h.c  |   9 +-
 .../msa/int-dot-product/test_msa_dpsub_s_w.c  |   9 +-
 .../msa/int-dot-product/test_msa_dpsub_u_d.c  |   9 +-
 .../msa/int-dot-product/test_msa_dpsub_u_h.c  |   9 +-
 .../msa/int-dot-product/test_msa_dpsub_u_w.c  |   9 +-
 .../ase/msa/int-max-min/test_msa_max_a_b.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_max_a_d.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_max_a_h.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_max_a_w.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_max_s_b.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_max_s_d.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_max_s_h.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_max_s_w.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_max_u_b.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_max_u_d.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_max_u_h.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_max_u_w.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_min_a_b.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_min_a_d.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_min_a_h.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_min_a_w.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_min_s_b.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_min_s_d.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_min_s_h.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_min_s_w.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_min_u_b.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_min_u_d.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_min_u_h.c    |   9 +-
 .../ase/msa/int-max-min/test_msa_min_u_w.c    |   9 +-
 .../ase/msa/int-modulo/test_msa_mod_s_b.c     |   9 +-
 .../ase/msa/int-modulo/test_msa_mod_s_d.c     |   9 +-
 .../ase/msa/int-modulo/test_msa_mod_s_h.c     |   9 +-
 .../ase/msa/int-modulo/test_msa_mod_s_w.c     |   9 +-
 .../ase/msa/int-modulo/test_msa_mod_u_b.c     |   9 +-
 .../ase/msa/int-modulo/test_msa_mod_u_d.c     |   9 +-
 .../ase/msa/int-modulo/test_msa_mod_u_h.c     |   9 +-
 .../ase/msa/int-modulo/test_msa_mod_u_w.c     |   9 +-
 .../ase/msa/int-multiply/test_msa_maddv_b.c   |   9 +-
 .../ase/msa/int-multiply/test_msa_maddv_d.c   |   9 +-
 .../ase/msa/int-multiply/test_msa_maddv_h.c   |   9 +-
 .../ase/msa/int-multiply/test_msa_maddv_w.c   |   9 +-
 .../ase/msa/int-multiply/test_msa_msubv_b.c   |   9 +-
 .../ase/msa/int-multiply/test_msa_msubv_d.c   |   9 +-
 .../ase/msa/int-multiply/test_msa_msubv_h.c   |   9 +-
 .../ase/msa/int-multiply/test_msa_msubv_w.c   |   9 +-
 .../ase/msa/int-multiply/test_msa_mulv_b.c    |   9 +-
 .../ase/msa/int-multiply/test_msa_mulv_d.c    |   9 +-
 .../ase/msa/int-multiply/test_msa_mulv_h.c    |   9 +-
 .../ase/msa/int-multiply/test_msa_mulv_w.c    |   9 +-
 .../ase/msa/int-subtract/test_msa_asub_s_b.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_asub_s_d.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_asub_s_h.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_asub_s_w.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_asub_u_b.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_asub_u_d.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_asub_u_h.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_asub_u_w.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_hsub_s_d.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_hsub_s_h.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_hsub_s_w.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_hsub_u_d.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_hsub_u_h.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_hsub_u_w.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_subs_s_b.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_subs_s_d.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_subs_s_h.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_subs_s_w.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_subs_u_b.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_subs_u_d.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_subs_u_h.c  |   9 +-
 .../ase/msa/int-subtract/test_msa_subs_u_w.c  |   9 +-
 .../msa/int-subtract/test_msa_subsus_u_b.c    |   9 +-
 .../msa/int-subtract/test_msa_subsus_u_d.c    |   9 +-
 .../msa/int-subtract/test_msa_subsus_u_h.c    |   9 +-
 .../msa/int-subtract/test_msa_subsus_u_w.c    |   9 +-
 .../msa/int-subtract/test_msa_subsuu_s_b.c    |   9 +-
 .../msa/int-subtract/test_msa_subsuu_s_d.c    |   9 +-
 .../msa/int-subtract/test_msa_subsuu_s_h.c    |   9 +-
 .../msa/int-subtract/test_msa_subsuu_s_w.c    |   9 +-
 .../ase/msa/int-subtract/test_msa_subv_b.c    |   9 +-
 .../ase/msa/int-subtract/test_msa_subv_d.c    |   9 +-
 .../ase/msa/int-subtract/test_msa_subv_h.c    |   9 +-
 .../ase/msa/int-subtract/test_msa_subv_w.c    |   9 +-
 .../ase/msa/interleave/test_msa_ilvev_b.c     |   9 +-
 .../ase/msa/interleave/test_msa_ilvev_d.c     |   9 +-
 .../ase/msa/interleave/test_msa_ilvev_h.c     |   9 +-
 .../ase/msa/interleave/test_msa_ilvev_w.c     |   9 +-
 .../user/ase/msa/interleave/test_msa_ilvl_b.c |   9 +-
 .../user/ase/msa/interleave/test_msa_ilvl_d.c |   9 +-
 .../user/ase/msa/interleave/test_msa_ilvl_h.c |   9 +-
 .../user/ase/msa/interleave/test_msa_ilvl_w.c |   9 +-
 .../ase/msa/interleave/test_msa_ilvod_b.c     |   9 +-
 .../ase/msa/interleave/test_msa_ilvod_d.c     |   9 +-
 .../ase/msa/interleave/test_msa_ilvod_h.c     |   9 +-
 .../ase/msa/interleave/test_msa_ilvod_w.c     |   9 +-
 .../user/ase/msa/interleave/test_msa_ilvr_b.c |   9 +-
 .../user/ase/msa/interleave/test_msa_ilvr_d.c |   9 +-
 .../user/ase/msa/interleave/test_msa_ilvr_h.c |   9 +-
 .../user/ase/msa/interleave/test_msa_ilvr_w.c |   9 +-
 .../mips/user/ase/msa/logic/test_msa_and_v.c  |   9 +-
 .../mips/user/ase/msa/logic/test_msa_nor_v.c  |   9 +-
 .../mips/user/ase/msa/logic/test_msa_or_v.c   |   9 +-
 .../mips/user/ase/msa/logic/test_msa_xor_v.c  |   9 +-
 .../mips/user/ase/msa/move/test_msa_move_v.c  |   9 +-
 .../mips/user/ase/msa/pack/test_msa_pckev_b.c |   9 +-
 .../mips/user/ase/msa/pack/test_msa_pckev_d.c |   9 +-
 .../mips/user/ase/msa/pack/test_msa_pckev_h.c |   9 +-
 .../mips/user/ase/msa/pack/test_msa_pckev_w.c |   9 +-
 .../mips/user/ase/msa/pack/test_msa_pckod_b.c |   9 +-
 .../mips/user/ase/msa/pack/test_msa_pckod_d.c |   9 +-
 .../mips/user/ase/msa/pack/test_msa_pckod_h.c |   9 +-
 .../mips/user/ase/msa/pack/test_msa_pckod_w.c |   9 +-
 .../mips/user/ase/msa/pack/test_msa_vshf_b.c  |   9 +-
 .../mips/user/ase/msa/pack/test_msa_vshf_d.c  |   9 +-
 .../mips/user/ase/msa/pack/test_msa_vshf_h.c  |   9 +-
 .../mips/user/ase/msa/pack/test_msa_vshf_w.c  |   9 +-
 .../mips/user/ase/msa/shift/test_msa_sll_b.c  |   9 +-
 .../mips/user/ase/msa/shift/test_msa_sll_d.c  |   9 +-
 .../mips/user/ase/msa/shift/test_msa_sll_h.c  |   9 +-
 .../mips/user/ase/msa/shift/test_msa_sll_w.c  |   9 +-
 .../mips/user/ase/msa/shift/test_msa_sra_b.c  |   9 +-
 .../mips/user/ase/msa/shift/test_msa_sra_d.c  |   9 +-
 .../mips/user/ase/msa/shift/test_msa_sra_h.c  |   9 +-
 .../mips/user/ase/msa/shift/test_msa_sra_w.c  |   9 +-
 .../mips/user/ase/msa/shift/test_msa_srar_b.c |   9 +-
 .../mips/user/ase/msa/shift/test_msa_srar_d.c |   9 +-
 .../mips/user/ase/msa/shift/test_msa_srar_h.c |   9 +-
 .../mips/user/ase/msa/shift/test_msa_srar_w.c |   9 +-
 .../mips/user/ase/msa/shift/test_msa_srl_b.c  |   9 +-
 .../mips/user/ase/msa/shift/test_msa_srl_d.c  |   9 +-
 .../mips/user/ase/msa/shift/test_msa_srl_h.c  |   9 +-
 .../mips/user/ase/msa/shift/test_msa_srl_w.c  |   9 +-
 .../mips/user/ase/msa/shift/test_msa_srlr_b.c |   9 +-
 .../mips/user/ase/msa/shift/test_msa_srlr_d.c |   9 +-
 .../mips/user/ase/msa/shift/test_msa_srlr_h.c |   9 +-
 .../mips/user/ase/msa/shift/test_msa_srlr_w.c |   9 +-
 .../mips64r6/bit-count/test_mips64r6_clo.c    |   7 +-
 .../mips64r6/bit-count/test_mips64r6_clz.c    |   7 +-
 .../mips64r6/bit-count/test_mips64r6_dclo.c   |   7 +-
 .../mips64r6/bit-count/test_mips64r6_dclz.c   |   7 +-
 .../mips64r6/bit-swap/test_mips64r6_bitswap.c |   7 +-
 .../bit-swap/test_mips64r6_dbitswap.c         |   7 +-
 .../int-multiply/test_mips64r6_dmuh.c         |   7 +-
 .../int-multiply/test_mips64r6_dmuhu.c        |   7 +-
 .../int-multiply/test_mips64r6_dmul.c         |   7 +-
 .../int-multiply/test_mips64r6_dmulu.c        |   7 +-
 .../mips64r6/int-multiply/test_mips64r6_muh.c |   7 +-
 .../int-multiply/test_mips64r6_muhu.c         |   7 +-
 .../mips64r6/int-multiply/test_mips64r6_mul.c |   7 +-
 .../int-multiply/test_mips64r6_mulu.c         |   7 +-
 .../isa/mips64r6/logic/test_mips64r6_and.c    |   7 +-
 .../isa/mips64r6/logic/test_mips64r6_nor.c    |   7 +-
 .../isa/mips64r6/logic/test_mips64r6_or.c     |   7 +-
 .../isa/mips64r6/logic/test_mips64r6_xor.c    |   7 +-
 .../isa/mips64r6/shift/test_mips64r6_dsllv.c  |   7 +-
 .../isa/mips64r6/shift/test_mips64r6_dsrav.c  |   7 +-
 .../isa/mips64r6/shift/test_mips64r6_dsrlv.c  |   7 +-
 .../isa/mips64r6/shift/test_mips64r6_sllv.c   |   7 +-
 .../isa/mips64r6/shift/test_mips64r6_srav.c   |   7 +-
 .../isa/mips64r6/shift/test_mips64r6_srlv.c   |   7 +-
 tests/tcg/multiarch/sha512.c                  |   9 +-
 tools/virtiofsd/fuse_lowlevel.c               |  24 +---
 .../xtensa/core-dsp3400/xtensa-modules.c.inc  | 136 +++++-------------
 target/xtensa/core-lx106/xtensa-modules.c.inc |  16 +--
 328 files changed, 989 insertions(+), 2099 deletions(-)

diff --git a/scripts/coccinelle/return_directly.cocci b/scripts/coccinelle/return_directly.cocci
index 4cf50e75ea..6cb1b3c99a 100644
--- a/scripts/coccinelle/return_directly.cocci
+++ b/scripts/coccinelle/return_directly.cocci
@@ -11,9 +11,8 @@ identifier F;
 -    T VAR;
      ... when != VAR
 
--    VAR =
-+    return
-     E;
+-    VAR = (E);
 -    return VAR;
++    return E;
      ... when != VAR
  }
diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
index 6ccaaf5154..06e2d5f889 100644
--- a/include/hw/pci/pci.h
+++ b/include/hw/pci/pci.h
@@ -921,11 +921,8 @@ PCI_DMA_DEFINE_LDST(q_be, q_be, 64);
 static inline void *pci_dma_map(PCIDevice *dev, dma_addr_t addr,
                                 dma_addr_t *plen, DMADirection dir)
 {
-    void *buf;
-
-    buf = dma_memory_map(pci_get_address_space(dev), addr, plen, dir,
-                         MEMTXATTRS_UNSPECIFIED);
-    return buf;
+    return dma_memory_map(pci_get_address_space(dev), addr, plen, dir,
+                          MEMTXATTRS_UNSPECIFIED);
 }
 
 static inline void pci_dma_unmap(PCIDevice *dev, void *buffer, dma_addr_t len,
diff --git a/target/avr/cpu.h b/target/avr/cpu.h
index 96419c0c2b..f19dd72926 100644
--- a/target/avr/cpu.h
+++ b/target/avr/cpu.h
@@ -215,8 +215,7 @@ static inline int cpu_interrupts_enabled(CPUAVRState *env)
 
 static inline uint8_t cpu_get_sreg(CPUAVRState *env)
 {
-    uint8_t sreg;
-    sreg = (env->sregC) << 0
+    return (env->sregC) << 0
          | (env->sregZ) << 1
          | (env->sregN) << 2
          | (env->sregV) << 3
@@ -224,7 +223,6 @@ static inline uint8_t cpu_get_sreg(CPUAVRState *env)
          | (env->sregH) << 5
          | (env->sregT) << 6
          | (env->sregI) << 7;
-    return sreg;
 }
 
 static inline void cpu_set_sreg(CPUAVRState *env, uint8_t sreg)
diff --git a/block/vmdk.c b/block/vmdk.c
index 26376352b9..bac3d8db50 100644
--- a/block/vmdk.c
+++ b/block/vmdk.c
@@ -2821,7 +2821,6 @@ static BlockBackend *vmdk_co_create_cb(int64_t size, int idx,
 static int coroutine_fn vmdk_co_create(BlockdevCreateOptions *create_options,
                                        Error **errp)
 {
-    int ret;
     BlockdevCreateOptionsVmdk *opts;
 
     opts = &create_options->u.vmdk;
@@ -2829,24 +2828,19 @@ static int coroutine_fn vmdk_co_create(BlockdevCreateOptions *create_options,
     /* Validate options */
     if (!QEMU_IS_ALIGNED(opts->size, BDRV_SECTOR_SIZE)) {
         error_setg(errp, "Image size must be a multiple of 512 bytes");
-        ret = -EINVAL;
-        goto out;
+        return -EINVAL;
     }
 
-    ret = vmdk_co_do_create(opts->size,
-                            opts->subformat,
-                            opts->adapter_type,
-                            opts->backing_file,
-                            opts->hwversion,
-                            opts->toolsversion,
-                            false,
-                            opts->zeroed_grain,
-                            vmdk_co_create_cb,
-                            opts, errp);
-    return ret;
-
-out:
-    return ret;
+    return vmdk_co_do_create(opts->size,
+                             opts->subformat,
+                             opts->adapter_type,
+                             opts->backing_file,
+                             opts->hwversion,
+                             opts->toolsversion,
+                             false,
+                             opts->zeroed_grain,
+                             vmdk_co_create_cb,
+                             opts, errp);
 }
 
 static void vmdk_close(BlockDriverState *bs)
diff --git a/hw/9pfs/9p-synth.c b/hw/9pfs/9p-synth.c
index 1c5813e4dd..38d787f494 100644
--- a/hw/9pfs/9p-synth.c
+++ b/hw/9pfs/9p-synth.c
@@ -72,7 +72,6 @@ static V9fsSynthNode *v9fs_add_dir_node(V9fsSynthNode *parent, int mode,
 int qemu_v9fs_synth_mkdir(V9fsSynthNode *parent, int mode,
                           const char *name, V9fsSynthNode **result)
 {
-    int ret;
     V9fsSynthNode *node, *tmp;
 
     if (!synth_fs) {
@@ -87,8 +86,7 @@ int qemu_v9fs_synth_mkdir(V9fsSynthNode *parent, int mode,
     QEMU_LOCK_GUARD(&synth_mutex);
     QLIST_FOREACH(tmp, &parent->child, sibling) {
         if (!strcmp(tmp->name, name)) {
-            ret = EEXIST;
-            return ret;
+            return EEXIST;
         }
     }
     /* Add the name */
@@ -98,15 +96,13 @@ int qemu_v9fs_synth_mkdir(V9fsSynthNode *parent, int mode,
     v9fs_add_dir_node(node, node->attr->mode, ".",
                       node->attr, node->attr->inode);
     *result = node;
-    ret = 0;
-    return ret;
+    return 0;
 }
 
 int qemu_v9fs_synth_add_file(V9fsSynthNode *parent, int mode,
                              const char *name, v9fs_synth_read read,
                              v9fs_synth_write write, void *arg)
 {
-    int ret;
     V9fsSynthNode *node, *tmp;
 
     if (!synth_fs) {
@@ -122,8 +118,7 @@ int qemu_v9fs_synth_add_file(V9fsSynthNode *parent, int mode,
     QEMU_LOCK_GUARD(&synth_mutex);
     QLIST_FOREACH(tmp, &parent->child, sibling) {
         if (!strcmp(tmp->name, name)) {
-            ret = EEXIST;
-            return ret;
+            return EEXIST;
         }
     }
     /* Add file type and remove write bits */
@@ -138,8 +133,7 @@ int qemu_v9fs_synth_add_file(V9fsSynthNode *parent, int mode,
     node->private      = arg;
     pstrcpy(node->name, sizeof(node->name), name);
     QLIST_INSERT_HEAD_RCU(&parent->child, node, sibling);
-    ret = 0;
-    return ret;
+    return 0;
 }
 
 static void synth_fill_statbuf(V9fsSynthNode *node, struct stat *stbuf)
diff --git a/hw/char/sifive_uart.c b/hw/char/sifive_uart.c
index 1c75f792b3..f2684e57bc 100644
--- a/hw/char/sifive_uart.c
+++ b/hw/char/sifive_uart.c
@@ -274,7 +274,6 @@ SiFiveUARTState *sifive_uart_create(MemoryRegion *address_space, hwaddr base,
 {
     DeviceState *dev;
     SysBusDevice *s;
-    SiFiveUARTState *r;
 
     dev = qdev_new("riscv.sifive.uart");
     s = SYS_BUS_DEVICE(dev);
@@ -284,6 +283,5 @@ SiFiveUARTState *sifive_uart_create(MemoryRegion *address_space, hwaddr base,
                                 sysbus_mmio_get_region(s, 0));
     sysbus_connect_irq(s, 0, irq);
 
-    r = SIFIVE_UART(dev);
-    return r;
+    return SIFIVE_UART(dev);
 }
diff --git a/hw/ppc/ppc4xx_sdram.c b/hw/ppc/ppc4xx_sdram.c
index 8d7137faf3..54bf9a2b44 100644
--- a/hw/ppc/ppc4xx_sdram.c
+++ b/hw/ppc/ppc4xx_sdram.c
@@ -520,13 +520,10 @@ static inline hwaddr sdram_ddr2_base(uint32_t bcr)
 
 static hwaddr sdram_ddr2_size(uint32_t bcr)
 {
-    hwaddr size;
     int sh;
 
     sh = 1024 - ((bcr >> 6) & 0x3ff);
-    size = 8 * MiB * sh;
-
-    return size;
+    return 8 * MiB * sh;
 }
 
 static uint32_t sdram_ddr2_dcr_read(void *opaque, int dcrn)
diff --git a/hw/rdma/vmw/pvrdma_cmd.c b/hw/rdma/vmw/pvrdma_cmd.c
index da7ddfa548..71d1919c94 100644
--- a/hw/rdma/vmw/pvrdma_cmd.c
+++ b/hw/rdma/vmw/pvrdma_cmd.c
@@ -182,13 +182,10 @@ static int create_pd(PVRDMADev *dev, union pvrdma_cmd_req *req,
 {
     struct pvrdma_cmd_create_pd *cmd = &req->create_pd;
     struct pvrdma_cmd_create_pd_resp *resp = &rsp->create_pd_resp;
-    int rc;
 
     memset(resp, 0, sizeof(*resp));
-    rc = rdma_rm_alloc_pd(&dev->rdma_dev_res, &dev->backend_dev,
-                          &resp->pd_handle, cmd->ctx_handle);
-
-    return rc;
+    return rdma_rm_alloc_pd(&dev->rdma_dev_res, &dev->backend_dev,
+                            &resp->pd_handle, cmd->ctx_handle);
 }
 
 static int destroy_pd(PVRDMADev *dev, union pvrdma_cmd_req *req,
@@ -506,20 +503,17 @@ static int modify_qp(PVRDMADev *dev, union pvrdma_cmd_req *req,
                      union pvrdma_cmd_resp *rsp)
 {
     struct pvrdma_cmd_modify_qp *cmd = &req->modify_qp;
-    int rc;
 
     /* No need to verify sgid_index since it is u8 */
 
-    rc = rdma_rm_modify_qp(&dev->rdma_dev_res, &dev->backend_dev,
-                           cmd->qp_handle, cmd->attr_mask,
-                           cmd->attrs.ah_attr.grh.sgid_index,
-                           (union ibv_gid *)&cmd->attrs.ah_attr.grh.dgid,
-                           cmd->attrs.dest_qp_num,
-                           (enum ibv_qp_state)cmd->attrs.qp_state,
-                           cmd->attrs.qkey, cmd->attrs.rq_psn,
-                           cmd->attrs.sq_psn);
-
-    return rc;
+    return rdma_rm_modify_qp(&dev->rdma_dev_res, &dev->backend_dev,
+                             cmd->qp_handle, cmd->attr_mask,
+                             cmd->attrs.ah_attr.grh.sgid_index,
+                             (union ibv_gid *)&cmd->attrs.ah_attr.grh.dgid,
+                             cmd->attrs.dest_qp_num,
+                             (enum ibv_qp_state)cmd->attrs.qp_state,
+                             cmd->attrs.qkey, cmd->attrs.rq_psn,
+                             cmd->attrs.sq_psn);
 }
 
 static int query_qp(PVRDMADev *dev, union pvrdma_cmd_req *req,
@@ -528,15 +522,14 @@ static int query_qp(PVRDMADev *dev, union pvrdma_cmd_req *req,
     struct pvrdma_cmd_query_qp *cmd = &req->query_qp;
     struct pvrdma_cmd_query_qp_resp *resp = &rsp->query_qp_resp;
     struct ibv_qp_init_attr init_attr;
-    int rc;
 
     memset(resp, 0, sizeof(*resp));
 
-    rc = rdma_rm_query_qp(&dev->rdma_dev_res, &dev->backend_dev, cmd->qp_handle,
-                          (struct ibv_qp_attr *)&resp->attrs, cmd->attr_mask,
-                          &init_attr);
-
-    return rc;
+    return rdma_rm_query_qp(&dev->rdma_dev_res, &dev->backend_dev,
+                            cmd->qp_handle,
+                            (struct ibv_qp_attr *)&resp->attrs,
+                            cmd->attr_mask,
+                            &init_attr);
 }
 
 static int destroy_qp(PVRDMADev *dev, union pvrdma_cmd_req *req,
@@ -562,34 +555,27 @@ static int create_bind(PVRDMADev *dev, union pvrdma_cmd_req *req,
                        union pvrdma_cmd_resp *rsp)
 {
     struct pvrdma_cmd_create_bind *cmd = &req->create_bind;
-    int rc;
     union ibv_gid *gid = (union ibv_gid *)&cmd->new_gid;
 
     if (cmd->index >= MAX_PORT_GIDS) {
         return -EINVAL;
     }
 
-    rc = rdma_rm_add_gid(&dev->rdma_dev_res, &dev->backend_dev,
-                         dev->backend_eth_device_name, gid, cmd->index);
-
-    return rc;
+    return rdma_rm_add_gid(&dev->rdma_dev_res, &dev->backend_dev,
+                           dev->backend_eth_device_name, gid, cmd->index);
 }
 
 static int destroy_bind(PVRDMADev *dev, union pvrdma_cmd_req *req,
                         union pvrdma_cmd_resp *rsp)
 {
-    int rc;
-
     struct pvrdma_cmd_destroy_bind *cmd = &req->destroy_bind;
 
     if (cmd->index >= MAX_PORT_GIDS) {
         return -EINVAL;
     }
 
-    rc = rdma_rm_del_gid(&dev->rdma_dev_res, &dev->backend_dev,
-                        dev->backend_eth_device_name, cmd->index);
-
-    return rc;
+    return rdma_rm_del_gid(&dev->rdma_dev_res, &dev->backend_dev,
+                           dev->backend_eth_device_name, cmd->index);
 }
 
 static int create_uc(PVRDMADev *dev, union pvrdma_cmd_req *req,
@@ -597,12 +583,9 @@ static int create_uc(PVRDMADev *dev, union pvrdma_cmd_req *req,
 {
     struct pvrdma_cmd_create_uc *cmd = &req->create_uc;
     struct pvrdma_cmd_create_uc_resp *resp = &rsp->create_uc_resp;
-    int rc;
 
     memset(resp, 0, sizeof(*resp));
-    rc = rdma_rm_alloc_uc(&dev->rdma_dev_res, cmd->pfn, &resp->ctx_handle);
-
-    return rc;
+    return rdma_rm_alloc_uc(&dev->rdma_dev_res, cmd->pfn, &resp->ctx_handle);
 }
 
 static int destroy_uc(PVRDMADev *dev, union pvrdma_cmd_req *req,
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index abe23d4ebe..74a776ebe4 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -2532,11 +2532,7 @@ vhost_user_crypto_close_session(struct vhost_dev *dev, uint64_t session_id)
 static bool vhost_user_mem_section_filter(struct vhost_dev *dev,
                                           MemoryRegionSection *section)
 {
-    bool result;
-
-    result = memory_region_get_fd(section->mr) >= 0;
-
-    return result;
+    return memory_region_get_fd(section->mr) >= 0;
 }
 
 static int vhost_user_get_inflight_fd(struct vhost_dev *dev,
diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
index d6f1e01a70..4bfb97fc68 100644
--- a/migration/dirtyrate.c
+++ b/migration/dirtyrate.c
@@ -111,7 +111,6 @@ static void global_dirty_log_sync(unsigned int flag, bool one_shot)
 static DirtyPageRecord *vcpu_dirty_stat_alloc(VcpuStat *stat)
 {
     CPUState *cpu;
-    DirtyPageRecord *records;
     int nvcpu = 0;
 
     CPU_FOREACH(cpu) {
@@ -121,9 +120,7 @@ static DirtyPageRecord *vcpu_dirty_stat_alloc(VcpuStat *stat)
     stat->nvcpu = nvcpu;
     stat->rates = g_new0(DirtyRateVcpu, nvcpu);
 
-    records = g_new0(DirtyPageRecord, nvcpu);
-
-    return records;
+    return g_new0(DirtyPageRecord, nvcpu);
 }
 
 static void vcpu_dirty_stat_collect(VcpuStat *stat,
@@ -473,7 +470,6 @@ find_block_matched(RAMBlock *block, int count,
                   struct RamblockDirtyInfo *infos)
 {
     int i;
-    struct RamblockDirtyInfo *matched;
 
     for (i = 0; i < count; i++) {
         if (!strcmp(infos[i].idstr, qemu_ram_get_idstr(block))) {
@@ -492,9 +488,7 @@ find_block_matched(RAMBlock *block, int count,
         return NULL;
     }
 
-    matched = &infos[i];
-
-    return matched;
+    return &infos[i];
 }
 
 static bool compare_page_hash_info(struct RamblockDirtyInfo *info,
diff --git a/migration/tls.c b/migration/tls.c
index 73e8c9d3c2..4d2166a209 100644
--- a/migration/tls.c
+++ b/migration/tls.c
@@ -126,7 +126,6 @@ QIOChannelTLS *migration_tls_client_create(MigrationState *s,
                                            Error **errp)
 {
     QCryptoTLSCreds *creds;
-    QIOChannelTLS *tioc;
 
     creds = migration_tls_get_creds(
         s, QCRYPTO_TLS_CREDS_ENDPOINT_CLIENT, errp);
@@ -138,10 +137,7 @@ QIOChannelTLS *migration_tls_client_create(MigrationState *s,
         hostname = s->parameters.tls_hostname;
     }
 
-    tioc = qio_channel_tls_new_client(
-        ioc, creds, hostname, errp);
-
-    return tioc;
+    return qio_channel_tls_new_client(ioc, creds, hostname, errp);
 }
 
 void migration_tls_channel_connect(MigrationState *s,
diff --git a/replay/replay-time.c b/replay/replay-time.c
index 00ebcb7a49..ee0ebfcf09 100644
--- a/replay/replay-time.c
+++ b/replay/replay-time.c
@@ -48,7 +48,6 @@ void replay_read_next_clock(ReplayClockKind kind)
 /*! Reads next clock event from the input. */
 int64_t replay_read_clock(ReplayClockKind kind, int64_t raw_icount)
 {
-    int64_t ret;
     g_assert(replay_file && replay_mutex_locked());
 
     replay_advance_current_icount(raw_icount);
@@ -56,7 +55,5 @@ int64_t replay_read_clock(ReplayClockKind kind, int64_t raw_icount)
     if (replay_next_event_is(EVENT_CLOCK + kind)) {
         replay_read_next_clock(kind);
     }
-    ret = replay_state.cached_clock[kind];
-
-    return ret;
+    return replay_state.cached_clock[kind];
 }
diff --git a/semihosting/console.c b/semihosting/console.c
index 0f976fe8cb..5d61e8207e 100644
--- a/semihosting/console.c
+++ b/semihosting/console.c
@@ -43,10 +43,8 @@ static SemihostingConsole console;
 static int console_can_read(void *opaque)
 {
     SemihostingConsole *c = opaque;
-    int ret;
     g_assert(qemu_mutex_iothread_locked());
-    ret = (int) fifo8_num_free(&c->fifo);
-    return ret;
+    return (int)fifo8_num_free(&c->fifo);
 }
 
 static void console_wake_up(gpointer data, gpointer user_data)
diff --git a/softmmu/memory.c b/softmmu/memory.c
index bc0be3f62c..e05332d07f 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -2372,20 +2372,15 @@ void memory_region_reset_dirty(MemoryRegion *mr, hwaddr addr,
 
 int memory_region_get_fd(MemoryRegion *mr)
 {
-    int fd;
-
     RCU_READ_LOCK_GUARD();
     while (mr->alias) {
         mr = mr->alias;
     }
-    fd = mr->ram_block->fd;
-
-    return fd;
+    return mr->ram_block->fd;
 }
 
 void *memory_region_get_ram_ptr(MemoryRegion *mr)
 {
-    void *ptr;
     uint64_t offset = 0;
 
     RCU_READ_LOCK_GUARD();
@@ -2394,9 +2389,7 @@ void *memory_region_get_ram_ptr(MemoryRegion *mr)
         mr = mr->alias;
     }
     assert(mr->ram_block);
-    ptr = qemu_map_ram_ptr(mr->ram_block, offset);
-
-    return ptr;
+    return qemu_map_ram_ptr(mr->ram_block, offset);
 }
 
 MemoryRegion *memory_region_from_host(void *ptr, ram_addr_t *offset)
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index 1b606a3002..edec095c7a 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -3236,7 +3236,6 @@ void *address_space_map(AddressSpace *as,
     hwaddr len = *plen;
     hwaddr l, xlat;
     MemoryRegion *mr;
-    void *ptr;
     FlatView *fv;
 
     if (len == 0) {
@@ -3275,9 +3274,7 @@ void *address_space_map(AddressSpace *as,
     *plen = flatview_extend_translation(fv, addr, len, mr, xlat,
                                         l, is_write, attrs);
     fuzz_dma_read_cb(addr, *plen, mr);
-    ptr = qemu_ram_ptr_length(mr->ram_block, xlat, plen, true);
-
-    return ptr;
+    return qemu_ram_ptr_length(mr->ram_block, xlat, plen, true);
 }
 
 /* Unmaps a memory region previously mapped by address_space_map().
@@ -3545,15 +3542,13 @@ bool cpu_physical_memory_is_io(hwaddr phys_addr)
 {
     MemoryRegion*mr;
     hwaddr l = 1;
-    bool res;
 
     RCU_READ_LOCK_GUARD();
     mr = address_space_translate(&address_space_memory,
                                  phys_addr, &phys_addr, &l, false,
                                  MEMTXATTRS_UNSPECIFIED);
 
-    res = !(memory_region_is_ram(mr) || memory_region_is_romd(mr));
-    return res;
+    return !(memory_region_is_ram(mr) || memory_region_is_romd(mr));
 }
 
 int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque)
diff --git a/target/loongarch/cpu.c b/target/loongarch/cpu.c
index 46b04cbdad..e7b0e12be6 100644
--- a/target/loongarch/cpu.c
+++ b/target/loongarch/cpu.c
@@ -128,13 +128,11 @@ static inline bool cpu_loongarch_hw_interrupts_pending(CPULoongArchState *env)
 {
     uint32_t pending;
     uint32_t status;
-    bool r;
 
     pending = FIELD_EX64(env->CSR_ESTAT, CSR_ESTAT, IS);
     status  = FIELD_EX64(env->CSR_ECFG, CSR_ECFG, LIE);
 
-    r = (pending & status) != 0;
-    return r;
+    return (pending & status) != 0;
 }
 
 static void loongarch_cpu_do_interrupt(CPUState *cs)
diff --git a/target/mips/tcg/dsp_helper.c b/target/mips/tcg/dsp_helper.c
index 09b6e5fb15..7a4362c8ef 100644
--- a/target/mips/tcg/dsp_helper.c
+++ b/target/mips/tcg/dsp_helper.c
@@ -3281,15 +3281,12 @@ target_ulong helper_dextr_l(target_ulong ac, target_ulong shift,
                             CPUMIPSState *env)
 {
     uint64_t temp[3];
-    target_ulong ret;
 
     shift = shift & 0x3F;
 
     mipsdsp_rndrashift_acc(temp, ac, shift, env);
 
-    ret = (temp[1] << 63) | (temp[0] >> 1);
-
-    return ret;
+    return (temp[1] << 63) | (temp[0] >> 1);
 }
 
 target_ulong helper_dextr_r_l(target_ulong ac, target_ulong shift,
@@ -3297,7 +3294,6 @@ target_ulong helper_dextr_r_l(target_ulong ac, target_ulong shift,
 {
     uint64_t temp[3];
     uint32_t temp128;
-    target_ulong ret;
 
     shift = shift & 0x3F;
     mipsdsp_rndrashift_acc(temp, ac, shift, env);
@@ -3317,9 +3313,7 @@ target_ulong helper_dextr_r_l(target_ulong ac, target_ulong shift,
         set_DSPControl_overflow_flag(1, 23, env);
     }
 
-    ret = (temp[1] << 63) | (temp[0] >> 1);
-
-    return ret;
+    return (temp[1] << 63) | (temp[0] >> 1);
 }
 
 target_ulong helper_dextr_rs_l(target_ulong ac, target_ulong shift,
@@ -3327,7 +3321,6 @@ target_ulong helper_dextr_rs_l(target_ulong ac, target_ulong shift,
 {
     uint64_t temp[3];
     uint32_t temp128;
-    target_ulong ret;
 
     shift = shift & 0x3F;
     mipsdsp_rndrashift_acc(temp, ac, shift, env);
@@ -3354,9 +3347,7 @@ target_ulong helper_dextr_rs_l(target_ulong ac, target_ulong shift,
         set_DSPControl_overflow_flag(1, 23, env);
     }
 
-    ret = (temp[1] << 63) | (temp[0] >> 1);
-
-    return ret;
+    return (temp[1] << 63) | (temp[0] >> 1);
 }
 #endif
 
diff --git a/target/riscv/debug.c b/target/riscv/debug.c
index 26ea764407..e44848d0d7 100644
--- a/target/riscv/debug.c
+++ b/target/riscv/debug.c
@@ -243,15 +243,13 @@ static void do_trigger_action(CPURISCVState *env, target_ulong trigger_index)
 
 static uint32_t type2_breakpoint_size(CPURISCVState *env, target_ulong ctrl)
 {
-    uint32_t size, sizelo, sizehi = 0;
+    uint32_t sizelo, sizehi = 0;
 
     if (riscv_cpu_mxl(env) == MXL_RV64) {
         sizehi = extract32(ctrl, 21, 2);
     }
     sizelo = extract32(ctrl, 16, 2);
-    size = (sizehi << 2) | sizelo;
-
-    return size;
+    return (sizehi << 2) | sizelo;
 }
 
 static inline bool type2_breakpoint_enabled(target_ulong ctrl)
diff --git a/target/riscv/vector_helper.c b/target/riscv/vector_helper.c
index 0020b9a95d..00de879787 100644
--- a/target/riscv/vector_helper.c
+++ b/target/riscv/vector_helper.c
@@ -2791,31 +2791,25 @@ static inline uint16_t
 vssrl16(CPURISCVState *env, int vxrm, uint16_t a, uint16_t b)
 {
     uint8_t round, shift = b & 0xf;
-    uint16_t res;
 
     round = get_round(vxrm, a, shift);
-    res   = (a >> shift)  + round;
-    return res;
+    return (a >> shift) + round;
 }
 static inline uint32_t
 vssrl32(CPURISCVState *env, int vxrm, uint32_t a, uint32_t b)
 {
     uint8_t round, shift = b & 0x1f;
-    uint32_t res;
 
     round = get_round(vxrm, a, shift);
-    res   = (a >> shift)  + round;
-    return res;
+    return (a >> shift) + round;
 }
 static inline uint64_t
 vssrl64(CPURISCVState *env, int vxrm, uint64_t a, uint64_t b)
 {
     uint8_t round, shift = b & 0x3f;
-    uint64_t res;
 
     round = get_round(vxrm, a, shift);
-    res   = (a >> shift)  + round;
-    return res;
+    return (a >> shift) + round;
 }
 RVVCALL(OPIVV2_RM, vssrl_vv_b, OP_UUU_B, H1, H1, H1, vssrl8)
 RVVCALL(OPIVV2_RM, vssrl_vv_h, OP_UUU_H, H2, H2, H2, vssrl16)
@@ -2839,41 +2833,33 @@ static inline int8_t
 vssra8(CPURISCVState *env, int vxrm, int8_t a, int8_t b)
 {
     uint8_t round, shift = b & 0x7;
-    int8_t res;
 
     round = get_round(vxrm, a, shift);
-    res   = (a >> shift)  + round;
-    return res;
+    return (a >> shift) + round;
 }
 static inline int16_t
 vssra16(CPURISCVState *env, int vxrm, int16_t a, int16_t b)
 {
     uint8_t round, shift = b & 0xf;
-    int16_t res;
 
     round = get_round(vxrm, a, shift);
-    res   = (a >> shift)  + round;
-    return res;
+    return (a >> shift) + round;
 }
 static inline int32_t
 vssra32(CPURISCVState *env, int vxrm, int32_t a, int32_t b)
 {
     uint8_t round, shift = b & 0x1f;
-    int32_t res;
 
     round = get_round(vxrm, a, shift);
-    res   = (a >> shift)  + round;
-    return res;
+    return (a >> shift) + round;
 }
 static inline int64_t
 vssra64(CPURISCVState *env, int vxrm, int64_t a, int64_t b)
 {
     uint8_t round, shift = b & 0x3f;
-    int64_t res;
 
     round = get_round(vxrm, a, shift);
-    res   = (a >> shift)  + round;
-    return res;
+    return (a >> shift) + round;
 }
 
 RVVCALL(OPIVV2_RM, vssra_vv_b, OP_SSS_B, H1, H1, H1, vssra8)
diff --git a/tests/bench/benchmark-crypto-akcipher.c b/tests/bench/benchmark-crypto-akcipher.c
index 15e69557ed..5e68cb0a1c 100644
--- a/tests/bench/benchmark-crypto-akcipher.c
+++ b/tests/bench/benchmark-crypto-akcipher.c
@@ -24,14 +24,12 @@ static QCryptoAkCipher *create_rsa_akcipher(const uint8_t *priv_key,
                                             QCryptoHashAlgorithm hash)
 {
     QCryptoAkCipherOptions opt;
-    QCryptoAkCipher *rsa;
 
     opt.alg = QCRYPTO_AKCIPHER_ALG_RSA;
     opt.u.rsa.padding_alg = padding;
     opt.u.rsa.hash_alg = hash;
-    rsa = qcrypto_akcipher_new(&opt, QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE,
-                               priv_key, keylen, &error_abort);
-    return rsa;
+    return qcrypto_akcipher_new(&opt, QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE,
+                                priv_key, keylen, &error_abort);
 }
 
 static void test_rsa_speed(const uint8_t *priv_key, size_t keylen,
diff --git a/tests/qtest/erst-test.c b/tests/qtest/erst-test.c
index 4e768a126f..974e8bcfe5 100644
--- a/tests/qtest/erst-test.c
+++ b/tests/qtest/erst-test.c
@@ -154,10 +154,7 @@ static void test_acpi_erst_basic(void)
 
 int main(int argc, char **argv)
 {
-    int ret;
-
     g_test_init(&argc, &argv, NULL);
     qtest_add_func("/acpi-erst/basic", test_acpi_erst_basic);
-    ret = g_test_run();
-    return ret;
+    return g_test_run();
 }
diff --git a/tests/qtest/hexloader-test.c b/tests/qtest/hexloader-test.c
index 8b7aa2d72d..3023548041 100644
--- a/tests/qtest/hexloader-test.c
+++ b/tests/qtest/hexloader-test.c
@@ -34,12 +34,8 @@ static void hex_loader_test(void)
 
 int main(int argc, char **argv)
 {
-    int ret;
-
     g_test_init(&argc, &argv, NULL);
 
     qtest_add_func("/tmp/hex_loader", hex_loader_test);
-    ret = g_test_run();
-
-    return ret;
+    return g_test_run();
 }
diff --git a/tests/qtest/pvpanic-pci-test.c b/tests/qtest/pvpanic-pci-test.c
index c82c365c26..2c05b376ba 100644
--- a/tests/qtest/pvpanic-pci-test.c
+++ b/tests/qtest/pvpanic-pci-test.c
@@ -86,13 +86,9 @@ static void test_panic(void)
 
 int main(int argc, char **argv)
 {
-    int ret;
-
     g_test_init(&argc, &argv, NULL);
     qtest_add_func("/pvpanic-pci/panic", test_panic);
     qtest_add_func("/pvpanic-pci/panic-nopause", test_panic_nopause);
 
-    ret = g_test_run();
-
-    return ret;
+    return g_test_run();
 }
diff --git a/tests/qtest/pvpanic-test.c b/tests/qtest/pvpanic-test.c
index bc7b7dfc39..78f1cf8186 100644
--- a/tests/qtest/pvpanic-test.c
+++ b/tests/qtest/pvpanic-test.c
@@ -59,13 +59,9 @@ static void test_panic(void)
 
 int main(int argc, char **argv)
 {
-    int ret;
-
     g_test_init(&argc, &argv, NULL);
     qtest_add_func("/pvpanic/panic", test_panic);
     qtest_add_func("/pvpanic/panic-nopause", test_panic_nopause);
 
-    ret = g_test_run();
-
-    return ret;
+    return g_test_run();
 }
diff --git a/tests/qtest/test-filter-mirror.c b/tests/qtest/test-filter-mirror.c
index c8b0a92b53..248fc88699 100644
--- a/tests/qtest/test-filter-mirror.c
+++ b/tests/qtest/test-filter-mirror.c
@@ -76,12 +76,8 @@ static void test_mirror(void)
 
 int main(int argc, char **argv)
 {
-    int ret;
-
     g_test_init(&argc, &argv, NULL);
 
     qtest_add_func("/netfilter/mirror", test_mirror);
-    ret = g_test_run();
-
-    return ret;
+    return g_test_run();
 }
diff --git a/tests/qtest/virtio-ccw-test.c b/tests/qtest/virtio-ccw-test.c
index d05236407b..2de77bb6fe 100644
--- a/tests/qtest/virtio-ccw-test.c
+++ b/tests/qtest/virtio-ccw-test.c
@@ -95,8 +95,6 @@ static void virtio_scsi_hotplug(void)
 
 int main(int argc, char **argv)
 {
-    int ret;
-
     g_test_init(&argc, &argv, NULL);
     qtest_add_func("/virtio/balloon/nop", virtio_balloon_nop);
     qtest_add_func("/virtio/console/nop", virtconsole_nop);
@@ -109,7 +107,5 @@ int main(int argc, char **argv)
     qtest_add_func("/virtio/scsi/nop", virtio_scsi_nop);
     qtest_add_func("/virtio/scsi/hotplug", virtio_scsi_hotplug);
 
-    ret = g_test_run();
-
-    return ret;
+    return g_test_run();
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nloc_b.c b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nloc_b.c
index 6ceb5aab20..492df6069d 100644
--- a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nloc_b.c
+++ b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nloc_b.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Count";
     char *instruction_name =  "NLOC.B";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -141,9 +140,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nloc_d.c b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nloc_d.c
index 897e90fbbc..52ade86b52 100644
--- a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nloc_d.c
+++ b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nloc_d.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Count";
     char *instruction_name =  "NLOC.D";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -141,9 +140,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nloc_h.c b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nloc_h.c
index 85cf3e6f70..51a96e25a2 100644
--- a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nloc_h.c
+++ b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nloc_h.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Count";
     char *instruction_name =  "NLOC.H";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -141,9 +140,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nloc_w.c b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nloc_w.c
index 7ed97be2b4..c2729eb084 100644
--- a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nloc_w.c
+++ b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nloc_w.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Count";
     char *instruction_name =  "NLOC.W";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -141,9 +140,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nlzc_b.c b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nlzc_b.c
index 2103d5fbfe..09909912f0 100644
--- a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nlzc_b.c
+++ b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nlzc_b.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Count";
     char *instruction_name =  "NLZC.B";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -141,9 +140,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nlzc_d.c b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nlzc_d.c
index b1ca3d44aa..7bf8193066 100644
--- a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nlzc_d.c
+++ b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nlzc_d.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Count";
     char *instruction_name =  "NLZC.D";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -141,9 +140,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nlzc_h.c b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nlzc_h.c
index 6531c67a86..34a7e3a8ae 100644
--- a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nlzc_h.c
+++ b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nlzc_h.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Count";
     char *instruction_name =  "NLZC.H";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -141,9 +140,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nlzc_w.c b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nlzc_w.c
index 71db53c9fe..2a6b066009 100644
--- a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nlzc_w.c
+++ b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_nlzc_w.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Count";
     char *instruction_name =  "NLZC.W";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -141,9 +140,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_pcnt_b.c b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_pcnt_b.c
index 184f7f4a49..cdd9b17dbb 100644
--- a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_pcnt_b.c
+++ b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_pcnt_b.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Count";
     char *instruction_name =  "PCNT.B";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -141,9 +140,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_pcnt_d.c b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_pcnt_d.c
index 3cc0d851b2..ebb982bf6a 100644
--- a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_pcnt_d.c
+++ b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_pcnt_d.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Count";
     char *instruction_name =  "PCNT.D";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -141,9 +140,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_pcnt_h.c b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_pcnt_h.c
index f1052b3c26..9d6007793d 100644
--- a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_pcnt_h.c
+++ b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_pcnt_h.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Count";
     char *instruction_name =  "PCNT.H";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -141,9 +140,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_pcnt_w.c b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_pcnt_w.c
index 625ef29406..417cffbe41 100644
--- a/tests/tcg/mips/user/ase/msa/bit-count/test_msa_pcnt_w.c
+++ b/tests/tcg/mips/user/ase/msa/bit-count/test_msa_pcnt_w.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Count";
     char *instruction_name =  "PCNT.W";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -141,9 +140,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsl_b.c b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsl_b.c
index 4a34f69953..6c85b60241 100644
--- a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsl_b.c
+++ b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsl_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Move";
     char *instruction_name =  "BINSL.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsl_d.c b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsl_d.c
index 0fc44fa195..9a60711b6e 100644
--- a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsl_d.c
+++ b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsl_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Move";
     char *instruction_name =  "BINSL.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsl_h.c b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsl_h.c
index cc2db04a2d..a8521f5e34 100644
--- a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsl_h.c
+++ b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsl_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Move";
     char *instruction_name =  "BINSL.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsl_w.c b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsl_w.c
index 21d6eec4db..164a8d8ba3 100644
--- a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsl_w.c
+++ b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsl_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Move";
     char *instruction_name =  "BINSL.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsr_b.c b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsr_b.c
index b1927c5c34..da64a04470 100644
--- a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsr_b.c
+++ b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsr_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Move";
     char *instruction_name =  "BINSR.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsr_d.c b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsr_d.c
index 6499415daa..02b360c0ec 100644
--- a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsr_d.c
+++ b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsr_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Move";
     char *instruction_name =  "BINSR.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsr_h.c b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsr_h.c
index 2dc3dbe89b..c0fdc8225d 100644
--- a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsr_h.c
+++ b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsr_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Move";
     char *instruction_name =  "BINSR.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsr_w.c b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsr_w.c
index 5073187340..33f36cb8ec 100644
--- a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsr_w.c
+++ b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_binsr_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Move";
     char *instruction_name =  "BINSR.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_bmnz_v.c b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_bmnz_v.c
index ba1c635087..2704a563bc 100644
--- a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_bmnz_v.c
+++ b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_bmnz_v.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Move";
     char *instruction_name =  "BMNZ.V";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_bmz_v.c b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_bmz_v.c
index b38ddc2c12..91ba1a58ce 100644
--- a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_bmz_v.c
+++ b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_bmz_v.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Move";
     char *instruction_name =  "BMZ.V";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_bsel_v.c b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_bsel_v.c
index 062e5a2fa0..c1572dada4 100644
--- a/tests/tcg/mips/user/ase/msa/bit-move/test_msa_bsel_v.c
+++ b/tests/tcg/mips/user/ase/msa/bit-move/test_msa_bsel_v.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Move";
     char *instruction_name =  "BSEL.V";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bclr_b.c b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bclr_b.c
index 56fdee3f31..32135a49ad 100644
--- a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bclr_b.c
+++ b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bclr_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Set";
     char *instruction_name =  "BCLR.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bclr_d.c b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bclr_d.c
index 0accccf093..e33b8c0cb8 100644
--- a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bclr_d.c
+++ b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bclr_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Set";
     char *instruction_name =  "BCLR.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bclr_h.c b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bclr_h.c
index 474e5297b8..a4bec519f9 100644
--- a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bclr_h.c
+++ b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bclr_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Set";
     char *instruction_name =  "BCLR.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bclr_w.c b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bclr_w.c
index 818b12ff0a..0eccfb43b0 100644
--- a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bclr_w.c
+++ b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bclr_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Set";
     char *instruction_name =  "BCLR.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bneg_b.c b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bneg_b.c
index 78ba32f360..82acdaf934 100644
--- a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bneg_b.c
+++ b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bneg_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Set";
     char *instruction_name =  "BNEG.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bneg_d.c b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bneg_d.c
index 44cd608688..20f25d9ed4 100644
--- a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bneg_d.c
+++ b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bneg_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Set";
     char *instruction_name =  "BNEG.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bneg_h.c b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bneg_h.c
index 5d17ceeba3..9fa1589889 100644
--- a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bneg_h.c
+++ b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bneg_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Set";
     char *instruction_name =  "BNEG.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bneg_w.c b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bneg_w.c
index 90d21f453d..4a34674e1d 100644
--- a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bneg_w.c
+++ b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bneg_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Set";
     char *instruction_name =  "BNEG.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bset_b.c b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bset_b.c
index 8aabf4bb88..c00df3b27c 100644
--- a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bset_b.c
+++ b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bset_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Set";
     char *instruction_name =  "BSET.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bset_d.c b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bset_d.c
index e3f9a7e4ca..2e144a4f7f 100644
--- a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bset_d.c
+++ b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bset_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Set";
     char *instruction_name =  "BSET.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bset_h.c b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bset_h.c
index cf9f608180..9e65c920cc 100644
--- a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bset_h.c
+++ b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bset_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Set";
     char *instruction_name =  "BSET.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bset_w.c b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bset_w.c
index 77478116f2..0fc8c01975 100644
--- a/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bset_w.c
+++ b/tests/tcg/mips/user/ase/msa/bit-set/test_msa_bset_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Bit Set";
     char *instruction_name =  "BSET.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_madd_q_h.c b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_madd_q_h.c
index 29a2990011..1b7240bce6 100644
--- a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_madd_q_h.c
+++ b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_madd_q_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Fixed Multiply";
     char *instruction_name =  "MADD_Q.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -208,9 +207,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_madd_q_w.c b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_madd_q_w.c
index 529d60d1e9..098d17658e 100644
--- a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_madd_q_w.c
+++ b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_madd_q_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Fixed Multiply";
     char *instruction_name =  "MADD_Q.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -208,9 +207,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_maddr_q_h.c b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_maddr_q_h.c
index a4713f2321..9bee226fe6 100644
--- a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_maddr_q_h.c
+++ b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_maddr_q_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Fixed Multiply";
     char *instruction_name =  "MADDR_Q.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -208,9 +207,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_maddr_q_w.c b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_maddr_q_w.c
index 19eccbf5ba..6d34e88056 100644
--- a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_maddr_q_w.c
+++ b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_maddr_q_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Fixed Multiply";
     char *instruction_name =  "MADDR_Q.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -208,9 +207,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_msub_q_h.c b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_msub_q_h.c
index b584736ed1..2ae0f52b5a 100644
--- a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_msub_q_h.c
+++ b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_msub_q_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Fixed Multiply";
     char *instruction_name =  "MSUB_Q.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -208,9 +207,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_msub_q_w.c b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_msub_q_w.c
index 56191924a1..a5af34f407 100644
--- a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_msub_q_w.c
+++ b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_msub_q_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Fixed Multiply";
     char *instruction_name =  "MSUB_Q.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -208,9 +207,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_msubr_q_h.c b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_msubr_q_h.c
index 0be6d51418..385d4492cd 100644
--- a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_msubr_q_h.c
+++ b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_msubr_q_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Fixed Multiply";
     char *instruction_name =  "MSUBR_Q.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -208,9 +207,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_msubr_q_w.c b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_msubr_q_w.c
index 7d57cb500a..e879df5ade 100644
--- a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_msubr_q_w.c
+++ b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_msubr_q_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Fixed Multiply";
     char *instruction_name =  "MSUBR_Q.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -208,9 +207,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_mul_q_h.c b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_mul_q_h.c
index cce7e9e8ac..31533f138d 100644
--- a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_mul_q_h.c
+++ b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_mul_q_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Fixed Multiply";
     char *instruction_name =  "MUL_Q.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_mul_q_w.c b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_mul_q_w.c
index 81d2635d7d..9e34d4d912 100644
--- a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_mul_q_w.c
+++ b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_mul_q_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Fixed Multiply";
     char *instruction_name =  "MUL_Q.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_mulr_q_h.c b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_mulr_q_h.c
index d5b00f1eb0..34a456673c 100644
--- a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_mulr_q_h.c
+++ b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_mulr_q_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Fixed Multiply";
     char *instruction_name =  "MULR_Q.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_mulr_q_w.c b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_mulr_q_w.c
index 78c9e22394..3d2f0ec8bd 100644
--- a/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_mulr_q_w.c
+++ b/tests/tcg/mips/user/ase/msa/fixed-multiply/test_msa_mulr_q_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Fixed Multiply";
     char *instruction_name =  "MULR_Q.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmax_a_d.c b/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmax_a_d.c
index d9b49cea8c..f24092c1bb 100644
--- a/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmax_a_d.c
+++ b/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmax_a_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Float Max Min";
     char *instruction_name =  "FMAX_A.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmax_a_w.c b/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmax_a_w.c
index f64276f2f1..7fa5fbc565 100644
--- a/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmax_a_w.c
+++ b/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmax_a_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Float Max Min";
     char *instruction_name =  "FMAX_A.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmax_d.c b/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmax_d.c
index ba548e4882..b356cff346 100644
--- a/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmax_d.c
+++ b/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmax_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Float Max Min";
     char *instruction_name =  "FMAX.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmax_w.c b/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmax_w.c
index f9aa24d62b..4efc663dda 100644
--- a/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmax_w.c
+++ b/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmax_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Float Max Min";
     char *instruction_name =  "FMAX.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmin_a_d.c b/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmin_a_d.c
index 555aa133ae..b58c18a394 100644
--- a/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmin_a_d.c
+++ b/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmin_a_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Float Max Min";
     char *instruction_name =  "FMIN_A.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmin_a_w.c b/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmin_a_w.c
index 9a81f1c6c5..e1071a9b9b 100644
--- a/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmin_a_w.c
+++ b/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmin_a_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Float Max Min";
     char *instruction_name =  "FMIN_A.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmin_d.c b/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmin_d.c
index 97123c8c0b..30de267f46 100644
--- a/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmin_d.c
+++ b/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmin_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Float Max Min";
     char *instruction_name =  "FMIN.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmin_w.c b/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmin_w.c
index 1e91136441..e28994a32f 100644
--- a/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmin_w.c
+++ b/tests/tcg/mips/user/ase/msa/float-max-min/test_msa_fmin_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Float Max Min";
     char *instruction_name =  "FMIN.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_add_a_b.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_add_a_b.c
index c0a07b5552..fe5f21ec9d 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_add_a_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_add_a_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADD_A.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_add_a_d.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_add_a_d.c
index 0771cdbdfe..9ad0d6ad10 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_add_a_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_add_a_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADD_A.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_add_a_h.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_add_a_h.c
index 7956960d0f..4ccb7c150e 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_add_a_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_add_a_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADD_A.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_add_a_w.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_add_a_w.c
index 590f440406..c97b1a157f 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_add_a_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_add_a_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADD_A.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_a_b.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_a_b.c
index 42dd260726..d33e88d528 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_a_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_a_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADDS_A.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_a_d.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_a_d.c
index 3e4e6f7f99..3817ba5013 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_a_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_a_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADDS_A.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_a_h.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_a_h.c
index 2901a8174b..3cabc9695b 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_a_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_a_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADDS_A.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_a_w.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_a_w.c
index 9e483e0754..41a88abaa0 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_a_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_a_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADDS_A.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_s_b.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_s_b.c
index 955815bf45..b8d92f263d 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_s_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_s_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADDS_S.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_s_d.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_s_d.c
index 0795f7e2c5..5738c255be 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_s_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_s_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADDS_S.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_s_h.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_s_h.c
index 793c5afb8c..8237be9712 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_s_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_s_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADDS_S.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_s_w.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_s_w.c
index 1c72c84669..aef671f171 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_s_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_s_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADDS_S.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_u_b.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_u_b.c
index f20340799e..7714a3d755 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_u_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_u_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADDS_U.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_u_d.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_u_d.c
index 30249edca0..b033651560 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_u_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_u_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADDS_U.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_u_h.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_u_h.c
index 1bd8aa9d20..f1c43d8382 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_u_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_u_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADDS_U.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_u_w.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_u_w.c
index a91c69f624..d8a9a54af3 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_u_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_adds_u_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADDS_U.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_addv_b.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_addv_b.c
index 2f11c76aa3..366174aa26 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_addv_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_addv_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADDV.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_addv_d.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_addv_d.c
index 4ed0b97876..c0697e1864 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_addv_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_addv_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADDV.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_addv_h.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_addv_h.c
index ca6ddd4b54..62c407032b 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_addv_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_addv_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADDV.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_addv_w.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_addv_w.c
index dff0f70a07..7d8e9a1d4c 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_addv_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_addv_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "ADDV.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_s_d.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_s_d.c
index c50a9dde87..2c9ec9a18f 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_s_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_s_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "HADD_S.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_s_h.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_s_h.c
index 586ef923cc..2da7cca0bb 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_s_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_s_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "HADD_S.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_s_w.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_s_w.c
index 3589c33940..0b87815964 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_s_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_s_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "HADD_S.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_u_d.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_u_d.c
index 35b2021347..2431eb0e46 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_u_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_u_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "HADD_U.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_u_h.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_u_h.c
index 3b38f9bb33..7cca3e32f0 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_u_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_u_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "HADD_U.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_u_w.c b/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_u_w.c
index fd420cb8de..de29d8d4d9 100644
--- a/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_u_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-add/test_msa_hadd_u_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Add";
     char *instruction_name =  "HADD_U.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_s_b.c b/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_s_b.c
index 14ee4ab4db..34a9fc88c3 100644
--- a/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_s_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_s_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Average";
     char *instruction_name =  "AVE_S.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_s_d.c b/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_s_d.c
index ae7b3c8b89..6fb7c8d084 100644
--- a/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_s_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_s_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Average";
     char *instruction_name =  "AVE_S.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_s_h.c b/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_s_h.c
index d0d327e80f..e36b8a7d18 100644
--- a/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_s_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_s_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Average";
     char *instruction_name =  "AVE_S.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_s_w.c b/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_s_w.c
index 77010209fb..e0a0a845df 100644
--- a/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_s_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_s_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Average";
     char *instruction_name =  "AVE_S.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_u_b.c b/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_u_b.c
index c9e834e74d..379a362335 100644
--- a/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_u_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_u_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Average";
     char *instruction_name =  "AVE_U.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_u_d.c b/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_u_d.c
index 5462ffac0f..78607536df 100644
--- a/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_u_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_u_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Average";
     char *instruction_name =  "AVE_U.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_u_h.c b/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_u_h.c
index 10d57e5741..34e205d209 100644
--- a/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_u_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_u_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Average";
     char *instruction_name =  "AVE_U.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_u_w.c b/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_u_w.c
index 53106dee74..764b316976 100644
--- a/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_u_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-average/test_msa_ave_u_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Average";
     char *instruction_name =  "AVE_U.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_s_b.c b/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_s_b.c
index 465f54fc13..94c32c6039 100644
--- a/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_s_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_s_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Average";
     char *instruction_name =  "AVER_S.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_s_d.c b/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_s_d.c
index 391cb85ff0..5ca476e607 100644
--- a/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_s_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_s_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Average";
     char *instruction_name =  "AVER_S.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_s_h.c b/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_s_h.c
index 352b57d786..302b2dc4ca 100644
--- a/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_s_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_s_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Average";
     char *instruction_name =  "AVER_S.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_s_w.c b/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_s_w.c
index cfba37b0ae..eeabddf1f9 100644
--- a/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_s_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_s_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Average";
     char *instruction_name =  "AVER_S.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_u_b.c b/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_u_b.c
index 91f227b830..3dcdcd9c29 100644
--- a/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_u_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_u_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Average";
     char *instruction_name =  "AVER_U.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_u_d.c b/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_u_d.c
index fde57a2a5c..3874b61e45 100644
--- a/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_u_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_u_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Average";
     char *instruction_name =  "AVER_U.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_u_h.c b/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_u_h.c
index b9ec39a3de..54b0b0bd11 100644
--- a/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_u_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_u_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Average";
     char *instruction_name =  "AVER_U.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_u_w.c b/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_u_w.c
index dc3c2e432e..b8c39cad6a 100644
--- a/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_u_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-average/test_msa_aver_u_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Average";
     char *instruction_name =  "AVER_U.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_ceq_b.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_ceq_b.c
index c9a9ee227d..24ee133e09 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_ceq_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_ceq_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CEQ.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_ceq_d.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_ceq_d.c
index 542c460f2f..90e8ebba27 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_ceq_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_ceq_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CEQ.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_ceq_h.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_ceq_h.c
index 3ebe59550c..5f578092be 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_ceq_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_ceq_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CEQ.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_ceq_w.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_ceq_w.c
index 003acf1544..18ce27752b 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_ceq_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_ceq_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CEQ.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_s_b.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_s_b.c
index ff20f0ea0e..c2705bf374 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_s_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_s_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CLE_S.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_s_d.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_s_d.c
index 3dc18bd661..6f4b6842cf 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_s_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_s_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CLE_S.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_s_h.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_s_h.c
index 00c48d657b..7d51c2617f 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_s_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_s_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CLE_S.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_s_w.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_s_w.c
index 16f84a13e7..0c90e79113 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_s_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_s_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CLE_S.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_u_b.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_u_b.c
index 24574dc30d..a434b5382e 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_u_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_u_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CLE_U.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_u_d.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_u_d.c
index e3f571545d..f355352093 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_u_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_u_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CLE_U.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_u_h.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_u_h.c
index 8938d31c59..d443e41f3c 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_u_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_u_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CLE_U.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_u_w.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_u_w.c
index 078a0c1815..bbc96d3ee6 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_u_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_cle_u_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CLE_U.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_s_b.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_s_b.c
index 02c3dfa09e..2066c25e94 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_s_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_s_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CLT_S.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_s_d.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_s_d.c
index 40637e2761..7a49f490b3 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_s_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_s_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CLT_S.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_s_h.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_s_h.c
index ee3cd628fc..287d5d122a 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_s_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_s_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CLT_S.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_s_w.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_s_w.c
index bde4d95350..dad15b19fa 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_s_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_s_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CLT_S.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_u_b.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_u_b.c
index 147bf484b7..28f1d20d7e 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_u_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_u_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CLT_U.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_u_d.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_u_d.c
index 5daf716726..55f6295cfa 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_u_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_u_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CLT_U.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_u_h.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_u_h.c
index 8d51c2cc3c..425004a010 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_u_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_u_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CLT_U.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_u_w.c b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_u_w.c
index 5403af8688..9da360a493 100644
--- a/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_u_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-compare/test_msa_clt_u_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Compare";
     char *instruction_name =  "CLT_U.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_s_b.c b/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_s_b.c
index f263201e72..b21b527609 100644
--- a/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_s_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_s_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Divide";
     char *instruction_name =  "DIV_S.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_s_d.c b/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_s_d.c
index 0458f933f6..04d61827c7 100644
--- a/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_s_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_s_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Divide";
     char *instruction_name =  "DIV_S.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_s_h.c b/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_s_h.c
index fffe7be072..e26fd8651b 100644
--- a/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_s_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_s_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Divide";
     char *instruction_name =  "DIV_S.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_s_w.c b/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_s_w.c
index 22fa184d80..e2188aabf1 100644
--- a/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_s_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_s_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Divide";
     char *instruction_name =  "DIV_S.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_u_b.c b/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_u_b.c
index 8097d6c864..fbb1465804 100644
--- a/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_u_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_u_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Divide";
     char *instruction_name =  "DIV_U.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_u_d.c b/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_u_d.c
index 54d6fda1f2..26dfa27937 100644
--- a/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_u_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_u_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Divide";
     char *instruction_name =  "DIV_U.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_u_h.c b/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_u_h.c
index 5a729906ac..f018e37f7c 100644
--- a/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_u_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_u_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Divide";
     char *instruction_name =  "DIV_U.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_u_w.c b/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_u_w.c
index e9e2da4718..73928c83e3 100644
--- a/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_u_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-divide/test_msa_div_u_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Divide";
     char *instruction_name =  "DIV_U.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_s_d.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_s_d.c
index cb13ff3e75..d6df83c3c8 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_s_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_s_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DOTP_S.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_s_h.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_s_h.c
index 19451ee57d..094ff32f55 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_s_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_s_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DOTP_S.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_s_w.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_s_w.c
index e635888e6c..fcaead98e6 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_s_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_s_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DOTP_S.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_u_d.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_u_d.c
index af4337d02c..c7771ac9a9 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_u_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_u_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DOTP_U.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_u_h.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_u_h.c
index a87b72b121..09598a3b56 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_u_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_u_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DOTP_U.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_u_w.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_u_w.c
index 05df4cb583..6dec27f839 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_u_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dotp_u_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DOTP_U.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_s_d.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_s_d.c
index d039e1a785..eb234cea13 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_s_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_s_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DPADD_S.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_s_h.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_s_h.c
index bcaafe3b71..d0441d0fa9 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_s_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_s_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DPADD_S.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_s_w.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_s_w.c
index 90562ab8a5..90c629802b 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_s_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_s_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DPADD_S.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_u_d.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_u_d.c
index 106dc73d1f..a4662d9b19 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_u_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_u_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DPADD_U.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_u_h.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_u_h.c
index 5fae97e907..4227b45d53 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_u_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_u_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DPADD_U.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_u_w.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_u_w.c
index 2bea9f669b..89760c500c 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_u_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpadd_u_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DPADD_U.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_s_d.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_s_d.c
index 560e29a248..0e300688a3 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_s_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_s_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DPSUB_S.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_s_h.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_s_h.c
index 3fb88ab5c2..e1592a8dd3 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_s_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_s_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DPSUB_S.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_s_w.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_s_w.c
index b95878b67b..06fbd05866 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_s_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_s_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DPSUB_S.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_u_d.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_u_d.c
index fc6c4e61dc..ea541f986d 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_u_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_u_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DPSUB_U.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_u_h.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_u_h.c
index 741c887bbd..3213d2d6a6 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_u_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_u_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DPSUB_U.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_u_w.c b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_u_w.c
index 3e1b711b61..9239d6bea1 100644
--- a/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_u_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-dot-product/test_msa_dpsub_u_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Dot Product";
     char *instruction_name =  "DPSUB_U.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_a_b.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_a_b.c
index 7e984a786e..a6b0344da5 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_a_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_a_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MAX_A.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_a_d.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_a_d.c
index 3dfdb482f4..289fb857cf 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_a_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_a_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MAX_A.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_a_h.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_a_h.c
index e1d65f98dc..cace99353f 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_a_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_a_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MAX_A.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_a_w.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_a_w.c
index 600f60af56..4d06125989 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_a_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_a_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MAX_A.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_s_b.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_s_b.c
index ab4161f20c..5edd33d0b7 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_s_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_s_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MAX_S.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_s_d.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_s_d.c
index 54a78ae56a..bf0d4d91be 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_s_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_s_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MAX_S.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_s_h.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_s_h.c
index 79b1e0adfd..727776bc79 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_s_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_s_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MAX_S.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_s_w.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_s_w.c
index 32e32456eb..61ded97163 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_s_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_s_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MAX_S.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_u_b.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_u_b.c
index a63d226279..eeccb68469 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_u_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_u_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MAX_U.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_u_d.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_u_d.c
index 815a9ef497..acedbec408 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_u_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_u_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MAX_U.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_u_h.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_u_h.c
index b668b39507..41e319f98b 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_u_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_u_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MAX_U.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_u_w.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_u_w.c
index 3329455f92..82858d9f13 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_u_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_max_u_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MAX_U.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_a_b.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_a_b.c
index 8fdbfc3bd3..a9b7c59866 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_a_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_a_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MIN_A.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_a_d.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_a_d.c
index 6a9f6bf10e..faaed4b822 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_a_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_a_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MIN_A.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_a_h.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_a_h.c
index 67a40b96f3..4c05f96ce7 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_a_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_a_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MIN_A.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_a_w.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_a_w.c
index d08cb9cea8..05d869e05f 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_a_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_a_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MIN_A.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_s_b.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_s_b.c
index 048233bbab..d060b576ab 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_s_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_s_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MIN_S.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_s_d.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_s_d.c
index 04e18ebdbf..40daff1839 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_s_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_s_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MIN_S.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_s_h.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_s_h.c
index 3bf32d487a..ec852b2521 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_s_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_s_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MIN_S.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_s_w.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_s_w.c
index eeb2ec9359..99034cb1e0 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_s_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_s_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MIN_S.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_u_b.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_u_b.c
index bdebf68a49..9c7c6e0ba3 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_u_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_u_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MIN_U.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_u_d.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_u_d.c
index fcd90167ed..4d21696208 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_u_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_u_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MIN_U.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_u_h.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_u_h.c
index 16f54b79e1..80d09eb3c5 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_u_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_u_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MIN_U.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_u_w.c b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_u_w.c
index 574c169d03..13169c7f28 100644
--- a/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_u_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-max-min/test_msa_min_u_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Max Min";
     char *instruction_name =  "MIN_U.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_s_b.c b/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_s_b.c
index 1533790cae..d1ae9dbd5e 100644
--- a/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_s_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_s_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Modulo";
     char *instruction_name =  "MOD_S.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_s_d.c b/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_s_d.c
index a8237f4244..c693f9bea3 100644
--- a/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_s_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_s_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Modulo";
     char *instruction_name =  "MOD_S.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_s_h.c b/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_s_h.c
index 5d6e4d63f8..85fc2546c5 100644
--- a/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_s_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_s_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Modulo";
     char *instruction_name =  "MOD_S.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_s_w.c b/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_s_w.c
index 1b068f28f5..fd8b276b16 100644
--- a/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_s_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_s_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Modulo";
     char *instruction_name =  "MOD_S.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_u_b.c b/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_u_b.c
index 0d9ddf5907..d6c5a69d70 100644
--- a/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_u_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_u_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Modulo";
     char *instruction_name =  "MOD_U.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_u_d.c b/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_u_d.c
index 1c3aa2bb36..b1efdd4d0a 100644
--- a/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_u_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_u_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Modulo";
     char *instruction_name =  "MOD_U.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_u_h.c b/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_u_h.c
index a17a69f1f3..a8a1fd8341 100644
--- a/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_u_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_u_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Modulo";
     char *instruction_name =  "MOD_U.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_u_w.c b/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_u_w.c
index ac0f704b18..60bce8dba8 100644
--- a/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_u_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-modulo/test_msa_mod_u_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Modulo";
     char *instruction_name =  "MOD_U.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_maddv_b.c b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_maddv_b.c
index d543e1af28..6dcadca833 100644
--- a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_maddv_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_maddv_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Multiply";
     char *instruction_name =  "MADDV.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_maddv_d.c b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_maddv_d.c
index fda35f757b..81aae83587 100644
--- a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_maddv_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_maddv_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Multiply";
     char *instruction_name =  "MADDV.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_maddv_h.c b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_maddv_h.c
index a9ee9b328a..4012d3d20e 100644
--- a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_maddv_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_maddv_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Multiply";
     char *instruction_name =  "MADDV.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_maddv_w.c b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_maddv_w.c
index bc3f5d246e..7b898fea7a 100644
--- a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_maddv_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_maddv_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Multiply";
     char *instruction_name =  "MADDV.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_msubv_b.c b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_msubv_b.c
index 808c49d050..4ae7113079 100644
--- a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_msubv_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_msubv_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Multiply";
     char *instruction_name =  "MSUBV.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_msubv_d.c b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_msubv_d.c
index 9722dbd99f..372ef096bd 100644
--- a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_msubv_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_msubv_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Multiply";
     char *instruction_name =  "MSUBV.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_msubv_h.c b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_msubv_h.c
index 6c059c779c..1bef77d351 100644
--- a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_msubv_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_msubv_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Multiply";
     char *instruction_name =  "MSUBV.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_msubv_w.c b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_msubv_w.c
index 0a83db4787..87d3be6969 100644
--- a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_msubv_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_msubv_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Multiply";
     char *instruction_name =  "MSUBV.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_mulv_b.c b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_mulv_b.c
index de1046820c..936f1caf78 100644
--- a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_mulv_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_mulv_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Multiply";
     char *instruction_name =  "MULV.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_mulv_d.c b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_mulv_d.c
index ae2ebef559..225a974b71 100644
--- a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_mulv_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_mulv_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Multiply";
     char *instruction_name =  "MULV.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_mulv_h.c b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_mulv_h.c
index 27479a82c5..40a3e8d27a 100644
--- a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_mulv_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_mulv_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Multiply";
     char *instruction_name =  "MULV.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_mulv_w.c b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_mulv_w.c
index adeb1bfa98..3f811481fb 100644
--- a/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_mulv_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-multiply/test_msa_mulv_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Multiply";
     char *instruction_name =  "MULV.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_s_b.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_s_b.c
index a3ab83b76c..e749711b0c 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_s_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_s_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "ASUB_S.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_s_d.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_s_d.c
index ee46ffadf1..c87e94fc61 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_s_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_s_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "ASUB_S.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_s_h.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_s_h.c
index 3262365907..f91b190289 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_s_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_s_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "ASUB_S.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_s_w.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_s_w.c
index 51f9a69413..1957573f33 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_s_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_s_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "ASUB_S.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_u_b.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_u_b.c
index e086214ef8..9078ad87c4 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_u_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_u_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "ASUB_U.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_u_d.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_u_d.c
index 5640b65007..04197a9dc9 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_u_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_u_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "ASUB_U.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_u_h.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_u_h.c
index a5bf2d2054..8aa2dd967b 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_u_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_u_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "ASUB_U.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_u_w.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_u_w.c
index 772e90eedb..f1284cbda4 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_u_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_asub_u_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "ASUB_U.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_s_d.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_s_d.c
index 66137f5856..eb299784aa 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_s_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_s_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "HSUB_S.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_s_h.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_s_h.c
index e66261b821..cf3e08102f 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_s_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_s_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "HSUB_S.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_s_w.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_s_w.c
index 6d97abfe3c..5196a7194c 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_s_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_s_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "HSUB_S.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_u_d.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_u_d.c
index 8f39a4525b..834f2326ff 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_u_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_u_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "HSUB_U.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_u_h.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_u_h.c
index 6cc82fce29..5eca52dcfc 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_u_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_u_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "HSUB_U.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_u_w.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_u_w.c
index b427e87a3a..a6bb5ccb36 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_u_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_hsub_u_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "HSUB_U.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_s_b.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_s_b.c
index 5c1f810d66..3c103d8466 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_s_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_s_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBS_S.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_s_d.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_s_d.c
index 546c24c5c2..bd252173a6 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_s_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_s_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBS_S.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_s_h.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_s_h.c
index 24ddc826c3..bd11db11f2 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_s_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_s_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBS_S.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_s_w.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_s_w.c
index f6109a5331..7565933288 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_s_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_s_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBS_S.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_u_b.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_u_b.c
index f170912348..7d5539c31d 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_u_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_u_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBS_U.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_u_d.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_u_d.c
index bf647db221..36d90810e8 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_u_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_u_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBS_U.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_u_h.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_u_h.c
index c4616be3e9..97be4e046a 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_u_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_u_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBS_U.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_u_w.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_u_w.c
index 61052672ca..74affbcc1c 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_u_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subs_u_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBS_U.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsus_u_b.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsus_u_b.c
index 71ea14fa2d..694878288d 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsus_u_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsus_u_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBSUS_U.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsus_u_d.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsus_u_d.c
index 070c457c44..7ae1bb1120 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsus_u_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsus_u_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBSUS_U.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsus_u_h.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsus_u_h.c
index f98d010436..80f7ceb0a9 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsus_u_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsus_u_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBSUS_U.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsus_u_w.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsus_u_w.c
index d325c19217..0172cf2a06 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsus_u_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsus_u_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBSUS_U.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsuu_s_b.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsuu_s_b.c
index 66012b5894..741681f9d2 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsuu_s_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsuu_s_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBSUU_S.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsuu_s_d.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsuu_s_d.c
index 344a373055..d5b1dc7072 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsuu_s_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsuu_s_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBSUU_S.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsuu_s_h.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsuu_s_h.c
index 1cacb26395..4a488974cf 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsuu_s_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsuu_s_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBSUU_S.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsuu_s_w.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsuu_s_w.c
index 42f3ee56f6..3b62ef65af 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsuu_s_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subsuu_s_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBSUU_S.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subv_b.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subv_b.c
index b8bd085516..3095c78132 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subv_b.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subv_b.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBV.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subv_d.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subv_d.c
index f532e4a69d..1d1b50d2ae 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subv_d.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subv_d.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBV.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subv_h.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subv_h.c
index ac7f8ee6b5..b147a7ed7c 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subv_h.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subv_h.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBV.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subv_w.c b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subv_w.c
index 93eeaecc7c..44b10d1145 100644
--- a/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subv_w.c
+++ b/tests/tcg/mips/user/ase/msa/int-subtract/test_msa_subv_w.c
@@ -38,7 +38,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Int Subtract";
     char *instruction_name =  "SUBV.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -152,9 +151,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvev_b.c b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvev_b.c
index 3506202cd9..ebbc530a45 100644
--- a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvev_b.c
+++ b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvev_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Interleave";
     char *instruction_name =  "ILVEV.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvev_d.c b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvev_d.c
index 896b11dce0..94eb1d20c0 100644
--- a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvev_d.c
+++ b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvev_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Interleave";
     char *instruction_name =  "ILVEV.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvev_h.c b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvev_h.c
index a68fea643f..2f8cc7ec5a 100644
--- a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvev_h.c
+++ b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvev_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Interleave";
     char *instruction_name =  "ILVEV.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvev_w.c b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvev_w.c
index 6e168c701e..dd47b84b2b 100644
--- a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvev_w.c
+++ b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvev_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Interleave";
     char *instruction_name =  "ILVEV.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvl_b.c b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvl_b.c
index 11cfbf398a..e6ae48ebbf 100644
--- a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvl_b.c
+++ b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvl_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Interleave";
     char *instruction_name =  "ILVL.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvl_d.c b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvl_d.c
index 35581ee7ea..1a0b56af2e 100644
--- a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvl_d.c
+++ b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvl_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Interleave";
     char *instruction_name =  "ILVL.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvl_h.c b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvl_h.c
index 0d89d95edd..13dbfbd3e7 100644
--- a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvl_h.c
+++ b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvl_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Interleave";
     char *instruction_name =  "ILVL.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvl_w.c b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvl_w.c
index ce044889c3..84c13af6d2 100644
--- a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvl_w.c
+++ b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvl_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Interleave";
     char *instruction_name =  "ILVL.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvod_b.c b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvod_b.c
index f7dd1d22b0..eb34133dfd 100644
--- a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvod_b.c
+++ b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvod_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Interleave";
     char *instruction_name =  "ILVOD.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvod_d.c b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvod_d.c
index bef28d8ded..38bd1c2ed1 100644
--- a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvod_d.c
+++ b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvod_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Interleave";
     char *instruction_name =  "ILVOD.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvod_h.c b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvod_h.c
index d2355c6676..36f0bc8574 100644
--- a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvod_h.c
+++ b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvod_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Interleave";
     char *instruction_name =  "ILVOD.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvod_w.c b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvod_w.c
index 636a62d056..728a0b626c 100644
--- a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvod_w.c
+++ b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvod_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Interleave";
     char *instruction_name =  "ILVOD.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvr_b.c b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvr_b.c
index 75bc9de9f9..4a6c78e9de 100644
--- a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvr_b.c
+++ b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvr_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Interleave";
     char *instruction_name =  "ILVR.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvr_d.c b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvr_d.c
index a80aa446f8..1fc2877957 100644
--- a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvr_d.c
+++ b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvr_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Interleave";
     char *instruction_name =  "ILVR.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvr_h.c b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvr_h.c
index caa00224fd..b828558cd9 100644
--- a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvr_h.c
+++ b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvr_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Interleave";
     char *instruction_name =  "ILVR.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvr_w.c b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvr_w.c
index 65c89a3712..558546f4aa 100644
--- a/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvr_w.c
+++ b/tests/tcg/mips/user/ase/msa/interleave/test_msa_ilvr_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Interleave";
     char *instruction_name =  "ILVR.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/logic/test_msa_and_v.c b/tests/tcg/mips/user/ase/msa/logic/test_msa_and_v.c
index 22d1f9cc0f..79f56cc6f5 100644
--- a/tests/tcg/mips/user/ase/msa/logic/test_msa_and_v.c
+++ b/tests/tcg/mips/user/ase/msa/logic/test_msa_and_v.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Logic";
     char *instruction_name =  "AND.V";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/logic/test_msa_nor_v.c b/tests/tcg/mips/user/ase/msa/logic/test_msa_nor_v.c
index 3b9e481582..7fc327e3df 100644
--- a/tests/tcg/mips/user/ase/msa/logic/test_msa_nor_v.c
+++ b/tests/tcg/mips/user/ase/msa/logic/test_msa_nor_v.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Logic";
     char *instruction_name =  "NOR.V";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/logic/test_msa_or_v.c b/tests/tcg/mips/user/ase/msa/logic/test_msa_or_v.c
index e6e5da4efb..683bcb0962 100644
--- a/tests/tcg/mips/user/ase/msa/logic/test_msa_or_v.c
+++ b/tests/tcg/mips/user/ase/msa/logic/test_msa_or_v.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Logic";
     char *instruction_name =  "OR.V";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/logic/test_msa_xor_v.c b/tests/tcg/mips/user/ase/msa/logic/test_msa_xor_v.c
index 1b699b5ca4..a2b9e8e2f8 100644
--- a/tests/tcg/mips/user/ase/msa/logic/test_msa_xor_v.c
+++ b/tests/tcg/mips/user/ase/msa/logic/test_msa_xor_v.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Logic";
     char *instruction_name =  "XOR.V";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/move/test_msa_move_v.c b/tests/tcg/mips/user/ase/msa/move/test_msa_move_v.c
index ef2aa6dbdd..30b8ce10d5 100644
--- a/tests/tcg/mips/user/ase/msa/move/test_msa_move_v.c
+++ b/tests/tcg/mips/user/ase/msa/move/test_msa_move_v.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Move";
     char *instruction_name =  "MOVE.V";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -141,9 +140,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/pack/test_msa_pckev_b.c b/tests/tcg/mips/user/ase/msa/pack/test_msa_pckev_b.c
index 2f4ffd9195..7527240888 100644
--- a/tests/tcg/mips/user/ase/msa/pack/test_msa_pckev_b.c
+++ b/tests/tcg/mips/user/ase/msa/pack/test_msa_pckev_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Pack";
     char *instruction_name =  "PCKEV.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/pack/test_msa_pckev_d.c b/tests/tcg/mips/user/ase/msa/pack/test_msa_pckev_d.c
index 3f0bd47ffd..b390c17a8f 100644
--- a/tests/tcg/mips/user/ase/msa/pack/test_msa_pckev_d.c
+++ b/tests/tcg/mips/user/ase/msa/pack/test_msa_pckev_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Pack";
     char *instruction_name =  "PCKEV.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/pack/test_msa_pckev_h.c b/tests/tcg/mips/user/ase/msa/pack/test_msa_pckev_h.c
index 2eae01fa75..e351f62275 100644
--- a/tests/tcg/mips/user/ase/msa/pack/test_msa_pckev_h.c
+++ b/tests/tcg/mips/user/ase/msa/pack/test_msa_pckev_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Pack";
     char *instruction_name =  "PCKEV.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/pack/test_msa_pckev_w.c b/tests/tcg/mips/user/ase/msa/pack/test_msa_pckev_w.c
index f7215d0e43..07c52042fa 100644
--- a/tests/tcg/mips/user/ase/msa/pack/test_msa_pckev_w.c
+++ b/tests/tcg/mips/user/ase/msa/pack/test_msa_pckev_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Pack";
     char *instruction_name =  "PCKEV.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/pack/test_msa_pckod_b.c b/tests/tcg/mips/user/ase/msa/pack/test_msa_pckod_b.c
index 6355338332..23da0644c7 100644
--- a/tests/tcg/mips/user/ase/msa/pack/test_msa_pckod_b.c
+++ b/tests/tcg/mips/user/ase/msa/pack/test_msa_pckod_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Pack";
     char *instruction_name =  "PCKOD.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/pack/test_msa_pckod_d.c b/tests/tcg/mips/user/ase/msa/pack/test_msa_pckod_d.c
index ac75526fda..55809f5ebe 100644
--- a/tests/tcg/mips/user/ase/msa/pack/test_msa_pckod_d.c
+++ b/tests/tcg/mips/user/ase/msa/pack/test_msa_pckod_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Pack";
     char *instruction_name =  "PCKOD.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/pack/test_msa_pckod_h.c b/tests/tcg/mips/user/ase/msa/pack/test_msa_pckod_h.c
index 12c1fa1ea5..935d6127b3 100644
--- a/tests/tcg/mips/user/ase/msa/pack/test_msa_pckod_h.c
+++ b/tests/tcg/mips/user/ase/msa/pack/test_msa_pckod_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Pack";
     char *instruction_name =  "PCKOD.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/pack/test_msa_pckod_w.c b/tests/tcg/mips/user/ase/msa/pack/test_msa_pckod_w.c
index b8979c3f43..8073d518e1 100644
--- a/tests/tcg/mips/user/ase/msa/pack/test_msa_pckod_w.c
+++ b/tests/tcg/mips/user/ase/msa/pack/test_msa_pckod_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Pack";
     char *instruction_name =  "PCKOD.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/pack/test_msa_vshf_b.c b/tests/tcg/mips/user/ase/msa/pack/test_msa_vshf_b.c
index 1839a26ca7..f97f0ef142 100644
--- a/tests/tcg/mips/user/ase/msa/pack/test_msa_vshf_b.c
+++ b/tests/tcg/mips/user/ase/msa/pack/test_msa_vshf_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Pack";
     char *instruction_name =  "VSHF.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/pack/test_msa_vshf_d.c b/tests/tcg/mips/user/ase/msa/pack/test_msa_vshf_d.c
index ebc198feb8..cdfcac31e0 100644
--- a/tests/tcg/mips/user/ase/msa/pack/test_msa_vshf_d.c
+++ b/tests/tcg/mips/user/ase/msa/pack/test_msa_vshf_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Pack";
     char *instruction_name =  "VSHF.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/pack/test_msa_vshf_h.c b/tests/tcg/mips/user/ase/msa/pack/test_msa_vshf_h.c
index a7240134d7..a83f19439b 100644
--- a/tests/tcg/mips/user/ase/msa/pack/test_msa_vshf_h.c
+++ b/tests/tcg/mips/user/ase/msa/pack/test_msa_vshf_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Pack";
     char *instruction_name =  "VSHF.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/pack/test_msa_vshf_w.c b/tests/tcg/mips/user/ase/msa/pack/test_msa_vshf_w.c
index 607ac4fb53..b5df87c4fb 100644
--- a/tests/tcg/mips/user/ase/msa/pack/test_msa_vshf_w.c
+++ b/tests/tcg/mips/user/ase/msa/pack/test_msa_vshf_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Pack";
     char *instruction_name =  "VSHF.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -206,9 +205,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_sll_b.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_sll_b.c
index 649e67b6a1..99c5ab5573 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_sll_b.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_sll_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SLL.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_sll_d.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_sll_d.c
index 1d6fe54207..089f6d3499 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_sll_d.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_sll_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SLL.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_sll_h.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_sll_h.c
index 1e6c27bfe7..39186a3e76 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_sll_h.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_sll_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SLL.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_sll_w.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_sll_w.c
index 8bfbaca6fc..2c85fd8131 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_sll_w.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_sll_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SLL.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_sra_b.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_sra_b.c
index a5dcee3a72..90dc2830d6 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_sra_b.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_sra_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SRA.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_sra_d.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_sra_d.c
index 95a13620b9..69b63b3cb6 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_sra_d.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_sra_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SRA.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_sra_h.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_sra_h.c
index f00003d51c..0b7f5bc1b6 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_sra_h.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_sra_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SRA.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_sra_w.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_sra_w.c
index f00da6d3d9..f4d8bb6747 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_sra_w.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_sra_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SRA.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_srar_b.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_srar_b.c
index dcda9c2c95..6927e3359d 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_srar_b.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_srar_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SRAR.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_srar_d.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_srar_d.c
index 478098acd9..1f04aa93e7 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_srar_d.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_srar_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SRAR.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_srar_h.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_srar_h.c
index a30025548c..ec039c2127 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_srar_h.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_srar_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SRAR.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_srar_w.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_srar_w.c
index 027d4ce565..2483750f50 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_srar_w.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_srar_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SRAR.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_srl_b.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_srl_b.c
index 0e7c453cec..b134e8b5ad 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_srl_b.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_srl_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SRL.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_srl_d.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_srl_d.c
index f6351f875a..eff665db63 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_srl_d.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_srl_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SRL.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_srl_h.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_srl_h.c
index 93394ef47a..5bed8f79c0 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_srl_h.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_srl_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SRL.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_srl_w.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_srl_w.c
index c18cd9892a..d36d56a58f 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_srl_w.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_srl_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SRL.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_srlr_b.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_srlr_b.c
index d173d8fa9c..9c6c1665c4 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_srlr_b.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_srlr_b.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SRLR.B";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_srlr_d.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_srlr_d.c
index ecd7bd0c22..d5bae01f2d 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_srlr_d.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_srlr_d.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SRLR.D";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_srlr_h.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_srlr_h.c
index ca7fd75342..f8352ed75d 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_srlr_h.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_srlr_h.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SRLR.H";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/ase/msa/shift/test_msa_srlr_w.c b/tests/tcg/mips/user/ase/msa/shift/test_msa_srlr_w.c
index ccbe6c0c84..af85949a48 100644
--- a/tests/tcg/mips/user/ase/msa/shift/test_msa_srlr_w.c
+++ b/tests/tcg/mips/user/ase/msa/shift/test_msa_srlr_w.c
@@ -36,7 +36,6 @@ int32_t main(void)
     char *isa_ase_name = "MSA";
     char *group_name = "Shift";
     char *instruction_name =  "SRLR.W";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -150,9 +149,7 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_128(isa_ase_name, group_name, instruction_name,
-                            TEST_COUNT_TOTAL, elapsed_time,
-                            &b128_result[0][0], &b128_expect[0][0]);
-
-    return ret;
+    return check_results_128(isa_ase_name, group_name, instruction_name,
+                             TEST_COUNT_TOTAL, elapsed_time,
+                             &b128_result[0][0], &b128_expect[0][0]);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/bit-count/test_mips64r6_clo.c b/tests/tcg/mips/user/isa/mips64r6/bit-count/test_mips64r6_clo.c
index e7ecdc5910..02c4582f07 100644
--- a/tests/tcg/mips/user/isa/mips64r6/bit-count/test_mips64r6_clo.c
+++ b/tests/tcg/mips/user/isa/mips64r6/bit-count/test_mips64r6_clo.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Bit Count";
     char *instruction_name =   "CLO";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -139,8 +138,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/bit-count/test_mips64r6_clz.c b/tests/tcg/mips/user/isa/mips64r6/bit-count/test_mips64r6_clz.c
index a77a8e4eb5..0575feae23 100644
--- a/tests/tcg/mips/user/isa/mips64r6/bit-count/test_mips64r6_clz.c
+++ b/tests/tcg/mips/user/isa/mips64r6/bit-count/test_mips64r6_clz.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Bit Count";
     char *instruction_name =   "CLZ";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -139,8 +138,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/bit-count/test_mips64r6_dclo.c b/tests/tcg/mips/user/isa/mips64r6/bit-count/test_mips64r6_dclo.c
index eb41fbdfdf..562c21ac3b 100644
--- a/tests/tcg/mips/user/isa/mips64r6/bit-count/test_mips64r6_dclo.c
+++ b/tests/tcg/mips/user/isa/mips64r6/bit-count/test_mips64r6_dclo.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Bit Count";
     char *instruction_name =   "DCLO";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -139,8 +138,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/bit-count/test_mips64r6_dclz.c b/tests/tcg/mips/user/isa/mips64r6/bit-count/test_mips64r6_dclz.c
index be393ac199..c987b1f899 100644
--- a/tests/tcg/mips/user/isa/mips64r6/bit-count/test_mips64r6_dclz.c
+++ b/tests/tcg/mips/user/isa/mips64r6/bit-count/test_mips64r6_dclz.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Bit Count";
     char *instruction_name =   "DCLZ";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -139,8 +138,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/bit-swap/test_mips64r6_bitswap.c b/tests/tcg/mips/user/isa/mips64r6/bit-swap/test_mips64r6_bitswap.c
index df3d1b11f6..78484b2d1f 100644
--- a/tests/tcg/mips/user/isa/mips64r6/bit-swap/test_mips64r6_bitswap.c
+++ b/tests/tcg/mips/user/isa/mips64r6/bit-swap/test_mips64r6_bitswap.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Bit Swap";
     char *instruction_name =   "BITSWAP";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -139,8 +138,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/bit-swap/test_mips64r6_dbitswap.c b/tests/tcg/mips/user/isa/mips64r6/bit-swap/test_mips64r6_dbitswap.c
index 377835940d..d15950bb40 100644
--- a/tests/tcg/mips/user/isa/mips64r6/bit-swap/test_mips64r6_dbitswap.c
+++ b/tests/tcg/mips/user/isa/mips64r6/bit-swap/test_mips64r6_dbitswap.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Bit Swap";
     char *instruction_name =   "DBITSWAP";
-    int32_t ret;
     uint32_t i;
     struct timeval start, end;
     double elapsed_time;
@@ -139,8 +138,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_dmuh.c b/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_dmuh.c
index eb21615f95..425f33486a 100644
--- a/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_dmuh.c
+++ b/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_dmuh.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Int Multiply";
     char *instruction_name =   "DMUH";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_dmuhu.c b/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_dmuhu.c
index 7316d79e2a..565fd39cab 100644
--- a/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_dmuhu.c
+++ b/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_dmuhu.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Int Multiply";
     char *instruction_name =   "DMUHU";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_dmul.c b/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_dmul.c
index 3ac1965cca..212bb92f21 100644
--- a/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_dmul.c
+++ b/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_dmul.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Int Multiply";
     char *instruction_name =   "DMUL";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_dmulu.c b/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_dmulu.c
index 0862780e3d..6482d0b94e 100644
--- a/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_dmulu.c
+++ b/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_dmulu.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Int Multiply";
     char *instruction_name =   "DMULU";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_muh.c b/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_muh.c
index ff1ae6fd9c..dcfccfa2ce 100644
--- a/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_muh.c
+++ b/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_muh.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Int Multiply";
     char *instruction_name =   "MUH";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_muhu.c b/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_muhu.c
index cb2752767a..ccb960b931 100644
--- a/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_muhu.c
+++ b/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_muhu.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Int Multiply";
     char *instruction_name =   "MUHU";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_mul.c b/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_mul.c
index 5cdc4d5632..8c8903400b 100644
--- a/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_mul.c
+++ b/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_mul.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Int Multiply";
     char *instruction_name =   "MUL";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_mulu.c b/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_mulu.c
index ccb3bdc1ac..f75b05046f 100644
--- a/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_mulu.c
+++ b/tests/tcg/mips/user/isa/mips64r6/int-multiply/test_mips64r6_mulu.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Int Multiply";
     char *instruction_name =   "MULU";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/logic/test_mips64r6_and.c b/tests/tcg/mips/user/isa/mips64r6/logic/test_mips64r6_and.c
index 4d6cf2e1f1..9bdba589f6 100644
--- a/tests/tcg/mips/user/isa/mips64r6/logic/test_mips64r6_and.c
+++ b/tests/tcg/mips/user/isa/mips64r6/logic/test_mips64r6_and.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Logic";
     char *instruction_name =   "AND";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/logic/test_mips64r6_nor.c b/tests/tcg/mips/user/isa/mips64r6/logic/test_mips64r6_nor.c
index 21005ddc53..007310679d 100644
--- a/tests/tcg/mips/user/isa/mips64r6/logic/test_mips64r6_nor.c
+++ b/tests/tcg/mips/user/isa/mips64r6/logic/test_mips64r6_nor.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Logic";
     char *instruction_name =   "NOR";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/logic/test_mips64r6_or.c b/tests/tcg/mips/user/isa/mips64r6/logic/test_mips64r6_or.c
index 345b4544fe..500446a422 100644
--- a/tests/tcg/mips/user/isa/mips64r6/logic/test_mips64r6_or.c
+++ b/tests/tcg/mips/user/isa/mips64r6/logic/test_mips64r6_or.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Logic";
     char *instruction_name =   "OR";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/logic/test_mips64r6_xor.c b/tests/tcg/mips/user/isa/mips64r6/logic/test_mips64r6_xor.c
index 7e36fee517..f906d9a9ae 100644
--- a/tests/tcg/mips/user/isa/mips64r6/logic/test_mips64r6_xor.c
+++ b/tests/tcg/mips/user/isa/mips64r6/logic/test_mips64r6_xor.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Logic";
     char *instruction_name =   "XOR";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_dsllv.c b/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_dsllv.c
index 4f719efda1..c853afada1 100644
--- a/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_dsllv.c
+++ b/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_dsllv.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Shift";
     char *instruction_name =   "DSLLV";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_dsrav.c b/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_dsrav.c
index 024d508ca8..459e2c2e4f 100644
--- a/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_dsrav.c
+++ b/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_dsrav.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Shift";
     char *instruction_name =   "DSRAV";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_dsrlv.c b/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_dsrlv.c
index fd1c398ffd..aee5cfae52 100644
--- a/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_dsrlv.c
+++ b/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_dsrlv.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Shift";
     char *instruction_name =   "DSRLV";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_sllv.c b/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_sllv.c
index a5fa72b727..6c7d2fcdee 100644
--- a/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_sllv.c
+++ b/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_sllv.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Shift";
     char *instruction_name =   "SLLV";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_srav.c b/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_srav.c
index 79e1a047eb..fccb200942 100644
--- a/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_srav.c
+++ b/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_srav.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Shift";
     char *instruction_name =   "SRAV";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_srlv.c b/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_srlv.c
index 1f8c45d8cc..77b92d4810 100644
--- a/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_srlv.c
+++ b/tests/tcg/mips/user/isa/mips64r6/shift/test_mips64r6_srlv.c
@@ -34,7 +34,6 @@ int32_t main(void)
     char *isa_ase_name = "mips64r6";
     char *group_name = "Shift";
     char *instruction_name =   "SRLV";
-    int32_t ret;
     uint32_t i, j;
     struct timeval start, end;
     double elapsed_time;
@@ -146,8 +145,6 @@ int32_t main(void)
     elapsed_time = (end.tv_sec - start.tv_sec) * 1000.0;
     elapsed_time += (end.tv_usec - start.tv_usec) / 1000.0;
 
-    ret = check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
-                           b64_result, b64_expect);
-
-    return ret;
+    return check_results_64(instruction_name, TEST_COUNT_TOTAL, elapsed_time,
+                            b64_result, b64_expect);
 }
diff --git a/tests/tcg/multiarch/sha512.c b/tests/tcg/multiarch/sha512.c
index e1729828b9..9e701bcf20 100644
--- a/tests/tcg/multiarch/sha512.c
+++ b/tests/tcg/multiarch/sha512.c
@@ -855,8 +855,6 @@ plan_tests(unsigned int tests)
 static int
 exit_status_(void)
 {
-    int r;
-
     /* If there's no plan, just return the number of failures */
     if(no_plan || !have_plan) {
         return failures;
@@ -865,15 +863,12 @@ exit_status_(void)
     /* Ran too many tests?  Return the number of tests that were run
        that shouldn't have been */
     if(e_tests < test_count) {
-        r = test_count - e_tests;
-        return r;
+        return test_count - e_tests;
     }
 
     /* Return the number of tests that failed + the number of tests
        that weren't run */
-    r = failures + e_tests - test_count;
-
-    return r;
+    return failures + e_tests - test_count;
 }
 
 int
diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 2f08471627..194a1b813b 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -216,7 +216,6 @@ static int send_reply(fuse_req_t req, int error, const void *arg,
 
 int fuse_reply_iov(fuse_req_t req, const struct iovec *iov, int count)
 {
-    int res;
     g_autofree struct iovec *padded_iov = NULL;
 
     padded_iov = g_try_new(struct iovec, count + 1);
@@ -227,9 +226,7 @@ int fuse_reply_iov(fuse_req_t req, const struct iovec *iov, int count)
     memcpy(padded_iov + 1, iov, count * sizeof(struct iovec));
     count++;
 
-    res = send_reply_iov(req, 0, padded_iov, count);
-
-    return res;
+    return send_reply_iov(req, 0, padded_iov, count);
 }
 
 
@@ -589,7 +586,6 @@ int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec *in_iov,
     g_autofree struct fuse_ioctl_iovec *out_fiov = NULL;
     struct iovec iov[4];
     size_t count = 1;
-    int res;
 
     memset(&arg, 0, sizeof(arg));
     arg.flags |= FUSE_IOCTL_RETRY;
@@ -601,15 +597,13 @@ int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec *in_iov,
 
     /* Can't handle non-compat 64bit ioctls on 32bit */
     if (sizeof(void *) == 4 && req->ioctl_64bit) {
-        res = fuse_reply_err(req, EINVAL);
-        return res;
+        return fuse_reply_err(req, EINVAL);
     }
 
     if (in_count) {
         in_fiov = fuse_ioctl_iovec_copy(in_iov, in_count);
         if (!in_fiov) {
-            res = fuse_reply_err(req, ENOMEM);
-            return res;
+            return fuse_reply_err(req, ENOMEM);
         }
 
         iov[count].iov_base = (void *)in_fiov;
@@ -619,8 +613,7 @@ int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec *in_iov,
     if (out_count) {
         out_fiov = fuse_ioctl_iovec_copy(out_iov, out_count);
         if (!out_fiov) {
-            res = fuse_reply_err(req, ENOMEM);
-            return res;
+            return fuse_reply_err(req, ENOMEM);
         }
 
         iov[count].iov_base = (void *)out_fiov;
@@ -628,9 +621,7 @@ int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec *in_iov,
         count++;
     }
 
-    res = send_reply_iov(req, 0, iov, count);
-
-    return res;
+    return send_reply_iov(req, 0, iov, count);
 }
 
 int fuse_reply_ioctl(fuse_req_t req, int result, const void *buf, size_t size)
@@ -659,7 +650,6 @@ int fuse_reply_ioctl_iov(fuse_req_t req, int result, const struct iovec *iov,
 {
     g_autofree struct iovec *padded_iov = NULL;
     struct fuse_ioctl_out arg;
-    int res;
 
     padded_iov = g_try_new(struct iovec, count + 2);
     if (padded_iov == NULL) {
@@ -673,9 +663,7 @@ int fuse_reply_ioctl_iov(fuse_req_t req, int result, const struct iovec *iov,
 
     memcpy(&padded_iov[2], iov, count * sizeof(struct iovec));
 
-    res = send_reply_iov(req, 0, padded_iov, count + 2);
-
-    return res;
+    return send_reply_iov(req, 0, padded_iov, count + 2);
 }
 
 int fuse_reply_poll(fuse_req_t req, unsigned revents)
diff --git a/target/xtensa/core-dsp3400/xtensa-modules.c.inc b/target/xtensa/core-dsp3400/xtensa-modules.c.inc
index 28ea3d75fe..f12fd92337 100644
--- a/target/xtensa/core-dsp3400/xtensa-modules.c.inc
+++ b/target/xtensa/core-dsp3400/xtensa-modules.c.inc
@@ -41401,9 +41401,7 @@ Operand_arr_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_arr_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -41415,9 +41413,7 @@ Operand_ars_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_ars_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -41429,9 +41425,7 @@ Operand_art_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_art_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -41443,9 +41437,7 @@ Operand_ar0_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_ar0_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0x1f) != 0;
-  return error;
+  return (*valp & ~0x1f) != 0;
 }
 
 static int
@@ -41457,9 +41449,7 @@ Operand_ar4_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_ar4_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0x1f) != 0;
-  return error;
+  return (*valp & ~0x1f) != 0;
 }
 
 static int
@@ -41471,9 +41461,7 @@ Operand_ar8_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_ar8_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0x1f) != 0;
-  return error;
+  return (*valp & ~0x1f) != 0;
 }
 
 static int
@@ -41485,9 +41473,7 @@ Operand_ar12_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_ar12_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0x1f) != 0;
-  return error;
+  return (*valp & ~0x1f) != 0;
 }
 
 static int
@@ -41499,9 +41485,7 @@ Operand_ars_entry_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_ars_entry_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0x1f) != 0;
-  return error;
+  return (*valp & ~0x1f) != 0;
 }
 
 static int
@@ -42111,9 +42095,7 @@ Operand_bt_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_bt_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -42125,9 +42107,7 @@ Operand_bs_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_bs_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -42139,9 +42119,7 @@ Operand_br_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_br_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -42469,9 +42447,7 @@ Operand_frr_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_frr_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -42483,9 +42459,7 @@ Operand_frs_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_frs_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -42497,9 +42471,7 @@ Operand_frt_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_frt_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -42511,9 +42483,7 @@ Operand_dsp340050b49a6c_oper45_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper45_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -42525,9 +42495,7 @@ Operand_dsp340050b49a6c_oper46_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper46_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -42539,9 +42507,7 @@ Operand_dsp340050b49a6c_oper47_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper47_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -42593,9 +42559,7 @@ Operand_dsp340050b49a6c_oper50_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper50_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -42607,9 +42571,7 @@ Operand_dsp340050b49a6c_oper51_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper51_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0x7) != 0;
-  return error;
+  return (*valp & ~0x7) != 0;
 }
 
 static int
@@ -42641,9 +42603,7 @@ Operand_dsp340050b49a6c_oper53_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper53_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -42655,9 +42615,7 @@ Operand_dsp340050b49a6c_oper54_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper54_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0x7) != 0;
-  return error;
+  return (*valp & ~0x7) != 0;
 }
 
 static int
@@ -42669,9 +42627,7 @@ Operand_dsp340050b49a6c_oper55_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper55_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -42683,9 +42639,7 @@ Operand_dsp340050b49a6c_oper56_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper56_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -42797,9 +42751,7 @@ Operand_dsp340050b49a6c_oper62_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper62_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -42811,9 +42763,7 @@ Operand_dsp340050b49a6c_oper63_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper63_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0x7) != 0;
-  return error;
+  return (*valp & ~0x7) != 0;
 }
 
 static int
@@ -42845,9 +42795,7 @@ Operand_dsp340050b49a6c_oper65_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper65_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -42859,9 +42807,7 @@ Operand_dsp340050b49a6c_oper66_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper66_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0x7) != 0;
-  return error;
+  return (*valp & ~0x7) != 0;
 }
 
 static int
@@ -42873,9 +42819,7 @@ Operand_dsp340050b49a6c_oper67_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper67_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0x7) != 0;
-  return error;
+  return (*valp & ~0x7) != 0;
 }
 
 static int
@@ -42947,9 +42891,7 @@ Operand_dsp340050b49a6c_oper71_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper71_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0x7) != 0;
-  return error;
+  return (*valp & ~0x7) != 0;
 }
 
 static int
@@ -43061,9 +43003,7 @@ Operand_dsp340050b49a6c_oper77_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper77_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -43095,9 +43035,7 @@ Operand_dsp340050b49a6c_oper79_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper79_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -43109,9 +43047,7 @@ Operand_dsp340050b49a6c_oper80_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper80_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -43123,9 +43059,7 @@ Operand_dsp340050b49a6c_oper81_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper81_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -43137,9 +43071,7 @@ Operand_dsp340050b49a6c_oper82_reg_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_dsp340050b49a6c_oper82_reg_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
diff --git a/target/xtensa/core-lx106/xtensa-modules.c.inc b/target/xtensa/core-lx106/xtensa-modules.c.inc
index f2b5efc6ec..6e3626b267 100644
--- a/target/xtensa/core-lx106/xtensa-modules.c.inc
+++ b/target/xtensa/core-lx106/xtensa-modules.c.inc
@@ -1280,9 +1280,7 @@ Operand_art_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_art_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -1294,9 +1292,7 @@ Operand_ars_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_ars_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -1308,9 +1304,7 @@ Operand_arr_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_arr_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
@@ -1322,9 +1316,7 @@ Operand_ar0_decode (uint32 *valp ATTRIBUTE_UNUSED)
 static int
 Operand_ar0_encode (uint32 *valp)
 {
-  int error;
-  error = (*valp & ~0xf) != 0;
-  return error;
+  return (*valp & ~0xf) != 0;
 }
 
 static int
-- 
2.37.3

