DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=7kmZfKphmPDJyPhB1aEwSutJQo/nVZHIpGqlV62NkC0=;
	b=CQYTV7T/6dptI2gBfu2uXwU4RqC1UIrULXwa1LcNs212HPvwiKRj5wzH9w17HNj1/S
	xgABLrdaMQrQKih8MZ3en05XSPZ6cYtpvN8zEPBJT0wL6K+HI44uIDZofAFjGDHjjwcZ
	LWo+0RcMIe0icmrDfhi9RpZ6cZJmo1ANKTqLA=
MIME-Version: 1.0
References: <20190821173742.24574-1-vgoyal@redhat.com>
	<CAJfpegv_XS=kLxw_FzWNM2Xao5wsn7oGbk3ow78gU8tpXwo-sg@mail.gmail.com>
	<20190829132949.GA6744@redhat.com>
	<CAJfpegtd-MQNbUW9YuL4xdXDkGR8K6LMHCqDG2Ppu9F_Hyk2RQ@mail.gmail.com>
	<20190829143107.GB6744@redhat.com>
In-Reply-To: <20190829143107.GB6744@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 Aug 2019 16:47:17 +0200
Message-ID: <CAJfpegtOC8dHofLmpYpryKv9+93KHwn9Xb-NCyvgg0rG8XspTw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v3 00/13] virtio-fs: shared file system for
	virtual machines
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org

On Thu, Aug 29, 2019 at 4:31 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> Cool. That works. Faced another compilation error with "make allmodconfig"
> config file.
>
>   HDRINST usr/include/linux/virtio_fs.h
> error: include/uapi/linux/virtio_fs.h: missing "WITH Linux-syscall-note" for SPDX-License-Identifier
> make[1]: *** [scripts/Makefile.headersinst:66: usr/include/linux/virtio_fs.h] Error 1
>
> Looks like include/uapi/linux/virtio_fs.h needs following.
>
> -/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
> +/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */

Fixed and pushed.

Thanks,
Miklos

