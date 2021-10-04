Date: Mon, 4 Oct 2021 17:10:59 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YVtt49qZAy+AYMf5@redhat.com>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-10-vgoyal@redhat.com>
	<YVsQyxaPHyChcOel@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVsQyxaPHyChcOel@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 09/13] virtiofsd: Specify size of
 notification buffer using config space
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

On Mon, Oct 04, 2021 at 03:33:47PM +0100, Stefan Hajnoczi wrote:
> On Thu, Sep 30, 2021 at 11:30:33AM -0400, Vivek Goyal wrote:
> > Daemon specifies size of notification buffer needed and that should be
> > done using config space.
> > 
> > Only ->notify_buf_size value of config space comes from daemon. Rest of
> > it is filled by qemu device emulation code.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
> > ---
> >  hw/virtio/vhost-user-fs.c                  | 27 +++++++++++++++++++
> >  include/hw/virtio/vhost-user-fs.h          |  2 ++
> >  include/standard-headers/linux/virtio_fs.h |  2 ++
> >  tools/virtiofsd/fuse_virtio.c              | 31 ++++++++++++++++++++++
> >  4 files changed, 62 insertions(+)
> > 
> > diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> > index 6bafcf0243..68a94708b4 100644
> > --- a/hw/virtio/vhost-user-fs.c
> > +++ b/hw/virtio/vhost-user-fs.c
> > @@ -36,15 +36,41 @@ static const int user_feature_bits[] = {
> >      VHOST_INVALID_FEATURE_BIT
> >  };
> >  
> > +static int vhost_user_fs_handle_config_change(struct vhost_dev *dev)
> > +{
> > +    return 0;
> > +}
> > +
> > +const VhostDevConfigOps fs_ops = {
> > +    .vhost_dev_config_notifier = vhost_user_fs_handle_config_change,
> > +};
> > +
> >  static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
> >  {
> >      VHostUserFS *fs = VHOST_USER_FS(vdev);
> >      struct virtio_fs_config fscfg = {};
> > +    Error *local_err = NULL;
> > +    int ret;
> > +
> > +    /*
> > +     * As of now we only get notification buffer size from device. And that's
> > +     * needed only if notification queue is enabled.
> > +     */
> > +    if (fs->notify_enabled) {
> > +        ret = vhost_dev_get_config(&fs->vhost_dev, (uint8_t *)&fs->fscfg,
> > +                                   sizeof(struct virtio_fs_config),
> > +                                   &local_err);
> > +        if (ret) {
> > +            error_report_err(local_err);
> > +            return;
> > +        }
> > +    }
> >  
> >      memcpy((char *)fscfg.tag, fs->conf.tag,
> >             MIN(strlen(fs->conf.tag) + 1, sizeof(fscfg.tag)));
> >  
> >      virtio_stl_p(vdev, &fscfg.num_request_queues, fs->conf.num_request_queues);
> > +    virtio_stl_p(vdev, &fscfg.notify_buf_size, fs->fscfg.notify_buf_size);
> >  
> >      memcpy(config, &fscfg, sizeof(fscfg));
> >  }
> > @@ -316,6 +342,7 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
> >                  sizeof(struct virtio_fs_config));
> >  
> >      vuf_create_vqs(vdev, true);
> > +    vhost_dev_set_config_notifier(&fs->vhost_dev, &fs_ops);
> >      ret = vhost_dev_init(&fs->vhost_dev, &fs->vhost_user,
> >                           VHOST_BACKEND_TYPE_USER, 0, errp);
> >      if (ret < 0) {
> > diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-user-fs.h
> > index 95dc0dd402..3b114ee260 100644
> > --- a/include/hw/virtio/vhost-user-fs.h
> > +++ b/include/hw/virtio/vhost-user-fs.h
> > @@ -14,6 +14,7 @@
> >  #ifndef _QEMU_VHOST_USER_FS_H
> >  #define _QEMU_VHOST_USER_FS_H
> >  
> > +#include "standard-headers/linux/virtio_fs.h"
> >  #include "hw/virtio/virtio.h"
> >  #include "hw/virtio/vhost.h"
> >  #include "hw/virtio/vhost-user.h"
> > @@ -37,6 +38,7 @@ struct VHostUserFS {
> >      struct vhost_virtqueue *vhost_vqs;
> >      struct vhost_dev vhost_dev;
> >      VhostUserState vhost_user;
> > +    struct virtio_fs_config fscfg;
> >      VirtQueue **req_vqs;
> >      VirtQueue *hiprio_vq;
> >      VirtQueue *notification_vq;
> > diff --git a/include/standard-headers/linux/virtio_fs.h b/include/standard-headers/linux/virtio_fs.h
> > index b7f015186e..867d18acf6 100644
> > --- a/include/standard-headers/linux/virtio_fs.h
> > +++ b/include/standard-headers/linux/virtio_fs.h
> > @@ -17,6 +17,8 @@ struct virtio_fs_config {
> >  
> >  	/* Number of request queues */
> >  	uint32_t num_request_queues;
> > +	/* Size of notification buffer */
> > +	uint32_t notify_buf_size;
> >  } QEMU_PACKED;
> >  
> >  /* For the id field in virtio_pci_shm_cap */
> 
> Please put all the include/standard-headers/linux/ changes into a single
> commit that imports these changes from linux.git. Changes to this header
> shouldn't be hand-written, use scripts/update-linux-headers.sh instead.

Will do. These changes are not in kernel yet. So will use
update-linux-headers.sh when changes are upstreamed. But agreed,
that this change should be in separate patch even for review
purpose (before it is merged in kernel).

> 
> > diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> > index f5b87a508a..3b720c5d4a 100644
> > --- a/tools/virtiofsd/fuse_virtio.c
> > +++ b/tools/virtiofsd/fuse_virtio.c
> > @@ -856,6 +856,35 @@ static bool fv_queue_order(VuDev *dev, int qidx)
> >      return false;
> >  }
> >  
> > +static uint64_t fv_get_protocol_features(VuDev *dev)
> > +{
> > +    return 1ull << VHOST_USER_PROTOCOL_F_CONFIG;
> > +}
> > +
> > +static int fv_get_config(VuDev *dev, uint8_t *config, uint32_t len)
> > +{
> > +    struct virtio_fs_config fscfg = {};
> > +    unsigned notify_size, roundto = 64;
> > +    union fuse_notify_union {
> > +        struct fuse_notify_poll_wakeup_out  wakeup_out;
> > +        struct fuse_notify_inval_inode_out  inode_out;
> > +        struct fuse_notify_inval_entry_out  entry_out;
> > +        struct fuse_notify_delete_out       delete_out;
> > +        struct fuse_notify_store_out        store_out;
> > +        struct fuse_notify_retrieve_out     retrieve_out;
> > +    };
> > +
> > +    notify_size = sizeof(struct fuse_out_header) +
> > +              sizeof(union fuse_notify_union);
> > +    notify_size = ((notify_size + roundto) / roundto) * roundto;
> 
> Why is the size rounded to 64 bytes?

Hmm.., I really can't remember why did I do that. Maybe I thought it
is just nice to round it to 64 bytes. I can get rid of this rounding
if it s not making sense.

Vivek


