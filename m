Date: Thu, 23 Jul 2020 09:47:33 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200723134733.GA5885@redhat.com>
References: <20200722130206.224898-1-stefanha@redhat.com>
	<20200722130206.224898-3-stefanha@redhat.com>
	<20200722175820.GL2660@work-vm>
	<20200723122850.GI186372@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723122850.GI186372@stefanha-x1.localdomain>
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
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vromanso@redhat.com, rmohr@redhat.com

On Thu, Jul 23, 2020 at 01:28:50PM +0100, Stefan Hajnoczi wrote:
> On Wed, Jul 22, 2020 at 06:58:20PM +0100, Dr. David Alan Gilbert wrote:
> > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > > virtiofsd cannot run in an unprivileged container because CAP_SYS_ADMIN
> > > is required to create namespaces.
> > > 
> > > Introduce a weaker sandbox that is sufficient in container environments
> > > because the container runtime already sets up namespaces. Use chroot to
> > > restrict path traversal to the shared directory.
> > > 
> > > virtiofsd loses the following:
> > > 
> > > 1. Mount namespace. The process chroots to the shared directory but
> > >    leaves the mounts in place. Seccomp rejects mount(2)/umount(2)
> > >    syscalls.
> > 
> > OK, I'm guessing the behaviour of what happens if the host adds another
> > mount afterwards might be different?
> 
> Running inside a container with -o chroot:
>  - The container has its own mount namespace and it is therefore not
>    affected, modulo shared subtrees (see mount(8)).

How does virtiofsd inside container gets the directory it wants to
export to guest? I am assuming that its probably a volume mount
inside container. If yes, volume mounts can set propagation
properties say "slave" and that means mounts done later will
propagate inside container in that volume (and hopefully be
visible inside guest once submount patches are upstream).

Thanks
Vivek

