DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=intel-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=+A1yNa9EKEJAvf7mT00hIXluvZccqZJ7nsuzns/AIw8=;
	b=QcqFB30MvhWgAdAzPCflfRmMETbH1hoaJBG7MjYnvbJcTSSYFCqw7gCztL7VDsBjEQ
	bft3HLIHqI3AG32tRCL397/3D+LE5eZUjbGrWZoUGjgrKYA3BuQJ7UwTUoalWAZm+esn
	8VdrudiYMzMuJ2ZlhI0/GyrZnfkMedu++29oggEnKOE7bVGp9DPbnOW7whKKa8O3My1v
	HoCi+cbEXmbmUDIWSPp3CDf36DG9rMFaaQTalTxHrlD/PJvxiwpEn0B+nR3yasZOwDky
	JzxMuv+w316sqBBqiR96737ifpKGaWFGzriRnlgq4zDPQgbOkNVzn1ruNr2LzpuIl1yv
	O9tg==
MIME-Version: 1.0
References: <20190821175720.25901-1-vgoyal@redhat.com>
	<20190821175720.25901-3-vgoyal@redhat.com>
	<20190826115316.GB21051@infradead.org>
	<20190826203326.GB13860@redhat.com>
	<20190826205829.GC13860@redhat.com> <20200103141235.GA13350@redhat.com>
	<CAPcyv4hr-KXUAT_tVy-GuTOq1GvVGHKsHwAPih60wcW3DGmqRg@mail.gmail.com>
	<CAPcyv4jM8s8T5ifv0c2eyqaBu3f2bd_j+fQHmJttZAajZ-we=g@mail.gmail.com>
	<20200103183307.GB13350@redhat.com>
In-Reply-To: <20200103183307.GB13350@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 3 Jan 2020 11:30:35 -0800
Message-ID: <CAPcyv4geobjz_FZpfow7CKYDHHPe=65=tYV65E0901OzPszpww@mail.gmail.com>
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

On Fri, Jan 3, 2020 at 10:33 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Fri, Jan 03, 2020 at 10:18:22AM -0800, Dan Williams wrote:
> > On Fri, Jan 3, 2020 at 10:12 AM Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > On Fri, Jan 3, 2020 at 6:12 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > [..]
> > > > Hi Dan,
> > > >
> > > > Ping for this patch. I see christoph and Jan acked it. Can we take it. Not
> > > > sure how to get ack from ext4 developers.
> > >
> > > Jan counts for ext4, I just missed this. Now merged.
> >
> > Oh, this now collides with:
> >
> >    30fa529e3b2e xfs: add a xfs_inode_buftarg helper
> >
> > Care to rebase? I'll also circle back to your question about
> > partitions on patch1.
>
> Hi Dan,
>
> Here is the updated patch.
>
> Thanks
> Vivek
>
> Subject: dax: Pass dax_dev instead of bdev to dax_writeback_mapping_range()

Looks good, applied.


