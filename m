DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209;
	h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N1CS+JREmKmZmsb3/+Y0E8O1tSvBvWwvhYqw5K1frW8=;
	b=fyFSwHnVtojOmyAIldsnUxbp2c
	fStqfRoBxbicVf6TyYYq5KR7CSJtoZlTTGuM55J44givMzR8eZ6GmAM9wLvG2YRqzc1esFeeuM/5N
	5kzj7tysOOMdsK3iixuRAjwN3UEKRmXeyAf8ljNskHktrDG6f90ueV6ojBicMYS/cR6CwKGV8d2DY
	ELU56FceROBeH1ibYgIa1NJvmGI9rkEEOTOd5onPHysUEFA/3xQKzSPzTIuVhmTeFUYcYGLJJqleY
	hcipJwnP68IeYZLj2WZoRCgao/jEx6d8B8QCOvvqpYtNU2mw90m0fXkoUuVTGsXCocKhCH1tk/ztB
	TnIlW3tA==
Date: Mon, 26 Apr 2021 14:46:32 +0100
From: Matthew Wilcox <willy@infradead.org>
Message-ID: <20210426134632.GM235567@casper.infradead.org>
References: <20210423130723.1673919-1-vgoyal@redhat.com>
	<20210423130723.1673919-2-vgoyal@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210423130723.1673919-2-vgoyal@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v4 1/3] dax: Add an enum for specifying dax
	wakup mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jack@suse.cz, miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com

On Fri, Apr 23, 2021 at 09:07:21AM -0400, Vivek Goyal wrote:
> +enum dax_wake_mode {
> +	WAKE_NEXT,
> +	WAKE_ALL,
> +};

Why define them in this order when ...

> @@ -196,7 +207,7 @@ static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
>  	 * must be in the waitqueue and the following check will see them.
>  	 */
>  	if (waitqueue_active(wq))
> -		__wake_up(wq, TASK_NORMAL, wake_all ? 0 : 1, &key);
> +		__wake_up(wq, TASK_NORMAL, mode == WAKE_ALL ? 0 : 1, &key);

... they're used like this?  This is almost as bad as

enum bool {
	true,
	false,
};

