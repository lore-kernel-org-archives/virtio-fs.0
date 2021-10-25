Date: Mon, 25 Oct 2021 19:00:20 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YXbwtHt6xo7I+Jlc@work-vm>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210930153037.1194279-1-vgoyal@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 00/13] virtiofsd: Support notification queue
	and
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, qemu-devel@nongnu.org, virtio-fs@redhat.com

* Vivek Goyal (vgoyal@redhat.com) wrote:
> Hi,
> 
> Here are the patches to support notification queue and blocking
> posix locks. One of the biggest change since las time has been
> creation of custom thread pool for handling locking requests. 
> Thanks to Ioannis for doing most of the work on custom thread
> pool.
> 
> I have posted corresponding kernel changes here.
> 
> https://lore.kernel.org/linux-fsdevel/20210930143850.1188628-1-vgoyal@redhat.com/T/#mb2d0fbfdb580ef33b6e812d0acbd16333b11f2cf

I'm queuing:
[PATCH 03/13] virtiofsd: Remove unused virtio_fs_config definition
[PATCH 04/13] virtiofsd: Add a helper to send element on virtqueue
[PATCH 05/13] virtiofsd: Add a helper to stop all queues

from this series; they're separate cleanups.

Dave

> Any feedback is welcome.
> 
> Thanks
> Vivek
> 
> Vivek Goyal (13):
>   virtio_fs.h: Add notification queue feature bit
>   virtiofsd: fuse.h header file changes for lock notification
>   virtiofsd: Remove unused virtio_fs_config definition
>   virtiofsd: Add a helper to send element on virtqueue
>   virtiofsd: Add a helper to stop all queues
>   vhost-user-fs: Use helpers to create/cleanup virtqueue
>   virtiofsd: Release file locks using F_UNLCK
>   virtiofsd: Create a notification queue
>   virtiofsd: Specify size of notification buffer using config space
>   virtiofsd: Custom threadpool for remote blocking posix locks requests
>   virtiofsd: Shutdown notification queue in the end
>   virtiofsd: Implement blocking posix locks
>   virtiofsd, seccomp: Add clock_nanosleep() to allow list
> 
>  hw/virtio/vhost-user-fs-pci.c              |   4 +-
>  hw/virtio/vhost-user-fs.c                  | 158 ++++++++--
>  include/hw/virtio/vhost-user-fs.h          |   4 +
>  include/standard-headers/linux/fuse.h      |  11 +-
>  include/standard-headers/linux/virtio_fs.h |   5 +
>  tools/virtiofsd/fuse_i.h                   |   1 +
>  tools/virtiofsd/fuse_lowlevel.c            |  37 ++-
>  tools/virtiofsd/fuse_lowlevel.h            |  26 ++
>  tools/virtiofsd/fuse_virtio.c              | 339 +++++++++++++++++----
>  tools/virtiofsd/meson.build                |   1 +
>  tools/virtiofsd/passthrough_ll.c           |  91 +++++-
>  tools/virtiofsd/passthrough_seccomp.c      |   2 +
>  tools/virtiofsd/tpool.c                    | 331 ++++++++++++++++++++
>  tools/virtiofsd/tpool.h                    |  18 ++
>  14 files changed, 915 insertions(+), 113 deletions(-)
>  create mode 100644 tools/virtiofsd/tpool.c
>  create mode 100644 tools/virtiofsd/tpool.h
> 
> -- 
> 2.31.1
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


