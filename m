MIME-Version: 1.0
References: <20200108152425.GD1995@redhat.com>
In-Reply-To: <20200108152425.GD1995@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Wed, 8 Jan 2020 16:42:46 +0100
Message-ID: <CAOssrKdomzxQsMh3FeQYN+HdLt-MSoZOi_MnWAbbf3P=U8ToPA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Enable xattr support by default
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Wed, Jan 8, 2020 at 4:24 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Enable xattr support by default. Currently it is disabled by defaut
> and that makes getfattr/setfattr fail in guest.

I think the reason this was disabled by default is that it's a
significant performance hit for "ls" due to missing xattr caching.
Not sure how much it affects other workloads.

Thanks,
Miklos


