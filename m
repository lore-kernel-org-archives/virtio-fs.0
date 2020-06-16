DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=vbO9qGecYmWXUD37SUob42kXBPCWyMyGCznqgXAEuis=;
	b=Keh5C5dNltLNDS2F1Npj/VN3K++TmHgh7nTPacEIM2BOK+xGgVI7UcTLmX/G1wxYLV
	bH3I8lohkmiAv+0i53hLMJefz/kGA6oQ0pJp80i3BesKw5osPZMjaq6yUOtdlR7/JAsB
	iNjzi0tNPIeQx8YAxxsHUz2hTsz5jDigZC7IA=
MIME-Version: 1.0
References: <20200601053214.201723-1-chirantan@chromium.org>
	<20200610092744.140038-1-chirantan@chromium.org>
	<CAJfpegs4Dt9gjQPQch=i_GW5EtBVaycG0_nD11xspG3x8f_W9Q@mail.gmail.com>
In-Reply-To: <CAJfpegs4Dt9gjQPQch=i_GW5EtBVaycG0_nD11xspG3x8f_W9Q@mail.gmail.com>
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Tue, 16 Jun 2020 18:41:35 +0900
Message-ID: <CAJFHJrr7VKD-gumaG5uQ_SPKUTzN+g98rh-rKFWUV7vcGNafHQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v2] RFC: fuse: Call security hooks on new
	inodes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Suleiman Souhlal <suleiman@chromium.org>, virtio-fs-list <virtio-fs@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Dylan Reid <dgreid@chromium.org>, Vivek Goyal <vgoyal@redhat.com>

On Tue, Jun 16, 2020 at 6:29 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Wed, Jun 10, 2020 at 11:27 AM Chirantan Ekbote
> <chirantan@chromium.org> wrote:
> >
> >
> > When set to true, get the security context for a newly created inode via
> > `security_dentry_init_security` and append it to the create, mkdir,
> > mknod, and symlink requests.  The server should use this context by
> > writing it to `/proc/thread-self/attr/fscreate` before creating the
> > requested inode.
>
> This is confusing.  You mean if the server is stacking on top of a
> real fs, then it can force the created new inode to have the given
> security attributes by writing to that proc file?
>

Yes that's correct.  Writing to that proc file ends up setting a field
in an selinux struct in the kernel.  Later, when an inode is created
the selinux security hook uses that field to determine the label that
should be applied to the inode.  This ensures that inodes appear
atomically with the correct selinux labels.  Most users actually end
up using setfscreatecon from libselinux but all that does is write to
/proc/thread-self/attr/fscreate itself after doing some
conversion/validation.

> >
> >  static void fuse_advise_use_readdirplus(struct inode *dir)
> >  {
> > @@ -442,6 +445,8 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
> >         struct fuse_entry_out outentry;
> >         struct fuse_inode *fi;
> >         struct fuse_file *ff;
> > +       void *security_ctx = NULL;
> > +       u32 security_ctxlen = 0;
> >
> >         /* Userspace expects S_IFREG in create mode */
> >         BUG_ON((mode & S_IFMT) != S_IFREG);
> > @@ -477,6 +482,21 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
> >         args.out_args[0].value = &outentry;
> >         args.out_args[1].size = sizeof(outopen);
> >         args.out_args[1].value = &outopen;
> > +
> > +       if (fc->init_security) {
> > +               err = security_dentry_init_security(entry, mode, &entry->d_name,
> > +                                                   &security_ctx,
> > +                                                   &security_ctxlen);
> > +               if (err)
> > +                       goto out_put_forget_req;
> > +
> > +               if (security_ctxlen > 0) {
> > +                       args.in_numargs = 3;
> > +                       args.in_args[2].size = security_ctxlen;
> > +                       args.in_args[2].value = security_ctx;
> > +               }
> > +       }
> > +
>
> The above is quadruplicated, a helper is in order.

Ack.

>
> >         err = fuse_simple_request(fc, &args);
> >         if (err)
> >                 goto out_free_ff;
> > @@ -513,6 +533,8 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
> >         return err;
> >
> >  out_free_ff:
> > +       if (security_ctxlen > 0)
> > +               kfree(security_ctx);
>
> Freeing NULL is okay, if that's guaranteed in case of security_ctxlen
> == 0, then you need not check that condition.

Ack.  Will fix in v3.

