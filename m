DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=OR0mfp69BO369dwMXiG/0IV7r83mKSvkOO+HBHsDV1U=;
	b=T/QAfqa4gFf2yPcnbt8MpH2hlEvC+xI2OD12t7di66bI1nfIJIzk+a+tCDwCLV8YPn
	BccJQNU5tQCdz8kxQHRhSAQmRfOaCS23oCHN8QHk53uiXkmEzU937zEX7hw2JXA13fLh
	H6AvPzEbMLFvJRql+xRU19vf1Ve9o1Z8CbYHM=
MIME-Version: 1.0
References: <20200601053214.201723-1-chirantan@chromium.org>
	<20200610092744.140038-1-chirantan@chromium.org>
In-Reply-To: <20200610092744.140038-1-chirantan@chromium.org>
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Mon, 15 Jun 2020 16:37:48 +0900
Message-ID: <CAJFHJrq6aeVkKaYL2jcYjxFkcnEp_T6wc1tQ8pZYbwsubKW66A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v2] RFC: fuse: Call security hooks on new
	inodes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Suleiman Souhlal <suleiman@chromium.org>, virtio-fs-list <virtio-fs@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Dylan Reid <dgreid@chromium.org>, Vivek Goyal <vgoyal@redhat.com>

Friendly ping.  Are there any concerns with this patch?  I know I
probably need to split it up into 2 patches: one that adds the flag
and one that implements support.  Since v2 adds a new flag to the
init_out struct I'd really like to get this merged upstream as
carrying it locally would effectively mean forking the protocol.

Thanks,
Chirantan

