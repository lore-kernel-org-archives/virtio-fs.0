Return-Path: <lulu@redhat.com>
MIME-Version: 1.0
References: <20220724064454.875882-1-lulu@redhat.com>
 <20220726094357-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220726094357-mutt-send-email-mst@kernel.org>
From: Cindy Lu <lulu@redhat.com>
Date: Wed, 27 Jul 2022 15:01:40 +0800
Message-ID: <CACLfguXG5yXazYBRq5AGqB2bzuQPf-HyFnnKSx294EFvrGXNkA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v15 00/10] vhost-vdpa: add support for
 configure interrupt
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: QEMU Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Jason Wang <jasowang@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>

On Tue, 26 Jul 2022 at 21:45, Michael S. Tsirkin <mst@redhat.com> wrote:
>
> Hi!
> So I don't think this will make it in 7.1.
> I'll tag this to be merged afterwards, but just to make sure
> please ping me right after the release.
>
> Thanks!
>
Got it, thanks Michael, I will ping you that time.

Thanks
Cindy

> On Sun, Jul 24, 2022 at 02:44:44PM +0800, Cindy Lu wrote:
> > These patches introduced the support for configure interrupt
> > These codes are tested on x86_64 and aarch64 platforms.
> > the test scenario is based on vp-vdpa/vdpa_sim /virtio net device, with
> > the irqfd and without irqfd.
> > Tested in virtio-pci bus and virtio-mmio bus
> >
> > Change in v2:
> > Add support for virtio-mmio bus
> > active the notifier while the backend support configure interrupt
> > misc fixes from v1
> >
> > Change in v3
> > fix the coding style problems
> >
> > Change in v4
> > misc fixes from v3
> > merge the set_config_notifier to set_guest_notifier
> > when vdpa start, check the feature by VIRTIO_NET_F_STATUS
> >
> > Change in v5
> > misc fixes from v4
> > split the code to introduce configure interrupt type and the callback function
> > will init the configure interrupt in all virtio-pci and virtio-mmio bus, but will
> > only active while using vhost-vdpa driver
> >
> > Change in v6
> > misc fixes from v5
> > decouple vq from interrupt setting and misc process
> > fix the bug in virtio_net_handle_rx
> >
> > Change in v7
> > misc fixes from v6
> > decouple vq from interrupt setting and misc process
> > decouple vq from vector use/release process
> > decouple vq from set notifier fd handler process
> > move config_notifier and masked_config_notifier to VirtIODevice
> > fix the bug in virtio_net_handle_rx, add more information
> > add VIRTIO_CONFIG_IRQ_IDX as the queue number for configure interrupt
> >
> > Change in v8
> > misc fixes from v7
> > decouple vq from interrupt setting and misc process
> > decouple vq from vector use/release process
> > decouple vq from set notifier fd handler process
> > move the vhost configure interrupt to vhost_net
> >
> > Change in v9
> > misc fixes from v8
> > address the comments from v8
> >
> > Change in v10
> > fix the hang issue in qtest
> > address the comments from v9
> >
> > Change in v11
> > fix the crash in aarch64 plateform.
> > fix the crash upstream reported
> >
> > Change in v12
> > fix the typo and the comments
> >
> > changes in v13
> > re-send the patches by git-publish
> >
> > changes in v14
> > rebased the code based on upstream
> >
> > Cindy Lu (10):
> >   virtio: introduce macro VIRTIO_CONFIG_IRQ_IDX
> >   virtio-pci: decouple notifier from interrupt process
> >   virtio-pci: decouple the single vector from the interrupt process
> >   vhost: introduce new VhostOps vhost_set_config_call
> >   vhost-vdpa: add support for config interrupt
> >   virtio: add support for configure interrupt
> >   vhost: add support for configure interrupt
> >   virtio-net: add support for configure interrupt
> >   virtio-mmio: add support for configure interrupt
> >   virtio-pci: add support for configure interrupt
> >
> >  hw/display/vhost-user-gpu.c       |  15 ++
> >  hw/net/vhost_net.c                |   9 +
> >  hw/net/virtio-net.c               |  20 ++-
> >  hw/virtio/trace-events            |   1 +
> >  hw/virtio/vhost-user-fs.c         |  16 ++
> >  hw/virtio/vhost-vdpa.c            |   8 +
> >  hw/virtio/vhost-vsock-common.c    |  16 ++
> >  hw/virtio/vhost.c                 |  78 +++++++-
> >  hw/virtio/virtio-crypto.c         |  16 ++
> >  hw/virtio/virtio-mmio.c           |  27 +++
> >  hw/virtio/virtio-pci.c            | 283 +++++++++++++++++++++---------
> >  hw/virtio/virtio.c                |  29 +++
> >  include/hw/virtio/vhost-backend.h |   3 +
> >  include/hw/virtio/vhost.h         |   4 +
> >  include/hw/virtio/virtio-pci.h    |   4 +-
> >  include/hw/virtio/virtio.h        |   7 +
> >  include/net/vhost_net.h           |   2 +
> >  17 files changed, 451 insertions(+), 87 deletions(-)
> >
> > --
> > 2.34.3
> >
>

