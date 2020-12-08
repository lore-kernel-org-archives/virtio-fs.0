DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=0styejjvaAGmzemOZ5MgVk/FxItoWovN4p8t1k68Ido=;
	b=zQ9miL8kae4D2P0vHCXxyu6zOLNOtsMXBhVjDzSeDAgWDgQezVOte9VFwMnx0nJFF6
	W2W1++Tp0cqsk14cyNspQDcpKVeuChDDiv6r6hRB53n9YF6AJWWyachsJXXvs/FmcT2d
	tiKKG49oNDAx3Dfd5s7Uvnrr6wrmsyRzGcgflUNMFd1NTSHrXCLBVeUSvgak8SsEY9Ms
	gTC/ktstcbpYkqzBLGb52MSTAOY8QY+PAmfun9yn8qyH1hFwUIoRcnHy54jMGHDemWSn
	oHiy3sdklNTw4k7QZEXXOhwjv5AtQZPKbp6U2H2HW0NNed2mAxUE3wkRfSFzkB0onVLQ
	ADqA==
MIME-Version: 1.0
References: <CAFqZXNsGabHBfV36nNAVLJgEzjkBev-O3YZ1vnmXyVoaDdjiHQ@mail.gmail.com>
	<CAHC9VhRCu5W4YOzcidUhv7biVc+a4QrRknVn-57YVSM3vWZH+Q@mail.gmail.com>
	<20201207205209.GD3107@redhat.com>
In-Reply-To: <20201207205209.GD3107@redhat.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 8 Dec 2020 18:41:17 -0500
Message-ID: <CAHC9VhTHXxZRKaUybvLzPMFLP08co9e6yNjB3upVJyCPbh3=+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] virtiofs and its optional xattr support vs.
	fs_use_xattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: SElinux list <selinux@vger.kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, Zdenek Pytela <zpytela@redhat.com>

On Mon, Dec 7, 2020 at 3:52 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Dec 07, 2020 at 10:03:24AM -0500, Paul Moore wrote:
> > On Mon, Dec 7, 2020 at 9:43 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > >
> > > Hi everyone,
> > >
> > > In [1] we ran into a problem with the current handling of filesystem
> > > labeling rules. Basically, it is only possible to specify either
> > > genfscon or fs_use_xattr for a given filesystem, but in the case of
> > > virtiofs, certain mounts may support security xattrs, while other ones
> > > may not.
>
> [ cc virtio-fs list and miklos ]
> > Quickly skimming the linked GH issue, it appears that the problem
> > really lies in the fact that virtiofs allows one to enable/disable
> > xattrs at mount time.  What isn't clear to me is why one would need to
> > disable xattrs, can you explain that use case?  Why does enabling
> > xattrs in virtiofs cause problems?
>
> Its not exactly a mount time option. Its a virtiofs file server option.
>
> xattr support by default is disabled because it has performance
> penalty. Users can enable it if they want to.

Oh the number of sins against security that have been committed under
the banner of performance! ;)

Regardless, thanks for the explanation, that helps.

-- 
paul moore
www.paul-moore.com

