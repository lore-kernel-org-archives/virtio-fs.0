DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=0Q3HOIVTiQQjN2WQrPLYQE1BmRGFiieaz+rA81DvnjU=;
	b=ZZWD9OpNRL0XtYFi2lFZlHxSZinqyJ8TpyLRrYC9iPu82pocpeGILmNJueXE79tL46
	Hx3iIG3SHdJuf3SlJEy1VlbhChjRlBUg7MhHjF0H71LlBWYxfvIQWax+sVjsQt5WUM/v
	VduNLbytEHMvZQWgrRu0W2b2t0rKniNs6zLPs=
MIME-Version: 1.0
References: <20190829134104.23653-1-stefanha@redhat.com>
In-Reply-To: <20190829134104.23653-1-stefanha@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 Aug 2019 15:48:56 +0200
Message-ID: <CAJfpegsMwGLryccnOR5a0RTFKjv3jH4g0DQt-HpkSQTwZgHyKw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] virtio-fs: add
	Documentation/filesystems/virtiofs.rst
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On Thu, Aug 29, 2019 at 3:41 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> Add information about the new "virtiofs" file system.

Thanks, applied.

Miklos

