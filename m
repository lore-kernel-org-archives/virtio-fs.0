Return-Path: <hreitz@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
Date: Mon, 16 Oct 2023 15:42:39 +0200
Message-ID: <20231016134243.68248-4-hreitz@redhat.com>
In-Reply-To: <20231016134243.68248-1-hreitz@redhat.com>
References: <20231016134243.68248-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v5 3/7] vhost-user.rst: Introduce suspended state
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Hanna Czenczek <hreitz@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>

In vDPA, GET_VRING_BASE does not stop the queried vring, which is why
SUSPEND was introduced so that the returned index would be stable.  In
vhost-user, it does stop the vring, so under the same reasoning, it can
get away without SUSPEND.

Still, we do want to clarify that if the device is completely stopped,
i.e. all vrings are stopped, the back-end should cease to modify any
state relating to the guest.  Do this by calling it "suspended".

Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
---
 docs/interop/vhost-user.rst | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index e5a04c04ed..035a23ed35 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -442,6 +442,19 @@ back-end must enable all rings immediately.
 While processing the rings (whether they are enabled or not), the back-end
 must support changing some configuration aspects on the fly.
 
+.. _suspended_device_state:
+
+Suspended device state
+^^^^^^^^^^^^^^^^^^^^^^
+
+While all vrings are stopped, the device is *suspended*.  In addition to
+not processing any vring (because they are stopped), the device must:
+
+* not write to any guest memory regions,
+* not send any notifications to the guest,
+* not send any messages to the front-end,
+* still process and reply to messages from the front-end.
+
 Multiple queue support
 ----------------------
 
@@ -529,7 +542,8 @@ ancillary data, it may be used to inform the front-end that the log has
 been modified.
 
 Once the source has finished migration, rings will be stopped by the
-source. No further update must be done before rings are restarted.
+source (:ref:`Suspended device state <suspended_device_state>`). No
+further update must be done before rings are restarted.
 
 In postcopy migration the back-end is started before all the memory has
 been received from the source host, and care must be taken to avoid
@@ -1123,6 +1137,10 @@ Front-end message types
   (*a vring descriptor index for split virtqueues* vs. *vring descriptor
   indices for packed virtqueues*).
 
+  When and as long as all of a device’s vrings are stopped, it is
+  *suspended*, see :ref:`Suspended device state
+  <suspended_device_state>`.
+
   The request payload’s *num* field is currently reserved and must be
   set to 0.
 
-- 
2.41.0

