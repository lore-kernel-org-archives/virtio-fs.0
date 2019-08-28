DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209;
	h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=szNJz18IkRAVT+3DLDeg5T2vD
	WT8kAIr+wRfzUYqoWe2r0V3HDeaGreLe677vNPwGbgYYq1xGfL1D1t2kE0r3pViWZkUmLoS8sqSIl
	QXWFlVXGkG2vnmcVnBlXgmKcU6Q9RtifXngNuzfT/C26+O01GKWLef7p7JZS87uqfT58i/KziRv4G
	yJQvoyNT0RB1HjYDeYtrlzCqDnJi7svD549u+Kt8T7NPZOlZjGhyHsREDEYG7ve2Cz2CAcV9yVPyA
	CbRp6AuAwF7Fj77sSpASWMNq6GeVTuQUhJJNJGvHpnaCQ8FRrPUOoghkohlGayGnr9EflsVWobzvS
	jC9Apm6Ag==;
Date: Tue, 27 Aug 2019 23:58:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20190828065829.GB27426@infradead.org>
References: <20190821175720.25901-1-vgoyal@redhat.com>
	<20190821175720.25901-3-vgoyal@redhat.com>
	<20190826115316.GB21051@infradead.org>
	<20190826203326.GB13860@redhat.com>
	<20190826205829.GC13860@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826205829.GC13860@redhat.com>
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
Cc: virtio-fs@redhat.com, linux-nvdimm@lists.01.org, miklos@szeredi.hu, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

