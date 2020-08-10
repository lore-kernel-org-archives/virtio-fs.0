Date: Tue, 11 Aug 2020 08:06:55 +1000
From: Dave Chinner <david@fromorbit.com>
Message-ID: <20200810220655.GC2079@dread.disaster.area>
References: <20200807195526.426056-1-vgoyal@redhat.com>
	<20200807195526.426056-14-vgoyal@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200807195526.426056-14-vgoyal@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v2 13/20] fuse,
	dax: Implement dax read/write operations
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On Fri, Aug 07, 2020 at 03:55:19PM -0400, Vivek Goyal wrote:
> This patch implements basic DAX support. mmap() is not implemented
> yet and will come in later patches. This patch looks into implemeting
> read/write.

....

> +static int iomap_begin_setup_new_mapping(struct inode *inode, loff_t pos,
> +					 loff_t length, unsigned flags,
> +					 struct iomap *iomap)

please doin't use the iomap_* namespace even for static functions in
filesystem code. This really doesn't have anything to do with iomap
except that whatever fuse sets up is used to fill an iomap.
i.e. fuse_setup_new_dax_mapping() would be far more appropriate
name.

> +static int iomap_begin_upgrade_mapping(struct inode *inode, loff_t pos,
> +					 loff_t length, unsigned flags,
> +					 struct iomap *iomap)

ditto: fuse_upgrade_dax_mapping().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

