DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=intel-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=oMeNYRjmE3xADDHseE8To74pLJCIPrrI6iJEnl8/MJE=;
	b=aT9oM/LCSkoU4DdjNflW1gLMp0wxVh5dnFJb8sf5sPgjVDLhWEqnZiSRpAeeGcHRg3
	GRzzra9Yib97QPwwnxC3RKcRXN0Osb1l24DjUOUZJ42RCQqm3m5RkDe9UzWztOZTtr3w
	XJLFOTDwV3oVI5CjkHlup8nJ4bFUjCoH08/1ROlE0ivkkm69CMkthrbLYK4pynoIEaCB
	4b2UfkD1BJyszzW0TA68YU1tJwy/mY/yyObGN3t3ngSw0QpZlvhObmzfxajy07Khz5ST
	sg9FBbkL6YcKUuz5INzL2GxKWtGK7zsaP+IAywWCUcl1epohdi+uxvi6VWUJeh0J4I0J
	5dyA==
MIME-Version: 1.0
References: <CAPcyv4jGEAbYSJef2zLzgg6Arozsuz7eN_vZL1iTcd1XQuNT4Q@mail.gmail.com>
	<20191216181014.GA30106@redhat.com>
	<20200107125159.GA15745@infradead.org>
	<CAPcyv4jZE35sbDo6J4ihioEUFTuekJ3_h0=2Ra4PY+xn2xn1cQ@mail.gmail.com>
	<20200107170731.GA472641@magnolia>
	<CAPcyv4ggH7-QhYg+YOOWn_m25uds+-0L46=N09ap-LALeGuU_A@mail.gmail.com>
	<20200107180101.GC15920@redhat.com>
	<CAPcyv4gmdoqpwwwy4dS3D2eZFjmJ_Zi39k=1a4wn-_ksm-UV4A@mail.gmail.com>
	<20200107183307.GD15920@redhat.com>
	<CAPcyv4ggoS4dWjq-1KbcuaDtroHKEi5Vu19ggJ-qgycs6w1eCA@mail.gmail.com>
	<20200107190258.GB472665@magnolia>
In-Reply-To: <20200107190258.GB472665@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 7 Jan 2020 11:46:37 -0800
Message-ID: <CAPcyv4ia9r0rdbb7t0JvEnGW6nnHdAWUHbaMrY5FKBY+4Fum6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 01/19] dax: remove block device dependencies
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: virtio-fs@redhat.com, linux-nvdimm <linux-nvdimm@lists.01.org>, Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Tue, Jan 7, 2020 at 11:03 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
[..]
> > That can already happen today. If you do not properly align the
> > partition then dax operations will be disabled.
>
> Er... is this conversation getting confused?  I was talking about
> kpartx's /dev/mapper/pmem0p1 being a straight replacement for the kernel
> creating /dev/pmem0p1.  I thnk Vivek was complaining about the
> inconsistent behavior between the two, even if the partition is aligned
> properly.
>
> I'm not sure how alignment leaked in here?

Oh, whoops, I was jumping to the mismatch between host device and
partition and whether we had precedent to fail to support dax on the
partition when the base block device does support it.

But yes, the mismatch between kpartx and native partitions is weird.
That said kpartx is there to add partition support where the kernel
for whatever reason fails to, or chooses not to, and dax is looking
like such a place.

> > This proposal just
> > extends that existing failure domain to make all partitions fail to
> > support dax.
>
> Oh, wait.  You're proposing that "partitions of pmem devices don't
> support DAX", not "the kernel will not create partitions for pmem
> devices".
>
> Yeah, that would be inconsistent and weird.

More weird than the current constraints?

> I'd say deprecate the
> kernel automounting partitions, but I guess it already does that, and

Ok, now I don't know why automounting is leaking into this discussion?

> removing it would break /something/.

Yes, the breakage risk is anyone that was using ext4 mount failure as
a dax capability detector.

> I guess you could put
> "/dev/pmemXpY" on the deprecation schedule.

...but why deprecate /dev/pmemXpY partitions altogether? If someone
doesn't care about dax then they can do all the legacy block things.
If they do care about dax then work with whole device namespaces.

The proposal is to detect dax on partitions and warn people to move to
kpartx. Let the core fs/dax implementation continue to shed block
dependencies.


