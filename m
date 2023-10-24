Return-Path: <mst@redhat.com>
Date: Tue, 24 Oct 2023 13:18:12 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20231024131734-mutt-send-email-mst@kernel.org>
References: <20231019095610.2818087-1-alex.bennee@linaro.org>
 <878r7s0wnz.fsf@linaro.org>
MIME-Version: 1.0
In-Reply-To: <878r7s0wnz.fsf@linaro.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v5 0/6] virtio: cleanup vhost-user-generic
 and reduce c&p
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, virtio-fs@redhat.com, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Hanna Reitz <hreitz@redhat.com>, Eric Blake <eblake@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Markus Armbruster <armbru@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>

On Tue, Oct 24, 2023 at 06:14:36PM +0100, Alex Benn=E9e wrote:
>=20
> Alex Benn=E9e <alex.bennee@linaro.org> writes:
>=20
> > A lot of our vhost-user stubs are large chunks of boilerplate that do
> > (mostly) the same thing. This series continues the cleanups by
> > splitting the vhost-user-base and vhost-user-generic implementations.
> > After adding a new vq_size property the rng, gpio and i2c vhost-user
> > devices become simple specialisations of the common base defining the
> > ID, number of queues and potentially the config handling.
> >
> > I've also added Manos' vhost-user-sound while I was at it.
>=20
> Ping MST. Any more comments or happy to take as is?

It's tagged already.

> --=20
> Alex Benn=E9e
> Virtualisation Tech Lead @ Linaro

