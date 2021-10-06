DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=W5RbKdU0RdNE/VuLnONY3GNvrkAEDf0Jgqqzk1poVuk=;
	b=gTTpjcVz8RI+018/o+5OKjln50wQrwHs0GBpGVGFAktAYafJviz/6TqixLy+6eJDvC
	0DvBvq3LGN07BsrieLoXfX7p8Lv3mCZqzSQPTdw2isDnesJR+DWPj4p+6F2uv5p30btS
	cxdRHxmqARBygmNzVltGZgP2wbgpew9NvACqE=
MIME-Version: 1.0
References: <20210930143850.1188628-1-vgoyal@redhat.com>
	<20210930143850.1188628-6-vgoyal@redhat.com>
In-Reply-To: <20210930143850.1188628-6-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 6 Oct 2021 14:46:46 +0200
Message-ID: <CAJfpeguTohOfd60+vkVMBOHEfcT4T5hTuWtE2pqCLStNTHuZFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 5/8] virtiofs: Add a virtqueue for
	notifications
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org

On Thu, 30 Sept 2021 at 16:39, Vivek Goyal <vgoyal@redhat.com> wrote:

> @@ -34,10 +35,12 @@ static LIST_HEAD(virtio_fs_instances);
>
>  enum {
>         VQ_TYPE_HIPRIO,
> -       VQ_TYPE_REQUEST
> +       VQ_TYPE_REQUEST,
> +       VQ_TYPE_NOTIFY
>  };
>
>  #define VQ_NAME_LEN    24
> +#define VQ_NOTIFY_ELEMS 16     /* Number of notification elements */

Where does this number come from?

Thanks,
Miklos

