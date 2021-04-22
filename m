DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=intel-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=iL1WsOQVTYMGLSrNemHFm1Wr4O/+l/TQ2XP4MbaIT84=;
	b=CmFvXIcEhplHy1cMKEiKqrrqPheSSo1tQSdHL5LuMKhZpbjL0xzsjRbBEY7JGPNwgB
	Rq2HDJXX7H9NUz+rdw7db6fYhPfq+H4AGu9PcMFUm5AhsIBYGkPErbJhrcfuYlbBPFYQ
	HLRYZPoypAdPbIrrECtkBoFVczwlLhCcpX0aY3EAAk+3n7JPzT+V2jtReizvuenO7+j8
	ASjo98WFatar+0BBXCjWu/epjHUSYjFmdVvwLdtR9NMGSyP556uJiaR9BXYmAkz6Dk++
	VqnXUHcRFiLap4vdlP7I9NJWWERch31qrDZ1/V0QRI0/hvcEqMMe9fYP62kf6RyW0FIS
	dLTg==
MIME-Version: 1.0
References: <20210419213636.1514816-1-vgoyal@redhat.com>
	<20210419213636.1514816-3-vgoyal@redhat.com>
	<20210420093420.2eed3939@bahia.lan>
	<20210420140033.GA1529659@redhat.com>
	<CAPcyv4g2raipYhivwbiSvsHmSdgLO8wphh5dhY3hpjwko9G4Hw@mail.gmail.com>
	<20210422062458.GA4176641@infradead.org>
In-Reply-To: <20210422062458.GA4176641@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Apr 2021 13:01:15 -0700
Message-ID: <CAPcyv4h42yPKmWByBVkjgL_0LjBg3ZNYKLBJKgjixsdTzOpaiA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Miklos Szeredi <miklos@szeredi.hu>, Matthew Wilcox <willy@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Apr 21, 2021 at 11:25 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Apr 21, 2021 at 12:09:54PM -0700, Dan Williams wrote:
> > Can you get in the habit of not replying inline with new patches like
> > this? Collect the review feedback, take a pause, and resend the full
> > series so tooling like b4 and patchwork can track when a new posting
> > supersedes a previous one. As is, this inline style inflicts manual
> > effort on the maintainer.
>
> Honestly I don't mind it at all.  If you shiny new tooling can't handle
> it maybe you should fix your shiny new tooling instead of changing
> everyones workflow?

I think asking a submitter to resend a series is par for the course,
especially for poor saps like me burdened by corporate email systems.
Vivek, if this is too onerous a request just give me a heads up and
I'll manually pull out the patch content from your replies.

