Return-Path: <mst@redhat.com>
Date: Sat, 5 Nov 2022 14:16:18 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20221105172453.445049-3-mst@redhat.com>
References: <20221105172453.445049-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20221105172453.445049-1-mst@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PATCH RFC 2/3] gpio: use virtio_device_running
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

Same as other vhost-user devices, vhost-user-gpio cares whether
device is running not whether frontend is started.
Switch to that.

Fixes: 27ba7b027f ("hw/virtio: add boilerplate for vhost-user-gpio device")
Cc: "Viresh Kumar" <viresh.kumar@linaro.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 hw/virtio/vhost-user-gpio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/vhost-user-gpio.c b/hw/virtio/vhost-user-gpio.c
index 8b40fe450c..f34ee59b6e 100644
--- a/hw/virtio/vhost-user-gpio.c
+++ b/hw/virtio/vhost-user-gpio.c
@@ -152,7 +152,7 @@ static void vu_gpio_stop(VirtIODevice *vdev)
 static void vu_gpio_set_status(VirtIODevice *vdev, uint8_t status)
 {
     VHostUserGPIO *gpio = VHOST_USER_GPIO(vdev);
-    bool should_start = virtio_device_started(vdev, status);
+    bool should_start = virtio_device_running(vdev, status);
 
     trace_virtio_gpio_set_status(status);
 
@@ -228,7 +228,7 @@ static int vu_gpio_connect(DeviceState *dev, Error **errp)
     }
 
     /* restore vhost state */
-    if (virtio_device_started(vdev, vdev->status)) {
+    if (virtio_device_running(vdev, vdev->status)) {
         vu_gpio_start(vdev);
     }
 
-- 
MST

