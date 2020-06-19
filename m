Date: Fri, 19 Jun 2020 12:12:44 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200619111244.GE2690@work-vm>
References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200618190816.GD3814@redhat.com> <20200618191655.GI2769@work-vm>
	<20200618192717.GE3814@redhat.com>
	<CAJFHJrrJzPLatNvw2xC3WYLbzCW0+DB+4UczQHGPBF9p+WGYQA@mail.gmail.com>
	<20200619083953.GB2690@work-vm>
	<CAJFHJrpRGJ=myQzJtxjgQhHdbyhGXhz_N24=xJTKM4JqhhZG2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJFHJrpRGJ=myQzJtxjgQhHdbyhGXhz_N24=xJTKM4JqhhZG2g@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: drop Linux capabilities(7)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

* Chirantan Ekbote (chirantan@chromium.org) wrote:
> On Fri, Jun 19, 2020 at 5:40 PM Dr. David Alan Gilbert
> <dgilbert@redhat.com> wrote:
> >
> > * Chirantan Ekbote (chirantan@chromium.org) wrote:
> >
> > > We ended up working around it by prefixing "user.virtiofs." to the
> > > xattr name[2], which has its own problems but there was pretty much no
> > > chance that we would be able to give the fs device CAP_SYS_ADMIN in
> > > the init namespace.
> >
> >
> > What problems did you hit with that?  We should standardise the renaming
> > so we make an on-disc format that's compatible.
> >
> 
> I guess what I meant by problems is that it made what was previously a
> simple and straightforward implementation into something more complex
> and added some limitations.

Yeh.

>  For example, we now need to parse the
> result of the listxattr system call and strip out the prefix from any
> name in the list.  It also means that we cannot allow the guest to
> directly set or remove any "user.virtiofs." xattr as this would allow
> an unprivileged process in the vm to modify an xattr that it wouldn't
> otherwise be allowed to modify.  On top of being a somewhat arbitrary
> restriction this also means that you can't have stacked virtiofs
> instances as the lower instance would reject attempts by the upper one
> to set those xattrs.  These limitations aren't really a problem for us
> but I can see how they might be a problem for others.

Isn't this a classic escaping problem?
Would it work if you prepended  'user.virtiofs.' onto any xattr
that started with 'trusted' or 'user.virtiofs.' ?

> The change was also merged just yesterday so there may be other
> problems with it that haven't surfaced yet.
> 
> I didn't mention it before because I figured this was something that
> we brought upon ourselves as chrome os is a bit extreme about
> sandboxing. 

I think we're trying to be as extreme in virtiofsd, but it is causing us
similar problems.

> If we can come up with a standardized way to handle this
> I think we'll gladly switch the chrome os implementation to use it.

Great!

Dave

> 
> Chirantan
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

