Date: Tue, 29 Jun 2021 16:50:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210629205048.GE5231@redhat.com>
References: <20210621062657.3641879-1-hch@lst.de>
	<20210622081217.GA2975@lst.de>
	<YNGhERcnLuzjn8j9@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNGhERcnLuzjn8j9@stefanha-x1.localdomain>
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk

On Tue, Jun 22, 2021 at 09:36:33AM +0100, Stefan Hajnoczi wrote:
> On Tue, Jun 22, 2021 at 10:12:17AM +0200, Christoph Hellwig wrote:
> > Just output the '\0' separate list of supported file systems for block
> > devices directly rather than going through a pointless round of string
> > manipulation.
> > 
> > Based on an earlier patch from Al Viro <viro@zeniv.linux.org.uk>.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/filesystems.c   | 24 ++++++++++++++----------
> >  include/linux/fs.h |  2 +-
> >  init/do_mounts.c   | 20 +-------------------
> >  3 files changed, 16 insertions(+), 30 deletions(-)
> > 
> > diff --git a/fs/filesystems.c b/fs/filesystems.c
> > index 90b8d879fbaf..7c136251607a 100644
> > --- a/fs/filesystems.c
> > +++ b/fs/filesystems.c
> > @@ -209,21 +209,25 @@ SYSCALL_DEFINE3(sysfs, int, option, unsigned long, arg1, unsigned long, arg2)
> >  }
> >  #endif
> >  
> > -int __init get_filesystem_list(char *buf)
> > +void __init list_bdev_fs_names(char *buf, size_t size)
> >  {
> > -	int len = 0;
> > -	struct file_system_type * tmp;
> > +	struct file_system_type *p;
> > +	size_t len;
> >  
> >  	read_lock(&file_systems_lock);
> > -	tmp = file_systems;
> > -	while (tmp && len < PAGE_SIZE - 80) {
> > -		len += sprintf(buf+len, "%s\t%s\n",
> > -			(tmp->fs_flags & FS_REQUIRES_DEV) ? "" : "nodev",
> > -			tmp->name);
> > -		tmp = tmp->next;
> > +	for (p = file_systems; p; p = p->next) {
> > +		if (!(p->fs_flags & FS_REQUIRES_DEV))
> > +			continue;
> > +		len = strlen(p->name) + 1;
> > +		if (len > size) {
> > +			pr_warn("%s: truncating file system list\n", __func__);
> > +			break;
> > +		}
> > +		memcpy(buf, p->name, len);
> > +		buf += len;
> > +		size -= len;
> >  	}
> >  	read_unlock(&file_systems_lock);
> > -	return len;
> >  }
> 
> I don't see the extra NUL terminator byte being added that's required by
> the loop in mount_block_root()?

May be we should modify mount_block_root() code so that it does not
require that extra "\0". Possibly zero initialize page and that should
make sure list_bdev_fs_names() does not have to worry about it.

It is possible that a page gets full from the list of filesystems, and
last byte on page is terminating null. In that case just zeroing page
will not help. We can keep track of some sort of end pointer and make
sure we are not searching beyond that for valid filesystem types.

end = page + PAGE_SIZE - 1;

mount_block_root()
{
	for (p = fs_names; p < end && *p; p += strlen(p)+1) {
	}
}

Thanks
Vivek

