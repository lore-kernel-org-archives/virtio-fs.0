DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=37W8TGaMYq9fdsSZ/oWmvBfLa7Md34iai9k20+Je5v8=;
	b=Ke6uANZjKR7vA/CtgRdIzIJXRk582DxKVDqpGSzjylquDV86pphvXTewuyAjurdHmZ
	y6GchW4zzV9z5NkmfE37HBY5EupivsmScUdp3s7ZwoHEb25eRSZ/Dit3jVLoG8I+CNFm
	4C15d6S6/qIcOhaXfQMCa0EM8rDc6SgewQixs=
MIME-Version: 1.0
References: <20210209224754.GG3171@redhat.com>
	<20210305133401.GA109162@redhat.com>
In-Reply-To: <20210305133401.GA109162@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 5 Mar 2021 15:48:02 +0100
Message-ID: <CAJfpegs9uCd8666YKjuhSd_0=_tqLNEmrtQEtX44=+AdcEHVdA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] virtiofs: Fail dax mount if device does not
	support it
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Linux fsdevel mailing list <linux-fsdevel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>

On Fri, Mar 5, 2021 at 2:34 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Feb 09, 2021 at 05:47:54PM -0500, Vivek Goyal wrote:
> > Right now "mount -t virtiofs -o dax myfs /mnt/virtiofs" succeeds even
> > if filesystem deivce does not have a cache window and hence DAX can't
> > be supported.
> >
> > This gives a false sense to user that they are using DAX with virtiofs
> > but fact of the matter is that they are not.
> >
> > Fix this by returning error if dax can't be supported and user has asked
> > for it.
>
> Hi Miklos,
>
> Did you get a chance to look at this patch.

Thanks for the reminder.  Pushed out now.

Miklos

