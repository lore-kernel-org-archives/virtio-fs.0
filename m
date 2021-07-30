Date: Fri, 30 Jul 2021 00:57:07 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
Message-ID: <YQNOY9H/6mJMWRNN@zeniv-ca.linux.org.uk>
References: <20210714202321.59729-1-vgoyal@redhat.com>
	<20210714202321.59729-4-vgoyal@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210714202321.59729-4-vgoyal@redhat.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v3 3/3] fs: simplify get_filesystem_list /
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
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, hch@lst.de

On Wed, Jul 14, 2021 at 04:23:21PM -0400, Vivek Goyal wrote:

> +static int __init split_fs_names(char *page, char *names)
>  {
> +	int count = 0;
> +	char *p = page;
>  
> +	strcpy(p, root_fs_names);
> +	while (*p++) {
> +		if (p[-1] == ',')
> +			p[-1] = '\0';
>  	}
> +	*p = '\0';
> +
> +	for (p = page; *p; p += strlen(p)+1)
> +		count++;
>  
> +	return count;
>  }

Ummm....  The last part makes no sense - it counts '\0' in the array
pointed to be page, until the first double '\0' in there.  All of
which had been put there by the loop immediately prior to that one...

Incidentally, it treats stray ,, in root_fs_names as termination;
is that intentional?

