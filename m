DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=dzjiSE/0Hpa/u2YaEx0I4w/Q55oG4EeAA+DOe/kfQpI=;
	b=NvAaWST2THpyF4Kn9wSoX+o2whIh7NEn/hw3uOSfYQN6I5Zjb67L3LF7wQkB5GvQ9J
	5jfuDUsqLN40UPKCAexpgPCIU2CH3gsQlekwOQKCFOrEWQ7ZiVHybUIB3XSycxxozVFH
	FsQjec16Q2eU/NP5AF6OusDF0wf0SsXUCy9l4=
MIME-Version: 1.0
References: <20191011181826.GA13861@redhat.com>
In-Reply-To: <20191011181826.GA13861@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 14 Oct 2019 10:25:51 +0200
Message-ID: <CAJfpegv8p--fS5LeVJB2zpon1iXzqTYccyJRojd2Ef_Dv_U84w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] virtio_fs: Change module name to virtiofs.ko
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com

On Fri, Oct 11, 2019 at 8:18 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> We have been calling it virtio_fs and even file name is virtio_fs.c. Module
> name is virtio_fs.ko but when registering file system user is supposed to
> specify filesystem type as "virtiofs".
>
> Masayoshi Mizuma reported that he specified filesytem type as "virtio_fs" and
> got this warning on console.
>
>   ------------[ cut here ]------------
>   request_module fs-virtio_fs succeeded, but still no fs?
>   WARNING: CPU: 1 PID: 1234 at fs/filesystems.c:274 get_fs_type+0x12c/0x138
>   Modules linked in: ... virtio_fs fuse virtio_net net_failover ...
>   CPU: 1 PID: 1234 Comm: mount Not tainted 5.4.0-rc1 #1
>
> So looks like kernel could find the module virtio_fs.ko but could not find
> filesystem type after that.
>
> It probably is better to rename module name to virtiofs.ko so that above
> warning goes away in case user ends up specifying wrong fs name.
>
> Reported-by: Masayoshi Mizuma <msys.mizuma@gmail.com>
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Thanks, applied.

Miklos

