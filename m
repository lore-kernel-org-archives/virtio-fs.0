Return-Path: <mst@redhat.com>
Date: Sat, 5 Nov 2022 14:16:25 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20221105172453.445049-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PATCH RFC 0/3] virtio fix up started checks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, virtio-fs@redhat.com

This is an attempt to fix up device started checks.
Unfortunately this causes failures in CI
and I could not figure it out.

The simplest way to test is to set QEMU_CI to 2
on gitlab, then push there.

Alternatively, push to gitlab, then
create pipeline while setting QEMU_CI to 1,
then run amd64-fedora-container and then clang-system -
that slows things down enough to make the failures
trigger.

See: https://gitlab.com/mstredhat/qemu/-/jobs/3279537476


Alex, Viresh, need your help here. Thanks!

Alex, pls note that same failures are triggered by your RFC - if we know the
root cause we can discuss solutions. So if you prefer pls go ahead and
debug that. Thanks!

Michael S. Tsirkin (3):
  virtio: distinguish between started and running
  gpio: use virtio_device_running
  virtio: revert changes to virtio_device_started

 include/hw/virtio/virtio.h   | 7 ++++++-
 hw/virtio/vhost-user-fs.c    | 2 +-
 hw/virtio/vhost-user-gpio.c  | 4 ++--
 hw/virtio/vhost-user-i2c.c   | 4 ++--
 hw/virtio/vhost-user-rng.c   | 4 ++--
 hw/virtio/vhost-user-vsock.c | 2 +-
 hw/virtio/vhost-vsock.c      | 2 +-
 7 files changed, 15 insertions(+), 10 deletions(-)

-- 
MST

