Date: Tue, 13 Apr 2021 09:53:35 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YHVcDwX7bCW6T1B2@stefanha-x1.localdomain>
References: <20210408195534.647895-1-antonkuchin@yandex-team.ru>
	<20210409155657.GE1111800@redhat.com>
	<14f05a3d-7db6-2c01-7fe0-f83586ff1fd6@yandex-team.ru>
	<20210412184316.GF1184147@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="QSTS3cQwv5Jgiqij"
Content-Disposition: inline
In-Reply-To: <20210412184316.GF1184147@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] vhost-user-fs: fix features handling
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Anton Kuchin <antonkuchin@yandex-team.ru>, "Michael S. Tsirkin" <mst@redhat.com>


--QSTS3cQwv5Jgiqij
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 12, 2021 at 02:43:16PM -0400, Vivek Goyal wrote:
> On Sun, Apr 11, 2021 at 09:21:54AM +0300, Anton Kuchin wrote:
> >=20
> > On 09/04/2021 18:56, Vivek Goyal wrote:
> > > On Thu, Apr 08, 2021 at 10:55:34PM +0300, Anton Kuchin wrote:
> > > > Make virtio-fs take into account server capabilities.
> > > >=20
> > > > Just returning requested features assumes they all of then are impl=
emented
> > > > by server and results in setting unsupported configuration if some =
of them
> > > > are absent.
> > > >=20
> > > > Signed-off-by: Anton Kuchin<antonkuchin@yandex-team.ru>
> > > [CC stefan and qemu-devel.]
> > >=20
> > > Can you give more details of what problem exactly you are facing. Or
> > > this fix is about avoiding a future problem where device can refuse
> > > to support a feature qemu is requesting for.
> >=20
> > This fixes existing problem that qemu ignores features (un)supported by
> > backend and this works fine only if backend features match features of =
qemu.
> > Otherwise qemu incorrectly assumes that backend suports all of them and
> > calls vhost_set_features() not taking into account result of previous
> > vhost_get_features() call. This breaks protocol and can crash server or
> > cause incorrect behavior.
> >=20
> > This is why I hope it to be accepted in time for 6.0 release.
> >=20
> > > IIUC, this patch is preparing a list of features vhost-user-fs device
> > > can support. Then it calls vhost_get_features() which makes sure that
> > > all these features are support by real vhost-user device (hdev->featu=
res).
> > > If not, then corresponding feature is reset and remaining features
> > > are returned to caller.
> > When this callback is executed in virtio_bus_device_plugged() list of
> > features that vhost-backend supports has been already obtained earlier =
by
> > vhost_user_get_features() in vuf_device_realize() and stored in
> > hdev->features.
>=20
> > vuf_get_features() should return bitmask of features that
> > are common for vhost backend (hdev->features) and frontend
> > (vdev->host_features).
>=20
> But that's not what exactly this patch seems to be doing.
> IIUC, It only resets some of the features from list passed from
> the caller. So whatever has been defined in user_feature_bits[],
> and if these features are not supported by vhost-user backend, then
> that feature will be reset before returning to caller.
>=20
> So the question is what are those features which should be in
> user_feature_bits[]? For example, by default libvhost-user
> also supports.
>=20
>         /* vhost-user feature bits */
>         1ULL << VHOST_F_LOG_ALL |
>         1ULL << VHOST_USER_F_PROTOCOL_FEATURES;
>=20
> Should that be in user_feature_bits[] too. So that if a customer
> vhost-user-fs backend does not support VHOST_F_LOG_ALL or
> VHOST_USER_F_PROTOCOL_FEATURES, it is reset.
>=20
> IIUC, your current patch is not going to reset these features if
> caller passed you those in vuf_get_features(,requested_features).
>=20
> So to me this becomes more of a question that what are those common
> features which both the ends of vhost-user device should support for
> it to work and should be checked in vuf_get_features().=20

VHOST_F_LOG_ALL and VHOST_USER_F_PROTOCOL_FEATURES are controlled by
hw/virtio/vhost.c and hw/virtio/vhost-user.c. These feature bits are
part of the vhost-user protocol and are not involved in guest-visible
VIRTIO feature negotiation. It's confusing because these bits use the
same namespace as VIRTIO features but it is correct to omit it from
user_feature_bits[].

Stefan

--QSTS3cQwv5Jgiqij
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmB1XA8ACgkQnKSrs4Gr
c8g02ggArV+Wj1NH9XK5UCF5iuSo0MOaFnV+MEiTNa8WIdo7AuuLaEj55B7IEwQZ
dm1x0s0cEEi8DOI8Ru+a3jPqupe3i0BrOFQELdWVgtVCFmkOZBeBo4RDHUWFM9Ay
g44WLpS0bbwuMdqCTfKsVEA6TlqT7xW+CJlWI+e580/kGFZNUoQkFh+ogf0ySG30
cuMMXNBw5nzv7sUJiGD4cU6LUvfbhNlGrolFDpSU4HDRKXYpTsYcohOK2Ak+JebK
gGnNpTnggo/S1VQzGS8NlEtu+7D29h4dQGPSzYj5bsyVSDUjXn1EBICdIrQtBHbk
XtOP+wqprnkmvaxsN6AldWqw35U/2A==
=o6ac
-----END PGP SIGNATURE-----

--QSTS3cQwv5Jgiqij--

