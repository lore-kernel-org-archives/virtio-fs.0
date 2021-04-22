DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209;
	h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Htu27fcauCIeNAT1CNME/QOxZktPj64iBdmB2H8njcI=;
	b=lXK4RR4Pe60ylqYwFlXI3ChRDG
	hnSeO4/GoHq6M4ceNs1tOYvp3YWuD+GKnaJvIyIVtO/5o4GWvRXFS07DoScW4oAtcmps8EO6aRU1c
	VmosGKwwBKzJwQEV1mxrRpCca+iZxVVoPyqGbR0X6xfGWGhgUVLI1y52DpeHyC298ABQdVzSwAXBt
	Igmc+kY4Kf+jUbQpwCDifRqjEKCwHlpdFjC4pESppVPyYEoOu8OTUlYK04EbJflYwYRl1QQIy9WFF
	LJfj25QfbZ51TB4ExKQ0Tvkl1/qNEWp6iGCxcZLyyKjnh4nv947zhFCKOfWE9eSO9D7Le8Xe2pPq8
	tNHCH/xw==
Date: Thu, 22 Apr 2021 07:24:58 +0100
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20210422062458.GA4176641@infradead.org>
References: <20210419213636.1514816-1-vgoyal@redhat.com>
	<20210419213636.1514816-3-vgoyal@redhat.com>
	<20210420093420.2eed3939@bahia.lan>
	<20210420140033.GA1529659@redhat.com>
	<CAPcyv4g2raipYhivwbiSvsHmSdgLO8wphh5dhY3hpjwko9G4Hw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g2raipYhivwbiSvsHmSdgLO8wphh5dhY3hpjwko9G4Hw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v3 2/3] dax: Add a wakeup mode parameter to
 put_unlocked_entry()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Miklos Szeredi <miklos@szeredi.hu>, Matthew Wilcox <willy@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Apr 21, 2021 at 12:09:54PM -0700, Dan Williams wrote:
> Can you get in the habit of not replying inline with new patches like
> this? Collect the review feedback, take a pause, and resend the full
> series so tooling like b4 and patchwork can track when a new posting
> supersedes a previous one. As is, this inline style inflicts manual
> effort on the maintainer.

Honestly I don't mind it at all.  If you shiny new tooling can't handle
it maybe you should fix your shiny new tooling instead of changing
everyones workflow?

