Date: Mon, 25 Nov 2019 09:57:59 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20191125145759.GA13247@redhat.com>
References: <20191115205543.1816-1-vgoyal@redhat.com>
	<20191115205543.1816-4-vgoyal@redhat.com>
	<20191122103300.GD464656@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122103300.GD464656@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 3/4] virtiofsd: Specify size of notification
 buffer using config space
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, miklos@szeredi.hu, qemu-devel@nongnu.org

On Fri, Nov 22, 2019 at 10:33:00AM +0000, Stefan Hajnoczi wrote:
> On Fri, Nov 15, 2019 at 03:55:42PM -0500, Vivek Goyal wrote:
> > diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
> > index 411114c9b3..982b6ad0bd 100644
> > --- a/contrib/virtiofsd/fuse_virtio.c
> > +++ b/contrib/virtiofsd/fuse_virtio.c
> > @@ -109,7 +109,8 @@ static uint64_t fv_get_features(VuDev *dev)
> >      uint64_t features;
> >  
> >      features = 1ull << VIRTIO_F_VERSION_1 |
> > -               1ull << VIRTIO_FS_F_NOTIFICATION;
> > +               1ull << VIRTIO_FS_F_NOTIFICATION |
> > +               1ull << VHOST_USER_F_PROTOCOL_FEATURES;
> 
> This is not needed since VHOST_USER_F_PROTOCOL_FEATURES is already added
> by vu_get_features_exec():

Will do.

> 
>   vu_get_features_exec(VuDev *dev, VhostUserMsg *vmsg)
>   {
>       vmsg->payload.u64 =
>           1ULL << VHOST_F_LOG_ALL |
>           1ULL << VHOST_USER_F_PROTOCOL_FEATURES;
> 
>       if (dev->iface->get_features) {
>           vmsg->payload.u64 |= dev->iface->get_features(dev);
>       }
> 
> >  
> >      return features;
> >  }
> > @@ -927,6 +928,27 @@ static bool fv_queue_order(VuDev *dev, int qidx)
> >      return false;
> >  }
> >  
> > +static uint64_t fv_get_protocol_features(VuDev *dev)
> > +{
> > +	return 1ull << VHOST_USER_PROTOCOL_F_CONFIG;
> > +}
> 
> Please change vu_get_protocol_features_exec() in a separate patch so
> that devices don't need this boilerplate .get_protocol_features() code:
> 
>   static bool
>   vu_get_protocol_features_exec(VuDev *dev, VhostUserMsg *vmsg)
>   {
>       ...
>  -    if (dev->iface->get_config && dev->iface->set_config) {
>  +    if (dev->iface->get_config || dev->iface->set_config) {
>           features |= 1ULL << VHOST_USER_PROTOCOL_F_CONFIG;

This seems more like a nice to have thing. Can we leave it for sometime
later.

>       }
> 
> > +
> > +static int fv_get_config(VuDev *dev, uint8_t *config, uint32_t len)
> > +{
> > +	struct virtio_fs_config fscfg = {};
> > +
> > +	fuse_log(FUSE_LOG_DEBUG, "%s:Setting notify_buf_size=%d\n", __func__,
> > +                 sizeof(struct fuse_notify_lock_out));
> > +	/*
> > +	 * As of now only notification related to lock is supported. As more
> > +	 * notification types are supported, bump up the size accordingly.
> > +	 */
> > +	fscfg.notify_buf_size = sizeof(struct fuse_notify_lock_out);
> 
> Missing cpu_to_le32().

Not sure. Deivce converts to le32 when guests asks for it. So there should
not be any need to do this conversion between vhost-user daemon and
device. I am assuming that both daemon and qemu are using same endianess
and if that's the case, first converting it to le32 and undoing this
operation on other end (if we are running on an architecture with big
endian), seems unnecessary and confusing.

static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
{
    ...
    ...
    virtio_stl_p(vdev, &fscfg.notify_buf_size, fs->fscfg.notify_buf_size);
}

> 
> I'm not sure about specifying the size precisely down to the last byte
> because any change to guest-visible aspects of the device (like VIRTIO
> Configuration Space) are not compatible across live migration.  It will
> be necessary to introduce a device version command-line option for live
> migration compatibility so that existing guests can be migrated to a new
> virtiofsd without the device changing underneath them.

I am not sure I understand this point. If we were to support live
migration, will we not have to reset the queue and regoniate with
device again on destination host.
> 
> How about rounding this up to 4 KB?

Not sure how will that help. Right now it feels just wasteful of memory.

> 
> >  static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
> >  {
> >      VHostUserFS *fs = VHOST_USER_FS(vdev);
> >      struct virtio_fs_config fscfg = {};
> > +    int ret;
> > +
> > +    /*
> > +     * As of now we only get notification buffer size from device. And that's
> > +     * needed only if notification queue is enabled.
> > +     */
> > +    if (fs->notify_enabled) {
> > +        ret = vhost_dev_get_config(&fs->vhost_dev, (uint8_t *)&fs->fscfg,
> > +                                   sizeof(struct virtio_fs_config));
> > +	if (ret < 0) {
> 
> Indentation.

Will fix.

> 
> > +            error_report("vhost-user-fs: get device config space failed."
> > +                         " ret=%d\n", ret);
> > +            return;
> > +        }
> 
> Missing le32_to_cpu() for notify_buf_size.

See above.

[..]
> > @@ -545,6 +569,8 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
> >      fs->vhost_dev.nvqs = 2 + fs->conf.num_request_queues;
> >  
> >      fs->vhost_dev.vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
> > +
> > +    vhost_dev_set_config_notifier(&fs->vhost_dev, &fs_ops);
> 
> Is this really needed since vhost_user_fs_handle_config_change() ignores
> it?

Initially I did not introduce it but code did not work. Looked little
closer and noticed following code in vhost_user_backend_init().

        if (!dev->config_ops || !dev->config_ops->vhost_dev_config_notifier) {
            /* Don't acknowledge CONFIG feature if device doesn't support it */
            dev->protocol_features &= ~(1ULL << VHOST_USER_PROTOCOL_F_CONFIG);

So if dev->config_ops->vhost_dev_config_notifier is not provided, 
feature VHOST_USER_PROTOCOL_F_CONFIG will be reset.

Its kind of odd that its a hard requirement. Anyway, that's the reason
I added it so that VHOST_USER_PROTOCOL_F_CONFIG continues to work.

Thanks
Vivek

