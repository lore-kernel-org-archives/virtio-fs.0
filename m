Return-Path: <mst@redhat.com>
Date: Sat, 5 Nov 2022 14:16:21 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20221105172453.445049-4-mst@redhat.com>
References: <20221105172453.445049-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20221105172453.445049-1-mst@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH RFC 3/3] virtio: revert changes to
 virtio_device_started
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

virtio core often needs to know whether device is started, this is what
virtio_device_started already did. However, backends want to know
whether virtio is actually running which also depends on whether vm is
running. To address this we moved the check to virtio_device_started,
but this changes virtio core behavior which wasn't intentional.
Now that backends use the new virtio_device_running API,
revert the change to virtio_device_started.

Fixes: 9f6bcfd99f ("hw/virtio: move vm_running check to virtio_device_started")
Cc: "Alex Bennée" <alex.bennee@linaro.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/hw/virtio/virtio.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 634c24513f..de8d78af12 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -395,10 +395,6 @@ static inline bool virtio_device_started(VirtIODevice *vdev, uint8_t status)
         return vdev->started;
     }
 
-    if (!vdev->vm_running) {
-        return false;
-    }
-
     return status & VIRTIO_CONFIG_S_DRIVER_OK;
 }
 
-- 
MST

