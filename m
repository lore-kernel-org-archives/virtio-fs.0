Date: Tue, 2 Jul 2019 13:43:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190702174358.GA30547@redhat.com>
References: <20190702055937.3ffpwph7anvohmxu@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702055937.3ffpwph7anvohmxu@US-160370MP2.local>
Subject: Re: [Virtio-fs] data integrity in dax mode
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

On Mon, Jul 01, 2019 at 10:59:38PM -0700, Liu Bo wrote:
> Hi,
> 
> I have a concern about data integrity in dax mode.
> 
> For now virtio_fs_copy_from_iter() (i.e. the write direction) only
> does copy_from_iter(), which doesn't enforce a clean_cache_range or
> CLWB.

This is an interesting question and I had been wondring about it when
I wrote the code.

I could not justify the need of calling "clwb". Whatever we write will
be in host page cache (assuming dir is not pmem backed). And when app
in guest does fsync/msync, only then there are any guarantees that
data is persistent.

IOW, we are not offering pmem programming interface where msync can 
be avoided by applications. Apps still need to call in fsync/msync
to ensure that data has been saved to persistent storage. And if
that happens, I am not sure why clwb needs to be called.

> And even worse, virtio-fs doesn't have a dax_writepages like,
> which can calls dax_writeback_mapping_range().
> 
> Correct me if I'm wrong, but did virtio-fs solve it in some way?

We define address space operations for dax.

static const struct address_space_operations fuse_dax_file_aops  = {
        .writepages     = fuse_dax_writepages,
        .direct_IO      = noop_direct_IO,
        .set_page_dirty = noop_set_page_dirty,
        .invalidatepage = noop_invalidatepage,
};

And fuse_dax_writepages() will call dax_writeback_mapping_range().

Thanks
Vivek

