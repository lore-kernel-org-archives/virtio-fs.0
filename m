Return-Path: <stefanha@redhat.com>
Date: Thu, 16 Feb 2023 16:00:51 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <Y+6Zgy7JgABed+RO@fedora>
References: <0d57cc40-693b-b36c-a135-fdac60dd00ec@yandex-team.ru>
 <CAJSP0QUXB0kgsCSsmi8dpnJFYho2cR_2Liep=pGmp6WzDZ_7pw@mail.gmail.com>
 <d6bf0b9a-a167-817d-2c17-c2e472961155@yandex-team.ru>
 <CAJSP0QXXe6KgLN2PJvi-5GqcELhUKJPB2pUARL2ktO9TQYAq=g@mail.gmail.com>
 <2fb6efb4-9155-99ad-3acd-c274783436ed@yandex-team.ru>
 <87h6w5ea1m.fsf@secure.mitica>
 <ed9832ec-eaf0-68a4-b7c1-9f1691ab149e@yandex-team.ru>
 <874js4v151.fsf@secure.mitica>
 <626f6e7c-07e4-4aa7-3cce-b96d9fd96d33@yandex-team.ru>
 <87mt5ly03z.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="nyKNCi8hOw9wwgQO"
Content-Disposition: inline
In-Reply-To: <87mt5ly03z.fsf@secure.mitica>
Subject: Re: [Virtio-fs] [PATCH] vhost-user-fs: add capability to allow
 migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Juan Quintela <quintela@redhat.com>
Cc: Anton Kuchin <antonkuchin@yandex-team.ru>, Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Markus Armbruster <armbru@redhat.com>, Eric Blake <eblake@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, yc-core@yandex-team.ru, "Michael S. Tsirkin" <mst@redhat.com>


--nyKNCi8hOw9wwgQO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 10, 2023 at 05:08:16PM +0100, Juan Quintela wrote:
> Anton Kuchin <antonkuchin@yandex-team.ru> wrote:
> > On 02/02/2023 11:59, Juan Quintela wrote:
> >> Anton Kuchin <antonkuchin@yandex-team.ru> wrote:
> >>> On 01/02/2023 16:26, Juan Quintela wrote:
> >>>> Anton Kuchin <antonkuchin@yandex-team.ru> wrote:
> >>>>> On 19/01/2023 18:02, Stefan Hajnoczi wrote:
> >>>>>> On Thu, 19 Jan 2023 at 10:29, Anton Kuchin <antonkuchin@yandex-tea=
m.ru> wrote:
> >>>>>>> On 19/01/2023 16:30, Stefan Hajnoczi wrote:
> >>>>>>>> On Thu, 19 Jan 2023 at 07:43, Anton Kuchin <antonkuchin@yandex-t=
eam.ru> wrote:
> >>>>>>>>> On 18/01/2023 17:52, Stefan Hajnoczi wrote:
> >>>>>>>>>> On Sun, 15 Jan 2023 at 12:21, Anton Kuchin <antonkuchin@yandex=
-team.ru> wrote:
> >>>> Once told that, I think that you are making your live harder in the
> >>>> future when you add the other migratable devices.
> >>>>
> >>>> static const VMStateDescription vuf_vmstate =3D {
> >>>>       .name =3D "vhost-user-fs",
> >>>>       .minimum_version_id =3D 0,
> >>>>       .version_id =3D 0,
> >>>>       .fields =3D (VMStateField[]) {
> >>>>           VMSTATE_INT8(migration_type, struct VHostUserFS),
> >>>>           VMSTATE_VIRTIO_DEVICE,
> >>>>           VMSTATE_END_OF_LIST()
> >>>>       },
> >>>>       .pre_save =3D vhost_user_fs_pre_save,
> >>>>       .subsections =3D (const VMStateDescription*[]) {
> >>>>           &vmstate_vhost_user_fs_internal_sub,
> >>>>           NULL
> >>>>       }
> >>>> };
> >>>>
> >>>> And you are done.
> >>>>
> >>>> I will propose to use a property to set migration_type, but I didn't
> >>>> want to write the code right now.
> >
> > I have a little problem with implementation here and need an advice:
> >
> > Can we make this property adjustable at runtime after device was realiz=
ed?
> > There is a statement in qemu wiki [1] that makes me think this is possi=
ble
> > but I couldn't find any code for it or example in other devices.
> >> "Properties are, by default, locked while the device is
> >   realized. Exceptions
> >> can be made by the devices themselves in order to implement a way
> >   for a user
> >> to interact with a device while it is realized."
> >
> > Or is your idea just to set this property once at construction and keep=
 it
> > constant for device lifetime?
> >
> > [1] https://wiki.qemu.org/Features/QOM
>=20
> I have no clue here.  Markus?  Stefan?

Sorry for the late reply. Yes, QOM properties can be set after realize
(e.g. using the qom-set command).

The set() callback can return an error, so some properties are
implemented to refuse updates when ->realize is true.

Stefan

--nyKNCi8hOw9wwgQO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmPumYMACgkQnKSrs4Gr
c8h6+gf/Xm3DQUOYtCY4IS1GB6hMp0BIP3zfOfyPBh/CVlDtME0ngqYlOrBqxYZ6
wWEXSyTyHwxhGMK7TkNt0JofrNHdQegdvwqXZOtpoLmxcVjCkohHa6Dh3K8H9q/f
JcPdxz6+PPHzf293Rbo7XalCqYveWAPX+geTWRQDwLsaYksnv23UlXzkyqZQ2fyD
8MzRc3AILX9kwTZwWYRCUGEt9HubeE1jnu3tXp4cmAyvWOd4ap/d7dAMguZZlV8C
J7omECt5rZx5GLVdf5N8l9J/H6mUyXdGRppfsCAon3/yeSDwyNiRVsbpUQOaYqM5
iYsbZRqzkoZH9bnFp0l7wKk01WbkOA==
=bGPP
-----END PGP SIGNATURE-----

--nyKNCi8hOw9wwgQO--
