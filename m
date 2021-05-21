DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=I0bcwMa3PXE6BxBVKmr7yJhO3MpudMurDafu1kpNh8o=;
	b=egbbFhgbpZilJQP2aMecSiEeWjHfKV1nE/juvi4hnZl1Si+xJsytEUN8Vq0BBuhhQl
	mPJ9wt6fa38LLItKxFiLWEVBxPGc5+81u3RLfBZ3Tb3/kj6NTcAuaHcgJFk/f+Ha97wR
	K7P6QP+r2fsm8Jtw76LQ5gTjF+elCuvYTal0Y=
MIME-Version: 1.0
References: <20210520154654.1791183-1-groug@kaod.org>
	<20210520154654.1791183-6-groug@kaod.org>
	<20210521120840.4658d42c@bahia.lan>
In-Reply-To: <20210521120840.4658d42c@bahia.lan>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 May 2021 14:51:56 +0200
Message-ID: <CAJfpegtgPMw-MwWEJVt_=jc76032FShFon0xXUNyWb=zJBypbg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v4 5/5] virtiofs: propagate sync() to file
	server
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: linux-kernel@vger.kernel.org, Max Reitz <mreitz@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, Robert Krawitz <rlk@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Fri, 21 May 2021 at 12:09, Greg Kurz <groug@kaod.org> wrote:

> If it looks good to you, maybe you can just merge it and
> I'll re-post the fixes separately ?

Looks good, applied.

Thanks,
Miklos

