Date: Mon, 21 Jun 2021 14:51:24 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
Message-ID: <YNCnbIpKeprhPfRO@zeniv-ca.linux.org.uk>
References: <20210621062657.3641879-1-hch@lst.de>
	<20210621062657.3641879-2-hch@lst.de>
	<YNCmTSTcubslmj7k@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
In-Reply-To: <YNCmTSTcubslmj7k@zeniv-ca.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH 1/2] init: split get_fs_names
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On Mon, Jun 21, 2021 at 02:46:37PM +0000, Al Viro wrote:

> int __init get_filesystem_list(char *buf, bool is_dev)
> {
> 	int f = is_dev ? FS_REQUIRES_DEV : 0;
>         int left = PAGE_SIZE, count = 0;
>         struct file_system_type *p;
> 
>         read_lock(&file_systems_lock);
> 	for (p = file_systems; p; p = p->next) {
> 		if ((p->fs_flags & FS_REQUIRES_DEV) == f) {
> 			size_t len = strlen(p->name) + 1;
> 			if (len > left)
> 				break;
> 			memcpy(buf, p->name, len);
> 			buf += len;
> 			left -= len;
> 			count++;
> 		}
> 	}
>         read_unlock(&file_systems_lock);
> 	return count;
> }
> 
> Generates NUL-separated list, returns the number of list elements,
> the second argument is "what kind do you want"...

Actually, looking at the rest of the queue, that's only used for
!nodev ones, so might as well drop the flag here...

