Date: Wed, 5 Jun 2019 16:30:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190605203016.GC22236@redhat.com>
References: <20190605030233.19567-1-tao.peng@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605030233.19567-1-tao.peng@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH-v3 0/1] virtiofs: FUSE_REMOVEMAPPING remove
 multiple entries in one call
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Peng Tao <tao.peng@linux.alibaba.com>
Cc: virtio-fs@redhat.com

Hi Peng Tao,

I have squashed this patch and forget request wait patches into existing
pathces and pushed latest patches here.

https://github.com/rhvgoyal/linux/commits/virtio-fs-dev-5.1

Please give it a try.

I have made more function name changes into existing patches. There were
so many functions with name fuse_dax_free* that I was finding it hard
to remember which function is doing what.

Thanks
Vivek

On Wed, Jun 05, 2019 at 11:02:32AM +0800, Peng Tao wrote:
> Hi Vivek,
> 
> This works with corresponding qemu virtiofsd patch:
> "[PATCH-v3] virtiofsd: make FUSE_REMOVEMAPPING support multiple entries".
> 
> v1-v2: make fuse_removemapping_in count fuse_removemapping_one
> v2->v3:
> 1. fold in Vivek's cleanup and rename all forget_one to remove_one
> 2. assert dmap->list is not used by anyone when adding to temporary list
> 3. list_del() dmap->list when removing it from to_remove list
> 
> Please add your SOB line as I don't see it with your cleanup and thus
> did not add it to the patch when folding your change.
> 
> Thanks,
> Tao
> 
> Peng Tao (1):
>   virtiofs: FUSE_REMOVEMAPPING remove multiple entries in one call
> 
>  fs/fuse/file.c            | 205 +++++++++++++++++++++++++++-----------
>  fs/fuse/fuse_i.h          |   6 +-
>  fs/fuse/inode.c           |   2 +-
>  include/uapi/linux/fuse.h |   7 ++
>  4 files changed, 160 insertions(+), 60 deletions(-)
> 
> -- 
> 2.17.1
> 

