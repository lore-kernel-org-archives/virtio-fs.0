DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=lizzy;
	h=Cc:To:Subject:Date:From:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Content-ID:
	Content-Description; bh=WLafEToa0pRZAOaZ33ttmtTNXix/ukq0+Ud6g4Kwog8=;
	b=Y8g39
	FcwlCG0LAADLEUoQanvWxbFJ7uPsVT9VHZiIf3kTyVgYkbJOS+vBuJKg1o6HQOpfzTYIqaY90/f7E
	1ELsGqE8AD9LJmE/p6k6lyTNHzF0mOhT8Dsvjp9tSGJiQcNfTbGU2GO6EwJrcpZUD8oMhsI3BNPTm
	HAXHWZ7q2IJvT7mk8R5WJWdrcvqoMjE4cdPAarE+Hg9hnvpU5KkxM8Khs+UDa91Qrn07JkLogqjFe
	FwPiBBHzFwcJllzK/g3DkkvVhZMGh6oCf0GQXHt9llvPdrvQiTzgX89NwcSif4qr7g6p+2OJLRjtx
	uFajbQQGhLGu4eeyzvJ6H2KQxhTNQ==
Message-Id: <cover.1633376313.git.qemu_oss@crudebyte.com>
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Mon, 4 Oct 2021 21:38:00 +0200
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v2 0/3] virtio: increase VIRTQUEUE_MAX_SIZE to
	32k
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Amit Shah <amit@kernel.org>, David Hildenbrand <david@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, Fam Zheng <fam@euphon.net>

At the moment the maximum transfer size with virtio is limited to 4M
(1024 * PAGE_SIZE). This series raises this limit to its maximum
theoretical possible transfer size of 128M (32k pages) according to the
virtio specs:

https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.html#x1-240006

Maintainers: if you don't care about allowing users to go beyond 4M then no
action is required on your side for now. This series preserves the old value
of 1k for now by using VIRTQUEUE_LEGACY_MAX_SIZE on your end.

If you do want to support 128M however, then replace
VIRTQUEUE_LEGACY_MAX_SIZE by VIRTQUEUE_MAX_SIZE on your end (see patch 3 as
example for 9pfs being the first virtio user supporting it) and make sure
that this new transfer size limit is actually supported by you.

Changes v1 -> v2:

  * Instead of simply raising VIRTQUEUE_MAX_SIZE to 32k for all virtio
    users, preserve the old value of 1k for all virtio users unless they
    explicitly opted in:
    https://lists.gnu.org/archive/html/qemu-devel/2021-10/msg00056.html

Christian Schoenebeck (3):
  virtio: turn VIRTQUEUE_MAX_SIZE into a variable
  virtio: increase VIRTQUEUE_MAX_SIZE to 32k
  virtio-9p-device: switch to 32k max. transfer size

 hw/9pfs/virtio-9p-device.c     |  3 ++-
 hw/block/vhost-user-blk.c      |  6 +++---
 hw/block/virtio-blk.c          |  7 ++++---
 hw/char/virtio-serial-bus.c    |  2 +-
 hw/display/virtio-gpu-base.c   |  2 +-
 hw/input/virtio-input.c        |  2 +-
 hw/net/virtio-net.c            | 25 ++++++++++++------------
 hw/scsi/virtio-scsi.c          |  2 +-
 hw/virtio/vhost-user-fs.c      |  6 +++---
 hw/virtio/vhost-user-i2c.c     |  3 ++-
 hw/virtio/vhost-vsock-common.c |  2 +-
 hw/virtio/virtio-balloon.c     |  4 ++--
 hw/virtio/virtio-crypto.c      |  3 ++-
 hw/virtio/virtio-iommu.c       |  2 +-
 hw/virtio/virtio-mem.c         |  2 +-
 hw/virtio/virtio-mmio.c        |  4 ++--
 hw/virtio/virtio-pmem.c        |  2 +-
 hw/virtio/virtio-rng.c         |  3 ++-
 hw/virtio/virtio.c             | 35 +++++++++++++++++++++++-----------
 include/hw/virtio/virtio.h     | 25 ++++++++++++++++++++++--
 20 files changed, 90 insertions(+), 50 deletions(-)

-- 
2.20.1

