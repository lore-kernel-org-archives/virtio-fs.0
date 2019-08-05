DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=plexistor-com.20150623.gappssmtp.com; s=20150623;
	h=subject:to:cc:references:from:message-id:date:user-agent
	:mime-version:in-reply-to:content-language:content-transfer-encoding;
	bh=i8MUAFs9xWo3DeulQdVmEqj8r8vwJULZDf6MNUFq2ww=;
	b=UrVz3TL4y2Wd+2usgnHy3ExsuaOYfeNXBdmadp57B6j14Ve7GM/RifZdIa0BVHr1mR
	7EkSWqmNTRYWs8nNOfXbwW3zYaSffpmhx5FrOADWtrlzKsbxRmJQ56JPTmj4odOuuhcf
	GtyYiWudoTtgCmBg9n/4fgOB2kFttMVVvMsGFsI26QLy91SItBSIbfzaDnAQv3BwLj6U
	gWkJ8YpDvcU1ASeinejR8VSX6IjC07krSj47vZQWeEbbAqR2hO9cQfZwOzMLsqQo7ClK
	y/i3avrc0nF4z4Hp82ZrkJ56foE4TgFoWLOynsKwpfZFZ4E1XiAqKSR08yPeMsCWU6dU
	LM5w==
References: <20190802192956.GA3032@redhat.com>
	<CAPcyv4jxknEGq9FzGpsMJ6E7jC51d1W9KbNg4HX6Cj6vqt7dqg@mail.gmail.com>
	<9678e812-08c1-fab7-f358-eaf123af14e5@plexistor.com>
	<20190805184951.GC13994@redhat.com>
From: Boaz Harrosh <boaz@plexistor.com>
Message-ID: <9c0ec951-01e7-7ae0-2d69-1b26f3450d65@plexistor.com>
Date: Mon, 5 Aug 2019 22:16:45 +0300
MIME-Version: 1.0
In-Reply-To: <20190805184951.GC13994@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
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
To: Vivek Goyal <vgoyal@redhat.com>, Boaz Harrosh <boaz@plexistor.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtio-fs@redhat.com, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>

On 05/08/2019 21:49, Vivek Goyal wrote:
> On Mon, Aug 05, 2019 at 02:53:06PM +0300, Boaz Harrosh wrote:
<>
>> So as I understand the man page:
>> fallocate(FL_PUNCH_HOLE); means user is asking to get rid also of COW pages.
>> On the other way fallocate(FL_ZERO_RANGE) only the pmem portion is zeroed and COW (private pages) stays
> 
> I tested fallocate(FL_PUNCH_HOLE) on xfs (non-dax) and it does not seem to
> get rid of COW pages and my test case still can read the data it wrote
> in private pages.
> 

It seems you are right and I am wrong. This is what the Kernel code has to say about it:

	/*
	 * Unlike in truncate_pagecache, unmap_mapping_range is called only
	 * once (before truncating pagecache), and without "even_cows" flag:
	 * hole-punching should not remove private COWed pages from the hole.
	 */

For me this is confusing but that is what it is. So remove private COWed pages
is only done when we do an setattr(ATTR_SIZE).

>>
>> Just saying I have not followed the above code path
>> (We should have an xfstest for this?)
> 
> I don't know either. It indeed is interesting to figure out what's the
> expected behavior with fallocate() and truncate() for COW pages and cover
> that using xfstest (if not already done).
> 

I could not find any test for the COW positive FL_PUNCH_HOLE (I have that bug)
could be nice to make one, and let FSs like mine fail.
Any way very nice catch.

> 
> Thanks
> Vivek
> 

Thanks
Boaz

