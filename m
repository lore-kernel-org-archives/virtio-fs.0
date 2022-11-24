Return-Path: <groug@kaod.org>
Date: Thu, 24 Nov 2022 16:24:03 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20221124162403.7d45f4fb@bahia>
In-Reply-To: <20221124161511.73b50353@bahia>
References: <20221122134917.1217307-1-armbru@redhat.com>
 <20221122134917.1217307-2-armbru@redhat.com>
 <20221124161511.73b50353@bahia>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v2 1/2] cleanup: Tweak and re-run
 return_directly.cocci
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, qemu_oss@crudebyte.com, Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, philmd@linaro.org, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, berrange@redhat.com, thuth@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com

On Thu, 24 Nov 2022 16:15:11 +0100
Greg Kurz <groug@kaod.org> wrote:

> On Tue, 22 Nov 2022 14:49:16 +0100
> Markus Armbruster <armbru@redhat.com> wrote:
> 
> > Tweak the semantic patch to drop redundant parenthesis around the
> > return expression.
> > 
> > Coccinelle drops a comment in hw/rdma/vmw/pvrdma_cmd.c; restored
> > manually.
> > 
> > Coccinelle messes up vmdk_co_create(), not sure why.  Change dropped,
> > will be done manually in the next commit.
> > 
> > Line breaks in target/avr/cpu.h and hw/rdma/vmw/pvrdma_cmd.c tidied up
> > manually.
> > 
> > Whitespace in tools/virtiofsd/fuse_lowlevel.c tidied up manually.
> > 
> > checkpatch.pl complains "return of an errno should typically be -ve"
> > two times for hw/9pfs/9p-synth.c.  Preexisting, the patch merely makes
> > it visible to checkpatch.pl.
> > 
> 
> Hi Markus,
> 
> Yeah these positive errno values have been sitting there since the
> beginning. It was dead code until I hijacked the synth backend to
> implement qtest for 9p. I didn't care much about the return value
> of the two culprits at the time since both are passed to assert(!ret)
> right away. For this reason, changing the sign should be easy :-)
> 
> I see that checkpatch.pl considers this as an error. I'll post
> a fix. I guess you'll need to rebase on this fix for your patches
> to pass CI.
> 

Or maybe I can fix the issues detected by coccinelle as well and
you can just drop the 9p bits from this patch ?

