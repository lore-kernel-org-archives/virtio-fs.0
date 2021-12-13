Date: Mon, 13 Dec 2021 13:12:38 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YbeNFkzynMUHRnoS@redhat.com>
References: <20211125070530.79602-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125070530.79602-1-jefflexu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH v8 0/7] fuse,virtiofs: support per-file DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, joseph.qi@linux.alibaba.com, miklos@szeredi.hu

On Thu, Nov 25, 2021 at 03:05:23PM +0800, Jeffle Xu wrote:
> changes since v7:
> - rebase to v5.16
> - patch 2: rename FUSE_DAX_NONE|FUSE_DAX_INODE to
>   FUSE_DAX_INODE_DEFAULT|FUSE_DAX_INODE_USER
> - patch 5: remove redundant call for fuse_is_inode_dax_mode() in
>   process_init_reply()
> - patch 5: if server's map alignment is non-compliant (fail
>   fuse_dax_check_alignment()), the mounted fs won't work and users are
>   required to remount it explicitly, instead of silently falling back to
>   'never' mode.

Thanks Jeffle for this work. These patches look good to me. I have done
a basic testing with it and it seems to work as expected. Hence I have
provided my Reviewed-by tags for all the patches. 

Now it is up to the Miklos to decide whether he likes the patches or not.

Thanks
Vivek
> 
> Corresponding changes to virtiofsd:
> https://www.mail-archive.com/virtio-fs@redhat.com/msg04349.html
> 
> v7: https://lore.kernel.org/all/c41837f0-a183-d911-885d-cf3bcdd9b7c8@linux.alibaba.com/T/
> v6: https://lore.kernel.org/all/20211011030052.98923-1-jefflexu@linux.alibaba.com/
> v5: https://lore.kernel.org/all/20210923092526.72341-1-jefflexu@linux.alibaba.com/
> v4: https://lore.kernel.org/linux-fsdevel/20210817022220.17574-1-jefflexu@linux.alibaba.com/
> v3: https://www.spinics.net/lists/linux-fsdevel/msg200852.html
> v2: https://www.spinics.net/lists/linux-fsdevel/msg199584.html
> v1: https://www.spinics.net/lists/linux-virtualization/msg51008.html
> 
> Original Rationale for this Patchset
> ====================================
> 
> This patchset adds support of per-file DAX for virtiofs, which is
> inspired by Ira Weiny's work on ext4[1] and xfs[2].
> 
> Any comment is welcome.
> 
> [1] commit 9cb20f94afcd ("fs/ext4: Make DAX mount option a tri-state")
> [2] commit 02beb2686ff9 ("fs/xfs: Make DAX mount option a tri-state")
> 
> [Purpose]
> DAX may be limited in some specific situation. When the number of usable
> DAX windows is under watermark, the recalim routine will be triggered to
> reclaim some DAX windows. It may have a negative impact on the
> performance, since some processes may need to wait for DAX windows to be
> recalimed and reused then. To mitigate the performance degradation, the
> overall DAX window need to be expanded larger.
> 
> However, simply expanding the DAX window may not be a good deal in some
> scenario. To maintain one DAX window chunk (i.e., 2MB in size), 32KB
> (512 * 64 bytes) memory footprint will be consumed for page descriptors
> inside guest, which is greater than the memory footprint if it uses
> guest page cache when DAX disabled. Thus it'd better disable DAX for
> those files smaller than 32KB, to reduce the demand for DAX window and
> thus avoid the unworthy memory overhead.
> 
> Per-file DAX feature is introduced to address this issue, by offering a
> finer grained control for dax to users, trying to achieve a balance
> between performance and memory overhead.
> 
> 
> [Note]
> When the per-file DAX hint changes while the file is still *opened*, it
> is quite complicated and maybe fragile to dynamically change the DAX
> state, since dynamic switching needs to switch a_ops atomiclly. Ira
> Weiny had ever implemented a so called i_aops_sem lock [3] but
> eventually gave up since the complexity of the implementation
> [4][5][6][7].
> 
> Hence mark the inode and corresponding dentries as DONE_CACHE once the
> per-file DAX hint changes, so that the inode instance will be evicted
> and freed as soon as possible once the file is closed and the last
> reference to the inode is put. And then when the file gets reopened next
> time, the new instantiated inode will reflect the new DAX state.
> 
> In summary, when the per-file DAX hint changes for an *opened* file, the
> DAX state of the file won't be updated until this file is closed and
> reopened later. This is also how ext4/xfs per-file DAX works.
> 
> [3] https://lore.kernel.org/lkml/20200227052442.22524-7-ira.weiny@intel.com/
> [4] https://patchwork.kernel.org/project/xfs/cover/20200407182958.568475-1-ira.weiny@intel.com/
> [5] https://lore.kernel.org/lkml/20200305155144.GA5598@lst.de/
> [6] https://lore.kernel.org/lkml/20200401040021.GC56958@magnolia/
> [7] https://lore.kernel.org/lkml/20200403182904.GP80283@magnolia/
> 
> 
> Jeffle Xu (7):
>   fuse: add fuse_should_enable_dax() helper
>   fuse: make DAX mount option a tri-state
>   fuse: support per inode DAX in fuse protocol
>   fuse: enable per inode DAX
>   fuse: negotiate per inode DAX in FUSE_INIT
>   fuse: mark inode DONT_CACHE when per inode DAX hint changes
>   Documentation/filesystem/dax: DAX on virtiofs
> 
>  Documentation/filesystems/dax.rst | 20 +++++++++++++++--
>  fs/fuse/dax.c                     | 36 +++++++++++++++++++++++++++++--
>  fs/fuse/file.c                    |  4 ++--
>  fs/fuse/fuse_i.h                  | 28 ++++++++++++++++++++----
>  fs/fuse/inode.c                   | 28 +++++++++++++++++-------
>  fs/fuse/virtio_fs.c               | 18 +++++++++++++---
>  include/uapi/linux/fuse.h         |  5 +++++
>  7 files changed, 118 insertions(+), 21 deletions(-)
> 
> -- 
> 2.27.0
> 

