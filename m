DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=I7xiJvvblsTV5IXytyvrj4LJ0qb4rQ21aY+usBJ+RoI=;
	b=HxqnyvOm30lKHERhqJk/wrxbr+pxSYu4X6waf5EP+c/lFbNZQRCn8itQSf5q5CYQFt
	ZaU+CX1yKRUWoYsg4LzOYBmP8vhap1oc8jmpUCRlQF0g4HLEQ+2pBhJ6iIYNaBNum7sy
	RwWsh5KBUiGtJoBv7n0Ltk1p8iw2zdsz8ot1E=
MIME-Version: 1.0
References: <20200929185015.GG220516@redhat.com>
	<CAOQ4uxgMeWF_vitenBY6_N3Eu-ix92q8AO5ckDAF+SVxHTBXXw@mail.gmail.com>
	<20200930130222.GA267985@redhat.com>
In-Reply-To: <20200930130222.GA267985@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 30 Sep 2020 15:38:37 +0200
Message-ID: <CAJfpegvJOwd8-x8WJCY5disScnGrRXN3t+pD2O6_iYQMxdKcLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [RFC PATCH] fuse: update attributes on read() only
	on timeout
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Linux fsdevel mailing list <linux-fsdevel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, Brian Foster <bfoster@redhat.com>, Amir Goldstein <amir73il@gmail.com>

On Wed, Sep 30, 2020 at 3:02 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Sep 30, 2020 at 07:35:57AM +0300, Amir Goldstein wrote:

> > I wonder out loud if this change of behavior you proposed is a good opportunity
> > to introduce some of the verbs from SMB oplocks / NFS delegations into the
> > FUSE protocol in order to allow finer grained control over per-file
> > (and later also
> > per-directory) caching behavior.
>
> May be. How will NFS delegation help with cache invalidation issue. I
> mean if client B has the lease and modifying file, then client A will
> still need to know when client B has modified the file and invalidate
> its own caches.

Right.   So the way it would work in the mixed read-write workload is
that the client tries to obtain a WRITE lease for the file.

a) it could obtain the lease: it can do cached reads and writes
without having to go to the server until the cache is flushed
naturally or the lease is revoked.

b) it can't obtain the lease: client will disable cache and let server
manage coherency (cache=none basically).

For a read-only workload the same happens but only a READ lease is
requested.  The nice thing  is that multiple entities can have a READ
lease on the file as long as it is not being modified.

So this is best of both worlds, optimized for the non-contended case,
but still consistent for the case when the file is being read/modified
by more than one entity.

Thanks,
Miklos

