DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=vg14DGUUTv8H89VUwzRZsbktcbP23wgUdWgjdUjfNQA=;
	b=dEX2+30aTsCAIysXdZvVJFU14uPr90OtNVrO7vOwLZJuVg1Ttkl0JjOa26DSWWRwVg
	RQhMmdjxeyMFgAAr8jTCR/nr0nymCith0gbs8dQEcNH/6YjiuFULZrdElioNOkJDXGli
	DcxQskqpumXcVMzbfls6BcagbkAcAO6FTBBX0=
MIME-Version: 1.0
References: <20200722090758.3221812-1-chirantan@chromium.org>
In-Reply-To: <20200722090758.3221812-1-chirantan@chromium.org>
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Fri, 14 Aug 2020 14:20:33 +0900
Message-ID: <CAJFHJrr+B=xszNvdkmksG5ULPy_nKpn4_MS9_Pnq6ySkkb5y6g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [RESEND] [PATCHv4 1/2] uapi: fuse: Add
	FUSE_SECURITY_CTX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>, Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>, Suleiman Souhlal <suleiman@chromium.org>, virtio-fs-list <virtio-fs@redhat.com>, SElinux list <selinux@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Dylan Reid <dgreid@chromium.org>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Jul 22, 2020 at 6:09 PM Chirantan Ekbote <chirantan@chromium.org> wrote:
>
> Add the FUSE_SECURITY_CTX flag for the `flags` field of the
> fuse_init_out struct.  When this flag is set the kernel will append the
> security context for a newly created inode to the request (create,
> mkdir, mknod, and symlink).  The server is responsible for ensuring that
> the inode appears atomically with the requested security context.
>
> For example, if the server is backed by a "real" linux file system then
> it can write the security context value to
> /proc/thread-self/attr/fscreate before making the syscall to create the
> inode.
>

Friendly ping. Will this (and the next patch in the series) be merged into 5.9?

Chirantan


Chirantan

