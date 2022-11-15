Return-Path: <mst@redhat.com>
Date: Tue, 15 Nov 2022 04:05:05 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20221115035522-mutt-send-email-mst@kernel.org>
References: <20221108092308.1717426-1-alex.bennee@linaro.org>
 <20221108092308.1717426-6-alex.bennee@linaro.org>
 <2277569a-c218-30d1-4d88-9b77d3604513@linux.ibm.com>
 <20221114113518-mutt-send-email-mst@kernel.org>
 <aaae3f2a-c5bb-8e62-09d4-4f6f43efe37b@linux.ibm.com>
 <20221114115549-mutt-send-email-mst@kernel.org>
 <2bd5f801-a203-2598-3e6e-ed8f5dad5159@linux.ibm.com>
 <20221114121959-mutt-send-email-mst@kernel.org>
 <69fbc17f-cd78-a849-f7fc-31f8b3945ded@linux.ibm.com>
MIME-Version: 1.0
In-Reply-To: <69fbc17f-cd78-a849-f7fc-31f8b3945ded@linux.ibm.com>
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

On Tue, Nov 15, 2022 at 09:18:27AM +0100, Christian Borntraeger wrote:
>=20
> Am 14.11.22 um 18:20 schrieb Michael S. Tsirkin:
> > On Mon, Nov 14, 2022 at 06:15:30PM +0100, Christian Borntraeger wrote:
> > >=20
> > >=20
> > > Am 14.11.22 um 18:10 schrieb Michael S. Tsirkin:
> > > > On Mon, Nov 14, 2022 at 05:55:09PM +0100, Christian Borntraeger wro=
te:
> > > > >=20
> > > > >=20
> > > > > Am 14.11.22 um 17:37 schrieb Michael S. Tsirkin:
> > > > > > On Mon, Nov 14, 2022 at 05:18:53PM +0100, Christian Borntraeger=
 wrote:
