DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=lizzy; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=C1LAl7iFhSWxJo4O4+Fg+1J6QMFGsW7M6C6eJvk9vCY=;
	b=cNrpcyH0NFjMrz4CcpXPepwflE
	cABEw0CuVkczdQ4KKAiLuLaApRjK6H2iXpZDV57nFWniDUr2a2ltzigIX6S3E+7c4K5WtKJrAgO8z
	qDj2OelLbyk21s0r20IvfMrukx1q1ep6LtU0mKlcd1pUqK2Cj8He66+yNzYFe7ZLpUI1s6c4Zzv5X
	IxFH5mkv0k79MmH3PfJO67eZHFa2iiZyDQcE/M+qi3OitCYV61LvYPLolhFqF5yeoSm/ofhMNyt8j
	VeFN1sVB1SvCoU+nXNMAcxaETUeb6z2qfRRmJu6v6Iw3B9nwht/pIbUV8OPFyeidAdyx8AqEqRxdw
	aQtPraeA==
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Fri, 25 Sep 2020 10:06:41 +0200
Message-ID: <17216624.eqST2d0sUl@silver>
In-Reply-To: <20200924221023.GB132653@redhat.com>
References: <20200918213436.GA3520@redhat.com>
	<46D726A6-72F3-40FE-9382-A189513F783D@intel.com>
	<20200924221023.GB132653@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [Virtio-fs] virtiofs vs 9p performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "Venegas Munoz, Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, "cdupontd@redhat.com" <cdupontd@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, Greg Kurz <groug@kaod.org>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>, Vivek Goyal <vgoyal@redhat.com>

On Freitag, 25. September 2020 00:10:23 CEST Vivek Goyal wrote:
> In my testing, with cache=none, virtiofs performed better than 9p in
> all the fio jobs I was running. For the case of cache=auto  for virtiofs
> (with xattr enabled), 9p performed better in certain write workloads. I
> have identified root cause of that problem and working on
> HANDLE_KILLPRIV_V2 patches to improve WRITE performance of virtiofs
> with cache=auto and xattr enabled.

Please note, when it comes to performance aspects, you should set a reasonable 
high value for 'msize' on 9p client side:
https://wiki.qemu.org/Documentation/9psetup#msize

I'm also working on performance optimizations for 9p BTW. There is plenty of 
headroom to put it mildly. For QEMU 5.2 I started by addressing readdir 
requests:
https://wiki.qemu.org/ChangeLog/5.2#9pfs

Best regards,
Christian Schoenebeck


