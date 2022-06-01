Return-Path: <slp@redhat.com>
Date: Wed, 1 Jun 2022 08:01:19 +0200
From: Sergio Lopez <slp@redhat.com>
Message-ID: <20220601060045.7wjgfqkmcruraif7@mhamilton>
References: <BY5PR14MB3893A6AA17C5FEBE843B640286D99@BY5PR14MB3893.namprd14.prod.outlook.com>
 <Yo8xDlTWijVMVNli@stefanha-x1.localdomain>
 <20220526080646.vsfmqgxyiglhe64r@mhamilton>
 <YpVBKsogLU8/5kiV@redhat.com>
 <BY5PR14MB3893602BAEFA362A5C62485386DC9@BY5PR14MB3893.namprd14.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="ubi6gtl647wom7hw"
Content-Disposition: inline
In-Reply-To: <BY5PR14MB3893602BAEFA362A5C62485386DC9@BY5PR14MB3893.namprd14.prod.outlook.com>
Subject: Re: [Virtio-fs] vhost_set_vring_kick failed
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Pra.. Dew.." <linux_learner@outlook.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>


--ubi6gtl647wom7hw
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="w73vybx4nlbw3jse"
Content-Disposition: inline


--w73vybx4nlbw3jse
Content-Type: multipart/mixed; boundary="olxi4fcfwfrd7o5c"
Content-Disposition: inline


--olxi4fcfwfrd7o5c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 31, 2022 at 10:25:12PM +0000, Pra.. Dew.. wrote:
> Thank you so much Vivek. I enabled the trace in the code itself and
> ran it. The only message I got was InvalidParam message below. I did
> not get any other message.  We are going to try changing the
> structure [VhostUserMemRegMsg]  padding to see if that fixes the
> problem. Is there anything else we should try?

Applying 3009edff81 to qemu-5.1.0 should do the trick. I'm attaching
the patch to this email, so you can simply apply it with something
like:

patch -p1 < 0001-vhost-user-fix-VHOST_USER_ADD-REM_MEM_REG-truncation.patch

Sergio.

--olxi4fcfwfrd7o5c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-vhost-user-fix-VHOST_USER_ADD-REM_MEM_REG-truncation.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 3009edff8192991293fe9e2b50b0d90db83c4a89 Mon Sep 17 00:00:00 2001
=46rom: Stefan Hajnoczi <stefanha@redhat.com>
Date: Mon, 9 Nov 2020 17:43:55 +0000
Subject: [PATCH] vhost-user: fix VHOST_USER_ADD/REM_MEM_REG truncation

QEMU currently truncates the mmap_offset field when sending
VHOST_USER_ADD_MEM_REG and VHOST_USER_REM_MEM_REG messages. The struct
layout looks like this:

  typedef struct VhostUserMemoryRegion {
      uint64_t guest_phys_addr;
      uint64_t memory_size;
      uint64_t userspace_addr;
      uint64_t mmap_offset;
  } VhostUserMemoryRegion;

  typedef struct VhostUserMemRegMsg {
      uint32_t padding;
      /* WARNING: there is a 32-bit hole here! */
      VhostUserMemoryRegion region;
  } VhostUserMemRegMsg;

The payload size is calculated as follows when sending the message in
hw/virtio/vhost-user.c:

  msg->hdr.size =3D sizeof(msg->payload.mem_reg.padding) +
      sizeof(VhostUserMemoryRegion);

This calculation produces an incorrect result of only 36 bytes.
sizeof(VhostUserMemRegMsg) is actually 40 bytes.

The consequence of this is that the final field, mmap_offset, is
truncated. This breaks x86_64 TCG guests on s390 hosts. Other guest/host
combinations may get lucky if either of the following holds:
1. The guest memory layout does not need mmap_offset !=3D 0.
2. The host is little-endian and mmap_offset <=3D 0xffffffff so the
   truncation has no effect.

Fix this by extending the existing 32-bit padding field to 64-bit. Now
the padding reflects the actual compiler padding. This can be verified
using pahole(1).

Also document the layout properly in the vhost-user specification.  The
vhost-user spec did not document the exact layout. It would be
impossible to implement the spec without looking at the QEMU source
code.

Existing vhost-user frontends and device backends continue to work after
this fix has been applied. The only change in the wire protocol is that
QEMU now sets hdr.size to 40 instead of 36. If a vhost-user
implementation has a hardcoded size check for 36 bytes, then it will
fail with new QEMUs. Both QEMU and DPDK/SPDK don't check the exact
payload size, so they continue to work.

