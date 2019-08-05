DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=intel-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=w1iVLzk9vdxhakLt5F7vFH14/nHwewgaD6R8shprF8Y=;
	b=lUU7ngMfKIxRpqeMXeZclDK9g9/hMD5XSGU26fhPwOSAnWHP28jDnAB7VLeEhmLc0W
	EJcOWgGW8KmRbY4WbwlL7Z7fgueFFYyptqeSlONYAvUVK1pzz20Bk6L2vIW7tuSEPbuG
	DeM8MYGXvNF7fTD/DS5fX20aunJlpW+/ULWiQt6wjmx/FJ1pk5vSqm7qnoOcaD6zlEB5
	8GYsZzn75CdOM0Lid4lZIDcAEuBn+7yyz/flFiin3rISCkpnr/snk1FwWQhcoLP2WtNi
	3UIrpUAwQZ6RUqhcJtZEYD9Wi4bPabnLXTFtvFQUYHbVjlhTLNi5O3kLpyuWS0JX+2LZ
	JCzg==
MIME-Version: 1.0
References: <20190802192956.GA3032@redhat.com>
	<CAPcyv4jxknEGq9FzGpsMJ6E7jC51d1W9KbNg4HX6Cj6vqt7dqg@mail.gmail.com>
	<9678e812-08c1-fab7-f358-eaf123af14e5@plexistor.com>
	<20190805184951.GC13994@redhat.com>
	<9c0ec951-01e7-7ae0-2d69-1b26f3450d65@plexistor.com>
In-Reply-To: <9c0ec951-01e7-7ae0-2d69-1b26f3450d65@plexistor.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 5 Aug 2019 13:11:48 -0700
Message-ID: <CAPcyv4jgxTNbGBy9cQjS_mEzeuaXa6PQSQ+C5xBgy0mpxUmNzg@mail.gmail.com>
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
To: Boaz Harrosh <boaz@plexistor.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>

On Mon, Aug 5, 2019 at 12:17 PM Boaz Harrosh <boaz@plexistor.com> wrote:
>
> On 05/08/2019 21:49, Vivek Goyal wrote:
> > On Mon, Aug 05, 2019 at 02:53:06PM +0300, Boaz Harrosh wrote:
> <>
> >> So as I understand the man page:
> >> fallocate(FL_PUNCH_HOLE); means user is asking to get rid also of COW pages.
> >> On the other way fallocate(FL_ZERO_RANGE) only the pmem portion is zeroed and COW (private pages) stays
> >
> > I tested fallocate(FL_PUNCH_HOLE) on xfs (non-dax) and it does not seem to
> > get rid of COW pages and my test case still can read the data it wrote
> > in private pages.
> >
>
> It seems you are right and I am wrong. This is what the Kernel code has to say about it:
>
>         /*
>          * Unlike in truncate_pagecache, unmap_mapping_range is called only
>          * once (before truncating pagecache), and without "even_cows" flag:
>          * hole-punching should not remove private COWed pages from the hole.
>          */
>
> For me this is confusing but that is what it is. So remove private COWed pages
> is only done when we do an setattr(ATTR_SIZE).
>
> >>
> >> Just saying I have not followed the above code path
> >> (We should have an xfstest for this?)
> >
> > I don't know either. It indeed is interesting to figure out what's the
> > expected behavior with fallocate() and truncate() for COW pages and cover
> > that using xfstest (if not already done).
> >
>
> I could not find any test for the COW positive FL_PUNCH_HOLE (I have that bug)
> could be nice to make one, and let FSs like mine fail.
> Any way very nice catch.
>

Yes, and this bug is worse because it affects COW pages that are not
the direct target of the truncate / hole punch. This unmap in
dax_layout_busy_page() is only there to allow the fs to synchronize
against get_user_pages_fast() which might otherwise race to grab a
page reference and prevent the fs from making forward progress. The
unmap_mapping_range() that addresses COW pages in the truncated range
occurs later after the filesystem has regained control of the extent
layout (i.e. break layouts has succeeded).

