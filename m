Date: Thu, 28 Jan 2021 16:52:34 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210128165234.GC20377@stefanha-x1.localdomain>
References: <20210125180115.22936-1-vgoyal@redhat.com>
	<20210125180115.22936-5-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="m51xatjYGsM+13rf"
Content-Disposition: inline
In-Reply-To: <20210125180115.22936-5-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 4/6] qemu,
 vhost-user: Extend protocol to start/stop/flush slave channel
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, mst@redhat.com, qemu-devel@nongnu.org


--m51xatjYGsM+13rf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 25, 2021 at 01:01:13PM -0500, Vivek Goyal wrote:
> Currently we don't have a mechanism to flush slave channel while shutting
> down vhost-user device and that can result a deadlock. Consider following
> scenario.
>=20
> 1. Slave gets a request from guest on virtqueue (say index 1, vq1), to map
>    a portion of file in qemu address space.
>=20
> 2. Thread serving vq1 receives this request and sends a message to qemu on
>    slave channel/fd and gets blocked in waiting for a response from qemu.
>=20
> 3. In the mean time, user does "echo b > /proc/sysrq-trigger" in guest. T=
his
>    leads to qemu reset and ultimately in main thread we end up in
>    vhost_dev_stop() which is trying to shutdown virtqueues for the device.
>=20
> 4. Slave gets VHOST_USER_GET_VRING_BASE message to shutdown a virtqueue on
>    unix socket being used for communication.
>=20
> 5. Slave tries to shutdown the thread serving vq1 and waits for it to
>    terminate. But vq1 thread can't terminate because it is waiting for
>    a response from qemu on slave_fd. And qemu is not processing slave_fd
>    anymore as qemu is ressing (and not running main event loop anymore)
>    and is waiting for a response to VHOST_USER_GET_VRING_BASE.
>=20
> So we have a deadlock. Qemu is waiting on slave to response to
> VHOST_USER_GET_VRING_BASE message and slave is waiting on qemu to
> respond to request it sent on slave_fd.
>=20
> I can reliably reproduce this race with virtio-fs.
>=20
> Hence here is the proposal to solve this problem. Enhance vhost-user
> protocol to properly shutdown slave_fd channel. And if there are pending
> requests, flush the channel completely before sending the request to
> shutdown virtqueues.
>=20
> New workflow to shutdown slave channel is.
>=20
> - Qemu sends VHOST_USER_STOP_SLAVE_CHANNEL request to slave. It waits
>   for an reply from guest.
>=20
> - Then qemu sits in a tight loop waiting for
>   VHOST_USER_SLAVE_STOP_CHANNEL_COMPLETE message from slave on slave_fd.
>   And while waiting for this message, qemu continues to process requests
>   on slave_fd to flush any pending requests. This will unblock threads
>   in slave and allow slave to shutdown slave channel.
>=20
> - Once qemu gets VHOST_USER_SLAVE_STOP_CHANNEL_COMPLETE message, it knows
>   no more requests will come on slave_fd and it can continue to shutdown
>   virtqueues now.
>=20
> - Once device starts again, qemu will send VHOST_USER_START_SLAVE_CHANNEL
>   message to slave to open the slave channel and receive requests.
>=20
> IOW, this allows for proper shutdown of slave channel, making sure
> no threads in slave are blocked on sending/receiving message. And
> this in-turn allows for shutting down of virtqueues, hence resolving
> the deadlock.

Is the new message necessary? How about letting QEMU handle slave fd
activity while waiting for virtqueues to stop instead?

In other words, QEMU should monitor both the UNIX domain socket and the
slave fd after it has sent VHOST_USER_GET_VRING_BASE and is awaiting the
response.

Stefan

--m51xatjYGsM+13rf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAS69IACgkQnKSrs4Gr
c8hvdgf/TJrKtCrO7zJeyOv/D2hjb69ypEdv7T50K7n0aSHSauRES52UfiLdDAqT
R31dPir+EXxOQCstuw0w9GSVxJxWt8HBD6Nq4aclhjYiRun8wnYdc6A6WPv79v5C
H4Q45pXw179Dy3NDvpz2vAARp5Us/5s+yT8bhAAn4rKBipL2rkoVPOPA8aGKqNXp
021MOsfZLm50G5nKT1qCQMfRHDaGkPnjWIQmYmCn5OVE7HFw1OOy+4cC0ybQu8XV
cjI5x/RZfMnhYDshIdGgRmfP2NpWZskTOJ/beYmcoVDBy9WVMjn/6M5GZ4bzt7Jv
emvUMTBfaiT73CXMiAzHuhWD9xuh7w==
=mOHF
-----END PGP SIGNATURE-----

--m51xatjYGsM+13rf--

