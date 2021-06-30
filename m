Date: Wed, 30 Jun 2021 07:36:01 +0200
From: Christoph Hellwig <hch@lst.de>
Message-ID: <20210630053601.GA29241@lst.de>
References: <20210621062657.3641879-1-hch@lst.de>
	<20210622081217.GA2975@lst.de>
	<YNGhERcnLuzjn8j9@stefanha-x1.localdomain>
	<20210629205048.GE5231@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210629205048.GE5231@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH 3/2] fs: simplify get_filesystem_list /
 get_all_fs_names
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Tue, Jun 29, 2021 at 04:50:48PM -0400, Vivek Goyal wrote:
> May be we should modify mount_block_root() code so that it does not
> require that extra "\0". Possibly zero initialize page and that should
> make sure list_bdev_fs_names() does not have to worry about it.
> 
> It is possible that a page gets full from the list of filesystems, and
> last byte on page is terminating null. In that case just zeroing page
> will not help. We can keep track of some sort of end pointer and make
> sure we are not searching beyond that for valid filesystem types.
> 
> end = page + PAGE_SIZE - 1;
> 
> mount_block_root()
> {
> 	for (p = fs_names; p < end && *p; p += strlen(p)+1) {
> 	}
> }

Maybe.  To honest I'd prefer to not even touch this unrelated code given
how full of landmines it is :)

