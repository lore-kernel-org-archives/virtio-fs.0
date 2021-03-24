DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=cc2uWcmOYHsuFaDaziuqmdBB7HXaAseMJtvKA68Mmns=;
	b=fgVNZ/IDRPoyZoHD31LkoInkXHTy1IwCgAtx21pvGa67w88TdtZKHj3DPqEmSFUBE7
	jxwQOpaCEFAmP+Z0CfkPSiblkqKw52T+DfiHYhYkoT1DBx1ZtPgKrozdMzxIURueDQWO
	i0zTqQ5yGF608We/Ym1CTK4nXTi0CJr2AXaSo=
MIME-Version: 1.0
References: <20210318135223.1342795-1-ckuehl@redhat.com>
	<20210318135223.1342795-3-ckuehl@redhat.com>
	<YFNvH8w4l7WyEMyr@miu.piliscsaba.redhat.com>
	<04e46a8c-df26-3b58-71f8-c0b94c546d70@redhat.com>
In-Reply-To: <04e46a8c-df26-3b58-71f8-c0b94c546d70@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 24 Mar 2021 16:30:49 +0100
Message-ID: <CAJfpeguzdPV13LhXFL0U_bfKcpOHQCvg2wfxF6ryksp==tjVWA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 2/3] virtiofs: split requests that exceed
	virtqueue size
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Connor Kuehl <ckuehl@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On Wed, Mar 24, 2021 at 4:09 PM Connor Kuehl <ckuehl@redhat.com> wrote:
>
> On 3/18/21 10:17 AM, Miklos Szeredi wrote:
> > I removed the conditional compilation and renamed the limit.  Also made
> > virtio_fs_get_tree() bail out if it hit the WARN_ON().  Updated patch below.
>
> Hi Miklos,
>
> Has this patch been queued?

It's in my internal patch queue at the moment.   Will push to
fuse.git#for-next in a couple of days.

Thanks,
Miklos

