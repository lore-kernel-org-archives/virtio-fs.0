Date: Tue, 15 Jun 2021 09:32:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210615133241.GA965196@redhat.com>
References: <20200722090758.3221812-1-chirantan@chromium.org>
	<20210614212808.GD869400@redhat.com>
	<CAJFHJrpu9vewcD2er6oB_xwtF4Pc-njkRaA7rfJwsTvw5Fi2og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJFHJrpu9vewcD2er6oB_xwtF4Pc-njkRaA7rfJwsTvw5Fi2og@mail.gmail.com>
Subject: Re: [Virtio-fs] [RESEND] [PATCHv4 1/2] uapi: fuse: Add
	FUSE_SECURITY_CTX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel <fuse-devel@lists.sourceforge.net>, Stephen Smalley <stephen.smalley.work@gmail.com>, Suleiman Souhlal <suleiman@chromium.org>, virtio-fs-list <virtio-fs@redhat.com>, SElinux list <selinux@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Dylan Reid <dgreid@chromium.org>

On Tue, Jun 15, 2021 at 06:35:21PM +0900, Chirantan Ekbote wrote:
> Hi Vivek,
> 
> On Tue, Jun 15, 2021 at 6:28 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Wed, Jul 22, 2020 at 06:07:57PM +0900, Chirantan Ekbote wrote:
> > > Add the FUSE_SECURITY_CTX flag for the `flags` field of the
> > > fuse_init_out struct.  When this flag is set the kernel will append the
> > > security context for a newly created inode to the request (create,
> > > mkdir, mknod, and symlink).  The server is responsible for ensuring that
> > > the inode appears atomically with the requested security context.
> > >
> > > For example, if the server is backed by a "real" linux file system then
> > > it can write the security context value to
> > > /proc/thread-self/attr/fscreate before making the syscall to create the
> > > inode.
> > >
> > > Signed-off-by: Chirantan Ekbote <chirantan@chromium.org>
> >
> > Hi Chirantan,
> >
> > I am wondering what's the status of this work now. Looks like it
> > was not merged.
> >
> > We also need the capability to set selinux security xattrs on newly
> > created files in virtiofs.
> >
> > Will you be interested in reviving this work and send patches again
> > and copy the selinux as well as linux security module list
> > (linux-security-module@vger.kernel.org) as suggested by casey.
> >
> 
> Not really.  We have our own local solution for this (see below) so if
> you or someone else wants to pick it up, please go ahead.
> 

Ok.

> > How are you managing in the meantime. Carrying patches in your own
> > kernel?
> >
> 
> Kind of. This patch series changes the protocol and the feature bit we
> were using was claimed by FUSE_SUBMOUNTS instead so carrying it
> locally is not really viable long term.  Instead we're carrying a
> patch similar to the original RFC patch that doesn't change the
> protocol [1].

Ok, got it. So you went ahead for simpler solution of setting security
xattr after creating file hence making it non-atomic. But changelog
suggests that it works for your use case as you always do a restorecon
on reboot. 

But I guess upstream will need a solution where file creation and
security xattr setting can be atomic.

Thanks. If time permits, I might look into the patches you had posted.

Thanks
Vivek

