Date: Tue, 27 Jul 2021 14:29:33 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YQBQje2SBNw9hqO0@redhat.com>
References: <20210714202321.59729-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714202321.59729-1-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 0/3] support booting of arbitrary
 non-blockdevice file systems
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: viro@zeniv.linux.org.uk
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, hch@lst.de

On Wed, Jul 14, 2021 at 04:23:18PM -0400, Vivek Goyal wrote:
> Hi,
> 
> This is V3 of patches. Christoph had posted V2 here.

Hi,

Ping?

Vivek

> 
> https://lore.kernel.org/linux-fsdevel/20210621062657.3641879-1-hch@lst.de/
> 
> There was a small issue in last patch series that list_bdev_fs_names()
> did not put an extra '\0' at the end as current callers were expecting.
> 
> To fix this, I have modified list_bdev_fs_names() and split_fs_names()
> to return number of null terminated strings they have parsed. And
> modified callers to use that to loop through strings (instead of
> relying on an extra null at the end).
> 
> Christoph was finding it hard to find time so I took his patches, 
> added my changes in patch3 and reposting the patch series.
> 
> I have tested it with 9p, virtiofs and ext4 filesystems as rootfs
> and it works for me.
> 
> Thanks
> Vivek
> 
> Christoph Hellwig (3):
>   init: split get_fs_names
>   init: allow mounting arbitrary non-blockdevice filesystems as root
>   fs: simplify get_filesystem_list / get_all_fs_names
> 
>  fs/filesystems.c   | 27 ++++++++------
>  include/linux/fs.h |  2 +-
>  init/do_mounts.c   | 90 +++++++++++++++++++++++++++++++++-------------
>  3 files changed, 83 insertions(+), 36 deletions(-)
> 
> -- 
> 2.31.1
> 

