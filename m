Date: Wed, 24 Apr 2019 14:41:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190424184130.GC8962@redhat.com>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH 0/9] virtio-fs fixes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com

Hi Liubo,

I have made some fixes and took some of yours and pushed latest snapshot
of my internal tree here.

https://github.com/rhvgoyal/linux/commits/virtio-fs-dev-5.1

Patches have been rebased to 5.1-rc5 kernel. I am thinking of updating
this branch frequently with latest code.

Vivek

On Wed, Apr 17, 2019 at 02:03:13AM +0800, Liu Bo wrote:

> Hi,
> 
> This set contains a few fixes collected by running xfstests.
> 
> thanks,
> liubo
> 
> Liu Bo (6):
>   virtio-fs: fix multiple tag support
>   virtio-fs: clean up dax mapping before aborting connection
>   fuse: export fuse_drop_waiting()
>   virtio-fs: let dax style override directIO style when dax+cache=none
>   fuse: return early if punch_hole fails
>   virtio-fs: honor RLIMIT_FSIZE in fuse_file_fallocate
> 
> Xiaoguang Wang (3):
>   virtio-fs: fix use-after-free against virtio_fs_vq's fuse_dev info
>   fuse: do not write whole page while page straddles i_size
>   fuse: fix deadlock in __fuse_file_fallocate()
> 
>  fs/fuse/dev.c       |  3 ++-
>  fs/fuse/file.c      | 31 +++++++++++++++++++++++--------
>  fs/fuse/fuse_i.h    |  3 +++
>  fs/fuse/inode.c     |  9 +++++++++
>  fs/fuse/virtio_fs.c | 13 +++++++++++--
>  5 files changed, 48 insertions(+), 11 deletions(-)
> 
> -- 
> 1.8.3.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

