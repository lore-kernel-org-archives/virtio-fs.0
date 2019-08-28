DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=gqkmpot9s6gPML1W2+U08e8kxWH1kqOpgIslvJ6ETaY=;
	b=dhNnulrZXhgiY7H6M+oJdiiIwYTeim61SHJlStKeam/O6Txv6bzIsCPGf1aTvCiGGC
	TX4oGm3mf/6F7uOsTWqquRw/W1VoA3P0uDRu7tmP2WSvzGWA/XKlTEvFiY+1asbMoW5T
	GOEa9uhLbKi979xcEOROpziFYXdhp8Wq1Mgow=
MIME-Version: 1.0
References: <20190821173742.24574-1-vgoyal@redhat.com>
	<20190821173742.24574-3-vgoyal@redhat.com>
In-Reply-To: <20190821173742.24574-3-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 Aug 2019 09:45:28 +0200
Message-ID: <CAJfpegu41FYEBfniEBPtujgLW4nC+w6_6VG2EmNi=kC8ZeNFtA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 02/13] fuse: Use default_file_splice_read
	for direct IO
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On Wed, Aug 21, 2019 at 7:38 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> From: Miklos Szeredi <mszeredi@redhat.com>

Nice patch, except I have no idea why I did this.  Splice with
FOPEN_DIRECT_IO  seems to work fine without it.

Anyway, I'll just drop this, unless someone has an idea why it is
actually needed.

Thanks,
Miklos

