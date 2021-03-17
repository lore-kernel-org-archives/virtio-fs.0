Date: Wed, 17 Mar 2021 10:05:32 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YFHUbEdszo4nursr@stefanha-x1.localdomain>
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
	<CAJ+F1CLZ4VtgKp5fEdC70m22PgV2VHvRHunR-nPOWDnJPFvqqg@mail.gmail.com>
	<CAFQAk7hCqSMMfRjUO8vtK-B2cKxJZZTJgSDAbRycd1AOSktM_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9Vc79ZT7RY7KtoLf"
Content-Disposition: inline
In-Reply-To: <CAFQAk7hCqSMMfRjUO8vtK-B2cKxJZZTJgSDAbRycd1AOSktM_w@mail.gmail.com>
Subject: Re: [Virtio-fs] [External] Re: [RFC PATCH 0/9] Support for
 Virtio-fs daemon crash reconnection
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, QEMU <qemu-devel@nongnu.org>, virtio-fs@redhat.com, Xie Yongji <xieyongji@bytedance.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@gmail.com>


--9Vc79ZT7RY7KtoLf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 18, 2020 at 05:39:34PM +0800, Jiachen Zhang wrote:
> Thanks for the suggestions. Actually, we choose to save all state
> information to QEMU because a virtiofsd has the same lifecycle as its
> QEMU master. However, saving things to a file do avoid communication with
> QEMU, and we no longer need to increase the complexity of vhost-user
> protocol. The suggestion to save fds to the systemd is also very reasonab=
le
> if we don't consider the lifecycle issues, we will try it.

Hi,
We recently discussed crash recovery in the virtio-fs bi-weekly call and
I read some of this email thread because it's a topic I'm interested in.

I agree with Marc-Andr=E9 that storing file descriptors does not need to
be in the vhost-user protocol. The lifetime of a vhost-user device
backend is not controlled by the VMM since the device backend is
launched separately. Therefore it's reasonable for the component that
launched the device backend to also have the responsibility of cleaning
up the vhost-user device backend.

Using the sd_notify(3) interface is a neat idea. It's supported natively
by systemd but you can also implement a compatible interface in your own
software. This way the vhost-user device backend can be launched using
systemd or your own software.

That said, if people find it more convenient to store fds using the
vhost-user protocol, then I think that is enough justification to add a
generic message to the vhost-user protocol. The important thing is to
make the message generic so it solves all crash recovery use cases. The
inflight fd messages were too specific and now we're having to think
about adding more messages again.

Stefan

--9Vc79ZT7RY7KtoLf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBR1GwACgkQnKSrs4Gr
c8jYOQf9E6s0sDs+N1LozftpB4f74CvIEp3WRfZUHlIxK70WayhhZXu41S7McL8I
XOIod9IFtXJ01ZobnW5MqAFuuz/iLjwd2bqItZl/FiYB6xGLpNBzBNST9a5MIuFs
CfRvdol5zaPKp1BMfXCKaBEMIAycyd3p+Pt1pfBt6MswfbSgFEKPaRB4UbNz8EmH
Km7fKIjeLYqUHlTUgq5tFlfZaFtXW3uG8aMc2jm35SbCn2NxyYBBKJpyfpYBmVXH
Xf6dVYNoPtLc/KPP8jCsKfWhhhQTHr9mR+m3yEXU9QUGQi4pQNnQ1i4RWpEnrSBi
K3igrjfGyc6XiPYwaFaZXOZWSEapWQ==
=GuLY
-----END PGP SIGNATURE-----

--9Vc79ZT7RY7KtoLf--

