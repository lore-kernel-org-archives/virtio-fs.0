DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1614181454; bh=ZV8jkMbY8El7E5ZFbA9docIbSkA9tEpu7hmt+4Awjko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VsE5jdr/5aZpQH+iy7jVXAIurhi3NlE749qCFkpkQQXTKLZ7EcdbMytdAVWvGLbO4
	yrQl2sg3Ro42bSA3PZ21pohotim5n/cZtc3ZFmh09AqaoDUTXHVcRFeVW6yGo2By7D
	dcRGux1GlLIY/yihtuj76PwQ1QCHm7YwA5wkVwI4Mw8OsuLfI2J2PX/dRALFf2NZ7b
	LwBfghtJh8qE6qYp8dlWFJYbyYBSmGt09FUpPGOrt8vqt2ravJT4MUWgNLOBh+zQUr
	+JXEiAqK+//aafD2H/UazGLSU64xrLP7QUUo5fTTfZh+4yenAAjlYn+cOIf3pGANRC
	gyXblOwR/IiYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1614181453; bh=ZV8jkMbY8El7E5ZFbA9docIbSkA9tEpu7hmt+4Awjko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cg4V6oqyH5eIpG+vlgHKbC/pIbonfhxTTuPNEM6WTJnR05IOLD9CkddT/7KkI5nDu
	f+oBz98aOjF7gyK2dZ942PyqTnmoTfh+l90ies6b/vyeHlujKtk4Y7svX2SlRSLGRd
	4IaQuFgM++MFYG/UMgGN5/wZ2xPwuzzOa2t1UMIrosD/6qDRgj54Z9svWmf2AtXOHJ
	CpOlGz9izTLCorDbl+RwbVIPlLtnzpc2vRe0IiKyjFghHep3Eg9Wzb3d7+IBGOFqkM
	vh2I58M9ZaHrZK++A8EtEZUzmCudlJxJP+t7J0A7Qo9pwTzEoEwlo06iKsFvNIZK+D
	MQqJZQwLAoMVg==
Date: Thu, 25 Feb 2021 00:43:57 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
Message-ID: <20210224154357.GA12207@tyr>
References: <20200918213436.GA3520@redhat.com> <6115734.fQeFoySBn5@silver>
	<20210223090531-mutt-send-email-mst@kernel.org>
	<2006960.IAZaadA1hq@silver>
MIME-Version: 1.0
In-Reply-To: <2006960.IAZaadA1hq@silver>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
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
To: Christian Schoenebeck <qemu_oss@crudebyte.com>
Cc: "cdupontd@redhat.com" <cdupontd@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, qemu-devel@nongnu.org, virtio-fs-list <virtio-fs@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, v9fs-developer@lists.sourceforge.net, "Shinde,
	Archana M" <archana.m.shinde@intel.com>

Christian Schoenebeck wrote on Wed, Feb 24, 2021 at 04:16:52PM +0100:
> Misapprehension + typo(s) in my previous message, sorry Michael. That's 500k 
> of course (not 5k), yes.
> 
> Let me rephrase that question: are you aware of something in virtio that would 
> per se mandate an absolute hard coded message size limit (e.g. from virtio 
> specs perspective or maybe some compatibility issue)?
> 
> If not, we would try getting rid of that hard coded limit of the 9p client on 
> kernel side in the first place, because the kernel's 9p client already has a 
> dynamic runtime option 'msize' and that hard coded enforced limit (500k) is a 
> performance bottleneck like I said.

We could probably set it at init time through virtio_max_dma_size(vdev)
like virtio_blk does (I just tried and get 2^64 so we can probably
expect virtually no limit there)

I'm not too familiar with virtio, feel free to try and if it works send
me a patch -- the size drop from 512 to 500k is old enough that things
probably have changed in the background since then.


On the 9p side itself, unrelated to virtio, we don't want to make it
*too* big as the client code doesn't use any scatter-gather and will
want to allocate upfront contiguous buffers of the size that got
negotiated -- that can get ugly quite fast, but we can leave it up to
users to decide.
One of my very-long-term goal would be to tend to that, if someone has
cycles to work on it I'd gladly review any patch in that area.
A possible implementation path would be to have transport define
themselves if they support it or not and handle it accordingly until all
transports migrated, so one wouldn't need to care about e.g. rdma or xen
if you don't have hardware to test in the short term.

The next best thing would be David's netfs helpers and sending
concurrent requests if you use cache, but that's not merged yet either
so it'll be a few cycles as well.


Cheers,
-- 
Dominique