> > > > > > > Am 08.11.22 um 10:23 schrieb Alex Benn=E9e:
> > > > > > > > The previous fix to virtio_device_started revealed a proble=
m in its
> > > > > > > > use by both the core and the device code. The core code sho=
uld be able
> > > > > > > > to handle the device "starting" while the VM isn't running =
to handle
> > > > > > > > the restoration of migration state. To solve this dual use =
introduce a
> > > > > > > > new helper for use by the vhost-user backends who all use i=
t to feed a
> > > > > > > > should_start variable.
> > > > > > > >=20
> > > > > > > > We can also pick up a change vhost_user_blk_set_status whil=
e we are at
> > > > > > > > it which follows the same pattern.
> > > > > > > >=20
> > > > > > > > Fixes: 9f6bcfd99f (hw/virtio: move vm_running check to virt=
io_device_started)
> > > > > > > > Fixes: 27ba7b027f (hw/virtio: add boilerplate for vhost-use=
r-gpio device)
> > > > > > > > Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> > > > > > > > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > > > > > >=20
> > > > > > > Hmmm, is this
> > > > > > > commit 259d69c00b67c02a67f3bdbeeea71c2c0af76c35
> > > > > > > Author:     Alex Benn=E9e <alex.bennee@linaro.org>
> > > > > > > AuthorDate: Mon Nov 7 12:14:07 2022 +0000
> > > > > > > Commit:     Michael S. Tsirkin <mst@redhat.com>
> > > > > > > CommitDate: Mon Nov 7 14:08:18 2022 -0500
> > > > > > >=20
> > > > > > >        hw/virtio: introduce virtio_device_should_start
> > > > > > >=20
> > > > > > > and older version?
> > > > > >=20
> > > > > > This is what got merged:
> > > > > > https://lore.kernel.org/r/20221107121407.1010913-1-alex.bennee%=
40linaro.org
> > > > > > This patch was sent after I merged the RFC.
> > > > > > I think the only difference is the commit log but I might be mi=
ssing
> > > > > > something.
> > > > > >=20
> > > > > > > This does not seem to fix the regression that I have reported.
> > > > > >=20
> > > > > > This was applied on top of 9f6bcfd99f which IIUC does, right?
> > > > > >=20
> > > > > >=20
> > > > >=20
> > > > > QEMU master still fails for me for suspend/resume to disk:
> > > > >=20
> > > > > #0  0x000003ff8e3980a6 in __pthread_kill_implementation () at /li=
b64/libc.so.6
> > > > > #1  0x000003ff8e348580 in raise () at /lib64/libc.so.6
> > > > > #2  0x000003ff8e32b5c0 in abort () at /lib64/libc.so.6
> > > > > #3  0x000003ff8e3409da in __assert_fail_base () at /lib64/libc.so=
.6
> > > > > #4  0x000003ff8e340a4e in  () at /lib64/libc.so.6
> > > > > #5  0x000002aa1ffa8966 in vhost_vsock_common_pre_save (opaque=3D<=
optimized out>) at ../hw/virtio/vhost-vsock-common.c:203
> > > > > #6  0x000002aa1fe5e0ee in vmstate_save_state_v
> > > > >       (f=3Df@entry=3D0x2aa21bdc170, vmsd=3D0x2aa204ac5f0 <vmstate=
_virtio_vhost_vsock>, opaque=3D0x2aa21bac9f8, vmdesc=3Dvmdesc@entry=3D0x3fd=
dc08eb30, version_id=3Dversion_id@entry=3D0) at ../migration/vmstate.c:329
> > > > > #7  0x000002aa1fe5ebf8 in vmstate_save_state (f=3Df@entry=3D0x2aa=
21bdc170, vmsd=3D<optimized out>, opaque=3D<optimized out>, vmdesc_id=3Dvmd=
esc_id@entry=3D0x3fddc08eb30) at ../migration/vmstate.c:317
> > > > > #8  0x000002aa1fe75bd0 in vmstate_save (f=3Df@entry=3D0x2aa21bdc1=
70, se=3Dse@entry=3D0x2aa21bdbe90, vmdesc=3Dvmdesc@entry=3D0x3fddc08eb30) a=
t ../migration/savevm.c:908
> > > > > #9  0x000002aa1fe79584 in qemu_savevm_state_complete_precopy_non_=
iterable (f=3Df@entry=3D0x2aa21bdc170, in_postcopy=3Din_postcopy@entry=3Dfa=
lse, inactivate_disks=3Dinactivate_disks@entry=3Dtrue)
> > > > >       at ../migration/savevm.c:1393
> > > > > #10 0x000002aa1fe79a96 in qemu_savevm_state_complete_precopy (f=
=3D0x2aa21bdc170, iterable_only=3Diterable_only@entry=3Dfalse, inactivate_d=
isks=3Dinactivate_disks@entry=3Dtrue) at ../migration/savevm.c:1459
> > > > > #11 0x000002aa1fe6d6ee in migration_completion (s=3D0x2aa218ef600=
) at ../migration/migration.c:3314
> > > > > #12 migration_iteration_run (s=3D0x2aa218ef600) at ../migration/m=
igration.c:3761
> > > > > #13 migration_thread (opaque=3Dopaque@entry=3D0x2aa218ef600) at .=
./migration/migration.c:3989
> > > > > #14 0x000002aa201f0b8c in qemu_thread_start (args=3D<optimized ou=
t>) at ../util/qemu-thread-posix.c:505
> > > > > #15 0x000003ff8e396248 in start_thread () at /lib64/libc.so.6
> > > > > #16 0x000003ff8e41183e in thread_start () at /lib64/libc.so.6
> > > > >=20
> > > > > Michael, your previous branch did work if I recall correctly.
> > > >=20
> > > > That one was failing under github CI though (for reasons we didn't
> > > > really address, such as disconnect during stop causing a recursive
> > > > call to stop, but there you are).
> > > Even the double revert of everything?
> >=20
> > I don't remember at this point.
> >=20
> > > So how do we proceed now?
> >=20
> > I'm hopeful Alex will come up with a fix.
>=20
>=20
> The initial fix changed to qemu/master does still work for me
>=20
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index a973811cbfc6..fb3072838119 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -411,14 +411,14 @@ static inline bool virtio_device_started(VirtIODevi=
ce *vdev, uint8_t status)
>   */
>  static inline bool virtio_device_should_start(VirtIODevice *vdev, uint8_=
t status)
>  {
> -    if (vdev->use_started) {
> -        return vdev->started;
> -    }
> -
>      if (!vdev->vm_running) {
>          return false;
>      }
> +    if (vdev->use_started) {
> +        return vdev->started;
> +    }
> +
>      return status & VIRTIO_CONFIG_S_DRIVER_OK;
>  }

Hmm this makes sense to me. And with the new API the
follout should be minimal. Let's see how it behaves on github.
It would be nice to fix the recursive stop problem properly
too but I"m not optimistic on that for this release.

--=20
MST

