DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=71+P9Y1aQOgw6Dp9fK4XNoBcCfSmpfYHfETpowIUBEc=;
	b=mOY+F7IoXze5/oEY9qnxW4BtDV3c6OGnOM65rcAz4tBQ+pP1oCmZx3kBCsHFdm9ssi
	tdD9aqu1qDCinK7SZKtFdQ7WsDaXA5OVnxl3jnwgL/Rl00M0BEsmJ/uoAk72kSFu5qei
	FYQzoLZKR/w9+CtVp9n067d669r/fYv2PpYlk=
MIME-Version: 1.0
References: <20190905194859.16219-1-vgoyal@redhat.com>
In-Reply-To: <20190905194859.16219-1-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 6 Sep 2019 10:15:14 +0200
Message-ID: <CAJfpegu8POz9gC4MDEcXxDWBD0giUNFgJhMEzntJX_u4+cS9Zw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 00/18] virtiofs: Fix various races and
	cleanups round 1
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org

On Thu, Sep 5, 2019 at 9:49 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Hi,
>
> Michael Tsirkin pointed out issues w.r.t various locking related TODO
> items and races w.r.t device removal.
>
> In this first round of cleanups, I have taken care of most pressing
> issues.
>
> These patches apply on top of following.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git#virtiofs-v4
>
> I have tested these patches with mount/umount and device removal using
> qemu monitor. For example.

Is device removal mandatory?  Can't this be made a non-removable
device?  Is there a good reason why removing the virtio-fs device
makes sense?

Thanks,
Miklos

