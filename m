Return-Path: <mst@redhat.com>
Date: Mon, 14 Nov 2022 11:37:13 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20221114113518-mutt-send-email-mst@kernel.org>
References: <20221108092308.1717426-1-alex.bennee@linaro.org>
 <20221108092308.1717426-6-alex.bennee@linaro.org>
 <2277569a-c218-30d1-4d88-9b77d3604513@linux.ibm.com>
MIME-Version: 1.0
In-Reply-To: <2277569a-c218-30d1-4d88-9b77d3604513@linux.ibm.com>
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
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, qemu-devel@nongnu.org, fam@euphon.net, berrange@redhat.com, f4bug@amsat.org, aurelien@aurel32.net, pbonzini@redhat.com, stefanha@redhat.com, crosa@redhat.com, Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "open list:Block layer core" <qemu-block@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>

On Mon, Nov 14, 2022 at 05:18:53PM +0100, Christian Borntraeger wrote:
> Am 08.11.22 um 10:23 schrieb Alex Benn=E9e:
> > The previous fix to virtio_device_started revealed a problem in its
> > use by both the core and the device code. The core code should be able
> > to handle the device "starting" while the VM isn't running to handle
> > the restoration of migration state. To solve this dual use introduce a
> > new helper for use by the vhost-user backends who all use it to feed a
> > should_start variable.
> >=20
> > We can also pick up a change vhost_user_blk_set_status while we are at
> > it which follows the same pattern.
> >=20
> > Fixes: 9f6bcfd99f (hw/virtio: move vm_running check to virtio_device_st=
arted)
> > Fixes: 27ba7b027f (hw/virtio: add boilerplate for vhost-user-gpio devic=
e)
> > Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> > Cc: "Michael S. Tsirkin" <mst@redhat.com>
>=20
> Hmmm, is this
> commit 259d69c00b67c02a67f3bdbeeea71c2c0af76c35
> Author:     Alex Benn=E9e <alex.bennee@linaro.org>
> AuthorDate: Mon Nov 7 12:14:07 2022 +0000
> Commit:     Michael S. Tsirkin <mst@redhat.com>
> CommitDate: Mon Nov 7 14:08:18 2022 -0500
>=20
>     hw/virtio: introduce virtio_device_should_start
>=20
> and older version?

This is what got merged:
https://lore.kernel.org/r/20221107121407.1010913-1-alex.bennee%40linaro.org
This patch was sent after I merged the RFC.
I think the only difference is the commit log but I might be missing
something.

> This does not seem to fix the regression that I have reported.

This was applied on top of 9f6bcfd99f which IIUC does, right?


--=20
MST

