Date: Mon, 21 Jun 2021 14:46:37 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
Message-ID: <YNCmTSTcubslmj7k@zeniv-ca.linux.org.uk>
References: <20210621062657.3641879-1-hch@lst.de>
	<20210621062657.3641879-2-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210621062657.3641879-2-hch@lst.de>
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

On Mon, Jun 21, 2021 at 08:26:56AM +0200, Christoph Hellwig wrote:
> Split get_fs_names into one function that splits up the command line
> argument, and one that gets the list of all registered file systems.

> +static void __init get_all_fs_names(char *page)
> +{
> +	int len = get_filesystem_list(page);
> +	char *s = page, *p, *next;
> +
> +	page[len] = '\0';
> +	for (p = page - 1; p; p = next) {
> +		next = strchr(++p, '\n');
> +		if (*p++ != '\t')
> +			continue;
> +		while ((*s++ = *p++) != '\n')
> +			;
> +		s[-1] = '\0';
>  	}
> +
>  	*s = '\0';
>  }

TBH, I would rather take that one into fs/filesystems.c.  Rationale:
get_filesystem_list(), for all its resemblance to /proc/filesystems
contents, is used only by init/*.c and it's not a big deal to make
it

int __init get_filesystem_list(char *buf, bool is_dev)
{
	int f = is_dev ? FS_REQUIRES_DEV : 0;
        int left = PAGE_SIZE, count = 0;
        struct file_system_type *p;

        read_lock(&file_systems_lock);
	for (p = file_systems; p; p = p->next) {
		if ((p->fs_flags & FS_REQUIRES_DEV) == f) {
			size_t len = strlen(p->name) + 1;
			if (len > left)
				break;
			memcpy(buf, p->name, len);
			buf += len;
			left -= len;
			count++;
		}
	}
        read_unlock(&file_systems_lock);
	return count;
}

Generates NUL-separated list, returns the number of list elements,
the second argument is "what kind do you want"...

