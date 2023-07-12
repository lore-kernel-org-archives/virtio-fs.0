Return-Path: <hreitz@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
Date: Wed, 12 Jul 2023 13:16:59 +0200
Message-ID: <20230712111703.28031-2-hreitz@redhat.com>
In-Reply-To: <20230712111703.28031-1-hreitz@redhat.com>
References: <20230712111703.28031-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 1/4] vhost-user.rst: Migrating
 back-end-internal state
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Hanna Czenczek <hreitz@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>

For vhost-user devices, qemu can migrate the virtio state, but not the
back-end's internal state.  To do so, we need to be able to transfer
this internal state between front-end (qemu) and back-end.

At this point, this new feature is added for the purpose of virtio-fs
migration.  Because virtiofsd's internal state will not be too large, we
believe it is best to transfer it as a single binary blob after the
streaming phase.

These are the additions to the protocol:
- New vhost-user protocol feature VHOST_USER_PROTOCOL_F_MIGRATORY_STATE
- SET_DEVICE_STATE_FD function: Front-end and back-end negotiate a pipe
  over which to transfer the state.
- CHECK_DEVICE_STATE: After the state has been transferred through the
  pipe, the front-end invokes this function to verify success.  There is
  no in-band way (through the pipe) to indicate failure, so we need to
  check explicitly.

Once the transfer pipe has been established via SET_DEVICE_STATE_FD
(which includes establishing the direction of transfer and migration
phase), the sending side writes its data into the pipe, and the reading
side reads it until it sees an EOF.  Then, the front-end will check for
success via CHECK_DEVICE_STATE, which on the destination side includes
checking for integrity (i.e. errors during deserialization).

Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
---
 docs/interop/vhost-user.rst | 87 +++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index ac6be34c4c..c98dfeca25 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -334,6 +334,7 @@ in the ancillary data:
 * ``VHOST_USER_SET_VRING_ERR``
 * ``VHOST_USER_SET_BACKEND_REQ_FD`` (previous name ``VHOST_USER_SET_SLAVE_REQ_FD``)
 * ``VHOST_USER_SET_INFLIGHT_FD`` (if ``VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD``)
+* ``VHOST_USER_SET_DEVICE_STATE_FD``
 
 If *front-end* is unable to send the full message or receives a wrong
 reply it will close the connection. An optional reconnection mechanism
@@ -497,6 +498,44 @@ it performs WAKE ioctl's on the userfaultfd to wake the stalled
 back-end.  The front-end indicates support for this via the
 ``VHOST_USER_PROTOCOL_F_PAGEFAULT`` feature.
 
+.. _migrating_backend_state:
+
+Migrating back-end state
+^^^^^^^^^^^^^^^^^^^^^^^^
+
+If the back-end has internal state that is to be sent from source to
+destination, the front-end may be able to store and transfer it via an
+internal migration stream.  Support for this is negotiated with the
+``VHOST_USER_PROTOCOL_F_MIGRATORY_STATE`` feature.
+
+First, a channel over which the state is transferred is established on
+the source side using the ``VHOST_USER_SET_DEVICE_STATE_FD`` message.
+This message has two parameters:
+
+* Direction of transfer: On the source, the data is saved, transferring
+  it from the back-end to the front-end.  On the destination, the data
+  is loaded, transferring it from the front-end to the back-end.
+
+* Migration phase: Currently, only the period after memory transfer
+  before switch-over is supported, in which the device is suspended and
+  all of its rings are stopped.
+
+Then, the writing end will write all the data it has, signalling the end
+of data by closing its end of the pipe.  The reading end must read all
+of this data and process it:
+
+* If saving, the front-end will transfer this data to the destination,
+  where it is loaded into the destination back-end.
+
+* If loading, the back-end must deserialize its internal state from the
+  transferred data and be set up to resume operation.
+
+After the front-end has seen all data transferred (saving: seen an EOF
+on the pipe; loading: closed its end of the pipe), it sends the
+``VHOST_USER_CHECK_DEVICE_STATE`` message to verify that data transfer
+was successful in the back-end, too.  The back-end responds once it
+knows whether the tranfer and processing was successful or not.
+
 Memory access
 -------------
 
@@ -891,6 +930,7 @@ Protocol features
   #define VHOST_USER_PROTOCOL_F_STATUS               16
   #define VHOST_USER_PROTOCOL_F_XEN_MMAP             17
   #define VHOST_USER_PROTOCOL_F_SUSPEND              18
+  #define VHOST_USER_PROTOCOL_F_MIGRATORY_STATE      19
 
 Front-end message types
 -----------------------
@@ -1471,6 +1511,53 @@ Front-end message types
   before.  The back-end must again begin processing rings that are not
   stopped, and it may resume background operations.
 
+``VHOST_USER_SET_DEVICE_STATE_FD``
+  :id: 43
+  :equivalent ioctl: N/A
+  :request payload: device state transfer parameters
+  :reply payload: ``u64``
+
+  The front-end negotiates a pipe over which to transfer the back-end’s
+  internal state during migration.  For this purpose, this message is
+  accompanied by a file descriptor that is to be the back-end’s end of
+  the pipe.  If the back-end can provide a more efficient pipe (i.e.
+  because it internally already has a pipe into/from which to
+  put/receive state), it can ignore this and reply with a different file
+  descriptor to serve as the front-end’s end.
+
+  The request payload contains parameters for the subsequent data
+  transfer, as described in the :ref:`Migrating back-end state
+  <migrating_backend_state>` section.  That section also explains the
+  data transfer itself.
+
+  The value returned is both an indication for success, and whether a
+  new pipe file descriptor is returned: Bits 0–7 are 0 on success, and
+  non-zero on error.  Bit 8 is the invalid FD flag; this flag is set
+  when there is no file descriptor returned.  When this flag is not set,
+  the front-end must use the returned file descriptor as its end of the
+  pipe.  The back-end must not both indicate an error and return a file
+  descriptor.
+
+  Using this function requires prior negotiation of the
+  ``VHOST_USER_PROTOCOL_F_MIGRATORY_STATE`` feature.
+
+``VHOST_USER_CHECK_DEVICE_STATE``
+  :id: 44
+  :equivalent ioctl: N/A
+  :request payload: N/A
+  :reply payload: ``u64``
+
+  After transferring the back-end’s internal state during migration (see
+  the :ref:`Migrating back-end state <migrating_backend_state>`
+  section), check whether the back-end was able to successfully fully
+  process the state.
+
+  The value returned indicates success or error; 0 is success, any
+  non-zero value is an error.
+
+  Using this function requires prior negotiation of the
+  ``VHOST_USER_PROTOCOL_F_MIGRATORY_STATE`` feature.
+
 
 Back-end message types
 ----------------------
-- 
2.41.0

