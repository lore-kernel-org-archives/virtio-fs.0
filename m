DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=intel-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=8jfW1W8ZPOpcKWgvKCt6rdwp9cvHKeFm7M8ZtVMfoqE=;
	b=uUTSYWl8nz82vjdvvs/xw9mCFGyNA1/jWIoEbWuoMKlH3HcUmcrmAqAMT/hIMBHdeM
	Fuby+QAs66gLq4zerv1qQgWzxoVD8/r0SSdFiVPRB1KIlrgk+Ia/w09w2yIVb5UjPUKe
	aPbAUa8sDKqS+Z4oOye+qJxT2xWQdMreVtrK0E0UvXvfqOeelWZW8PJqgrqw9dRkK6uk
	n02sLzh2qbjLYtP6eE1hXlSk3R0Qtd222mErsWQ1QRt3DyYfq3l8wWs0f8OFXi4RxUqR
	Miqm3MNSWzoZ2hZI/iAGOnFy0qTR/HSd977eHvvgAqYPyJXhnZLiJOZszpwfj8/ebisx
	Q1SA==
MIME-Version: 1.0
References: <20190821175720.25901-1-vgoyal@redhat.com>
	<20190821175720.25901-3-vgoyal@redhat.com>
	<20190826115316.GB21051@infradead.org>
	<20190826203326.GB13860@redhat.com>
	<20190826205829.GC13860@redhat.com> <20200103141235.GA13350@redhat.com>
	<CAPcyv4hr-KXUAT_tVy-GuTOq1GvVGHKsHwAPih60wcW3DGmqRg@mail.gmail.com>
In-Reply-To: <CAPcyv4hr-KXUAT_tVy-GuTOq1GvVGHKsHwAPih60wcW3DGmqRg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 3 Jan 2020 10:18:22 -0800
Message-ID: <CAPcyv4jM8s8T5ifv0c2eyqaBu3f2bd_j+fQHmJttZAajZ-we=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 02/19] dax: Pass dax_dev to
	dax_writeback_mapping_range()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Jan 3, 2020 at 10:12 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Fri, Jan 3, 2020 at 6:12 AM Vivek Goyal <vgoyal@redhat.com> wrote:
[..]
> > Hi Dan,
> >
> > Ping for this patch. I see christoph and Jan acked it. Can we take it. Not
> > sure how to get ack from ext4 developers.
>
> Jan counts for ext4, I just missed this. Now merged.

Oh, this now collides with:

   30fa529e3b2e xfs: add a xfs_inode_buftarg helper

Care to rebase? I'll also circle back to your question about
partitions on patch1.


