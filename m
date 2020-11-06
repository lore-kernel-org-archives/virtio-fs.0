DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=Rv9/RsPL0JaHI/Y2/xGuzlUXKuZPhDUzfIQRWQ6BFYg=;
	b=axbIyE1GQ//a2Hv9kXu9gvzEHx0dQYmWqeS9/kl0aRG87i13UD9TOqDhPx1OWnvNwj
	o5WfEKYy+VCGjKtfiEXGzNq5hNLDwY6FdT65IBtoHQxc7lOVfTUSuVen0fi6ZcdyTfQC
	MfPMFQFgUTpu/sg/PjnjO2mSwQ2aNG1EMPAWs=
MIME-Version: 1.0
References: <20201009181512.65496-1-vgoyal@redhat.com>
	<20201009181512.65496-6-vgoyal@redhat.com>
	<CAJfpegvhK+5-Zze7qZFrXkUkXbN_4M1CpEqyL9Rq9UNOtb2ckg@mail.gmail.com>
	<20201106160015.GD1436035@redhat.com>
In-Reply-To: <20201106160015.GD1436035@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 6 Nov 2020 17:33:00 +0100
Message-ID: <CAJfpeguSoeD9UgEKAz-hxZQhVku93gsv8FUWArv_hMtQEun9Dw@mail.gmail.com>
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

On Fri, Nov 6, 2020 at 5:00 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Fri, Nov 06, 2020 at 02:55:11PM +0100, Miklos Szeredi wrote:
> > On Fri, Oct 9, 2020 at 8:16 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > With FUSE_HANDLE_KILLPRIV_V2 support, server will need to kill
> > > suid/sgid/security.capability on open(O_TRUNC), if server supports
> > > FUSE_ATOMIC_O_TRUNC.
> > >
> > > But server needs to kill suid/sgid only if caller does not have
> > > CAP_FSETID. Given server does not have this information, client
> > > needs to send this info to server.
> > >
> > > So add a flag FUSE_OPEN_KILL_PRIV to fuse_open_in request which tells
> > > server to kill suid/sgid(only if group execute is set).
> >
> > This is needed for FUSE_CREATE as well (which may act as a normal open
> > in case the file exists, and no O_EXCL was specified), right?
>
> Hi Miklos,
>
> IIUC, In current code we seem to use FUSE_CREATE only if file does not exist.
> If file exists, then we probably will take FUSE_OPEN path.

That's true if the cache is up to date, one important point for
FUSE_CREATE is that it works atomically even if the cache is stale.
So if cache is negative and we send a FUSE_CREATE it may still open an
*existing* file, and we want to do suid/caps clearing in that case
also, no?

Thanks,
Miklos

