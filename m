Date: Mon, 4 Oct 2021 15:58:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YVtc0UMWQtAaCNog@redhat.com>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-7-vgoyal@redhat.com>
	<YVsHifrJdRtVyERb@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVsHifrJdRtVyERb@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 06/13] vhost-user-fs: Use helpers to
 create/cleanup virtqueue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: miklos@szeredi.hu, qemu-devel@nongnu.org, virtio-fs@redhat.com

On Mon, Oct 04, 2021 at 02:54:17PM +0100, Stefan Hajnoczi wrote:
> On Thu, Sep 30, 2021 at 11:30:30AM -0400, Vivek Goyal wrote:
> > Add helpers to create/cleanup virtuqueues and use those helpers. I will
> 
> s/virtuqueues/virtqueues/
> 
> > need to reconfigure queues in later patches and using helpers will allow
> > reusing the code.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  hw/virtio/vhost-user-fs.c | 87 +++++++++++++++++++++++----------------
> >  1 file changed, 52 insertions(+), 35 deletions(-)
> > 
> > diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> > index c595957983..d1efbc5b18 100644
> > --- a/hw/virtio/vhost-user-fs.c
> > +++ b/hw/virtio/vhost-user-fs.c
> > @@ -139,6 +139,55 @@ static void vuf_set_status(VirtIODevice *vdev, uint8_t status)
> >      }
> >  }
> >  
> > +static void vuf_handle_output(VirtIODevice *vdev, VirtQueue *vq)
> > +{
> > +    /*
> > +     * Not normally called; it's the daemon that handles the queue;
> > +     * however virtio's cleanup path can call this.
> > +     */
> > +}
> > +
> > +static void vuf_create_vqs(VirtIODevice *vdev)
> > +{
> > +    VHostUserFS *fs = VHOST_USER_FS(vdev);
> > +    unsigned int i;
> > +
> > +    /* Hiprio queue */
> > +    fs->hiprio_vq = virtio_add_queue(vdev, fs->conf.queue_size,
> > +                                     vuf_handle_output);
> > +
> > +    /* Request queues */
> > +    fs->req_vqs = g_new(VirtQueue *, fs->conf.num_request_queues);
> > +    for (i = 0; i < fs->conf.num_request_queues; i++) {
> > +        fs->req_vqs[i] = virtio_add_queue(vdev, fs->conf.queue_size,
> > +                                          vuf_handle_output);
> > +    }
> > +
> > +    /* 1 high prio queue, plus the number configured */
> > +    fs->vhost_dev.nvqs = 1 + fs->conf.num_request_queues;
> > +    fs->vhost_dev.vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
> 
> These two lines prepare for vhost_dev_init(), so moving them here is
> debatable. If a caller is going to use this function again in the future
> then they need to be sure to also call vhost_dev_init(). For now it
> looks safe, so I guess it's okay.

Hmm..., I do call this function later from vuf_set_features() and
reconfigure the queues. I see that I don't call vhost_dev_init()
in that path. I am not even sure if I should be calling
vhost_dev_init() from inside vuf_set_features().

So core reuirement is that at the time of first creating device
I have no idea if driver supports notification queue or not. So
I do create device with notification queue. But later if driver
(and possibly vhost device) does not support notifiation queue,
then we need to reconfigure queues. What's the correct way to
do that?

Thanks
Vivek
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>


