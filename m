DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1623314038; bh=iZa1+1qRIau0JA4G4mFy2PSaXoZ0Z9gDo5Hw1Npi34I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QRM+WQ2kQ9sx5Y4/XpGwbQkVDQYGGG6kTh5bNn3v+wNTCxV1GgyxeL+y/vxWOwW77
	jNSv+/4WpMaiIgTDWQi/MLMov+9COh71KPjjyWf5wIMLkeTqtpVTcPPn/57G5Yy4xP
	EmLrh9hgh+L3Cx6nydAsBPJogUXxerfIBBKvsqX2mIWhs5hdLIv5taAPze6B7l0lEc
	787LsGpnHNb4Ab88lbksT5Vkrn2ZrxN7PnJo4OG8xFCujkSE7vYgUVwjQFOrjPZ+D5
	VxJMgHGoOpwvR5siK6P5HqFA2v9Ejp4KS5MqQjAHVeYU0vpvDkK1jhKY1Tf3N+fahB
	sfy0uOuQ8ngPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1623314037; bh=iZa1+1qRIau0JA4G4mFy2PSaXoZ0Z9gDo5Hw1Npi34I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kGqKC7AFVeIEp0fUgzcQS2c8VETAH1wLr0t3yFTzhPwRejmEg9Zcpu+JsrUWANfGB
	3EOPQYGvGI1CxHfxsK5+jACZk9LTEbrng404FtnrBelEryaGPAwAwZrmyyq+KhEt08
	To2C+BRqzZjyQTUwQL2nPUdfE6UvVGC5O/ADjTWNawEXw3q0gaZrQo8uByM8sXtow1
	Ehr+RutqLn8WN8yavzhmGLXakaHLFKfUHmvYaXr0ojkZZ4f/L1aGdHFVhmk3VjuwMl
	QodbN244pHG/7FS6g0TX8hpoyWc03/Vv5Rk1wcXbTqrq0HG4Wrpm2a4jP7K/vA8DXe
	W8mIarOt8lKJw==
Date: Thu, 10 Jun 2021 17:33:34 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
Message-ID: <YMHOXn2cpGh1T9vz@codewreck.org>
References: <20210608153524.GB504497@redhat.com>
	<YMCPPCbjbRoPAEcL@stefanha-x1.localdomain>
	<20210609154543.GA579806@redhat.com>
	<YMHKZhfT0CUgeLno@stefanha-x1.localdomain>
MIME-Version: 1.0
In-Reply-To: <YMHKZhfT0CUgeLno@stefanha-x1.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH] init/do_mounts.c: Add root="fstag:<tag>"
 syntax for root device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard.weinberger@gmail.com>, linux kernel mailing list <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, Vivek Goyal <vgoyal@redhat.com>

Stefan Hajnoczi wrote on Thu, Jun 10, 2021 at 09:16:38AM +0100:
> virtio-9p should be simple. I'm not sure how much additional setup the
> other 9p transports require. TCP and RDMA seem doable if there are
> kernel parameters to configure things before the root file system is
> mounted.

For TCP, we can probably piggyback on what nfs does for this, see the
ip= parameter in Documentation/admin-guide/nfs/nfsroot.rst -- it lives
in net/ipv4/ipconfig.c so should just work out of the box

For RDMA I'm less optimistic, technically if we can setup ipoib with an
ip with the same parameter it should work, but I have nothing to test it
on anyway so that'll wait until someone who cares actually does try...


Either way, we've got to start somewhere, so it's good there's something :)
-- 
Dominique


