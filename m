Date: Mon, 10 May 2021 17:58:35 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210510175835.3ee2d4cf@bahia.lan>
In-Reply-To: <20210510155539.998747-1-groug@kaod.org>
References: <20210510155539.998747-1-groug@kaod.org>
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
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, "Michael S.
	Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, virtio-fs@redhat.com, Szeredi <miklos@szeredi.hu>, Miklos, Paolo Bonzini <pbonzini@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

Of course, I forgot to drop the for-6.1 prefix in git publish...

On Mon, 10 May 2021 17:55:36 +0200
Greg Kurz <groug@kaod.org> wrote:

> FUSE_SYNCFS allows the client to flush the host page cache.
> This isn't available in upstream linux yet, but the following
> tree can be used to test:
> 
> https://gitlab.com/gkurz/linux/-/tree/virtio-fs-sync
> 
> v3: - track submounts and do per-submount syncfs() (Vivek)
>     - based on new version of FUSE_SYNCFS (still not upstream)
>       https://listman.redhat.com/archives/virtio-fs/2021-May/msg00025.html
> 
> v2: - based on new version of FUSE_SYNCFS
>       https://listman.redhat.com/archives/virtio-fs/2021-April/msg00166.html
>     - propagate syncfs() errors to client (Vivek)
> 
> Greg Kurz (3):
>   Update linux headers to 5.13-rc1 + FUSE_SYNCFS
>   virtiofsd: Track mounts
>   virtiofsd: Add support for FUSE_SYNCFS request
> 
>  .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.h   |  35 -
>  include/standard-headers/drm/drm_fourcc.h     |  23 +-
>  include/standard-headers/linux/ethtool.h      | 109 ++-
>  include/standard-headers/linux/fuse.h         |  27 +-
>  include/standard-headers/linux/input.h        |   2 +-
>  include/standard-headers/linux/virtio_ids.h   |   2 +
>  .../standard-headers/rdma/vmw_pvrdma-abi.h    |   7 +
>  linux-headers/asm-generic/unistd.h            |  13 +-
>  linux-headers/asm-mips/unistd_n32.h           | 752 +++++++--------
>  linux-headers/asm-mips/unistd_n64.h           | 704 +++++++-------
>  linux-headers/asm-mips/unistd_o32.h           | 844 ++++++++---------
>  linux-headers/asm-powerpc/kvm.h               |   2 +
>  linux-headers/asm-powerpc/unistd_32.h         | 857 +++++++++---------
>  linux-headers/asm-powerpc/unistd_64.h         | 801 ++++++++--------
>  linux-headers/asm-s390/unistd_32.h            |   5 +
>  linux-headers/asm-s390/unistd_64.h            |   5 +
>  linux-headers/asm-x86/kvm.h                   |   1 +
>  linux-headers/asm-x86/unistd_32.h             |   5 +
>  linux-headers/asm-x86/unistd_64.h             |   5 +
>  linux-headers/asm-x86/unistd_x32.h            |   5 +
>  linux-headers/linux/kvm.h                     | 134 +++
>  linux-headers/linux/userfaultfd.h             |  36 +-
>  linux-headers/linux/vfio.h                    |  35 +
>  tools/virtiofsd/fuse_lowlevel.c               |  11 +
>  tools/virtiofsd/fuse_lowlevel.h               |  12 +
>  tools/virtiofsd/passthrough_ll.c              |  80 +-
>  tools/virtiofsd/passthrough_seccomp.c         |   1 +
>  27 files changed, 2465 insertions(+), 2048 deletions(-)
> 

