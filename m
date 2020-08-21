DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=P8JqJ7RITgIzurlji1LRRQPoo/Vlt5Iw5NORag7G42Q=;
	b=PF5nQ0yhXqC6cdiS0QHJ/VuBLy6pv4wFad2TzgpHPe0m9/AbF0MrCgH7ZOwn839T+y
	ppa1BeyMv/4m6dQWPy5WScRu3mg4ShtrpD90yzFBkHvYXjWaDXOr3+0X49jXWBs4g6zL
	D2vhDiA+A+4B1xcKULWc9V5Jv3RkCK4fDM8aA=
MIME-Version: 1.0
References: <20200724183812.19573-1-vgoyal@redhat.com>
	<20200724183812.19573-4-vgoyal@redhat.com>
In-Reply-To: <20200724183812.19573-4-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Aug 2020 16:53:59 +0200
Message-ID: <CAJfpeguvMvc9rXChGrSuQsO9__Ln7exozmMWVY_1B8DrsV4rpQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 3/5] fuse: Add a flag FUSE_SETATTR_KILL_PRIV
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
> With handle_killpriv_v2, server needs to kill suid/sgid on truncate (setattr)
> but it does not know if caller has CAP_FSETID or not. So like write, send
> killpriv information in fuse_setattr_in and add a flag FUSE_SETATTR_KILL_PRIV.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

[...]

> +/**
> + * Setattr flags
> + * FUSE_SETATTR_KILL_PRIV: kill suid and sgid bits. sgid should be killed
> + * only if group execute bit (S_IXGRP) is set. Meant to be used together
> + * with FUSE_HANDLE_KILLPRIV_V2.
> + */
> +#define FUSE_SETATTR_KILL_PRIV (1 << 0)

Why not a FATTR_KILL_PRIV set in fuse_setattr_in.valid?

Thanks,
Miklos

