DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=lcbLQrSiUL+YaAapNG8d+YXT2Y9CdIB0zwvgwkGIw5w=;
	b=DjuW4F4jIF7ViLaGL0pcdbGuhHFINKJxh/enwFJdTt7AWVrpGi/xp6mziyYnz7YfUQ
	dN87/MrqLiYIJACPOrXmfYe39owKQiMEwVG54ni65/NRcAl+JFXI7CHZKHYfgwvNrrwK
	3R2lTuaBWuctRW8N5sj/fOXkXdx0a6kfAqhF0=
MIME-Version: 1.0
References: <20211102055646.103337-1-jefflexu@linux.alibaba.com>
	<Ya9y7uqsMoDfGIbc@redhat.com>
	<dab8877d-54ad-9384-4a0f-34eae2c93b75@linux.alibaba.com>
	<YbEP/1IeGVkDhbaC@redhat.com>
	<7815cbb4-4889-4d37-14d1-a23a0a960204@linux.alibaba.com>
	<YbeK8HOF5F8n+ZG8@redhat.com>
In-Reply-To: <YbeK8HOF5F8n+ZG8@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 14 Dec 2021 11:17:23 +0100
Message-ID: <CAJfpeguNSubpAwFZ7wzZjQsQMLTTUSSWHEvMwu56-oAdx_TZnA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v7 0/6] virtiofsd: support per inode DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Joseph Qi <joseph.qi@linux.alibaba.com>

On Mon, 13 Dec 2021 at 19:03, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Fri, Dec 10, 2021 at 10:54:20AM +0800, JeffleXu wrote:
> > Hi Vivek,
> >
> > Besides, I'd like to know that, to make the per inode DAX feature merged
> > into v5.17, shall the patches for virtiofsd also be ready during the
> > merge window?
>
> I think having virtiofsd patches ready is not a strict requirement to
> merge kernel patches. I will provide my ack for the kernel patches.
> After that it is up to the Miklos to accept or reject those patches.

Pushed to fuse.git#for-next.

The user API needed porting, the userspace part will have to take that
into account.  The only other change I did was replace the !!
construct with a (bool) cast.

Thanks,
Miklos