> Anyway, for 9p:
> 
> Reviewed-by: Greg Kurz <groug@kaod.org>
> 
> 
> > Signed-off-by: Markus Armbruster <armbru@redhat.com>
> > ---
> >  scripts/coccinelle/return_directly.cocci |  5 +--
> >  include/hw/pci/pci.h                     |  7 +--
> >  target/avr/cpu.h                         |  4 +-
> >  hw/9pfs/9p-synth.c                       | 14 ++----
> >  hw/char/sifive_uart.c                    |  4 +-
> >  hw/ppc/ppc4xx_sdram.c                    |  5 +--
> >  hw/rdma/vmw/pvrdma_cmd.c                 | 57 +++++++++---------------
> >  hw/virtio/vhost-user.c                   |  6 +--
> >  migration/dirtyrate.c                    | 10 +----
> >  migration/tls.c                          |  6 +--
> >  replay/replay-time.c                     |  5 +--
> >  semihosting/console.c                    |  4 +-
> >  softmmu/memory.c                         | 11 +----
> >  softmmu/physmem.c                        |  9 +---
> >  target/loongarch/cpu.c                   |  4 +-
> >  target/mips/tcg/dsp_helper.c             | 15 ++-----
> >  target/riscv/debug.c                     |  6 +--
> >  target/riscv/vector_helper.c             | 28 +++---------
> >  tests/bench/benchmark-crypto-akcipher.c  |  6 +--
> >  tests/qtest/erst-test.c                  |  5 +--
> >  tests/qtest/hexloader-test.c             |  6 +--
> >  tests/qtest/pvpanic-pci-test.c           |  6 +--
> >  tests/qtest/pvpanic-test.c               |  6 +--
> >  tests/qtest/test-filter-mirror.c         |  6 +--
> >  tests/qtest/virtio-ccw-test.c            |  6 +--
> >  tests/tcg/multiarch/sha512.c             |  9 +---
> >  tools/virtiofsd/fuse_lowlevel.c          | 24 +++-------
> >  27 files changed, 70 insertions(+), 204 deletions(-)
> > 
> > diff --git a/scripts/coccinelle/return_directly.cocci b/scripts/coccinelle/return_directly.cocci
> > index 4cf50e75ea..6cb1b3c99a 100644
> > --- a/scripts/coccinelle/return_directly.cocci
> > +++ b/scripts/coccinelle/return_directly.cocci
> > @@ -11,9 +11,8 @@ identifier F;
> >  -    T VAR;
> >       ... when != VAR
> >  
> > --    VAR =
> > -+    return
> > -     E;
> > +-    VAR = (E);
> >  -    return VAR;
> > ++    return E;
> >       ... when != VAR
> >   }
> > diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
> > index 6ccaaf5154..06e2d5f889 100644
> > --- a/include/hw/pci/pci.h
> > +++ b/include/hw/pci/pci.h
> > @@ -921,11 +921,8 @@ PCI_DMA_DEFINE_LDST(q_be, q_be, 64);
> >  static inline void *pci_dma_map(PCIDevice *dev, dma_addr_t addr,
> >                                  dma_addr_t *plen, DMADirection dir)
> >  {
> > -    void *buf;
> > -
> > -    buf = dma_memory_map(pci_get_address_space(dev), addr, plen, dir,
> > -                         MEMTXATTRS_UNSPECIFIED);
> > -    return buf;
> > +    return dma_memory_map(pci_get_address_space(dev), addr, plen, dir,
> > +                          MEMTXATTRS_UNSPECIFIED);
> >  }
> >  
> >  static inline void pci_dma_unmap(PCIDevice *dev, void *buffer, dma_addr_t len,
> > diff --git a/target/avr/cpu.h b/target/avr/cpu.h
> > index 96419c0c2b..f19dd72926 100644
> > --- a/target/avr/cpu.h
> > +++ b/target/avr/cpu.h
> > @@ -215,8 +215,7 @@ static inline int cpu_interrupts_enabled(CPUAVRState *env)
> >  
> >  static inline uint8_t cpu_get_sreg(CPUAVRState *env)
> >  {
> > -    uint8_t sreg;
> > -    sreg = (env->sregC) << 0
> > +    return (env->sregC) << 0
> >           | (env->sregZ) << 1
> >           | (env->sregN) << 2
> >           | (env->sregV) << 3
> > @@ -224,7 +223,6 @@ static inline uint8_t cpu_get_sreg(CPUAVRState *env)
> >           | (env->sregH) << 5
> >           | (env->sregT) << 6
> >           | (env->sregI) << 7;
> > -    return sreg;
> >  }
> >  
> >  static inline void cpu_set_sreg(CPUAVRState *env, uint8_t sreg)
> > diff --git a/hw/9pfs/9p-synth.c b/hw/9pfs/9p-synth.c
> > index 1c5813e4dd..38d787f494 100644
> > --- a/hw/9pfs/9p-synth.c
> > +++ b/hw/9pfs/9p-synth.c
> > @@ -72,7 +72,6 @@ static V9fsSynthNode *v9fs_add_dir_node(V9fsSynthNode *parent, int mode,
> >  int qemu_v9fs_synth_mkdir(V9fsSynthNode *parent, int mode,
> >                            const char *name, V9fsSynthNode **result)
> >  {
> > -    int ret;
> >      V9fsSynthNode *node, *tmp;
> >  
> >      if (!synth_fs) {
> > @@ -87,8 +86,7 @@ int qemu_v9fs_synth_mkdir(V9fsSynthNode *parent, int mode,
> >      QEMU_LOCK_GUARD(&synth_mutex);
> >      QLIST_FOREACH(tmp, &parent->child, sibling) {
> >          if (!strcmp(tmp->name, name)) {
> > -            ret = EEXIST;
> > -            return ret;
> > +            return EEXIST;
> >          }
> >      }
> >      /* Add the name */
> > @@ -98,15 +96,13 @@ int qemu_v9fs_synth_mkdir(V9fsSynthNode *parent, int mode,
> >      v9fs_add_dir_node(node, node->attr->mode, ".",
> >                        node->attr, node->attr->inode);
> >      *result = node;
> > -    ret = 0;
> > -    return ret;
> > +    return 0;
> >  }
> >  
> >  int qemu_v9fs_synth_add_file(V9fsSynthNode *parent, int mode,
> >                               const char *name, v9fs_synth_read read,
> >                               v9fs_synth_write write, void *arg)
> >  {
> > -    int ret;
> >      V9fsSynthNode *node, *tmp;
> >  
> >      if (!synth_fs) {
> > @@ -122,8 +118,7 @@ int qemu_v9fs_synth_add_file(V9fsSynthNode *parent, int mode,
> >      QEMU_LOCK_GUARD(&synth_mutex);
> >      QLIST_FOREACH(tmp, &parent->child, sibling) {
> >          if (!strcmp(tmp->name, name)) {
> > -            ret = EEXIST;
> > -            return ret;
> > +            return EEXIST;
> >          }
> >      }
> >      /* Add file type and remove write bits */
> > @@ -138,8 +133,7 @@ int qemu_v9fs_synth_add_file(V9fsSynthNode *parent, int mode,
> >      node->private      = arg;
> >      pstrcpy(node->name, sizeof(node->name), name);
> >      QLIST_INSERT_HEAD_RCU(&parent->child, node, sibling);
> > -    ret = 0;
> > -    return ret;
> > +    return 0;
> >  }
> >  
> >  static void synth_fill_statbuf(V9fsSynthNode *node, struct stat *stbuf)
> > diff --git a/hw/char/sifive_uart.c b/hw/char/sifive_uart.c
> > index 1c75f792b3..f2684e57bc 100644
> > --- a/hw/char/sifive_uart.c
> > +++ b/hw/char/sifive_uart.c
> > @@ -274,7 +274,6 @@ SiFiveUARTState *sifive_uart_create(MemoryRegion *address_space, hwaddr base,
> >  {
> >      DeviceState *dev;
> >      SysBusDevice *s;
> > -    SiFiveUARTState *r;
> >  
> >      dev = qdev_new("riscv.sifive.uart");
> >      s = SYS_BUS_DEVICE(dev);
> > @@ -284,6 +283,5 @@ SiFiveUARTState *sifive_uart_create(MemoryRegion *address_space, hwaddr base,
> >                                  sysbus_mmio_get_region(s, 0));
> >      sysbus_connect_irq(s, 0, irq);
> >  
> > -    r = SIFIVE_UART(dev);
> > -    return r;
> > +    return SIFIVE_UART(dev);
> >  }
> > diff --git a/hw/ppc/ppc4xx_sdram.c b/hw/ppc/ppc4xx_sdram.c
> > index 8d7137faf3..54bf9a2b44 100644
> > --- a/hw/ppc/ppc4xx_sdram.c
> > +++ b/hw/ppc/ppc4xx_sdram.c
> > @@ -520,13 +520,10 @@ static inline hwaddr sdram_ddr2_base(uint32_t bcr)
> >  
> >  static hwaddr sdram_ddr2_size(uint32_t bcr)
> >  {
> > -    hwaddr size;
> >      int sh;
> >  
> >      sh = 1024 - ((bcr >> 6) & 0x3ff);
> > -    size = 8 * MiB * sh;
> > -
> > -    return size;
> > +    return 8 * MiB * sh;
> >  }
> >  
> >  static uint32_t sdram_ddr2_dcr_read(void *opaque, int dcrn)
> > diff --git a/hw/rdma/vmw/pvrdma_cmd.c b/hw/rdma/vmw/pvrdma_cmd.c
> > index da7ddfa548..71d1919c94 100644
> > --- a/hw/rdma/vmw/pvrdma_cmd.c
> > +++ b/hw/rdma/vmw/pvrdma_cmd.c
> > @@ -182,13 +182,10 @@ static int create_pd(PVRDMADev *dev, union pvrdma_cmd_req *req,
> >  {
> >      struct pvrdma_cmd_create_pd *cmd = &req->create_pd;
> >      struct pvrdma_cmd_create_pd_resp *resp = &rsp->create_pd_resp;
> > -    int rc;
> >  
> >      memset(resp, 0, sizeof(*resp));
> > -    rc = rdma_rm_alloc_pd(&dev->rdma_dev_res, &dev->backend_dev,
> > -                          &resp->pd_handle, cmd->ctx_handle);
> > -
> > -    return rc;
> > +    return rdma_rm_alloc_pd(&dev->rdma_dev_res, &dev->backend_dev,
> > +                            &resp->pd_handle, cmd->ctx_handle);
> >  }
> >  
> >  static int destroy_pd(PVRDMADev *dev, union pvrdma_cmd_req *req,
> > @@ -506,20 +503,17 @@ static int modify_qp(PVRDMADev *dev, union pvrdma_cmd_req *req,
> >                       union pvrdma_cmd_resp *rsp)
> >  {
> >      struct pvrdma_cmd_modify_qp *cmd = &req->modify_qp;
> > -    int rc;
> >  
> >      /* No need to verify sgid_index since it is u8 */
> >  
> > -    rc = rdma_rm_modify_qp(&dev->rdma_dev_res, &dev->backend_dev,
> > -                           cmd->qp_handle, cmd->attr_mask,
> > -                           cmd->attrs.ah_attr.grh.sgid_index,
> > -                           (union ibv_gid *)&cmd->attrs.ah_attr.grh.dgid,
> > -                           cmd->attrs.dest_qp_num,
> > -                           (enum ibv_qp_state)cmd->attrs.qp_state,
> > -                           cmd->attrs.qkey, cmd->attrs.rq_psn,
> > -                           cmd->attrs.sq_psn);
> > -
> > -    return rc;
> > +    return rdma_rm_modify_qp(&dev->rdma_dev_res, &dev->backend_dev,
> > +                             cmd->qp_handle, cmd->attr_mask,
> > +                             cmd->attrs.ah_attr.grh.sgid_index,
> > +                             (union ibv_gid *)&cmd->attrs.ah_attr.grh.dgid,
> > +                             cmd->attrs.dest_qp_num,
> > +                             (enum ibv_qp_state)cmd->attrs.qp_state,
> > +                             cmd->attrs.qkey, cmd->attrs.rq_psn,
> > +                             cmd->attrs.sq_psn);
> >  }
> >  
> >  static int query_qp(PVRDMADev *dev, union pvrdma_cmd_req *req,
> > @@ -528,15 +522,14 @@ static int query_qp(PVRDMADev *dev, union pvrdma_cmd_req *req,
> >      struct pvrdma_cmd_query_qp *cmd = &req->query_qp;
> >      struct pvrdma_cmd_query_qp_resp *resp = &rsp->query_qp_resp;
> >      struct ibv_qp_init_attr init_attr;
> > -    int rc;
> >  
> >      memset(resp, 0, sizeof(*resp));
> >  
> > -    rc = rdma_rm_query_qp(&dev->rdma_dev_res, &dev->backend_dev, cmd->qp_handle,
> > -                          (struct ibv_qp_attr *)&resp->attrs, cmd->attr_mask,
> > -                          &init_attr);
> > -
> > -    return rc;
> > +    return rdma_rm_query_qp(&dev->rdma_dev_res, &dev->backend_dev,
> > +                            cmd->qp_handle,
> > +                            (struct ibv_qp_attr *)&resp->attrs,
> > +                            cmd->attr_mask,
> > +                            &init_attr);
> >  }
> >  
> >  static int destroy_qp(PVRDMADev *dev, union pvrdma_cmd_req *req,
> > @@ -562,34 +555,27 @@ static int create_bind(PVRDMADev *dev, union pvrdma_cmd_req *req,
> >                         union pvrdma_cmd_resp *rsp)
> >  {
> >      struct pvrdma_cmd_create_bind *cmd = &req->create_bind;
> > -    int rc;
> >      union ibv_gid *gid = (union ibv_gid *)&cmd->new_gid;
> >  
> >      if (cmd->index >= MAX_PORT_GIDS) {
> >          return -EINVAL;
> >      }
> >  
> > -    rc = rdma_rm_add_gid(&dev->rdma_dev_res, &dev->backend_dev,
> > -                         dev->backend_eth_device_name, gid, cmd->index);
> > -
> > -    return rc;
> > +    return rdma_rm_add_gid(&dev->rdma_dev_res, &dev->backend_dev,
> > +                           dev->backend_eth_device_name, gid, cmd->index);
> >  }
> >  
> >  static int destroy_bind(PVRDMADev *dev, union pvrdma_cmd_req *req,
> >                          union pvrdma_cmd_resp *rsp)
> >  {
> > -    int rc;
> > -
> >      struct pvrdma_cmd_destroy_bind *cmd = &req->destroy_bind;
> >  
> >      if (cmd->index >= MAX_PORT_GIDS) {
> >          return -EINVAL;
> >      }
> >  
> > -    rc = rdma_rm_del_gid(&dev->rdma_dev_res, &dev->backend_dev,
> > -                        dev->backend_eth_device_name, cmd->index);
> > -
> > -    return rc;
> > +    return rdma_rm_del_gid(&dev->rdma_dev_res, &dev->backend_dev,
> > +                           dev->backend_eth_device_name, cmd->index);
> >  }
> >  
> >  static int create_uc(PVRDMADev *dev, union pvrdma_cmd_req *req,
> > @@ -597,12 +583,9 @@ static int create_uc(PVRDMADev *dev, union pvrdma_cmd_req *req,
> >  {
> >      struct pvrdma_cmd_create_uc *cmd = &req->create_uc;
> >      struct pvrdma_cmd_create_uc_resp *resp = &rsp->create_uc_resp;
> > -    int rc;
> >  
> >      memset(resp, 0, sizeof(*resp));
> > -    rc = rdma_rm_alloc_uc(&dev->rdma_dev_res, cmd->pfn, &resp->ctx_handle);
> > -
> > -    return rc;
> > +    return rdma_rm_alloc_uc(&dev->rdma_dev_res, cmd->pfn, &resp->ctx_handle);
> >  }
> >  
> >  static int destroy_uc(PVRDMADev *dev, union pvrdma_cmd_req *req,
> > diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> > index abe23d4ebe..74a776ebe4 100644
> > --- a/hw/virtio/vhost-user.c
> > +++ b/hw/virtio/vhost-user.c
> > @@ -2532,11 +2532,7 @@ vhost_user_crypto_close_session(struct vhost_dev *dev, uint64_t session_id)
> >  static bool vhost_user_mem_section_filter(struct vhost_dev *dev,
> >                                            MemoryRegionSection *section)
> >  {
> > -    bool result;
> > -
> > -    result = memory_region_get_fd(section->mr) >= 0;
> > -
> > -    return result;
> > +    return memory_region_get_fd(section->mr) >= 0;
> >  }
> >  
> >  static int vhost_user_get_inflight_fd(struct vhost_dev *dev,
> > diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
> > index d6f1e01a70..4bfb97fc68 100644
> > --- a/migration/dirtyrate.c
> > +++ b/migration/dirtyrate.c
> > @@ -111,7 +111,6 @@ static void global_dirty_log_sync(unsigned int flag, bool one_shot)
> >  static DirtyPageRecord *vcpu_dirty_stat_alloc(VcpuStat *stat)
> >  {
> >      CPUState *cpu;
> > -    DirtyPageRecord *records;
> >      int nvcpu = 0;
> >  
> >      CPU_FOREACH(cpu) {
> > @@ -121,9 +120,7 @@ static DirtyPageRecord *vcpu_dirty_stat_alloc(VcpuStat *stat)
> >      stat->nvcpu = nvcpu;
> >      stat->rates = g_new0(DirtyRateVcpu, nvcpu);
> >  
> > -    records = g_new0(DirtyPageRecord, nvcpu);
> > -
> > -    return records;
> > +    return g_new0(DirtyPageRecord, nvcpu);
> >  }
> >  
> >  static void vcpu_dirty_stat_collect(VcpuStat *stat,
> > @@ -473,7 +470,6 @@ find_block_matched(RAMBlock *block, int count,
> >                    struct RamblockDirtyInfo *infos)
> >  {
> >      int i;
> > -    struct RamblockDirtyInfo *matched;
> >  
> >      for (i = 0; i < count; i++) {
> >          if (!strcmp(infos[i].idstr, qemu_ram_get_idstr(block))) {
> > @@ -492,9 +488,7 @@ find_block_matched(RAMBlock *block, int count,
> >          return NULL;
> >      }
> >  
> > -    matched = &infos[i];
> > -
> > -    return matched;
> > +    return &infos[i];
> >  }
> >  
> >  static bool compare_page_hash_info(struct RamblockDirtyInfo *info,
> > diff --git a/migration/tls.c b/migration/tls.c
> > index 73e8c9d3c2..4d2166a209 100644
> > --- a/migration/tls.c
> > +++ b/migration/tls.c
> > @@ -126,7 +126,6 @@ QIOChannelTLS *migration_tls_client_create(MigrationState *s,
> >                                             Error **errp)
> >  {
> >      QCryptoTLSCreds *creds;
> > -    QIOChannelTLS *tioc;
> >  
> >      creds = migration_tls_get_creds(
> >          s, QCRYPTO_TLS_CREDS_ENDPOINT_CLIENT, errp);
> > @@ -138,10 +137,7 @@ QIOChannelTLS *migration_tls_client_create(MigrationState *s,
> >          hostname = s->parameters.tls_hostname;
> >      }
> >  
> > -    tioc = qio_channel_tls_new_client(
> > -        ioc, creds, hostname, errp);
> > -
> > -    return tioc;
> > +    return qio_channel_tls_new_client(ioc, creds, hostname, errp);
> >  }
> >  
> >  void migration_tls_channel_connect(MigrationState *s,
> > diff --git a/replay/replay-time.c b/replay/replay-time.c
> > index 00ebcb7a49..ee0ebfcf09 100644
> > --- a/replay/replay-time.c
> > +++ b/replay/replay-time.c
> > @@ -48,7 +48,6 @@ void replay_read_next_clock(ReplayClockKind kind)
> >  /*! Reads next clock event from the input. */
> >  int64_t replay_read_clock(ReplayClockKind kind, int64_t raw_icount)
> >  {
> > -    int64_t ret;
> >      g_assert(replay_file && replay_mutex_locked());
> >  
> >      replay_advance_current_icount(raw_icount);
> > @@ -56,7 +55,5 @@ int64_t replay_read_clock(ReplayClockKind kind, int64_t raw_icount)
> >      if (replay_next_event_is(EVENT_CLOCK + kind)) {
> >          replay_read_next_clock(kind);
> >      }
> > -    ret = replay_state.cached_clock[kind];
> > -
> > -    return ret;
> > +    return replay_state.cached_clock[kind];
> >  }
> > diff --git a/semihosting/console.c b/semihosting/console.c
> > index 0f976fe8cb..5d61e8207e 100644
> > --- a/semihosting/console.c
> > +++ b/semihosting/console.c
> > @@ -43,10 +43,8 @@ static SemihostingConsole console;
> >  static int console_can_read(void *opaque)
> >  {
> >      SemihostingConsole *c = opaque;
> > -    int ret;
> >      g_assert(qemu_mutex_iothread_locked());
> > -    ret = (int) fifo8_num_free(&c->fifo);
> > -    return ret;
> > +    return (int)fifo8_num_free(&c->fifo);
> >  }
> >  
> >  static void console_wake_up(gpointer data, gpointer user_data)
> > diff --git a/softmmu/memory.c b/softmmu/memory.c
> > index bc0be3f62c..e05332d07f 100644
> > --- a/softmmu/memory.c
> > +++ b/softmmu/memory.c
> > @@ -2372,20 +2372,15 @@ void memory_region_reset_dirty(MemoryRegion *mr, hwaddr addr,
> >  
> >  int memory_region_get_fd(MemoryRegion *mr)
> >  {
> > -    int fd;
> > -
> >      RCU_READ_LOCK_GUARD();
> >      while (mr->alias) {
> >          mr = mr->alias;
> >      }
> > -    fd = mr->ram_block->fd;
> > -
> > -    return fd;
> > +    return mr->ram_block->fd;
> >  }
> >  
> >  void *memory_region_get_ram_ptr(MemoryRegion *mr)
> >  {
> > -    void *ptr;
> >      uint64_t offset = 0;
> >  
> >      RCU_READ_LOCK_GUARD();
> > @@ -2394,9 +2389,7 @@ void *memory_region_get_ram_ptr(MemoryRegion *mr)
> >          mr = mr->alias;
> >      }
> >      assert(mr->ram_block);
> > -    ptr = qemu_map_ram_ptr(mr->ram_block, offset);
> > -
> > -    return ptr;
> > +    return qemu_map_ram_ptr(mr->ram_block, offset);
> >  }
> >  
> >  MemoryRegion *memory_region_from_host(void *ptr, ram_addr_t *offset)
> > diff --git a/softmmu/physmem.c b/softmmu/physmem.c
> > index 1b606a3002..edec095c7a 100644
> > --- a/softmmu/physmem.c
> > +++ b/softmmu/physmem.c
> > @@ -3236,7 +3236,6 @@ void *address_space_map(AddressSpace *as,
> >      hwaddr len = *plen;
> >      hwaddr l, xlat;
> >      MemoryRegion *mr;
> > -    void *ptr;
> >      FlatView *fv;
> >  
> >      if (len == 0) {
> > @@ -3275,9 +3274,7 @@ void *address_space_map(AddressSpace *as,
> >      *plen = flatview_extend_translation(fv, addr, len, mr, xlat,
> >                                          l, is_write, attrs);
> >      fuzz_dma_read_cb(addr, *plen, mr);
> > -    ptr = qemu_ram_ptr_length(mr->ram_block, xlat, plen, true);
> > -
> > -    return ptr;
> > +    return qemu_ram_ptr_length(mr->ram_block, xlat, plen, true);
> >  }
> >  
> >  /* Unmaps a memory region previously mapped by address_space_map().
> > @@ -3545,15 +3542,13 @@ bool cpu_physical_memory_is_io(hwaddr phys_addr)
> >  {
> >      MemoryRegion*mr;
> >      hwaddr l = 1;
> > -    bool res;
> >  
> >      RCU_READ_LOCK_GUARD();
> >      mr = address_space_translate(&address_space_memory,
> >                                   phys_addr, &phys_addr, &l, false,
> >                                   MEMTXATTRS_UNSPECIFIED);
> >  
> > -    res = !(memory_region_is_ram(mr) || memory_region_is_romd(mr));
> > -    return res;
> > +    return !(memory_region_is_ram(mr) || memory_region_is_romd(mr));
> >  }
> >  
> >  int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque)
> > diff --git a/target/loongarch/cpu.c b/target/loongarch/cpu.c
> > index 46b04cbdad..e7b0e12be6 100644
> > --- a/target/loongarch/cpu.c
> > +++ b/target/loongarch/cpu.c
> > @@ -128,13 +128,11 @@ static inline bool cpu_loongarch_hw_interrupts_pending(CPULoongArchState *env)
> >  {
> >      uint32_t pending;
> >      uint32_t status;
> > -    bool r;
> >  
> >      pending = FIELD_EX64(env->CSR_ESTAT, CSR_ESTAT, IS);
> >      status  = FIELD_EX64(env->CSR_ECFG, CSR_ECFG, LIE);
> >  
> > -    r = (pending & status) != 0;
> > -    return r;
> > +    return (pending & status) != 0;
> >  }
> >  
> >  static void loongarch_cpu_do_interrupt(CPUState *cs)
> > diff --git a/target/mips/tcg/dsp_helper.c b/target/mips/tcg/dsp_helper.c
> > index 09b6e5fb15..7a4362c8ef 100644
> > --- a/target/mips/tcg/dsp_helper.c
> > +++ b/target/mips/tcg/dsp_helper.c
> > @@ -3281,15 +3281,12 @@ target_ulong helper_dextr_l(target_ulong ac, target_ulong shift,
> >                              CPUMIPSState *env)
> >  {
> >      uint64_t temp[3];
> > -    target_ulong ret;
> >  
> >      shift = shift & 0x3F;
> >  
> >      mipsdsp_rndrashift_acc(temp, ac, shift, env);
> >  
> > -    ret = (temp[1] << 63) | (temp[0] >> 1);
> > -
> > -    return ret;
> > +    return (temp[1] << 63) | (temp[0] >> 1);
> >  }
> >  
> >  target_ulong helper_dextr_r_l(target_ulong ac, target_ulong shift,
> > @@ -3297,7 +3294,6 @@ target_ulong helper_dextr_r_l(target_ulong ac, target_ulong shift,
> >  {
> >      uint64_t temp[3];
> >      uint32_t temp128;
> > -    target_ulong ret;
> >  
> >      shift = shift & 0x3F;
> >      mipsdsp_rndrashift_acc(temp, ac, shift, env);
> > @@ -3317,9 +3313,7 @@ target_ulong helper_dextr_r_l(target_ulong ac, target_ulong shift,
> >          set_DSPControl_overflow_flag(1, 23, env);
> >      }
> >  
> > -    ret = (temp[1] << 63) | (temp[0] >> 1);
> > -
> > -    return ret;
> > +    return (temp[1] << 63) | (temp[0] >> 1);
> >  }
> >  
> >  target_ulong helper_dextr_rs_l(target_ulong ac, target_ulong shift,
> > @@ -3327,7 +3321,6 @@ target_ulong helper_dextr_rs_l(target_ulong ac, target_ulong shift,
> >  {
> >      uint64_t temp[3];
> >      uint32_t temp128;
> > -    target_ulong ret;
> >  
> >      shift = shift & 0x3F;
> >      mipsdsp_rndrashift_acc(temp, ac, shift, env);
> > @@ -3354,9 +3347,7 @@ target_ulong helper_dextr_rs_l(target_ulong ac, target_ulong shift,
> >          set_DSPControl_overflow_flag(1, 23, env);
> >      }
> >  
> > -    ret = (temp[1] << 63) | (temp[0] >> 1);
> > -
> > -    return ret;
> > +    return (temp[1] << 63) | (temp[0] >> 1);
> >  }
> >  #endif
> >  
> > diff --git a/target/riscv/debug.c b/target/riscv/debug.c
> > index 26ea764407..e44848d0d7 100644
> > --- a/target/riscv/debug.c
> > +++ b/target/riscv/debug.c
> > @@ -243,15 +243,13 @@ static void do_trigger_action(CPURISCVState *env, target_ulong trigger_index)
> >  
> >  static uint32_t type2_breakpoint_size(CPURISCVState *env, target_ulong ctrl)
> >  {
> > -    uint32_t size, sizelo, sizehi = 0;
> > +    uint32_t sizelo, sizehi = 0;
> >  
> >      if (riscv_cpu_mxl(env) == MXL_RV64) {
> >          sizehi = extract32(ctrl, 21, 2);
> >      }
> >      sizelo = extract32(ctrl, 16, 2);
> > -    size = (sizehi << 2) | sizelo;
> > -
> > -    return size;
> > +    return (sizehi << 2) | sizelo;
> >  }
> >  
> >  static inline bool type2_breakpoint_enabled(target_ulong ctrl)
> > diff --git a/target/riscv/vector_helper.c b/target/riscv/vector_helper.c
> > index 0020b9a95d..00de879787 100644
> > --- a/target/riscv/vector_helper.c
> > +++ b/target/riscv/vector_helper.c
> > @@ -2791,31 +2791,25 @@ static inline uint16_t
> >  vssrl16(CPURISCVState *env, int vxrm, uint16_t a, uint16_t b)
> >  {
> >      uint8_t round, shift = b & 0xf;
> > -    uint16_t res;
> >  
> >      round = get_round(vxrm, a, shift);
> > -    res   = (a >> shift)  + round;
> > -    return res;
> > +    return (a >> shift) + round;
> >  }
> >  static inline uint32_t
> >  vssrl32(CPURISCVState *env, int vxrm, uint32_t a, uint32_t b)
> >  {
> >      uint8_t round, shift = b & 0x1f;
> > -    uint32_t res;
> >  
> >      round = get_round(vxrm, a, shift);
> > -    res   = (a >> shift)  + round;
> > -    return res;
> > +    return (a >> shift) + round;
> >  }
> >  static inline uint64_t
> >  vssrl64(CPURISCVState *env, int vxrm, uint64_t a, uint64_t b)
> >  {
> >      uint8_t round, shift = b & 0x3f;
> > -    uint64_t res;
> >  
> >      round = get_round(vxrm, a, shift);
> > -    res   = (a >> shift)  + round;
> > -    return res;
> > +    return (a >> shift) + round;
> >  }
> >  RVVCALL(OPIVV2_RM, vssrl_vv_b, OP_UUU_B, H1, H1, H1, vssrl8)
> >  RVVCALL(OPIVV2_RM, vssrl_vv_h, OP_UUU_H, H2, H2, H2, vssrl16)
> > @@ -2839,41 +2833,33 @@ static inline int8_t
> >  vssra8(CPURISCVState *env, int vxrm, int8_t a, int8_t b)
> >  {
> >      uint8_t round, shift = b & 0x7;
> > -    int8_t res;
> >  
> >      round = get_round(vxrm, a, shift);
> > -    res   = (a >> shift)  + round;
> > -    return res;
> > +    return (a >> shift) + round;
> >  }
> >  static inline int16_t
> >  vssra16(CPURISCVState *env, int vxrm, int16_t a, int16_t b)
> >  {
> >      uint8_t round, shift = b & 0xf;
> > -    int16_t res;
> >  
> >      round = get_round(vxrm, a, shift);
> > -    res   = (a >> shift)  + round;
> > -    return res;
> > +    return (a >> shift) + round;
> >  }
> >  static inline int32_t
> >  vssra32(CPURISCVState *env, int vxrm, int32_t a, int32_t b)
> >  {
> >      uint8_t round, shift = b & 0x1f;
> > -    int32_t res;
> >  
> >      round = get_round(vxrm, a, shift);
> > -    res   = (a >> shift)  + round;
> > -    return res;
> > +    return (a >> shift) + round;
> >  }
> >  static inline int64_t
> >  vssra64(CPURISCVState *env, int vxrm, int64_t a, int64_t b)
> >  {
> >      uint8_t round, shift = b & 0x3f;
> > -    int64_t res;
> >  
> >      round = get_round(vxrm, a, shift);
> > -    res   = (a >> shift)  + round;
> > -    return res;
> > +    return (a >> shift) + round;
> >  }
> >  
> >  RVVCALL(OPIVV2_RM, vssra_vv_b, OP_SSS_B, H1, H1, H1, vssra8)
> > diff --git a/tests/bench/benchmark-crypto-akcipher.c b/tests/bench/benchmark-crypto-akcipher.c
> > index 15e69557ed..5e68cb0a1c 100644
> > --- a/tests/bench/benchmark-crypto-akcipher.c
> > +++ b/tests/bench/benchmark-crypto-akcipher.c
> > @@ -24,14 +24,12 @@ static QCryptoAkCipher *create_rsa_akcipher(const uint8_t *priv_key,
> >                                              QCryptoHashAlgorithm hash)
> >  {
> >      QCryptoAkCipherOptions opt;
> > -    QCryptoAkCipher *rsa;
> >  
> >      opt.alg = QCRYPTO_AKCIPHER_ALG_RSA;
> >      opt.u.rsa.padding_alg = padding;
> >      opt.u.rsa.hash_alg = hash;
> > -    rsa = qcrypto_akcipher_new(&opt, QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE,
> > -                               priv_key, keylen, &error_abort);
> > -    return rsa;
> > +    return qcrypto_akcipher_new(&opt, QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE,
> > +                                priv_key, keylen, &error_abort);
> >  }
> >  
> >  static void test_rsa_speed(const uint8_t *priv_key, size_t keylen,
> > diff --git a/tests/qtest/erst-test.c b/tests/qtest/erst-test.c
> > index 4e768a126f..974e8bcfe5 100644
> > --- a/tests/qtest/erst-test.c
> > +++ b/tests/qtest/erst-test.c
> > @@ -154,10 +154,7 @@ static void test_acpi_erst_basic(void)
> >  
> >  int main(int argc, char **argv)
> >  {
> > -    int ret;
> > -
> >      g_test_init(&argc, &argv, NULL);
> >      qtest_add_func("/acpi-erst/basic", test_acpi_erst_basic);
> > -    ret = g_test_run();
> > -    return ret;
> > +    return g_test_run();
> >  }
> > diff --git a/tests/qtest/hexloader-test.c b/tests/qtest/hexloader-test.c
> > index 8b7aa2d72d..3023548041 100644
> > --- a/tests/qtest/hexloader-test.c
> > +++ b/tests/qtest/hexloader-test.c
> > @@ -34,12 +34,8 @@ static void hex_loader_test(void)
> >  
> >  int main(int argc, char **argv)
> >  {
> > -    int ret;
> > -
> >      g_test_init(&argc, &argv, NULL);
> >  
> >      qtest_add_func("/tmp/hex_loader", hex_loader_test);
> > -    ret = g_test_run();
> > -
> > -    return ret;
> > +    return g_test_run();
> >  }
> > diff --git a/tests/qtest/pvpanic-pci-test.c b/tests/qtest/pvpanic-pci-test.c
> > index c82c365c26..2c05b376ba 100644
> > --- a/tests/qtest/pvpanic-pci-test.c
> > +++ b/tests/qtest/pvpanic-pci-test.c
> > @@ -86,13 +86,9 @@ static void test_panic(void)
> >  
> >  int main(int argc, char **argv)
> >  {
> > -    int ret;
> > -
> >      g_test_init(&argc, &argv, NULL);
> >      qtest_add_func("/pvpanic-pci/panic", test_panic);
> >      qtest_add_func("/pvpanic-pci/panic-nopause", test_panic_nopause);
> >  
> > -    ret = g_test_run();
> > -
> > -    return ret;
> > +    return g_test_run();
> >  }
> > diff --git a/tests/qtest/pvpanic-test.c b/tests/qtest/pvpanic-test.c
> > index bc7b7dfc39..78f1cf8186 100644
> > --- a/tests/qtest/pvpanic-test.c
> > +++ b/tests/qtest/pvpanic-test.c
> > @@ -59,13 +59,9 @@ static void test_panic(void)
> >  
> >  int main(int argc, char **argv)
> >  {
> > -    int ret;
> > -
> >      g_test_init(&argc, &argv, NULL);
> >      qtest_add_func("/pvpanic/panic", test_panic);
> >      qtest_add_func("/pvpanic/panic-nopause", test_panic_nopause);
> >  
> > -    ret = g_test_run();
> > -
> > -    return ret;
> > +    return g_test_run();
> >  }
> > diff --git a/tests/qtest/test-filter-mirror.c b/tests/qtest/test-filter-mirror.c
> > index c8b0a92b53..248fc88699 100644
> > --- a/tests/qtest/test-filter-mirror.c
> > +++ b/tests/qtest/test-filter-mirror.c
> > @@ -76,12 +76,8 @@ static void test_mirror(void)
> >  
> >  int main(int argc, char **argv)
> >  {
> > -    int ret;
> > -
> >      g_test_init(&argc, &argv, NULL);
> >  
> >      qtest_add_func("/netfilter/mirror", test_mirror);
> > -    ret = g_test_run();
> > -
> > -    return ret;
> > +    return g_test_run();
> >  }
> > diff --git a/tests/qtest/virtio-ccw-test.c b/tests/qtest/virtio-ccw-test.c
> > index d05236407b..2de77bb6fe 100644
> > --- a/tests/qtest/virtio-ccw-test.c
> > +++ b/tests/qtest/virtio-ccw-test.c
> > @@ -95,8 +95,6 @@ static void virtio_scsi_hotplug(void)
> >  
> >  int main(int argc, char **argv)
> >  {
> > -    int ret;
> > -
> >      g_test_init(&argc, &argv, NULL);
> >      qtest_add_func("/virtio/balloon/nop", virtio_balloon_nop);
> >      qtest_add_func("/virtio/console/nop", virtconsole_nop);
> > @@ -109,7 +107,5 @@ int main(int argc, char **argv)
> >      qtest_add_func("/virtio/scsi/nop", virtio_scsi_nop);
> >      qtest_add_func("/virtio/scsi/hotplug", virtio_scsi_hotplug);
> >  
> > -    ret = g_test_run();
> > -
> > -    return ret;
> > +    return g_test_run();
> >  }
> > diff --git a/tests/tcg/multiarch/sha512.c b/tests/tcg/multiarch/sha512.c
> > index e1729828b9..9e701bcf20 100644
> > --- a/tests/tcg/multiarch/sha512.c
> > +++ b/tests/tcg/multiarch/sha512.c
> > @@ -855,8 +855,6 @@ plan_tests(unsigned int tests)
> >  static int
> >  exit_status_(void)
> >  {
> > -    int r;
> > -
> >      /* If there's no plan, just return the number of failures */
> >      if(no_plan || !have_plan) {
> >          return failures;
> > @@ -865,15 +863,12 @@ exit_status_(void)
> >      /* Ran too many tests?  Return the number of tests that were run
> >         that shouldn't have been */
> >      if(e_tests < test_count) {
> > -        r = test_count - e_tests;
> > -        return r;
> > +        return test_count - e_tests;
> >      }
> >  
> >      /* Return the number of tests that failed + the number of tests
> >         that weren't run */
> > -    r = failures + e_tests - test_count;
> > -
> > -    return r;
> > +    return failures + e_tests - test_count;
> >  }
> >  
> >  int
> > diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
> > index 2f08471627..194a1b813b 100644
> > --- a/tools/virtiofsd/fuse_lowlevel.c
> > +++ b/tools/virtiofsd/fuse_lowlevel.c
> > @@ -216,7 +216,6 @@ static int send_reply(fuse_req_t req, int error, const void *arg,
> >  
> >  int fuse_reply_iov(fuse_req_t req, const struct iovec *iov, int count)
> >  {
> > -    int res;
> >      g_autofree struct iovec *padded_iov = NULL;
> >  
> >      padded_iov = g_try_new(struct iovec, count + 1);
> > @@ -227,9 +226,7 @@ int fuse_reply_iov(fuse_req_t req, const struct iovec *iov, int count)
> >      memcpy(padded_iov + 1, iov, count * sizeof(struct iovec));
> >      count++;
> >  
> > -    res = send_reply_iov(req, 0, padded_iov, count);
> > -
> > -    return res;
> > +    return send_reply_iov(req, 0, padded_iov, count);
> >  }
> >  
> >  
> > @@ -589,7 +586,6 @@ int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec *in_iov,
> >      g_autofree struct fuse_ioctl_iovec *out_fiov = NULL;
> >      struct iovec iov[4];
> >      size_t count = 1;
> > -    int res;
> >  
> >      memset(&arg, 0, sizeof(arg));
> >      arg.flags |= FUSE_IOCTL_RETRY;
> > @@ -601,15 +597,13 @@ int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec *in_iov,
> >  
> >      /* Can't handle non-compat 64bit ioctls on 32bit */
> >      if (sizeof(void *) == 4 && req->ioctl_64bit) {
> > -        res = fuse_reply_err(req, EINVAL);
> > -        return res;
> > +        return fuse_reply_err(req, EINVAL);
> >      }
> >  
> >      if (in_count) {
> >          in_fiov = fuse_ioctl_iovec_copy(in_iov, in_count);
> >          if (!in_fiov) {
> > -            res = fuse_reply_err(req, ENOMEM);
> > -            return res;
> > +            return fuse_reply_err(req, ENOMEM);
> >          }
> >  
> >          iov[count].iov_base = (void *)in_fiov;
> > @@ -619,8 +613,7 @@ int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec *in_iov,
> >      if (out_count) {
> >          out_fiov = fuse_ioctl_iovec_copy(out_iov, out_count);
> >          if (!out_fiov) {
> > -            res = fuse_reply_err(req, ENOMEM);
> > -            return res;
> > +            return fuse_reply_err(req, ENOMEM);
> >          }
> >  
> >          iov[count].iov_base = (void *)out_fiov;
> > @@ -628,9 +621,7 @@ int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec *in_iov,
> >          count++;
> >      }
> >  
> > -    res = send_reply_iov(req, 0, iov, count);
> > -
> > -    return res;
> > +    return send_reply_iov(req, 0, iov, count);
> >  }
> >  
> >  int fuse_reply_ioctl(fuse_req_t req, int result, const void *buf, size_t size)
> > @@ -659,7 +650,6 @@ int fuse_reply_ioctl_iov(fuse_req_t req, int result, const struct iovec *iov,
> >  {
> >      g_autofree struct iovec *padded_iov = NULL;
> >      struct fuse_ioctl_out arg;
> > -    int res;
> >  
> >      padded_iov = g_try_new(struct iovec, count + 2);
> >      if (padded_iov == NULL) {
> > @@ -673,9 +663,7 @@ int fuse_reply_ioctl_iov(fuse_req_t req, int result, const struct iovec *iov,
> >  
> >      memcpy(&padded_iov[2], iov, count * sizeof(struct iovec));
> >  
> > -    res = send_reply_iov(req, 0, padded_iov, count + 2);
> > -
> > -    return res;
> > +    return send_reply_iov(req, 0, padded_iov, count + 2);
> >  }
> >  
> >  int fuse_reply_poll(fuse_req_t req, unsigned revents)
> 
> 

