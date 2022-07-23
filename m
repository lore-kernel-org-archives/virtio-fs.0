Return-Path: <lulu@redhat.com>
From: Cindy Lu <lulu@redhat.com>
Date: Sat, 23 Jul 2022 16:54:15 +0800
Message-Id: <20220723085425.823472-1-lulu@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Subject: [Virtio-fs] [PATCH v14 00/10] vhost-vdpa: add support for configure
 interrupt
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: lulu@redhat.com, qemu-devel@nongnu.org
Cc: Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, virtio-fs@redhat.com, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, Jason Wang <jasowang@redhat.com>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>

These patches are interduce the support for configure interrupt=0D
=0D
These codes are all tested on x86_64 and aarch64 platform.=0D
In the scenario with vp-vdpa/vdpa_sim /virtio net device, with=0D
the irqfd and without irqfd=0D
=0D
tested in virtio-pci bus and virtio-mmio bus=0D
=0D
Change in v2:=0D
Add support for virtio-mmio bus=0D
active the notifier while the backend support configure interrupt=0D
misc fixes from v1=0D
=0D
Change in v3=0D
fix the coding style problems=0D
=0D
Change in v4=0D
misc fixes from v3=0D
merge the set_config_notifier to set_guest_notifier=0D
when vdpa start, check the feature by VIRTIO_NET_F_STATUS=0D
=0D
Change in v5=0D
misc fixes from v4=0D
split the code to introduce configure interrupt type and the callback funct=
ion=0D
will init the configure interrupt in all virtio-pci and virtio-mmio bus, bu=
t will=0D
only active while using vhost-vdpa driver=0D
=0D
Change in v6=0D
misc fixes from v5=0D
decouple vq from interrupt setting and misc process=0D
fix the bug in virtio_net_handle_rx=0D
=0D
Change in v7=0D
misc fixes from v6=0D
decouple vq from interrupt setting and misc process=0D
decouple vq from vector use/release process=0D
decouple vq from set notifier fd handler process=0D
move config_notifier and masked_config_notifier to VirtIODevice=0D
fix the bug in virtio_net_handle_rx, add more information=0D
add VIRTIO_CONFIG_IRQ_IDX as the queue number for configure interrupt=C2=A0=
=0D
=0D
Change in v8=0D
misc fixes from v7=0D
decouple vq from interrupt setting and misc process=0D
decouple vq from vector use/release process=0D
decouple vq from set notifier fd handler process=0D
move the vhost configure interrupt to vhost_net=0D
=0D
Change in v9=0D
misc fixes from v8=0D
address the comments from v8=0D
=0D
Change in v10=0D
fix the hang issue in qtest=0D
address the comments from v9=0D
=0D
Change in v11=0D
fix the crash in aarch64 plateform.=0D
fix the crash upstream reported=0D
=0D
Change in v12=0D
fix the typo and the comments=0D
=0D
changes in v13=0D
re-send the patches by git-publish=0D
=0D
Cindy Lu (10):=0D
  virtio: introduce macro VIRTIO_CONFIG_IRQ_IDX=0D
  virtio-pci: decouple notifier from interrupt process=0D
  virtio-pci: decouple the single vector from the interrupt process=0D
  vhost: introduce new VhostOps vhost_set_config_call=0D
  vhost-vdpa: add support for config interrupt=0D
  virtio: add support for configure interrupt=0D
  vhost: add support for configure interrupt=0D
  virtio-net: add support for configure interrupt=0D
  virtio-mmio: add support for configure interrupt=0D
  virtio-pci: add support for configure interrupt=0D
=0D
 hw/display/vhost-user-gpu.c       |  13 ++=0D
 hw/net/vhost_net.c                |   9 +=0D
 hw/net/virtio-net.c               |  20 ++-=0D
 hw/virtio/trace-events            |   1 +=0D
 hw/virtio/vhost-user-fs.c         |  14 ++=0D
 hw/virtio/vhost-vdpa.c            |   8 +=0D
 hw/virtio/vhost-vsock-common.c    |  14 ++=0D
 hw/virtio/vhost.c                 |  78 +++++++-=0D
 hw/virtio/virtio-crypto.c         |  14 ++=0D
 hw/virtio/virtio-mmio.c           |  27 +++=0D
 hw/virtio/virtio-pci.c            | 283 +++++++++++++++++++++---------=0D
 hw/virtio/virtio-pci.h            |   4 +-=0D
 hw/virtio/virtio.c                |  29 +++=0D
 include/hw/virtio/vhost-backend.h |   3 +=0D
 include/hw/virtio/vhost.h         |   4 +=0D
 include/hw/virtio/virtio.h        |   7 +=0D
 include/net/vhost_net.h           |   2 +=0D
 17 files changed, 443 insertions(+), 87 deletions(-)=0D
=0D
-- =0D
2.34.3=0D
=0D
