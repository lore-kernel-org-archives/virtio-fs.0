Date: Thu, 23 Jul 2020 18:55:38 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200723175538.GW2621@work-vm>
References: <20200722130206.224898-1-stefanha@redhat.com>
	<20200722130206.224898-3-stefanha@redhat.com>
	<20200722190318.GM2660@work-vm>
	<20200723123229.GK186372@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723123229.GK186372@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH for-5.1 2/3] virtiofsd: add
 container-friendly -o chroot sandboxing option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, rmohr@redhat.com, qemu-devel@nongnu.org, vromanso@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Wed, Jul 22, 2020 at 08:03:18PM +0100, Dr. David Alan Gilbert wrote:
> > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > > +    /*
> > > +     * Make the shared directory the file system root so that FUSE_OPEN
> > > +     * (lo_open()) cannot escape the shared directory by opening a symlink.
> > > +     *
> > > +     * It's still possible to escape the chroot via lo->proc_self_fd but that
> > > +     * requires gaining control of the process first.
> > > +     */
> > > +    if (chroot(lo->source) != 0) {
> > > +        fuse_log(FUSE_LOG_ERR, "chroot(\"%s\"): %m\n", lo->source);
> > > +        exit(1);
> > > +    }
> > 
> > I'm seeing suggestions that you should drop CAP_SYS_CHROOT after
> > chroot'ing to stop an old escape (where you create another jail inside
> > the jail and the kernel then lets you walk outside of the old one).
> 
> That's already the case:
> 
> 1. setup_seccomp() blocks further chroot(2) calls.
> 2. setup_capabilities() drops CAP_SYS_CHROOT.

Ah yes; could you add a comment if you respin; it's not obvious that
the capability to chroot allows you to break out of an existing chroot
you're in.

Dave

> Stefan


--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

