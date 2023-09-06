Return-Path: <mvaralar@redhat.com>
Date: Wed, 6 Sep 2023 11:21:36 +0200
From: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
Message-ID: <ZPhEoP8/PYUQG8Ri@fedora>
References: <20230710153522.3469097-1-alex.bennee@linaro.org>
 <20230710153522.3469097-8-alex.bennee@linaro.org>
 <ZPc44//qJCPNAOXE@fedora> <87ledkh7q7.fsf@linaro.org>
MIME-Version: 1.0
In-Reply-To: <87ledkh7q7.fsf@linaro.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v3 07/20] virtio: add vhost-user-base and a
 generic vhost-user-device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, qemu-block@nongnu.org, Eric Blake <eblake@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Hanna Reitz <hreitz@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>

On Tue, Sep 05, 2023 at 06:01:56PM +0100, Alex Benn=E9e wrote:
>=20
> Matias Ezequiel Vara Larsen <mvaralar@redhat.com> writes:
>=20
> > On Mon, Jul 10, 2023 at 04:35:09PM +0100, Alex Benn=E9e wrote:
> >> In theory we shouldn't need to repeat so much boilerplate to support
> >> vhost-user backends. This provides a generic vhost-user-base QOM
> >> object and a derived vhost-user-device for which the user needs to
> >> provide the few bits of information that aren't currently provided by
> >> the vhost-user protocol. This should provide a baseline implementation
> >> from which the other vhost-user stub can specialise.
> >>=20
> >> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> >>=20
> >> ---
> >> v2
> >>   - split into vub and vud
> <snip>
> >> +
> >> +    /*
> >> +     * Disable guest notifiers, by default all notifications will be =
via the
> >> +     * asynchronous vhost-user socket.
> >> +     */
> >> +    vdev->use_guest_notifier_mask =3D false;
> >> +
> >> +    /* Allocate queues */
> >> +    vub->vqs =3D g_ptr_array_sized_new(vub->num_vqs);
> >> +    for (int i =3D 0; i < vub->num_vqs; i++) {
> >> +        g_ptr_array_add(vub->vqs,
> >> +                        virtio_add_queue(vdev, 4, vub_handle_output));
> >> +    }
> >> +
> >
> > Hello Alex, apologies if someone already asked this. If I understand
> > correctly, the second parameter of virtio_add_queue() is the len of the
> > queue. Why have you chosen "4" as its value? Shall qemu query the len of
> > the queue from the vhost-user device instead?
>=20
> Hmm yeah that is inherited from the virtio-rng backend which has a
> pretty short queue. I don't think it is intrinsic to the device
> implementation (although I guess that depends if a device will have
> multiple requests in flight).
>=20
> I propose making is some useful ^2 (like 64) and adding a config knob to
> increase it if needed.
>=20

LGTM. =20

Matias

