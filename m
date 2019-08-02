DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=intel-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=NwrICNfG+GCVC2f/Yrdzm2/WYF4KoqGDjXcdvaB1OtA=;
	b=B8yMMyk/3D2IW436VNHGsU7Cvj/2avp+aArFfUAMzCAYlyYeXqAi5B5EsDX04+vpKU
	EWMo0kTqkDZaPX20uvAW8/WCWDDlDl9lQkmb1tV/T3Ghf52lYWNGIFzhsOh49114ekUj
	1Tyrl+DrneBuVh2cpBRQfCLwZyOMy5rpH/5OhsyQAT40rLdrmvlyRaUUi8tjiTIXAtBY
	uHo97VuhitN/8yUM4bESCiTEqJv8UVSCTaHWE0D0otWhoIVkiyJ5KtxGzACfN4rq7CM3
	neH0i8AvQdA8em4dDsL/lro4wDa/g0FawQrGeDSWAaPAQA2Infbdgtocs1Jl5zck3ZSR
	qCzw==
MIME-Version: 1.0
References: <20190802192956.GA3032@redhat.com>
In-Reply-To: <20190802192956.GA3032@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 2 Aug 2019 12:37:59 -0700
Message-ID: <CAPcyv4jxknEGq9FzGpsMJ6E7jC51d1W9KbNg4HX6Cj6vqt7dqg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] dax: dax_layout_busy_page() should not
	unmap cow pages
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtio-fs@redhat.com, linux-nvdimm <linux-nvdimm@lists.01.org>

On Fri, Aug 2, 2019 at 12:30 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> As of now dax_layout_busy_page() calls unmap_mapping_range() with last
> argument as 1, which says even unmap cow pages. I am wondering who needs
> to get rid of cow pages as well.
>
> I noticed one interesting side affect of this. I mount xfs with -o dax and
> mmaped a file with MAP_PRIVATE and wrote some data to a page which created
> cow page. Then I called fallocate() on that file to zero a page of file.
> fallocate() called dax_layout_busy_page() which unmapped cow pages as well
> and then I tried to read back the data I wrote and what I get is old
> data from persistent memory. I lost the data I had written. This
> read basically resulted in new fault and read back the data from
> persistent memory.
>
> This sounds wrong. Are there any users which need to unmap cow pages
> as well? If not, I am proposing changing it to not unmap cow pages.
>
> I noticed this while while writing virtio_fs code where when I tried
> to reclaim a memory range and that corrupted the executable and I
> was running from virtio-fs and program got segment violation.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/dax.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: rhvgoyal-linux/fs/dax.c
> ===================================================================
> --- rhvgoyal-linux.orig/fs/dax.c        2019-08-01 17:03:10.574675652 -0400
> +++ rhvgoyal-linux/fs/dax.c     2019-08-02 14:32:28.809639116 -0400
> @@ -600,7 +600,7 @@ struct page *dax_layout_busy_page(struct
>          * guaranteed to either see new references or prevent new
>          * references from being established.
>          */
> -       unmap_mapping_range(mapping, 0, 0, 1);
> +       unmap_mapping_range(mapping, 0, 0, 0);

Good find, yes, this looks correct to me and should also go to -stable.

