DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=P/0wT5AVlfJU51+aOXmXuOFRQiK5GOEuvWtw0JpdSQw=;
	b=HLzehYXPr5Tyja0osk+SAA7sNvb+Fab+4kapFvH+KvWSEWJ5IGg6C32MSsPtS4lK1Z
	uGqttIPjgSVUZvOkrpuSB32efRB83q1Z5Dew/wxxREWuwJ+lauvG4LmgB3eZKk6MsdUw
	bEL4IU0r1uDnDHLT+SJmA0E/Fp3mMUuAEAaLM=
MIME-Version: 1.0
References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200618190816.GD3814@redhat.com>
	<20200618191655.GI2769@work-vm> <20200618192717.GE3814@redhat.com>
	<CAJFHJrrJzPLatNvw2xC3WYLbzCW0+DB+4UczQHGPBF9p+WGYQA@mail.gmail.com>
	<20200619191540.GI3154@redhat.com>
In-Reply-To: <20200619191540.GI3154@redhat.com>
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Thu, 25 Jun 2020 12:19:39 +0900
Message-ID: <CAJFHJroGNbfO-tXqrod_snCHcnN4NKjX8t9LTeroyiNEwjtVcQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: drop Linux capabilities(7)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, qemu-devel@nongnu.org

On Sat, Jun 20, 2020 at 4:15 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Fri, Jun 19, 2020 at 01:46:20PM +0900, Chirantan Ekbote wrote:
> > On Fri, Jun 19, 2020 at 4:27 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Thu, Jun 18, 2020 at 08:16:55PM +0100, Dr. David Alan Gilbert wrote:
> > > > * Vivek Goyal (vgoyal@redhat.com) wrote:
> > > > > On Thu, Apr 16, 2020 at 05:49:05PM +0100, Stefan Hajnoczi wrote:
> > > > > > virtiofsd doesn't need of all Linux capabilities(7) available to root.  Keep a
> > > > > > whitelisted set of capabilities that we require.  This improves security in
> > > > > > case virtiofsd is compromised by making it hard for an attacker to gain further
> > > > > > access to the system.
> > > > >
> > > > > Hi Stefan,
> > > > >
> > > > > I just noticed that this patch set breaks overlayfs on top of virtiofs.
> > > > >
> > > > > overlayfs sets "trusted.overlay.*" and xattrs in trusted domain
> > > > > need CAP_SYS_ADMIN.
> > > > >
> >
> > Not just that but it needs CAP_SYS_ADMIN in the init namespace[1].  We
> > have the same problem.  Our virtiofs process has CAP_SYS_ADMIN in a
> > user namespace and it cannot set any trusted or security xattrs.  The
> > security xattrs check is at least namespace aware so you only need
> > CAP_SYS_ADMIN in the namespace that mounted the fs but that doesn't
> > help us much.
> >
> > We ended up working around it by prefixing "user.virtiofs." to the
> > xattr name[2], which has its own problems but there was pretty much no
> > chance that we would be able to give the fs device CAP_SYS_ADMIN in
> > the init namespace.
>
> Chirantan,
>
> So you ended up renaming all "trusted", "security" and "system" xattrs?
> Only "user" xattrs are complete passthrough?
>

No, we only rename "security" xattrs (except for selinux).

>
> IOW, security.selinux will be renamed to user.virtiofs.security.selinux
> on host?
>

We don't relabel security.selinux because it only requires CAP_FOWNER
in the process's user namespace and it also does its own MAC-based
checks.  Also we have some tools that label files beforehand so it
seemed easier to leave them unchanged.

Chirantan

