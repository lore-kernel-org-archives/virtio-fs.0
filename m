Date: Thu, 18 Feb 2021 10:59:52 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YC5IqMK+6UUjaE04@work-vm>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-9-dgilbert@redhat.com>
	<20210211105755.GI247031@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211105755.GI247031@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 08/24] DAX: virtio-fs: Fill in slave
	commands for mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com, mst@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Tue, Feb 09, 2021 at 07:02:08PM +0000, Dr. David Alan Gilbert (git) wrote:
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > 
> > Fill in definitions for map, unmap and sync commands.
> > 
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > with fix by misono.tomohiro@fujitsu.com
> > ---
> >  hw/virtio/vhost-user-fs.c | 115 ++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 111 insertions(+), 4 deletions(-)
> > 
> > diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> > index 78401d2ff1..5f2fca4d82 100644
> > --- a/hw/virtio/vhost-user-fs.c
> > +++ b/hw/virtio/vhost-user-fs.c
> > @@ -37,15 +37,122 @@
> >  uint64_t vhost_user_fs_slave_map(struct vhost_dev *dev, VhostUserFSSlaveMsg *sm,
> >                                   int fd)
> >  {
> > -    /* TODO */
> > -    return (uint64_t)-1;
> > +    VHostUserFS *fs = VHOST_USER_FS(dev->vdev);
> > +    if (!fs) {
> > +        /* Shouldn't happen - but seen on error path */
> > +        error_report("Bad fs ptr");
> > +        return (uint64_t)-1;
> > +    }
> 
> If a non-vhost-user-fs vhost-user device backend sends this message
> VHOST_USER_FS() -> object_dynamic_cast_assert() there will either be an
> assertion failure (CONFIG_QOM_CAST_DEBUG) or the pointer will be
> silently cast to the wrong type (!CONFIG_QOM_CAST_DEBUG).
> 
> Both of these outcomes are not suitable for input validation. We need to
> fail cleanly here:
> 
>   VhostUserFS *fs = (VHostUserFS *)object_dynamic_cast(OBJECT(dev->vdev),
>                                                        TYPE_VHOST_USER_FS);
>   if (!fs) {
>       ...handle failure...
>   }
> 
> >  uint64_t vhost_user_fs_slave_unmap(struct vhost_dev *dev,
> >                                     VhostUserFSSlaveMsg *sm)
> >  {
> > -    /* TODO */
> > -    return (uint64_t)-1;
> > +    VHostUserFS *fs = VHOST_USER_FS(dev->vdev);
> > +    if (!fs) {
> > +        /* Shouldn't happen - but seen on error path */
> > +        error_report("Bad fs ptr");
> > +        return (uint64_t)-1;
> > +    }
> 
> Same here.

Thanks, fixed.

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

