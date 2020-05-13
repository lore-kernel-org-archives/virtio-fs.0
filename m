DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=1n37Br68mT3eu7bt7O2ori7dTgHwPTR+OlLQZux388k=;
	b=kZwzRgOVSQWkZ6cKU5Hp+/CoTc4SrRaCmdeB1VmystM7ZjNS9JynkDBfxHfX3j5HTs
	k2EIsIbbu4slPHjLlLAQLp9VZmHdqfus9YuLcG65X9OxgGoqYz6C6xwQzzdMaIsUfako
	mR0G9mWsvU9MJeaqmYJHG3T7cj0GnQgTpj6K8=
MIME-Version: 1.0
References: <1588778444-28375-1-git-send-email-eguan@linux.alibaba.com>
	<20200512022904.75689-1-eguan@linux.alibaba.com>
In-Reply-To: <20200512022904.75689-1-eguan@linux.alibaba.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 13 May 2020 11:39:34 +0200
Message-ID: <CAJfpegsVN-DuruF8E-hq2dxhsEciPOA+pBUdZSu6VHb3VAiTRw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v2] fuse: invalidate inode attr in writeback
	cache mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eryu Guan <eguan@linux.alibaba.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>

On Tue, May 12, 2020 at 4:29 AM Eryu Guan <eguan@linux.alibaba.com> wrote:
>
> Under writeback mode, inode->i_blocks is not updated, making utils du
> read st.blocks as 0.
>
> For example, when using virtiofs (cache=always & nondax mode) with
> writeback_cache enabled, writing a new file and check its disk usage
> with du, du reports 0 usage.
>
>   # uname -r
>   5.6.0-rc6+
>   # mount -t virtiofs virtiofs /mnt/virtiofs
>   # rm -f /mnt/virtiofs/testfile
>
>   # create new file and do extend write
>   # xfs_io -fc "pwrite 0 4k" /mnt/virtiofs/testfile
>   wrote 4096/4096 bytes at offset 0
>   4 KiB, 1 ops; 0.0001 sec (28.103 MiB/sec and 7194.2446 ops/sec)
>   # du -k /mnt/virtiofs/testfile
>   0               <==== disk usage is 0
>   # stat -c %s,%b /mnt/virtiofs/testfile
>   4096,0          <==== i_size is correct, but st_blocks is 0
>
> Fix it by invalidating attr in fuse_flush(), so we get up-to-date attr
> from server on next getattr.

Thanks, applied.

I started thinking: why is fuse_flush() only writing out dirty pages
if fc->no_flush is false?   It just doesn't make sense...  But that's
an independent bug, and I'll do a separate patch for that.

Thanks,
Miklos

