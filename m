Date: Mon, 10 Jun 2019 17:09:55 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190610160955.GA19995@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
Subject: [Virtio-fs] Adding notifications vq to the virtio-fs device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com
Cc: virtio-fs@redhat.com


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Vivek,
There is discussion of adding the notifications vq to the virtio-fs
device so that FUSE Notification messages are possible.  This was
previously discussed on the VIRTIO mailing lists here:
https://lists.oasis-open.org/archives/virtio-dev/201902/msg00074.html

The main issue is how to handle the case where the device wishes to
raise notifications but the driver has not supplied enough buffers.

FUSE requires reliable notification delivery.  We cannot drop
notifications.

The mechanism will have to support reliable delivery.  For example, the
device may need to pause further operation until the driver makes
buffers available again.  But this could lead to DoS or deadlocks, so
care is needed!

I hope this link is useful in restarting the discussion about the
notifications vq.

Stefan

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAlz+gNMACgkQnKSrs4Gr
c8jFEwgAgxg7vWbnp+8CwpS5WVY59QcfQXzDamLh/URvagczdcRM6fffutqccIyt
V6hLp8bS8D/HcUsck4evrxOuLoT2PCQoQSbFWqsJPXRduSA8UEtAOtsjMb1jbe/q
cATb2WilWrVMEeM/7Yjxn6VnSA9mtZHq3po/dt1YJHUFcYHtMb2UF0uJTfzqMvBa
rTANgOASyTMnGqaslcgzIKdl8KitV8cr0cn3B55aQ6M1WQzLBA6F6Sssi8Ew8Khi
T+78bXYPjY+XRxeq0BIildxa0/kboEFFsimCPcbpZQUnXegaDsV2t7ixG1nuGLSp
qIZJXr7TpSyU+HQF+XJVVqCdC+PzjA==
=WrV/
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--

