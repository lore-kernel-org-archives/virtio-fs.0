DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=TX2xvwAupq4mo3tJRD0vhjuXrlkWZa6Kdrd3xp27LiM=;
	b=PA2UaxG5F0GOxbAEFJ4NwShLZHnOijdUhSZ9dW22rET5aSh6EUBHOgrSiP/RWH/3Vt
	E9mE8tCdxV74eaMBeFLLF7IkvXczpmuEzml8C7ArZwtUsdU8k7Aq3BySM8vOAhHNqZ3e
	1acrITqu75SL1YIJAIixB9qTnqDqmjKpaYcpE=
MIME-Version: 1.0
References: <20201009181512.65496-1-vgoyal@redhat.com>
	<20201009181512.65496-6-vgoyal@redhat.com>
In-Reply-To: <20201009181512.65496-6-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 6 Nov 2020 14:55:11 +0100
Message-ID: <CAJfpegvhK+5-Zze7qZFrXkUkXbN_4M1CpEqyL9Rq9UNOtb2ckg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v3 5/6] fuse: Add a flag FUSE_OPEN_KILL_PRIV
	for open() request
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>

On Fri, Oct 9, 2020 at 8:16 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> With FUSE_HANDLE_KILLPRIV_V2 support, server will need to kill
> suid/sgid/security.capability on open(O_TRUNC), if server supports
> FUSE_ATOMIC_O_TRUNC.
>
> But server needs to kill suid/sgid only if caller does not have
> CAP_FSETID. Given server does not have this information, client
> needs to send this info to server.
>
> So add a flag FUSE_OPEN_KILL_PRIV to fuse_open_in request which tells
> server to kill suid/sgid(only if group execute is set).

This is needed for FUSE_CREATE as well (which may act as a normal open
in case the file exists, and no O_EXCL was specified), right?

I can edit the patch, if you agree.

Thanks,
Miklos

