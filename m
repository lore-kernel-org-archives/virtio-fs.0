DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=KjaBcZgjWLTrEHTtpDCJSULsNJuoblFy/BpOMSjwvEM=;
	b=M34nstMF9w2PwEwyxxptnoQ8LOk/1NPBmX32lqdND3qyVp6xLvFK0yrAJdQFU4tGIz
	7Osj4zYB4Foho1S1nJ9vbuKIYTY1kcayIlEmEtWA+638OgJPgM9AamWuTQzESJMnbxEU
	Gpyk5AuqeHBZPoxyGfqs2SNlgJurH2qrOg3r4=
MIME-Version: 1.0
References: <20210930143850.1188628-1-vgoyal@redhat.com>
	<20210930143850.1188628-8-vgoyal@redhat.com>
In-Reply-To: <20210930143850.1188628-8-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 6 Oct 2021 14:55:16 +0200
Message-ID: <CAJfpegu5Y5X_CcKS9hsoW3ao5+WPJjm-6hsMVEiGU8PjSKy2gg@mail.gmail.com>
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
>
> As of now we don't support blocking variant of posix locks and daemon
> returns -EOPNOTSUPP. Reason being that it can lead to deadlocks.
> Virtqueue size is limited and it is possible we fill virtqueue with
> all the requests of fcntl(F_SETLKW) and wait for reply. And later a
> subsequent unlock request can't make progress because virtqueue is full.
> And that means F_SETLKW can't make progress and we are deadlocked.
>
> This problem is not limited to posix locks only. I think blocking remote
> flock and open file description locks should face the same issue. Right
> now fuse does not support open file description locks, so its not
> a problem. But fuse/virtiofs does support remote flock and they can use
> same mechanism too.
>
> Use notification queue to solve this problem. After submitting lock
> request device will send a reply asking requester to wait. Once lock is
> available, requester will get a notification saying lock is available.
> That way we don't keep the request virtueue busy while we are waiting for
> lock and further unlock requests can make progress.
>
> When we get a reply in response to lock request, we need a way to know
> if we need to wait for notification or not. I have overloaded the
> fuse_out_header->error field. If value is ->error is 1, that's a signal
> to caller to wait for lock notification. Overloading ->error in this way
> is not the best way to do it. But I am running out of ideas.

Since all values besides -511..0 are reserved this seems okay.
However this needs to be a named value and added to uapi/linux/fuse.h.

