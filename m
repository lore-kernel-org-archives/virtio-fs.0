DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=subject:to:references:from:message-id:date:user-agent:mime-version
	:in-reply-to:content-transfer-encoding:content-language;
	bh=xnqm+rvQmV+vPU+vUrCBaF2Hlx/OFm/6GHwTX/hk6Es=;
	b=TLccTISBRM42fFsCfo/Gal4i7f7HE13u1fFFf2RioAjWmgDNsvM6gYGpBOSSwGL6IY
	LMQzV5OFDfXJ+L+fhL1h9MWvTPeAIUBmlt8kEWQVaTRNQIfJf4usK5qSa8ICESFokMwA
	+k4wF8c8NdiyK/ZnNot1bC7i7ggzFetMIbbGtocGCaNZyrpjdZCBs+ONo+hM4amki1g+
	0tOfKusULcPOmCTAfwKtFdKd2g66FOg9dDRLXO/6bGzBSKEmNJudB+NAYJ3qQ/R5kL02
	HqPdCzKJDiB6IEsQEjIsRqdYTWpqVl9Aag3TA3khGUx7o1QnlIbJSZhoM1eS7hgwtY4K
	9BNQ==
References: <Mb7HI6c--3-2@tutanota.com>
	<CAJFHJrpEKH_gDz=CpEG=Sy2v-pXe_VoHsX3AJ2FFM7Njh0w0DA@mail.gmail.com>
	<MbNHbdZ--3-2@tutanota.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <b6760207-bd13-20c4-0bfa-fe8ca5f2ea83@gmail.com>
Date: Mon, 7 Jun 2021 10:51:09 -0500
MIME-Version: 1.0
In-Reply-To: <MbNHbdZ--3-2@tutanota.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Subject: Re: [Virtio-fs] virtiofsd: doesn't garant write access at users
 allowed by group permission
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com


On 6/4/21 1:30 PM, tecufanujacu@tutanota.com wrote:
> I guess a third option is to change the fuse protocol so that it also
> includes the supplementary groups of the calling process.

I suspect that option will, over time, require the fewest
developer/maintainer hours.

But not in the short term....



