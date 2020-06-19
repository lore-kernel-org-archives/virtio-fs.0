DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=892xWMh1+vvidwxM0vd7W+Apqra00tDOkRAFYadbIlM=;
	b=fZacZoMW2LFP/V8rnrhWNwJ6hIRlvXIg3L1qB/qdpUZlDhCgAJZSPu9FQ6y3pLRPuY
	F7VFs/HPH35BRHVOW44BSIpLkfMqNI71xNb1UZhYDzjsYbgGlyiSqH0MCs8zoAEhDY4z
	F7uSWYZ8G3QWakRZpGSb2oEDXF+z3nhVveJ48=
MIME-Version: 1.0
References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200618190816.GD3814@redhat.com>
In-Reply-To: <20200618190816.GD3814@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 19 Jun 2020 16:16:30 +0200
Message-ID: <CAJfpegsfqADmK6foDyuQQnvMDh_jE0rNUCBRuxPchSSirrb04Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: drop Linux capabilities(7)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Thu, Jun 18, 2020 at 9:08 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Thu, Apr 16, 2020 at 05:49:05PM +0100, Stefan Hajnoczi wrote:
> > virtiofsd doesn't need of all Linux capabilities(7) available to root.  Keep a
> > whitelisted set of capabilities that we require.  This improves security in
> > case virtiofsd is compromised by making it hard for an attacker to gain further
> > access to the system.
>
> Hi Stefan,
>
> I just noticed that this patch set breaks overlayfs on top of virtiofs.

How so?  Virtiofs isn't mounting overlayfs, is it?  Only the mounter
requires CAP_SYS_ADMIN, not the accessor.

Thanks,
Miklos

