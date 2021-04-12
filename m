DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=QKoalR9J+WU3bjJGvLXhcQGEnQVWi1PGcVr9Ehq2xVw=;
	b=fO8IYqoAwqhSlT3rrWn1yQEJTVt/QiQ4YaIlpZNtUdao/p4yykiL30R1EcDI+8i3+r
	U1TwTh50+L3N2MWymVR8NBXzztI/a3DCetrwXiLjJTqgFbzHBt/ZL2A54f+a3qXJYySM
	bW+ItRLEPOg5Gy7H+mSdpK8NM7IVQeI/qIgmw=
MIME-Version: 1.0
References: <20210317084443.22657-1-lhenriques@suse.de>
In-Reply-To: <20210317084443.22657-1-lhenriques@suse.de>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 Apr 2021 17:16:29 +0200
Message-ID: <CAJfpegtpjw8OEvVwxvhz91jozt4GU6XxWB4MrKmjNOWVPf_qdw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v2] virtiofs: fix memory leak in
	virtio_fs_probe()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Luis Henriques <lhenriques@suse.de>
Cc: linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>, virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On Wed, Mar 17, 2021 at 9:43 AM Luis Henriques <lhenriques@suse.de> wrote:
>
> When accidentally passing twice the same tag to qemu, kmemleak ended up
> reporting a memory leak in virtiofs.  Also, looking at the log I saw the
> following error (that's when I realised the duplicated tag):
>
>   virtiofs: probe of virtio5 failed with error -17
>
> Here's the kmemleak log for reference:
>
> unreferenced object 0xffff888103d47800 (size 1024):
>   comm "systemd-udevd", pid 118, jiffies 4294893780 (age 18.340s)
>   hex dump (first 32 bytes):
>     00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
>     ff ff ff ff ff ff ff ff 80 90 02 a0 ff ff ff ff  ................
>   backtrace:
>     [<000000000ebb87c1>] virtio_fs_probe+0x171/0x7ae [virtiofs]
>     [<00000000f8aca419>] virtio_dev_probe+0x15f/0x210
>     [<000000004d6baf3c>] really_probe+0xea/0x430
>     [<00000000a6ceeac8>] device_driver_attach+0xa8/0xb0
>     [<00000000196f47a7>] __driver_attach+0x98/0x140
>     [<000000000b20601d>] bus_for_each_dev+0x7b/0xc0
>     [<00000000399c7b7f>] bus_add_driver+0x11b/0x1f0
>     [<0000000032b09ba7>] driver_register+0x8f/0xe0
>     [<00000000cdd55998>] 0xffffffffa002c013
>     [<000000000ea196a2>] do_one_initcall+0x64/0x2e0
>     [<0000000008f727ce>] do_init_module+0x5c/0x260
>     [<000000003cdedab6>] __do_sys_finit_module+0xb5/0x120
>     [<00000000ad2f48c6>] do_syscall_64+0x33/0x40
>     [<00000000809526b5>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
> Changes since v1:
> - Use kfree() to free fs->vqs instead of calling virtio_fs_put()

Applied, thanks.

Miklos

