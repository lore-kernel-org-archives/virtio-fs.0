DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1625071056;
	bh=fXFRwwIpr1pkbYhPokSUGN3Kioi8aY6VmPkFSwVxJog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L4Jdnhk4Ha/SKLA3QfGf/Ztd/pTzVu0TSJf2AFyXtErkqcnJttu6bmA1KPcIbpaTd
	cdaq1mrUrnSPC+TOn0InKjbA5K3L5xjOIVAsVcbsCJbN1wjZTX+cezHDCERaBHYoY+
	svnuN54AXS1vTZX2EldUhCj/HBU5qoGjqCCYoH0EZW0dt6UVsupXdtOgXDeu2iZDF/
	4U8Rvk/NBhzWO5d+dNSNL0ShXypnojVpEB+lCNaJTkXWEj0Z7AOVLaaiBHKu6PZ9sd
	A8oVUnQDS0PSwOI8ZJQf02dfRPWMAYZSfczkq1QeL8WWlysgYfF5Z10mbyDvBjZaEd
	ieOyrwz0V0kYA==
Date: Wed, 30 Jun 2021 09:37:35 -0700
From: Ming Lin <mlin@kernel.org>
Message-ID: <20210630163735.GA289024@ubuntu-server>
References: <1622792602-40459-1-git-send-email-mlin@kernel.org>
	<1622792602-40459-3-git-send-email-mlin@kernel.org>
	<20210628142723.GB1803896@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210628142723.GB1803896@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v2 2/2] mm: adds NOSIGBUS extension to mmap()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Simon Ser <contact@emersion.fr>, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, virtio-fs-list <virtio-fs@redhat.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>

O Mon, Jun 28, 2021 at 10:27:23AM -0400, Vivek Goyal wrote:
> On Fri, Jun 04, 2021 at 12:43:22AM -0700, Ming Lin wrote:
> > Adds new flag MAP_NOSIGBUS of mmap() to specify the behavior of
> > "don't SIGBUS on fault". Right now, this flag is only allowed
> > for private mapping.
> > 
> > For MAP_NOSIGBUS mapping, map in the zero page on read fault
> > or fill a freshly allocated page with zeroes on write fault.
> 
> I am wondering if this could be of limited use for me if MAP_NOSIGBUS
> were to be supported for shared mappings as well.

V1 did support shared mapping.
https://lkml.org/lkml/2021/6/1/1078

And V0 even supported unmapping the zero page for later write.
https://github.com/minggr/linux/commit/77f3722b94ff33cafe0a72c1bf1b8fa374adb29f

We may support shared mapping if there is a real use case.
As Hugh mentioned:
> And by restricting to MAP_PRIVATE, you would allow for adding a
> proper MAP_SHARED implementation later, if it's thought useful
> (that being the implementation which can subsequently unmap a
> zero page to let new page cache be mapped).

See https://lkml.org/lkml/2021/6/1/1258

Ming

> 
> When virtiofs is run with dax enabled, then it is possible that if
> a file is shared between two guests, then one guest truncates the
> file and second guest tries to do load/store operation. Given current
> kvm architecture, there is no mechanism to propagate SIGBUS to guest
> process, instead KVM retries page fault infinitely and guest cpu/process
> hangs.
> 
> Ideally we want this error to propagate all the way back into the
> guest and to the guest process but that solution is not in place yet.
> 
> https://lore.kernel.org/kvm/20200406190951.GA19259@redhat.com/
> 
> In the absense of a proper solution, one could think of mapping
> shared file on host with MAP_NOSIGBUS, and hopefully that means
> kvm will be able to resolve fault to a zero filled page and guest
> will not hang. But this means that data sharing between two processes
> is now broken. Writes by process A will not be visible to process B
> in another once this situation happens, IIUC.
> 
> So if we were to MAP_NOSIGBUS, guest will not hang but failures resulting
> from ftruncate will be silent and will be noticed sometime later. I guess
> not exactly a very pleasant scenario...
> 
> Thanks
> Vivek

