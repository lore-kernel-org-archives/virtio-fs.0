Return-Path: <miklos@szeredi.hu>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=szeredi.hu; s=google; t=1696845233; x=1697450033; darn=redhat.com;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=4T7SYiMmv73e/6ApSex0rmCrWvfOhJoVCXxcz+wzbuc=;
 b=l46R3v+of+73hYw2sveyYKag7blHDCsISfe3cxMxm31zuwVM+Y8R4H7QID45889wC6
 L9aFgJMYnbYsRIP6QRVAfTMoLrXJKDzK4TW0sh3acyYetNSQYGCXBh4hIrJ8vRoCu/BL
 LKMJN7v3FOaQf2RHmirLsqPPhe/sQFW8YDMtw=
MIME-Version: 1.0
References: <20231005203030.223489-1-vgoyal@redhat.com>
In-Reply-To: <20231005203030.223489-1-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 9 Oct 2023 11:53:42 +0200
Message-ID: <CAJfpegspVnkXAa5xfvjEQ9r5__vXpcgR4qubdG8=p=aiS2goRg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] virtiofs: Export filesystem tags through
 sysfs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, stefanha@redhat.com, mzxreary@0pointer.de, gmaglione@redhat.com

On Thu, 5 Oct 2023 at 22:30, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> virtiofs filesystem is mounted using a "tag" which is exported by the
> virtiofs device. virtiofs driver knows about all the available tags but
> these are not exported to user space.
>
> People have asked these tags to be exported to user space. Most recently
> Lennart Poettering has asked for it as he wants to scan the tags and mount
> virtiofs automatically in certain cases.
>
> https://gitlab.com/virtio-fs/virtiofsd/-/issues/128
>
> This patch exports tags through sysfs. One tag is associated with each
> virtiofs device. A new "tag" file appears under virtiofs device dir.
> Actual filesystem tag can be obtained by reading this "tag" file.
>
> For example, if a virtiofs device exports tag "myfs", a new file "tag"
> will show up here.
>
> /sys/bus/virtio/devices/virtio<N>/tag
>
> # cat /sys/bus/virtio/devices/virtio<N>/tag
> myfs
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Hi Vivek,

This needs something under Documentation/.

While the interface looks good to me, I think we need an ack on that
from the virtio maintainer.

Thanks,
Miklos

