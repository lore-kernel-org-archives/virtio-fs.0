DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=kw+MyCs5dnbWUnTLkNShmUXXjXtDqqnuyJ0rA7GvwNk=;
	b=rR0MeDwLsqLjJaQdT1+3OxUtjA48WjUu9U89zLWzhaRRkxBJYsDbWWgFlryNlBJuWS
	RlC15OhCP+UiHqNZ3K5zasmIuk0uZbtd9IbSkW+UN8FMW9o+hs+dsejvZd2B3MKUrYBe
	BlxJv71jqbQ6BAu+sZrbMcTn/GEPNA3Zfdwzk=
MIME-Version: 1.0
References: <20200427180354.GD146096@redhat.com>
In-Reply-To: <20200427180354.GD146096@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 30 Apr 2020 10:58:42 +0200
Message-ID: <CAJfpegunz80iFEvW=OhFHuHe4Zyb3isDBZKqCcLLGcRZp1PVmg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] fuse,
	virtiofs: Do not alloc/install fuse device in
	fuse_fill_super_common()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>

On Mon, Apr 27, 2020 at 8:04 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> As of now fuse_fill_super_common() allocates and installs one fuse device.
> Filesystems like virtiofs can have more than one filesystem queues and
> can have one fuse device per queue. Given, fuse_fill_super_common() only
> handles one device, virtiofs allocates and installes fuse devices for
> all queues except one.
>
> This makes logic little twisted and hard to understand. It probably
> is better to not do any device allocation/installation in
> fuse_fill_super_common() and let caller take care of it instead.

I don't have the details about the fuse super block setup in my head,
but leaving the fuse_dev_alloc_install() call inside
fuse_fill_super_common() and adding new
fuse_dev_alloc()/fuse_dev_install() calls looks highly suspicious.

Thanks,
Miklos


