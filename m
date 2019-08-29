DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=Ul0ttpZX8OaU+EBmALZ96xYYyCTstLYpC4GnYFarZNw=;
	b=BdfA7qONrUsx4A59nrxQQRxyjZMRkrGbqIPEVHms5IqmXTPPwE1mOuiPUmLjh3idfb
	qaC5Ifvf8wMelanxFTmnu/IIA21Q8dVP2kH44Urk3sHVXB1taDT3p9kO0Bf0wtJn8NPb
	33QKwni3K68F/+upvxd3jimKoGWOkSBUfSxu0=
MIME-Version: 1.0
References: <20190821173742.24574-1-vgoyal@redhat.com>
	<CAJfpegv_XS=kLxw_FzWNM2Xao5wsn7oGbk3ow78gU8tpXwo-sg@mail.gmail.com>
	<20190829132949.GA6744@redhat.com>
In-Reply-To: <20190829132949.GA6744@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 Aug 2019 15:41:26 +0200
Message-ID: <CAJfpegtd-MQNbUW9YuL4xdXDkGR8K6LMHCqDG2Ppu9F_Hyk2RQ@mail.gmail.com>
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

On Thu, Aug 29, 2019 at 3:29 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> #ifdef CONFIG_VIRTIO_FS
>         /** virtio-fs's physically contiguous buffer for in and out args */
>         void *argbuf;
> #endif
>
> It should have worked. Not sure why it is not working.

Needs to be changed to

#if IS_ENABLED(CONFIG_VIRTIO_FS)

Pushed out fixed version.

Thanks,
Miklos

