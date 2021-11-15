Date: Mon, 15 Nov 2021 15:30:11 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20211115153011.06b9f08e@bahia>
In-Reply-To: <YYwiGN7pfdyH9543@redhat.com>
References: <20210510155539.998747-1-groug@kaod.org>
	<YYwiGN7pfdyH9543@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [for-6.1 v3 0/3] virtiofsd: Add support for
	FUSE_SYNCFS request
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Szeredi <miklos@szeredi.hu>, Miklos, Paolo Bonzini <pbonzini@redhat.com>

On Wed, 10 Nov 2021 14:48:40 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> Hi Greg,
> 
> I don't see FUSE_SYNCFS support in virtiofsd. I see that kernel 
> patches got merged. Did you post another version of patches?
> 

Hi Vivek,

Unfortunately no and I'm really not sure I can get time to do
so. Sorry for that... :-\

Please feel free to take over.

Cheers,

--
Greg

> Will be nice to add syncfs support in virtiofsd/virtiofsd_rs as well. 
> 
> Thanks
> Vivek
> 
> On Mon, May 10, 2021 at 05:55:36PM +0200, Greg Kurz wrote:
> > FUSE_SYNCFS allows the client to flush the host page cache.
> > This isn't available in upstream linux yet, but the following
> > tree can be used to test:
> > 
> > https://gitlab.com/gkurz/linux/-/tree/virtio-fs-sync
> > 
> > v3: - track submounts and do per-submount syncfs() (Vivek)
> >     - based on new version of FUSE_SYNCFS (still not upstream)
> >       https://listman.redhat.com/archives/virtio-fs/2021-May/msg00025.html
> > 
> > v2: - based on new version of FUSE_SYNCFS
> >       https://listman.redhat.com/archives/virtio-fs/2021-April/msg00166.html
> >     - propagate syncfs() errors to client (Vivek)
> > 
> > Greg Kurz (3):
> >   Update linux headers to 5.13-rc1 + FUSE_SYNCFS
> >   virtiofsd: Track mounts
> >   virtiofsd: Add support for FUSE_SYNCFS request
> > 
> >  .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.h   |  35 -
> >  include/standard-headers/drm/drm_fourcc.h     |  23 +-
> >  include/standard-headers/linux/ethtool.h      | 109 ++-
> >  include/standard-headers/linux/fuse.h         |  27 +-
> >  include/standard-headers/linux/input.h        |   2 +-
> >  include/standard-headers/linux/virtio_ids.h   |   2 +
> >  .../standard-headers/rdma/vmw_pvrdma-abi.h    |   7 +
> >  linux-headers/asm-generic/unistd.h            |  13 +-
> >  linux-headers/asm-mips/unistd_n32.h           | 752 +++++++--------
> >  linux-headers/asm-mips/unistd_n64.h           | 704 +++++++-------
> >  linux-headers/asm-mips/unistd_o32.h           | 844 ++++++++---------
> >  linux-headers/asm-powerpc/kvm.h               |   2 +
> >  linux-headers/asm-powerpc/unistd_32.h         | 857 +++++++++---------
> >  linux-headers/asm-powerpc/unistd_64.h         | 801 ++++++++--------
> >  linux-headers/asm-s390/unistd_32.h            |   5 +
> >  linux-headers/asm-s390/unistd_64.h            |   5 +
> >  linux-headers/asm-x86/kvm.h                   |   1 +
> >  linux-headers/asm-x86/unistd_32.h             |   5 +
> >  linux-headers/asm-x86/unistd_64.h             |   5 +
> >  linux-headers/asm-x86/unistd_x32.h            |   5 +
> >  linux-headers/linux/kvm.h                     | 134 +++
> >  linux-headers/linux/userfaultfd.h             |  36 +-
> >  linux-headers/linux/vfio.h                    |  35 +
> >  tools/virtiofsd/fuse_lowlevel.c               |  11 +
> >  tools/virtiofsd/fuse_lowlevel.h               |  12 +
> >  tools/virtiofsd/passthrough_ll.c              |  80 +-
> >  tools/virtiofsd/passthrough_seccomp.c         |   1 +
> >  27 files changed, 2465 insertions(+), 2048 deletions(-)
> > 
> > -- 
> > 2.26.3
> > 
> > 
> 

