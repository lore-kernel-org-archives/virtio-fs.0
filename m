From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Fri, 23 Aug 2019 18:56:55 +0100
Message-Id: <20190823175657.12085-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 0/2] Add virtio-fs (experimental)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com
Cc: virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Hi,
  This pair of patches adds the core of the virtio-fs support to qemu;
it's marked experimental since the kernel patch and spec changes aren't
in yet; but they're bubbling along.

  While the spec change is still in progress; the ID number is already
reserved.

  A future set of patches will add the optional DAX mapping support.

  The actual qemu change is pretty minimal, since it's really only
a virtio device with some queues.

Some links:
  Mailing list: https://www.redhat.com/mailman/listinfo/virtio-fs
  Dev tree: Including filesystem daemon: https://gitlab.com/virtio-fs/qemu
  kernel: https://gitlab.com/virtio-fs/linux
  virtio spec changes: https://lists.oasis-open.org/archives/virtio-dev/201908/msg00104.html

v2:
  Renamed num_queues to num_request_queues
  Add a not-reached assert to vuf_handle_output
  Kill the one bit of notification queue off
  Use the same trick as vhost-user-scsi to calculate the number
    of vectors for the PCI device

Dr. David Alan Gilbert (2):
  virtio: add vhost-user-fs base device
  virtio: add vhost-user-fs-pci device

 configure                                   |  13 +
 hw/virtio/Makefile.objs                     |   2 +
 hw/virtio/vhost-user-fs-pci.c               |  85 ++++++
 hw/virtio/vhost-user-fs.c                   | 297 ++++++++++++++++++++
 include/hw/virtio/vhost-user-fs.h           |  45 +++
 include/standard-headers/linux/virtio_fs.h  |  41 +++
 include/standard-headers/linux/virtio_ids.h |   1 +
 7 files changed, 484 insertions(+)
 create mode 100644 hw/virtio/vhost-user-fs-pci.c
 create mode 100644 hw/virtio/vhost-user-fs.c
 create mode 100644 include/hw/virtio/vhost-user-fs.h
 create mode 100644 include/standard-headers/linux/virtio_fs.h

-- 
2.21.0

