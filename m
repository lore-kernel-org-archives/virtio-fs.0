Date: Tue, 11 May 2021 13:45:13 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJp8WbMaf3Y8/F7l@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9aaZjKXeq39h++GG"
Content-Disposition: inline
Subject: [Virtio-fs] vhost-user reconnection and crash recovery
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Sebastien Boeuf <sebastien.boeuf@intel.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--9aaZjKXeq39h++GG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Sebastien,
On #virtio-fs IRC you asked:

 I have a vhost-user question regarding disconnection/reconnection. How
 should this be handled? Let's say the vhost-user backend disconnects,
 and reconnects later on, does QEMU reset the virtio device by notifying
 the guest? Or does it simply reconnects to the backend without letting
 the guest know about what happened?

The vhost-user protocol does not have a generic reconnection solution.
Reconnection is handled on a case-by-case basis because device-specific
and implementation-specific state is involved.

The vhost-user-fs-pci device in QEMU has not been tested with
reconnection as far as I know.

The ideal reconnection behavior is to resume the device from its
previous state without disrupting the guest. Device state must survive
reconnection in order for this to work. Neither QEMU virtiofsd nor
virtiofsd-rs implement this today.

virtiofs has a lot of state, making it particularly difficult to support
either DEVICE_NEEDS_RESET or transparent vhost-user reconnection. We
have discussed virtiofs crash recovery on the bi-weekly virtiofs call
(https://etherpad.opendev.org/p/virtiofs-external-meeting). If you want
to work on this then joining the call would be a good starting point to
coordinate with others.

One approach for transparent crash recovery is for virtiofsd to keep its
state in tmpfs (e.g. inode/fd mappings) and open fds shared with a
clone(2) process via CLONE_FILES. This way the virtiofsd process can
terminate but its state persists in memory thanks to its clone process.
The clone can then be used to launch the new virtiofsd process from the
old state. This would allow the device to resume transparently with QEMU
only reconnecting the vhost-user UNIX domain socket. This is an idea
that we discussed in the bi-weekly virtiofs call.

You mentioned device reset. VIRTIO 1.1 has the Device Status Field
DEVICE_NEEDS_RESET flat that the device can use to tell the driver that
a reset is necessary. This feature is present in the specification but
not implemented in the Linux guest drivers. Again the reason is that
handling it requires driver-specific logic for restoring state after
reset...otherwise the device reset would be visible to userspace.

Stefan

--9aaZjKXeq39h++GG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCafFkACgkQnKSrs4Gr
c8g+GQf5AblITnCMGNDRgZvNrDQbCXjzNGRCVFJvebOMl/Ssqosn0IuJncHCEPe1
UOOzT3M7uMALEIkBG3UOzQOpq5B1i1d6stkGPEaeQuRT408GYi2RuznqKhkGhV9R
B7ZCylqGY0tQ4s69FCYKxty8G+c9MDPQ6nFyT8MODqcV3tMqT5qc/oB9da5CjKJB
320mJ0WjqjK3m8zYHhmKzfCAZeZSQzpHqmyOhVrqJ6lIMfXN46K6zmB7OFCHK+/O
mSzLvQZBVusn3eDUw8Ag5+Ul0J1K5uCOzQQNB7zvO9aZQNeqDIvToRj4iGTI8TkP
nA5RokQvQ/09PAvwU8q5IYPPIxDfOg==
=4ZGn
-----END PGP SIGNATURE-----

--9aaZjKXeq39h++GG--

