Date: Wed, 29 Apr 2020 11:35:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200429153540.GG231284@redhat.com>
References: <20200424133516.73077-1-mreitz@redhat.com>
	<20200427175902.GM2923@work-vm> <20200429145720.GA2835@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429145720.GA2835@work-vm>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Show submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Max Reitz <mreitz@redhat.com>

On Wed, Apr 29, 2020 at 03:57:20PM +0100, Dr. David Alan Gilbert wrote:
> * Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
> > * Max Reitz (mreitz@redhat.com) wrote:
> > > Currently, setup_mounts() bind-mounts the shared directory without
> > > MS_REC.  This makes all submounts disappear.
> > > 
> > > Pass MS_REC so that the guest can see submounts again.
> > 
> > Thanks!
> > 
> > > Fixes: 3ca8a2b1c83eb185c232a4e87abbb65495263756
> > 
> > Should this actually be 5baa3b8e95064c2434bd9e2f312edd5e9ae275dc ?
> > 
> > > Signed-off-by: Max Reitz <mreitz@redhat.com>
> > > ---
> > >  tools/virtiofsd/passthrough_ll.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> > > index 4c35c95b25..9d7f863e66 100644
> > > --- a/tools/virtiofsd/passthrough_ll.c
> > > +++ b/tools/virtiofsd/passthrough_ll.c
> > > @@ -2643,7 +2643,7 @@ static void setup_mounts(const char *source)
> > >      int oldroot;
> > >      int newroot;
> > >  
> > > -    if (mount(source, source, NULL, MS_BIND, NULL) < 0) {
> > > +    if (mount(source, source, NULL, MS_BIND | MS_REC, NULL) < 0) {
> > >          fuse_log(FUSE_LOG_ERR, "mount(%s, %s, MS_BIND): %m\n", source, source);
> > >          exit(1);
> > >      }
> > 
> > Do we want MS_SLAVE to pick up future mounts that might happenf rom the
> > host?
> > What's the interaction between this and the MS_REC|MS_SLAVE that we have
> > a few lines above for / ?
> 
> Just to confirm something from vgoyal, and what had confused me about
> why we hadn't spotted this earlier.
> 
> Even without this patch, the SLAVE stuff worked so if you start the
> daemon and *then* mount under the shared directory, the guest sees it
> with or without this patch.
> 
> However, without this patch you don't see a mount that was already there
> before you start the daemon.

MS_REC will do recursive mount and make all existing submounts visible.
But it does not do anything about propagation of newly created mounts
and that's controlled by propagation properties of mount points.

Our propagation properties seem to be SLAVE already and things work
for new mounts. But existing submounts must have been masked during
bind mount due to absense of MS_REC.

Vivek

