DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=0q53YT3XvFhfsnGqeW9X6BJ+dZY91toW3fLTVzpHF0o=;
	b=FsScJHrbC+3N+bhSBxfEBjdFNbD1Frd1EN89LdKobKzBcJ3Q5nlzjZuHc7/pjbKvF8
	TLSXS+duH1CFsS0pDsGjgnRWjlBBGSP2hzteI8XT8ki+F+bmepRClnu8uRCeL1QyD1B/
	zDMbq3L0LRqJKJ9uw6Q1sojsvYhIXOFvQDLFk=
MIME-Version: 1.0
References: <20210812054618.26057-1-jefflexu@linux.alibaba.com>
	<20210812054618.26057-2-jefflexu@linux.alibaba.com>
In-Reply-To: <20210812054618.26057-2-jefflexu@linux.alibaba.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 7 Sep 2021 10:34:43 +0200
Message-ID: <CAJfpegs3QGVNa4CXt0Hayr=G50cQb1TWowRDuVf0pZv6FYV3kw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 1/2] fuse: disable atomic_o_trunc if no_open
	is enabled
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On Thu, 12 Aug 2021 at 07:46, Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
>
> From: Liu Bo <bo.liu@linux.alibaba.com>
>
> When 'no_open' is used by virtiofsd, guest kernel won't send OPEN request
> any more.  However, with atomic_o_trunc, SETATTR request is also omitted in
> OPEN(O_TRUNC) so that the backend file is not truncated.  With a following
> GETATTR, inode size on guest side is updated to be same with that on host
> side, the end result is that O_TRUNC semantic is broken.
>
> This disables atomic_o_trunc as well if with no_open.

I don't quite get it why one would want to enable atomic_o_trunc with
no_open in the first place?

Thanks,
Miklos

