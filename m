DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=xexEpJdvSs8WA8ytXi5Jvt5/cU1ono4iJfJ2H9LSanI=;
	b=XPTZYNUAGTD6PuQEs5Xnr6OTxYtUaCDBi3AEe+52RdarJKKJnE5CizERVElvjXPzKM
	4d/gtP5lgLu4BDUhPptbBVeRvJrT8oRMEDkKjqKvP9rskHDrmLI5sBGKPAdreEiq4WCU
	/9E9J0lxb4EB7BEUXcFWSyv/3YC8Q4ZRLXyQ0=
MIME-Version: 1.0
References: <20210930143850.1188628-1-vgoyal@redhat.com>
	<20210930143850.1188628-8-vgoyal@redhat.com>
In-Reply-To: <20210930143850.1188628-8-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 6 Oct 2021 15:02:36 +0200
Message-ID: <CAJfpegtdftj7jQFu+4LBjysiAJ-hhLHkBC_KhowfJtepvZqaoQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 7/8] virtiofs: Add new notification type
	FUSE_NOTIFY_LOCK
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org

On Thu, 30 Sept 2021 at 16:39, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Add a new notification type FUSE_NOTIFY_LOCK. This notification can be
> sent by file server to signifiy that a previous locking request has
> completed and actual caller should be woken up.

Shouldn't this also be generic instead of lock specific?

I.e. generic header  + original outarg.

Thanks,
Miklos

