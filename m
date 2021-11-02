DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=hvn6IK84CbRQLtjc7l/5dJ9gRPuu8dy76RLolQ2t/AM=;
	b=qeOes2SFm05r0+Umjia2PAG8jdD4k4XAmhZPdxsEBv9der0W90mE02ru69zop8Nrqa
	hVO/svx+EkayJnWXzRND3cJG6t3JfdWfGyThkj1RnWXoPj2dbSb+sneRNvceNByd3NDP
	kSusTZQN6PPsTKrF2jcjaZ9uvDqtArXDiE9UU=
MIME-Version: 1.0
References: <20211012180624.447474-1-vgoyal@redhat.com>
	<20211012180624.447474-3-vgoyal@redhat.com>
	<CAJfpegs-EHBjjnsVQdPWfH=idVENj9Aw0e-L4tjcgx3v38NJtg@mail.gmail.com>
	<YYFZl3egeX88G3FQ@redhat.com>
In-Reply-To: <YYFZl3egeX88G3FQ@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 2 Nov 2021 16:38:06 +0100
Message-ID: <CAJfpeguMLE1rgpuP7gWWNcip6R+cgp-BdDfdQGtV=TouOVEn4A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v2 2/2] fuse: Send security context of inode
	on file creation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: SElinux list <selinux@vger.kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, LSM <linux-security-module@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Tue, 2 Nov 2021 at 16:30, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Nov 02, 2021 at 03:00:30PM +0100, Miklos Szeredi wrote:
> > On Tue, 12 Oct 2021 at 20:06, Vivek Goyal <vgoyal@redhat.com> wrote:

> > > @@ -633,7 +713,29 @@ static int create_new_entry(struct fuse_mount *fm, struct fuse_args *args,
> > >         args->out_numargs = 1;
> > >         args->out_args[0].size = sizeof(outarg);
> > >         args->out_args[0].value = &outarg;
> > > +
> > > +       if (init_security) {
> >
>
> Hi Miklos,
>
> > Instead of a new arg to create_new_entry(), this could check
> > args.opcode != FUSE_LINK.
>
> Will do.
>
> >
> > > +               unsigned short idx = args->in_numargs;
> > > +
> > > +               if ((size_t)idx >= ARRAY_SIZE(args->in_args)) {
> > > +                       err = -ENOMEM;
> > > +                       goto out_put_forget_req;
> > > +               }
> > > +
> > > +               err = get_security_context(entry, mode, &security_ctx,
> > > +                                          &security_ctxlen);
> > > +               if (err)
> > > +                       goto out_put_forget_req;
> > > +
> > > +               if (security_ctxlen > 0) {
> >
> > This doesn't seem right.  How would the server know if this is arg is missing?
> >
> > I think if FUSE_SECURITY_CTX was negotiated, then the secctx header
> > will always need to be added to the MK* requests.
>
> Even for the case of FUSE_LINK request? I think I put this check because
> FUSE_LINK is not sending secctx header. Other requests are appending
> this header even if a security module is not loaded/enabled.

No, FUSE_LINK wouldn't even get this far.

> I guess it makes more sense to add secctx header even for FUSE_LINK
> request. Just that header will mention 0 security contexts are
> following. This will interface more uniform. I will make this change.

Why? FUSE_LINK is not an inode creation op, it just shares the
instantiation part with creation.

Thanks,
Miklos

