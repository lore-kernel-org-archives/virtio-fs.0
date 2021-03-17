Date: Wed, 17 Mar 2021 13:41:25 +0100
From: Sergio Lopez <slp@redhat.com>
Message-ID: <20210317124100.2bepcspqmi6knspi@mhamilton>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jhcg5vjdqed7xi6t"
Content-Disposition: inline
Subject: [Virtio-fs] Notifications from virtiofsd-rs project
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com


--jhcg5vjdqed7xi6t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I've just created a service [1] that receives GitLab webhook events
=66rom the virtiofsd-rs project and sends an email to this mailing
list.

To keep the noise as low as possible, it only sends an event when an
Issue or Merge Request is opened, reopened, merged or closed. If you
want to receive a notification for other events (such as when a
comment is added to an Issue or MR), you'd still need to subscribe to
them (you can subscribe only to a single Issue or MR) using the GitLab
interface.

In case you want to filter those messages, the mails will have
"virtiofs-bot@sinrega.org" as the sender.

If you find those notifications to be an inconvenience, please let me
now.

Thanks!
Sergio.

[1] https://gitlab.com/slp/gitlab-webhooks-email

--jhcg5vjdqed7xi6t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmBR+PUACgkQ9GknjS8M
AjWbeA//Q20F1i3cDeDFD6yRoHe8W1IaX1mD+eBX5Ly3J+atozapz5y1wfOwp+3n
XscYZ1HSxcN+7VhPg7siihv+jd0FlkV50X02XqBgiNRLCBqOPDD0QAyLGC78djEI
C5LF8u3X/wLeEu24lFBcIx4uG7oj8lsM1wJB1M9OiO1MkuOBDxHN3OlVPimUMMiJ
LJMBG8fOFp2UIEhtcOxBX5e6XMXyRoNv/QFipKFG5TcjipwfC/PqGBg78xZhD151
fAot/Jc+OmtIoRgUtCPLF/HUdpH9LEmdoD3pNL/egM6/eu9AbdW3YDY60jOj0SOW
ZtOYOXzkkdkYu19MSiyGO8xZKm/M+qdA3dsNyoev/JB8ImZfGXyoqYja3TpirlT7
MPZSmbWyDiq1XertVJSAhJ1/kO7CKTWBHUHGv+KQ0Y9leUAgXt1fNX9zUtJG2kOr
SRhtRPFRixjkMK/cP5q9p48+ddekQU24PU3Fwe/xLi8stkH4F6DkpPf/gba3uGih
2ECtKW/shox8mIbEWCKaBE6csGN54Nf40e9uwxl5FUL7uTtkieVADd3iS/xQR07D
TMAYCx4fqDAQv38nEjhy+LHjxytXZFoN0UlGDrKwD4TdyiaNrWHaJn7i9UKpyXPU
bk5RGyS5jyr+efxxU4uSwap4eupRrsMgVdUePcJ9JYEsGhqETFc=
=ymY9
-----END PGP SIGNATURE-----

--jhcg5vjdqed7xi6t--

