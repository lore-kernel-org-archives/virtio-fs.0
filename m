DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=/y6xFzyCzw1KT1sJVP9w0ePufQ9CHZv14Yo6pv/8g4s=;
	b=lPaezqxKKhgEdyb2GpcJ7yFIjl
	ztGSuf6Rn/WteaZ3Oj3ZwnFFAChUJWeyUEu6HxWonSS3LF0NsMJOWdTDPlC555Az9Mj7akIHAKR6x
	6dOkznyj5KZLIwMGqrx9YaHAzP/xg/fCTm1WK2+DLoAY5owuBTzAKRXcNm+HMv9FAAxED/gW4bJL+
	zVkhnY/jF9pRj7LExnfAPhb0dMRYRijDKBZhKABA/SiHGQEu2R2748brJ8RlSLv+wFBuqNEjSS1o8
	czR7nVCx0qOipRdXf0VpW4fhCu4zU073NViCLWrk1bHGpq1zJVLaVARrhb4cWr+KqaLM/MXBWuPtc
	2EvAOaM22f4fFSC6Uy60LZZXtzQ/AcqE3KfRaFk80lOaWd6fayTHA0urUjf1zo9ChDW7X5ZYsa5mZ
	kmJ5BGieBhfq/rdVpcarA5Yj1vj5FoiDIvzCwtl13AOqjhUYcXnJlJ6qzHI4CGKndxPxtJL4uDxZ2
	mhH4AObrOSAt9W871eHOq3ysC41NERxeecRhLYjAteTbwWWIVWpFWDMSCcqRuj9LAzCPXYdrA0MI2
	8/yzb5pZmkMs6Mq0leUhZoAuNG8RbwQEkLiK9KIFiKkW94g7P8fc9a2hwTnI5LQY3Q9IOx9QulDCE
	eA6+C1b+0UcNYLQb8bPHu9yPveIsDMbEQA5tU4tAQ=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Wed, 24 Feb 2021 16:16:52 +0100
Message-ID: <2006960.IAZaadA1hq@silver>
In-Reply-To: <20210223090531-mutt-send-email-mst@kernel.org>
References: <20200918213436.GA3520@redhat.com> <6115734.fQeFoySBn5@silver>
	<20210223090531-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [Virtio-fs] Can not set high msize with virtio-9p (Was: Re:
	virtiofs vs 9p performance)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "cdupontd@redhat.com" <cdupontd@redhat.com>, Dominique Martinet <asmadeus@codewreck.org>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, qemu-devel@nongnu.org, virtio-fs-list <virtio-fs@redhat.com>, v9fs-developer@lists.sourceforge.net, "Shinde,
	Archana M" <archana.m.shinde@intel.com>, Vivek Goyal <vgoyal@redhat.com>

On Dienstag, 23. Februar 2021 15:07:31 CET Michael S. Tsirkin wrote:
> > Michael, Dominique,
> > 
> > we are wondering here about the message size limitation of just 5 kiB in
> > the 9p Linux client (using virtio transport) which imposes a performance
> > bottleneck, introduced by this kernel commit:
> > 
> > commit b49d8b5d7007a673796f3f99688b46931293873e
> > Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > Date:   Wed Aug 17 16:56:04 2011 +0000
> > 
> >     net/9p: Fix kernel crash with msize 512K
> >     
> >     With msize equal to 512K (PAGE_SIZE * VIRTQUEUE_NUM), we hit multiple
> >     crashes. This patch fix those.
> >     
> >     Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> >     Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
> 
> Well the change I see is:
> 
> -       .maxsize = PAGE_SIZE*VIRTQUEUE_NUM,
> +       .maxsize = PAGE_SIZE * (VIRTQUEUE_NUM - 3),
> 
> 
> so how come you say it changes 512K to 5K?
> Looks more like 500K to me.

Misapprehension + typo(s) in my previous message, sorry Michael. That's 500k 
of course (not 5k), yes.

Let me rephrase that question: are you aware of something in virtio that would 
per se mandate an absolute hard coded message size limit (e.g. from virtio 
specs perspective or maybe some compatibility issue)?

If not, we would try getting rid of that hard coded limit of the 9p client on 
kernel side in the first place, because the kernel's 9p client already has a 
dynamic runtime option 'msize' and that hard coded enforced limit (500k) is a 
performance bottleneck like I said.

Best regards,
Christian Schoenebeck


