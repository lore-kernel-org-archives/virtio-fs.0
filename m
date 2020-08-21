DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=9GdKxeOACY7uALRLtrv9oRSnF/gGqv6TA6L3Hiy25go=;
	b=hpiahwg9EH78MVjDWcW2rVaybIwoFsRbpdb0j63ncz9A2OgxnMI6zATzZRAYMsp1Nc
	x2OugxjWwVfSOPOhbrEQz35nU9ExDSz1+WGWhYI6hahz5uBrkN8c0RhYO6Zw3eYd/Hia
	bu9mRNzG9ehDQ0B2ekOU+jdtUAAf1KNc37fXI=
MIME-Version: 1.0
References: <20200724183812.19573-1-vgoyal@redhat.com>
In-Reply-To: <20200724183812.19573-1-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Aug 2020 16:46:44 +0200
Message-ID: <CAJfpeguzG3tfjHkToikA+v4Pu7iEa7Y=RxaO+SnycZHxFHRLGg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [RFC PATCH 0/5] fuse: Implement
 FUSE_HANDLE_KILLPRIV_V2 and enable SB_NOSEC
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

> If you are concerned about regression w.r.t clear of caps, then we
> can think of enabling SB_NOSEC conditionally. Say user chooses it
> as mount option. But given caps is just an outlier and currently
> we clear suid/sgid based on cache (and not based on state on server),
> I feel it might not be a huge issue.
>
> What do you think?

I think enabling xattr caching should be a separate feature, and yes,
SB_NOSEC would effectively enable xattr caching.

We could add the FUSE_CACHE_XATTR feature flag without actually adding
real caching, just SB_NOSEC...

Does that sound sane?

Thanks,
Miklos

