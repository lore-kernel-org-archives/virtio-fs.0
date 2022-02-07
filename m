Date: Mon, 7 Feb 2022 09:30:55 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YgEtH+MQquXg7CPN@redhat.com>
References: <20220202193935.268777-1-vgoyal@redhat.com>
	<YgEVVLBv9eWbhcDV@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgEVVLBv9eWbhcDV@work-vm>
Subject: Re: [Virtio-fs] [PATCH v5 0/9] virtiofsd: Add support for file
 security context at file creation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Mon, Feb 07, 2022 at 12:49:24PM +0000, Dr. David Alan Gilbert wrote:
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > Hi,
> > 
> > This is V5 of the patches. I posted V4 here.
> > 
> > https://listman.redhat.com/archives/virtio-fs/2022-January/msg00041.html
> > 
> > These will allow us to support SELinux with virtiofs. This will send
> > SELinux context at file creation to server and server can set it on
> > file.
> 
> I think that's pretty close; I've got some minor comments I've replied
> to on the individual patches.
> 
> I do worry that the number of different paths for each operation is now
> quite large so hard to test.

It is indeed many combinations to test. During development, I have made
sure to test every path atleast once to make sure it works.

> I also wonder what happens on something other than SELinux.

As of now this pretty much works only for SELinux. Especially usage of
fscreate knob is very specific to SELinux.

In some cases, it will work with some other LSM other than SELinux
as well. But lets not go there. 

If we want to support multiple security contexts at some point of time,
fuse procotol changes have been written in such a way so that fuse
can send mutiple security context and then we will have to modify
code to be able to deal with that.

In short, for now, this code is pretty much expectin one security
context that too SELinux. This is very much in line with ceph and
nfs.

Vivek
> 
> Dave
> 
> > Changes since V4
> > ----------------
> > - Parse only known current size of fuse_init_in. This will make sure
> >   that future extension does not break existing code upon header
> >   update. (David Gilbert)
> > 
> > - Changed order of one of the patch. It is first patch in series. This
> >   will help fix the breakage before header update patch and code remains
> >   git bisectable. (David Gilbert)
> > 
> > - Changed %lx to %llx at one place. (David Gilbert).
> > 
> > Thanks
> > Vivek
> >  
> > Vivek Goyal (9):
> >   virtiofsd: Fix breakage due to fuse_init_in size change
> >   linux-headers: Update headers to v5.17-rc1
> >   virtiofsd: Parse extended "struct fuse_init_in"
> >   virtiofsd: Extend size of fuse_conn_info->capable and ->want fields
> >   virtiofsd, fuse_lowlevel.c: Add capability to parse security context
> >   virtiofsd: Move core file creation code in separate function
> >   virtiofsd: Create new file with fscreate set
> >   virtiofsd: Create new file using O_TMPFILE and set security context
> >   virtiofsd: Add an option to enable/disable security label
> > 
> >  docs/tools/virtiofsd.rst                      |   7 +
> >  include/standard-headers/asm-x86/kvm_para.h   |   1 +
> >  include/standard-headers/drm/drm_fourcc.h     |  11 +
> >  include/standard-headers/linux/ethtool.h      |   1 +
> >  include/standard-headers/linux/fuse.h         |  60 ++-
> >  include/standard-headers/linux/pci_regs.h     | 142 +++---
> >  include/standard-headers/linux/virtio_gpio.h  |  72 +++
> >  include/standard-headers/linux/virtio_i2c.h   |  47 ++
> >  include/standard-headers/linux/virtio_iommu.h |   8 +-
> >  .../standard-headers/linux/virtio_pcidev.h    |  65 +++
> >  include/standard-headers/linux/virtio_scmi.h  |  24 +
> >  linux-headers/asm-generic/unistd.h            |   5 +-
> >  linux-headers/asm-mips/unistd_n32.h           |   2 +
> >  linux-headers/asm-mips/unistd_n64.h           |   2 +
> >  linux-headers/asm-mips/unistd_o32.h           |   2 +
> >  linux-headers/asm-powerpc/unistd_32.h         |   2 +
> >  linux-headers/asm-powerpc/unistd_64.h         |   2 +
> >  linux-headers/asm-riscv/bitsperlong.h         |  14 +
> >  linux-headers/asm-riscv/mman.h                |   1 +
> >  linux-headers/asm-riscv/unistd.h              |  44 ++
> >  linux-headers/asm-s390/unistd_32.h            |   2 +
> >  linux-headers/asm-s390/unistd_64.h            |   2 +
> >  linux-headers/asm-x86/kvm.h                   |  16 +-
> >  linux-headers/asm-x86/unistd_32.h             |   1 +
> >  linux-headers/asm-x86/unistd_64.h             |   1 +
> >  linux-headers/asm-x86/unistd_x32.h            |   1 +
> >  linux-headers/linux/kvm.h                     |  17 +
> >  tools/virtiofsd/fuse_common.h                 |   9 +-
> >  tools/virtiofsd/fuse_i.h                      |   7 +
> >  tools/virtiofsd/fuse_lowlevel.c               | 162 +++++--
> >  tools/virtiofsd/helper.c                      |   1 +
> >  tools/virtiofsd/passthrough_ll.c              | 414 ++++++++++++++++--
> >  32 files changed, 1013 insertions(+), 132 deletions(-)
> >  create mode 100644 include/standard-headers/linux/virtio_gpio.h
> >  create mode 100644 include/standard-headers/linux/virtio_i2c.h
> >  create mode 100644 include/standard-headers/linux/virtio_pcidev.h
> >  create mode 100644 include/standard-headers/linux/virtio_scmi.h
> >  create mode 100644 linux-headers/asm-riscv/bitsperlong.h
> >  create mode 100644 linux-headers/asm-riscv/mman.h
> >  create mode 100644 linux-headers/asm-riscv/unistd.h
> > 
> > -- 
> > 2.34.1
> > 
> -- 
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 

