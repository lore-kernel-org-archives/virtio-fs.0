Date: Tue, 27 Apr 2021 14:50:08 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210427145008.5d6914e9@bahia.lan>
In-Reply-To: <YIf1TY4MbAQnCYG0@work-vm>
References: <20210426152135.842037-1-groug@kaod.org> <YIf1TY4MbAQnCYG0@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [for-6.1 v2 0/2] virtiofsd: Add support for
	FUSE_SYNCFS request
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: kvm@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Tue, 27 Apr 2021 12:28:13 +0100
"Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:

> * Greg Kurz (groug@kaod.org) wrote:
> > FUSE_SYNCFS allows the client to flush the host page cache.
> > This isn't available in upstream linux yet, but the following
> > tree can be used to test:
> 
> That looks OK to me; but we'll need to wait until syncfs lands in the
> upstream kernel; we've got bitten before by stuff changing before it
> actaully lands in the kernel.
> 

Sure ! I'll repost an updated series when this happens.

Thanks for the feedback.

--
Greg

> Dave
> 
> > https://gitlab.com/gkurz/linux/-/tree/virtio-fs-sync
> > 
> > v2: - based on new version of FUSE_SYNCFS
> >       https://listman.redhat.com/archives/virtio-fs/2021-April/msg00166.html
> >     - propagate syncfs() errors to client (Vivek)
> > 
> > Greg Kurz (2):
> >   Update linux headers to 5.12-rc8 + FUSE_SYNCFS
> >   virtiofsd: Add support for FUSE_SYNCFS request
> > 
> >  include/standard-headers/drm/drm_fourcc.h     | 23 ++++-
> >  include/standard-headers/linux/ethtool.h      | 54 ++++++-----
> >  include/standard-headers/linux/fuse.h         | 13 ++-
> >  include/standard-headers/linux/input.h        |  2 +-
> >  .../standard-headers/rdma/vmw_pvrdma-abi.h    |  7 ++
> >  linux-headers/asm-generic/unistd.h            |  4 +-
> >  linux-headers/asm-mips/unistd_n32.h           |  1 +
> >  linux-headers/asm-mips/unistd_n64.h           |  1 +
> >  linux-headers/asm-mips/unistd_o32.h           |  1 +
> >  linux-headers/asm-powerpc/kvm.h               |  2 +
> >  linux-headers/asm-powerpc/unistd_32.h         |  1 +
> >  linux-headers/asm-powerpc/unistd_64.h         |  1 +
> >  linux-headers/asm-s390/unistd_32.h            |  1 +
> >  linux-headers/asm-s390/unistd_64.h            |  1 +
> >  linux-headers/asm-x86/kvm.h                   |  1 +
> >  linux-headers/asm-x86/unistd_32.h             |  1 +
> >  linux-headers/asm-x86/unistd_64.h             |  1 +
> >  linux-headers/asm-x86/unistd_x32.h            |  1 +
> >  linux-headers/linux/kvm.h                     | 89 +++++++++++++++++++
> >  linux-headers/linux/vfio.h                    | 27 ++++++
> >  tools/virtiofsd/fuse_lowlevel.c               | 19 ++++
> >  tools/virtiofsd/fuse_lowlevel.h               | 13 +++
> >  tools/virtiofsd/passthrough_ll.c              | 29 ++++++
> >  tools/virtiofsd/passthrough_seccomp.c         |  1 +
> >  24 files changed, 267 insertions(+), 27 deletions(-)
> > 
> > -- 
> > 2.26.3
> > 

