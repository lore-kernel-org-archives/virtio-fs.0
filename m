Date: Fri, 22 Nov 2019 17:29:09 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20191122172909.GK2785@work-vm>
References: <20191115205543.1816-1-vgoyal@redhat.com>
	<20191115205543.1816-3-vgoyal@redhat.com>
	<20191122101903.GC464656@stefanha-x1.localdomain>
	<20191122144721.GD8636@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122144721.GD8636@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/4] virtiofd: Create a notification queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, miklos@szeredi.hu

* Vivek Goyal (vgoyal@redhat.com) wrote:
> On Fri, Nov 22, 2019 at 10:19:03AM +0000, Stefan Hajnoczi wrote:
> > On Fri, Nov 15, 2019 at 03:55:41PM -0500, Vivek Goyal wrote:
> > >  /* Callback from libvhost-user */
> > >  static void fv_set_features(VuDev *dev, uint64_t features)
> > >  {
> > > +    struct fv_VuDev *vud = container_of(dev, struct fv_VuDev, dev);
> > > +    struct fuse_session *se = vud->se;
> > > +
> > > +    if ((1 << VIRTIO_FS_F_NOTIFICATION) & features) {
> > 
> > For consistency 1ull should be used.  That way the reader does not have
> > to check the bit position to verify that the bitmap isn't truncated at
> > 32 bits.
> 
> Ok, will do.
> 
> > 
> > > +        vud->notify_enabled = true;
> > > +        se->notify_enabled = true;
> > 
> > Only one copy of this field is needed.  vud has a pointer to se.
> 
> I need to access ->notify_enabled in passthrough_ll.c to determine if
> notification queue is enabled or not. That determines if async locks are
> supported or not.  And based on that either -EOPNOTSUPP is returned or
> a response to wait is returned.
> 
> I did not see passthrough_ll.c accessing vud. I did see it having access
> to session object though. So I created a copy there.
> 
> But I am open to suggestions on what's the best way to access this
> information in passthrough_ll.c
> 
> > 
> > > +    }
> > >  }
> > >  
> > >  /*
> > > @@ -662,6 +671,65 @@ static void fv_queue_worker(gpointer data, gpointer user_data)
> > >      free(req);
> > >  }
> > >  
> > > +static void *fv_queue_notify_thread(void *opaque)
> > > +{
> > > +    struct fv_QueueInfo *qi = opaque;
> > > +
> > > +    fuse_log(FUSE_LOG_INFO, "%s: Start for queue %d kick_fd %d\n", __func__,
> > > +             qi->qidx, qi->kick_fd);
> > > +
> > > +    while (1) {
> > > +        struct pollfd pf[2];
> > > +
> > > +        pf[0].fd = qi->kick_fd;
> > > +        pf[0].events = POLLIN;
> > > +        pf[0].revents = 0;
> > > +        pf[1].fd = qi->kill_fd;
> > > +        pf[1].events = POLLIN;
> > > +        pf[1].revents = 0;
> > > +
> > > +        fuse_log(FUSE_LOG_DEBUG, "%s: Waiting for Queue %d event\n", __func__,
> > > +                 qi->qidx);
> > > +        int poll_res = ppoll(pf, 2, NULL, NULL);
> > > +
> > > +        if (poll_res == -1) {
> > > +            if (errno == EINTR) {
> > > +                fuse_log(FUSE_LOG_INFO, "%s: ppoll interrupted, going around\n",
> > > +                         __func__);
> > > +                continue;
> > > +            }
> > > +            fuse_log(FUSE_LOG_ERR, "fv_queue_thread ppoll: %m\n");
> > > +            break;
> > > +        }
> > > +        assert(poll_res >= 1);
> > > +        if (pf[0].revents & (POLLERR | POLLHUP | POLLNVAL)) {
> > > +            fuse_log(FUSE_LOG_ERR, "%s: Unexpected poll revents %x Queue %d\n",
> > > +                     __func__, pf[0].revents, qi->qidx);
> > > +             break;
> > > +        }
> > > +        if (pf[1].revents & (POLLERR | POLLHUP | POLLNVAL)) {
> > > +            fuse_log(FUSE_LOG_ERR, "%s: Unexpected poll revents %x Queue %d"
> > > +                     "killfd\n", __func__, pf[1].revents, qi->qidx);
> > > +            break;
> > > +        }
> > > +        if (pf[1].revents) {
> > > +            fuse_log(FUSE_LOG_INFO, "%s: kill event on queue %d - quitting\n",
> > > +                     __func__, qi->qidx);
> > > +            break;
> > > +        }
> > > +        assert(pf[0].revents & POLLIN);
> > > +        fuse_log(FUSE_LOG_DEBUG, "%s: Got queue event on Queue %d\n", __func__,
> > > +                 qi->qidx);
> > > +
> > > +        eventfd_t evalue;
> > > +        if (eventfd_read(qi->kick_fd, &evalue)) {
> > > +            fuse_log(FUSE_LOG_ERR, "Eventfd_read for queue: %m\n");
> > > +            break;
> > > +        }
> > > +    }
> > > +    return NULL;
> > > +}
> > 
> > It's difficult to review function without any actual functionality using
> > the virtqueue.  I'm not sure a thread is even needed since the device
> > only needs to get a buffer when it has a notification for the driver.
> > I'll have to wait for the following patches to see what happens here...
> 
> This might very well be redundant. I am not sure. Can get rid of
> this thread if not needed at all. So we don't need to monitor even
> kill_fd and take any special action?

The kill_fd is internal to virtiofsd; it's only used as a way for the
main thread to cause the queue thread to exit;  if you've not got the
thread, you don't need the kill_fd.

Dave

> > 
> > > @@ -378,12 +382,23 @@ static void vuf_set_status(VirtIODevice *vdev, uint8_t status)
> > >      }
> > >  }
> > >  
> > > -static uint64_t vuf_get_features(VirtIODevice *vdev,
> > > -                                      uint64_t requested_features,
> > > -                                      Error **errp)
> > > +static uint64_t vuf_get_features(VirtIODevice *vdev, uint64_t features,
> > > +                                 Error **errp)
> > >  {
> > > -    /* No feature bits used yet */
> > > -    return requested_features;
> > > +    VHostUserFS *fs = VHOST_USER_FS(vdev);
> > > +
> > > +    virtio_add_feature(&features, VIRTIO_FS_F_NOTIFICATION);
> > > +
> > > +    return vhost_get_features(&fs->vhost_dev, user_feature_bits, features);
> > > +}
> > > +
> > > +static void vuf_set_features(VirtIODevice *vdev, uint64_t features)
> > > +{
> > > +    VHostUserFS *fs = VHOST_USER_FS(vdev);
> > > +
> > > +    if (virtio_has_feature(features, VIRTIO_FS_F_NOTIFICATION)) {
> > > +        fs->notify_enabled = true;
> > 
> > This field is unused, please remove it.
> 
> vuf_get_config() uses it.
> 
> Thanks
> Vivek
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

