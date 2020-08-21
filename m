DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=CFHd1R652j9IVdzjEHHv8CJFVu6cveWEKM1K8aqJjrQ=;
	b=haDU8LPcBr5xa7coersCLI6x4maLKVPLvitqPKOHCnpauOP1/pvLs2510Iwf64iV+d
	D+53HDw8XmunesV1pTwDVXIgCrdaYMnyO/HfzsTpcCMtw+Xa5D+8K9cL3wttaGffuJia
	4/C/t5tGfNpqjjoRqnQB2flfHY7xWltIH+JZU=
MIME-Version: 1.0
References: <20200724183812.19573-1-vgoyal@redhat.com>
	<20200724183812.19573-5-vgoyal@redhat.com>
In-Reply-To: <20200724183812.19573-5-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Aug 2020 17:05:16 +0200
Message-ID: <CAJfpegu0HKSbY53GBMWSYRYc7NJab+9NAXmfp9ekzU_QCiDCQg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 4/5] fuse: For sending setattr in case of
	open(O_TRUNC)
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

On Fri, Jul 24, 2020 at 8:38 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> open(O_TRUNC) will not kill suid/sgid on server and fuse_open_in does not
> have information if caller has CAP_FSETID or not.
>
> So force sending setattr() which is called after open(O_TRUNC) so that
> server clears setuid/setgid.

I don't really like the fact that we lose atomicity if
handle_killpriv_v2 is enabled.

Let's just add a new flag to open as well.  If a filesystem doesn't
want to add the complexity of handling that it can still just disable
atomic_o_trunc.

Thanks,
Miklos

