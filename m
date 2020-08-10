DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=CquD0s9C4x3ETpaALuSLXwVqkmCKd258dwzlSXP4DNs=;
	b=S2DnfquUHkVrQ3lZVZC1emkh4OCaAvpJvC5YFe8+WX6NKsOIK7gbvBx/6LZgrhozk7
	CFbSDsCdO1bYMfX6mAIinY2M5dta1plFEJhbQJA6IDjdZX4QYOF8Qga7R0zegK/Swnxn
	GUzWkJocv9oeIfkHDemI3ud7ojPTlett6S974=
MIME-Version: 1.0
References: <20200807195526.426056-1-vgoyal@redhat.com>
	<20200807195526.426056-19-vgoyal@redhat.com>
In-Reply-To: <20200807195526.426056-19-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 10 Aug 2020 10:29:13 +0200
Message-ID: <CAJfpegs1CtPMaVmbDc__N0Fc3FkNEe=vQOkrr8RKiiS6NqTyHA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v2 18/20] fuse: Release file in process
	context
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, linux-kernel@vger.kernel.org

On Fri, Aug 7, 2020 at 9:55 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> fuse_file_put(sync) can be called with sync=true/false. If sync=true,
> it waits for release request response and then calls iput() in the
> caller's context. If sync=false, it does not wait for release request
> response, frees the fuse_file struct immediately and req->end function
> does the iput().
>
> iput() can be a problem with DAX if called in req->end context. If this
> is last reference to inode (VFS has let go its reference already), then
> iput() will clean DAX mappings as well and send REMOVEMAPPING requests
> and wait for completion. (All the the worker thread context which is
> processing fuse replies from daemon on the host).
>
> That means it blocks worker thread and it stops processing further
> replies and system deadlocks.

Is this reasoning specific to DAX?  Seems to me this is a virtio-fs
specific issue.

Thanks,
Miklos

