DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209;
	h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=D8ph6pAIQDI8O5xX0/bF6rOuV3U8EpQmauqRDOmPVTw=;
	b=qawH6s/nu6gNZqpAj9pyqEDODz
	MQb09/vjLbdWiYpA8JVaY4k0zUar9DsoQrWhb4JKAzFeSFiL8GJvX006u8PF9KYUqLByb4Ue/thtk
	oHUI/3Nk7hR8YH6VY3dXwfhMF49O4GjrUZqiR2UqDLioeOmdpRDR5+HYGq7r0b4NYsZJmUSQB58pZ
	9yf4A3b8qVaku3GgAnm/HjM5eG8r0S/i5Fd4NtCo1kK+A0m4vcAiTx0LwElKu4AJoz2VA/d7Qug2d
	C/hQvAxLJwYFquqABYvrY4OBojOVzOzSv3epUm71kfq9jL4BbZdSsIpMvmfIWhangFScMsVdBsb7Y
	2F22fS4g==
Date: Mon, 21 Jun 2021 16:09:16 +0100
From: Matthew Wilcox <willy@infradead.org>
Message-ID: <YNCrnCvtlOuZO9jV@casper.infradead.org>
References: <20210621062657.3641879-1-hch@lst.de>
	<20210621062657.3641879-2-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210621062657.3641879-2-hch@lst.de>
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
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org

On Mon, Jun 21, 2021 at 08:26:56AM +0200, Christoph Hellwig wrote:
> -static void __init get_fs_names(char *page)
> +static void __init split_fs_names(char *page, char *names)

If you're going to respin it anyway, can you rename 'page' to 'buf'
or something?  Kind of confusing to have a char * called 'page'.

>  {
> +	strcpy(page, root_fs_names);
> +	while (*page++) {
> +		if (page[-1] == ',')
> +			page[-1] = '\0';
> +	}
> +	*page = '\0';
> +}

is it really worth doing a strcpy() followed by a custom strtok()?
would this work better?

	char c;

	do {
		c =  *root_fs_names++;
		*buf++ = c;
		if (c == ',')
			buf[-1] = '\0';
	} while (c);

> +static void __init get_all_fs_names(char *page)
> +{
> +	int len = get_filesystem_list(page);

it occurs to me that get_filesystem_list() fails silently.  if you build
every linux filesystem in, and want your root on zonefs (assuming
they're alphabetical), we'll fail to find it without a message
indicating that we overflowed the buffer.

