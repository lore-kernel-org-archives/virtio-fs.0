DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=WxNG5RN2hoFSDN98UXNrt2eLopXcYkRuq6vbl8JTP4I=;
	b=jeOCjcqHWRuh7dVt6kyPIOd+XHEy3VxDLMtocFh13ZMnJ5/zRfWLBYn1bfd4wscvh6
	DO4SHEFwO8hrR4zZ1DAKLrjPVhRKtxp8EtTLsorHk7u+/8kLY25txny1BprFIBHMwB5D
	y0KmUJDK+krmyTuS3jaKwkZyWpXZk0Zq05QeY=
MIME-Version: 1.0
References: <20200724183812.19573-1-vgoyal@redhat.com>
	<CAJfpeguzG3tfjHkToikA+v4Pu7iEa7Y=RxaO+SnycZHxFHRLGg@mail.gmail.com>
	<20200821200232.GA905782@redhat.com>
In-Reply-To: <20200821200232.GA905782@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Aug 2020 10:43:04 +0200
Message-ID: <CAJfpegsMu+_bjg4iEBCr-pG4jsVg7DKs+aH+jNwicoMpWsM-tw@mail.gmail.com>
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

On Fri, Aug 21, 2020 at 10:02 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> So how about, we instead implement a flag which tells fuse that
> file server is implementing a local filesystem and it does not
> expect anything to changed outside fuse. This will make sure
> distributed filesystems like gluster don't regress because
> of this change and a class of local filesystems can gain from
> this. Once we support sharing mode in virtiofs, then we will
> need to revisit it again and do it right for distributed
> filesystems (depending on their invalidation mechanism).

Okay, sounds good.

This flag can be set on "cache=always" in virtiofsd.

Thanks,
Miklos