Fixes: f1aeb14b0809e313c74244d838645ed25e85ea63 ("Transmit vhost-user memor=
y regions individually")
Cc: Raphael Norwitz <raphael.norwitz@nutanix.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20201109174355.1069147-1-stefanha@redhat.com>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Fixes: f1aeb14b0809 ("Transmit vhost-user memory regions individually")
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Raphael Norwitz <raphael.norwitz@nutanix.com>
---
 contrib/libvhost-user/libvhost-user.h |  2 +-
 docs/interop/vhost-user.rst           | 21 +++++++++++++++++++--
 hw/virtio/vhost-user.c                |  5 ++---
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/contrib/libvhost-user/libvhost-user.h b/contrib/libvhost-user/=
libvhost-user.h
index a1539dbb69..7d47f1364a 100644
--- a/contrib/libvhost-user/libvhost-user.h
+++ b/contrib/libvhost-user/libvhost-user.h
@@ -136,7 +136,7 @@ typedef struct VhostUserMemory {
 } VhostUserMemory;
=20
 typedef struct VhostUserMemRegMsg {
-    uint32_t padding;
+    uint64_t padding;
     VhostUserMemoryRegion region;
 } VhostUserMemRegMsg;
=20
diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index 988f154144..6d4025ba6a 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -131,6 +131,23 @@ A region is:
=20
 :mmap offset: 64-bit offset where region starts in the mapped memory
=20
+Single memory region description
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
++---------+---------------+------+--------------+-------------+
+| padding | guest address | size | user address | mmap offset |
++---------+---------------+------+--------------+-------------+
+
+:padding: 64-bit
+
+:guest address: a 64-bit guest address of the region
+
+:size: a 64-bit size
+
+:user address: a 64-bit user address
+
+:mmap offset: 64-bit offset where region starts in the mapped memory
+
 Log description
 ^^^^^^^^^^^^^^^
=20
@@ -1281,7 +1298,7 @@ Master message types
 ``VHOST_USER_ADD_MEM_REG``
   :id: 37
   :equivalent ioctl: N/A
-  :slave payload: memory region
+  :slave payload: single memory region description
=20
   When the ``VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS`` protocol
   feature has been successfully negotiated, this message is submitted
@@ -1296,7 +1313,7 @@ Master message types
 ``VHOST_USER_REM_MEM_REG``
   :id: 38
   :equivalent ioctl: N/A
-  :slave payload: memory region
+  :slave payload: single memory region description
=20
   When the ``VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS`` protocol
   feature has been successfully negotiated, this message is submitted
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 9c5b4f7fbc..2fdd5daf74 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -149,7 +149,7 @@ typedef struct VhostUserMemory {
 } VhostUserMemory;
=20
 typedef struct VhostUserMemRegMsg {
-    uint32_t padding;
+    uint64_t padding;
     VhostUserMemoryRegion region;
 } VhostUserMemRegMsg;
=20
@@ -800,8 +800,7 @@ static int vhost_user_add_remove_regions(struct vhost_d=
ev *dev,
     uint64_t shadow_pcb[VHOST_USER_MAX_RAM_SLOTS] =3D {};
     int nr_add_reg, nr_rem_reg;
=20
-    msg->hdr.size =3D sizeof(msg->payload.mem_reg.padding) +
-        sizeof(VhostUserMemoryRegion);
+    msg->hdr.size =3D sizeof(msg->payload.mem_reg);
=20
     /* Find the regions which need to be removed or added. */
     scrub_shadow_regions(dev, add_reg, &nr_add_reg, rem_reg, &nr_rem_reg,
--=20
2.36.1


--olxi4fcfwfrd7o5c--

--w73vybx4nlbw3jse--

--ubi6gtl647wom7hw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmKXAK8ACgkQ9GknjS8M
AjV9uw/+IvfPp5u8AOoIG72lz8IhE3ad5ZIgXV1u/xsfXRJac7yQR/64KUmDpLNz
EoSI9M+9Q0CDpNKDyFo2PF6+vqmNcbunXqmE+5TwiTPvW59bYYg/jlzoPkdxGDmh
jNt7mVKDYnywxh3riEiPqwAx8EJEROwHLjhY8CJMwPbodbYSwMczVHUJ+2fUIEEP
CHo3sZZOyyCRw2nh4N+KMg2iynrU9nllb8d/NFScu8/CPXgmCfL/4xJAtU6jk64C
zKXedcyU9/iIWiXfTxL1cxSOqQs0dgwxMYdwKCFFtmBzBCD9JW5XpEcZXkikjgmj
4+O9pjfEN+eJCFyyb+y/23yqcxCz5r4JsWwysNlhRp6bujESxMYN3OilZM8aDDh8
RF9JflmF6SCS2Ec1c3TzEze8zi0YTgr4rk302TSQE150o3ka88mfan+Uv50U7T5A
zxC5ZC+38Dzq1pTxgWznLHt6D6y8LVit1RRc4AoIugTNdObIlgo/TT7tQyJ3EXSI
aDzPOpVmkjqSVy0Cx7aZKKJ78OzWczVecv9VkdImAB3BfmbkeQ1S7KDh6YwKaDNy
Xr79EhGeVv+QGiqgnez9dFtx3I6sXcdGLcn8lCR4RldrnOOEftxMjmQahk2bP4YZ
EuNqPkTTIDG26HdeKTvCCB6KmP4NnqpzpKd/Q1stxtd7ZaXsuhQ=
=ZqQX
-----END PGP SIGNATURE-----

--ubi6gtl647wom7hw--
