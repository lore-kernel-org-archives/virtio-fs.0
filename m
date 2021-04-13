Date: Tue, 13 Apr 2021 09:35:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210413133534.GA1235549@redhat.com>
References: <20210408195534.647895-1-antonkuchin@yandex-team.ru>
	<YHVakoU5hY0wif2n@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHVakoU5hY0wif2n@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH] vhost-user-fs: fix features handling
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Anton Kuchin <antonkuchin@yandex-team.ru>, "Michael S. Tsirkin" <mst@redhat.com>

On Tue, Apr 13, 2021 at 09:47:14AM +0100, Stefan Hajnoczi wrote:
> On Thu, Apr 08, 2021 at 10:55:34PM +0300, Anton Kuchin wrote:
> > Make virtio-fs take into account server capabilities.
> > 
> > Just returning requested features assumes they all of then are implemented
> > by server and results in setting unsupported configuration if some of them
> > are absent.
> > 
> > Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
> > ---
> >  hw/virtio/vhost-user-fs.c | 17 +++++++++++++----
> >  1 file changed, 13 insertions(+), 4 deletions(-)
> > 
> > diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> > index ac4fc34b36..6cf983ba0e 100644
> > --- a/hw/virtio/vhost-user-fs.c
> > +++ b/hw/virtio/vhost-user-fs.c
> > @@ -24,6 +24,14 @@
> >  #include "monitor/monitor.h"
> >  #include "sysemu/sysemu.h"
> >  
> > +static const int user_feature_bits[] = {
> > +    VIRTIO_F_VERSION_1,
> > +    VIRTIO_RING_F_INDIRECT_DESC,
> > +    VIRTIO_RING_F_EVENT_IDX,
> > +    VIRTIO_F_NOTIFY_ON_EMPTY,
> > +    VHOST_INVALID_FEATURE_BIT
> > +};
> 
> Please add:
> 
> VIRTIO_F_RING_PACKED
> VIRTIO_F_IOMMU_PLATFORM

Hi Stefan,

What about

VIRTIO_F_ANY_LAYOUT

I see this one is currently set in requested_features. IIUC, qemu will
assume that device supports VIRTIO_F_ANY_LAYOUT if we don't reset it.

And I see two more flags.

VIRTIO_F_ORDER_PLATFORM
VIRTIO_F_SR_IOV

Should this be part of user_feature_bits[] too?

Thanks
Vivek

> 
> QEMU's virtiofsd does not enable either of these for now, but it's worth
> allowing the vhost-user device backend to participate in negotiation so
> that this can change in the future (or alternative virtiofsd
> implementations can support these features).



> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs

