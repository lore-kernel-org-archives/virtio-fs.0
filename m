Date: Fri, 19 Jun 2020 09:39:53 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200619083953.GB2690@work-vm>
References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200618190816.GD3814@redhat.com> <20200618191655.GI2769@work-vm>
	<20200618192717.GE3814@redhat.com>
	<CAJFHJrrJzPLatNvw2xC3WYLbzCW0+DB+4UczQHGPBF9p+WGYQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJFHJrrJzPLatNvw2xC3WYLbzCW0+DB+4UczQHGPBF9p+WGYQA@mail.gmail.com>
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
> On Fri, Jun 19, 2020 at 4:27 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Thu, Jun 18, 2020 at 08:16:55PM +0100, Dr. David Alan Gilbert wrote:
> > > * Vivek Goyal (vgoyal@redhat.com) wrote:
> > > > On Thu, Apr 16, 2020 at 05:49:05PM +0100, Stefan Hajnoczi wrote:
> > > > > virtiofsd doesn't need of all Linux capabilities(7) available to root.  Keep a
> > > > > whitelisted set of capabilities that we require.  This improves security in
> > > > > case virtiofsd is compromised by making it hard for an attacker to gain further
> > > > > access to the system.
> > > >
> > > > Hi Stefan,
> > > >
> > > > I just noticed that this patch set breaks overlayfs on top of virtiofs.
> > > >
> > > > overlayfs sets "trusted.overlay.*" and xattrs in trusted domain
> > > > need CAP_SYS_ADMIN.
> > > >
> 
> Not just that but it needs CAP_SYS_ADMIN in the init namespace[1].  We
> have the same problem.  Our virtiofs process has CAP_SYS_ADMIN in a
> user namespace and it cannot set any trusted or security xattrs.  The
> security xattrs check is at least namespace aware so you only need
> CAP_SYS_ADMIN in the namespace that mounted the fs but that doesn't
> help us much.

It would have been good if you'd mentioned that; it would have saved
Vivek some confusion!

> We ended up working around it by prefixing "user.virtiofs." to the
> xattr name[2], which has its own problems but there was pretty much no
> chance that we would be able to give the fs device CAP_SYS_ADMIN in
> the init namespace.


What problems did you hit with that?  We should standardise the renaming
so we make an on-disc format that's compatible.

Dave

> 
> [1]: https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux/+/5e857ce6eae7ca21b2055cca4885545e29228fe2/fs/xattr.c#116
> [2]: https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/2243111
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

