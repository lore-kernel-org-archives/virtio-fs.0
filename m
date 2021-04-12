DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=1bLXXtn/sInxr42wR069i3XMC3oTpYxOTPRZIb4fmKU=;
	b=oY9yjkS1FrppbTvlvHCyp5rRI61lxpfIFVSJ+I4eIHxXCYxzRX1F4If4V+kRn705Dt
	sNE/nIhMmgdKOXkvVGXBNez+sqrtGp4KTWMGL+eiacWPEtWfkponUZVNRvLxVkVnJmjG
	eZ6mSSdhW3M3NjQejemsvqmtoQvDDvYbpOGps=
MIME-Version: 1.0
References: <20210412145919.GE1184147@redhat.com>
In-Reply-To: <20210412145919.GE1184147@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 Apr 2021 17:08:26 +0200
Message-ID: <CAJfpegsaY05jSRNFTcquNFyMr+GMpPBMgoEO0YZcXxfqBi3g2A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] Query about fuse ->sync_fs and virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Linux fsdevel mailing list <linux-fsdevel@vger.kernel.org>, Robert Krawitz <rkrawitz@redhat.com>

On Mon, Apr 12, 2021 at 4:59 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Hi Miklos,
>
> Robert Krawitz drew attention to the fact that fuse does not seem to
> have a ->sync_fs implementation. That probably means that in case of
> virtiofs, upon sync()/syncfs(), host cache will not be written back
> to disk. And that's not something people expect.
>
> I read somewhere that fuse did not implement ->sync_fs because file
> server might not be trusted and it could block sync().
>
> In case of virtiofs, file server is trusted entity (w.r.t guest kernel),
> so it probably should be ok to implement ->sync_fs atleast for virtiofs?

Yes, that looks like a good idea.

Thanks,
Miklos

