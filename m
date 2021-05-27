Date: Thu, 27 May 2021 16:59:29 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YK/B4TX7L/NHfNCQ@work-vm>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-4-dgilbert@redhat.com>
	<YJFm+hocgArYnWAB@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJFm+hocgArYnWAB@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH v3 03/26] DAX: vhost-user: Rework slave
	return values
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Wed, Apr 28, 2021 at 12:00:37PM +0100, Dr. David Alan Gilbert (git) wrote:
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > 
> > All the current slave handlers on the qemu side generate an 'int'
> > return value that's squashed down to a bool (!!ret) and stuffed into
> > a uint64_t (field of a union) to be returned.
> > 
> > Move the uint64_t type back up through the individual handlers so
> > that we can make one actually return a full uint64_t.
> > 
> > Note that the definition in the interop spec says most of these
> > cases are defined as returning 0 on success and non-0 for failure,
> > so it's OK to change from a bool to another non-0.
> > 
> > Vivek:
> > This is needed because upcoming patches in series will add new functions
> > which want to return full error code. Existing functions continue to
> > return true/false so, it should not lead to change of behavior for
> > existing users.
> > 
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > Reviewed-by: Greg Kurz <groug@kaod.org>
> > ---
> >  hw/virtio/vhost-backend.c         |  6 +++---
> >  hw/virtio/vhost-user.c            | 31 ++++++++++++++++---------------
> >  include/hw/virtio/vhost-backend.h |  2 +-
> >  3 files changed, 20 insertions(+), 19 deletions(-)
> > 
> > diff --git a/hw/virtio/vhost-backend.c b/hw/virtio/vhost-backend.c
> > index 31b33bde37..1686c94767 100644
> > --- a/hw/virtio/vhost-backend.c
> > +++ b/hw/virtio/vhost-backend.c
> > @@ -401,8 +401,8 @@ int vhost_backend_invalidate_device_iotlb(struct vhost_dev *dev,
> >      return -ENODEV;
> >  }
> >  
> > -int vhost_backend_handle_iotlb_msg(struct vhost_dev *dev,
> > -                                          struct vhost_iotlb_msg *imsg)
> > +uint64_t vhost_backend_handle_iotlb_msg(struct vhost_dev *dev,
> > +                                        struct vhost_iotlb_msg *imsg)
> >  {
> >      int ret = 0;
> 
> This patch is messy. We want uint64_t but these functions use int ret
> internally. The actual return values are true/false instead of int 0 and
> 1.

Yeh.

> Please use uint64_t everywhere: return 0 for success and 1 for failure
> instead of bool literals and change the type of the local ret variables
> to uint64_t.


OK, reworked, this part of it now looks like :

int vhost_backend_handle_iotlb_msg(struct vhost_dev *dev,
-                                          struct vhost_iotlb_msg *imsg)
+uint64_t vhost_backend_handle_iotlb_msg(struct vhost_dev *dev,
+                                        struct vhost_iotlb_msg *imsg)
 {
-    int ret = 0;
+    uint64_t ret = 0;
 
     if (unlikely(!dev->vdev)) {
         error_report("Unexpected IOTLB message when virtio device is stopped");
-        return -EINVAL;
+        return EINVAL;
     }
 
     switch (imsg->type) {
     case VHOST_IOTLB_MISS:
-        ret = vhost_device_iotlb_miss(dev, imsg->iova,
-                                      imsg->perm != VHOST_ACCESS_RO);
+        ret = -vhost_device_iotlb_miss(dev, imsg->iova,
+                                       imsg->perm != VHOST_ACCESS_RO);
         break;
     case VHOST_IOTLB_ACCESS_FAIL:
         /* FIXME: report device iotlb error */
         error_report("Access failure IOTLB message type not supported");
-        ret = -ENOTSUP;
+        ret = ENOTSUP;
         break;
     case VHOST_IOTLB_UPDATE:
     case VHOST_IOTLB_INVALIDATE:
     default:
         error_report("Unexpected IOTLB message type");
-        ret = -EINVAL;
+        ret = EINVAL;
         break;
     }


-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

