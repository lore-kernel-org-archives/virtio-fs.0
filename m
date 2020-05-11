DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=G6rfSAq7VRiDOfN0G3BRn36tCGRPl0zkuCoZTRKLtCw=;
	b=ksZIGkW+yvvjbtaY2nNzmZwckBW1OR2ggJMaLYqFwgO5Iu+2GnXjxZzPNnrp3/IIke
	b7bHFtuIZmo6tmJXpcd5zp9vAqEnXB8ttdPhFUYu3lLj++m66sXLAKcO/urN46d+U5Uc
	k4gUgv8mKouRPRTiLfhwp/ZrB0tt3VukPk4do=
MIME-Version: 1.0
References: <1588778444-28375-1-git-send-email-eguan@linux.alibaba.com>
In-Reply-To: <1588778444-28375-1-git-send-email-eguan@linux.alibaba.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 11 May 2020 15:06:08 +0200
Message-ID: <CAJfpegsivYq68FjSxAGnszcPJBrJrYG5Gojsc8T+PKup0Cm8fw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH RFC] fuse: invalidate inode attr in
	writeback cache mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eryu Guan <eguan@linux.alibaba.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>

On Wed, May 6, 2020 at 5:21 PM Eryu Guan <eguan@linux.alibaba.com> wrote:
>
> Under writeback mode, inode->i_blocks is not updated, making utils like
> du read st.blocks as 0.
>
> For example, when using virtiofs (cache=always & nondax mode) with
> writeback_cache enabled, writing a new file and check its disk usage
> with du, du reports 0 usage.

Hmm... invalidating the attribute might also yield the wrong result as
the server may not have received the WRITE request that modifies the
underlying file.

Invalidating attributes at the end of fuse_flush() definitely makes
sense, though.

If we wanted 100% correct behavior, we'd need to flush WRITE requests
before each GETATTR request.  That might be a performance bottleneck,
though.

So first I'd just try doing the invalidation from fuse_flush().

Thanks,
Miklos

