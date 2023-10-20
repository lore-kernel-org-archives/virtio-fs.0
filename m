Return-Path: <mst@redhat.com>
Date: Fri, 20 Oct 2023 05:02:27 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20231020050210-mutt-send-email-mst@kernel.org>
References: <20231019095610.2818087-1-alex.bennee@linaro.org>
 <20231019095610.2818087-6-alex.bennee@linaro.org>
 <20231020031407.xd4ykc4msfdmoav5@vireshk-i7>
 <878r7x90a0.fsf@linaro.org>
MIME-Version: 1.0
In-Reply-To: <878r7x90a0.fsf@linaro.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v5 5/6] hw/virtio: add vhost-user-snd and
 virtio-snd-pci devices
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, qemu-devel@nongnu.org, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, virtio-fs@redhat.com, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Hanna Reitz <hreitz@redhat.com>, Eric Blake <eblake@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Markus Armbruster <armbru@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Manos Pitsidianakis <manos.pitsidianakis@linaro.org>

On Fri, Oct 20, 2023 at 09:16:03AM +0100, Alex Benn=E9e wrote:
>=20
> Viresh Kumar <viresh.kumar@linaro.org> writes:
>=20
> > On 19-10-23, 10:56, Alex Benn=E9e wrote:
> >> From: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
> >>=20
> >> Tested with rust-vmm vhost-user-sound daemon:
> >>=20
> >>     RUST_LOG=3Dtrace cargo run --bin vhost-user-sound -- --socket /tmp=
/snd.sock --backend null
> >>=20
> >> Invocation:
> >>=20
> >>     qemu-system-x86_64  \
> >>             -qmp unix:./qmp-sock,server,wait=3Doff  \
> >>             -m 4096 \
> >>             -numa node,memdev=3Dmem \
> >>             -object memory-backend-file,id=3Dmem,size=3D4G,mem-path=3D=
/dev/shm,share=3Don \
> >>             -D qemu.log \
> >>             -d guest_errors,trace:\*snd\*,trace:\*sound\*,trace:\*vhos=
t\* \
> >>             -chardev socket,id=3Dvsnd,path=3D/tmp/snd.sock \
> >>             -device vhost-user-snd-pci,chardev=3Dvsnd,id=3Dsnd \
> >>             /path/to/disk
> >>=20
> >> [AJB: imported from https://github.com/epilys/qemu-virtio-snd/commit/5=
4ae1cdd15fef2d88e9e387a175f099a38c636f4.patch]
> >>=20
> >> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> >
> > Missing SOB from Manos ?
>=20
> oops, guess I need a respin then ;-)

Just ask Manos to send his S.O.B in a reply.


> >
> >> Message-Id: <20231009095937.195728-6-alex.bennee@linaro.org>
>=20
>=20
> --=20
> Alex Benn=E9e
> Virtualisation Tech Lead @ Linaro

