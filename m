Return-Path: <mst@redhat.com>
Date: Tue, 8 Nov 2022 05:26:23 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20221108052544-mutt-send-email-mst@kernel.org>
References: <20221108092308.1717426-1-alex.bennee@linaro.org>
 <20221108092308.1717426-6-alex.bennee@linaro.org>
 <20221108043249-mutt-send-email-mst@kernel.org>
 <8735atg2vh.fsf@linaro.org>
MIME-Version: 1.0
In-Reply-To: <8735atg2vh.fsf@linaro.org>
Content-Type: text/plain; charset="windows-1252"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v1 5/9] hw/virtio: introduce
 virtio_device_should_start
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, fam@euphon.net, berrange@redhat.com, f4bug@amsat.org, aurelien@aurel32.net, pbonzini@redhat.com, stefanha@redhat.com, crosa@redhat.com, Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "open list:Block layer core" <qemu-block@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>

On Tue, Nov 08, 2022 at 10:23:15AM +0000, Alex Benn=E9e wrote:
>=20
> "Michael S. Tsirkin" <mst@redhat.com> writes:
>=20
> > On Tue, Nov 08, 2022 at 09:23:04AM +0000, Alex Benn=E9e wrote:
> >> The previous fix to virtio_device_started revealed a problem in its
> >> use by both the core and the device code. The core code should be able
> >> to handle the device "starting" while the VM isn't running to handle
> >> the restoration of migration state. To solve this dual use introduce a
> >> new helper for use by the vhost-user backends who all use it to feed a
> >> should_start variable.
> >>=20
> >> We can also pick up a change vhost_user_blk_set_status while we are at
> >> it which follows the same pattern.
> >>=20
> >> Fixes: 9f6bcfd99f (hw/virtio: move vm_running check to virtio_device_s=
tarted)
> >> Fixes: 27ba7b027f (hw/virtio: add boilerplate for vhost-user-gpio devi=
ce)
> >> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> >> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> >
> > why is this in this patchset?
>=20
> As per my cover letter:
>=20
>   Most of these patches have been posted before as single patch RFCs. A
>   couple are already scheduled through other trees so will drop out in
>   due course
>=20
> but I keep them in my tree until they are merged so I can continue to
> soak test them (and have a stable base for my other WIP trees).

That's fine just pls don't double-post them on list, certainly
not as part of a patchset.

> --=20
> Alex Benn=E9e

