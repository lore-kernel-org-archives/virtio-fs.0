Date: Mon, 3 May 2021 09:07:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210503130716.GB81443@redhat.com>
References: <714BD741-AE3F-4BC5-8DFB-F5C74A8623B1@netapp.com>
	<YFnC9QXo6uP+2zC1@work-vm> <20210323145312.GB483930@redhat.com>
	<YFoCpIh5PCSP6gXB@work-vm>
	<40D27E5F-C65A-4441-BA23-ABA6880DAA71@netapp.com>
	<YG8tXxdyakzkyI0h@stefanha-x1.localdomain>
	<423DD084-E08F-4402-AD5A-3583117A6B4E@netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <423DD084-E08F-4402-AD5A-3583117A6B4E@netapp.com>
Subject: Re: [Virtio-fs] Live migration support for virtio-fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Ge, Xiongzi" <Xiongzi.Ge@netapp.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>

Hi Xiongzi,

Try qemu monitor to hot device add/remove that works. I think libvirt
support is yet to be added.

One issue I faced was that I had to add a pcie root to move virtiofs
device off pcie.0 and then hot add remove functionality works.

So I had to add pcie root port by adding following to qemu command
line.

-device pcie-root-port,id=root1,slot=0

And now you can hot add a device using device_add.

 (qemu) device_add vhost-user-fs-pci,bus=root1,id=myvirtiofs,chardev=char0,tag=myfs,queue-size=1024

- To hot remove device, issue from qemu monitor.

  (qemu) device_del <device_id>
  ex. device_del myvirtiofs

Thanks
Vivek

On Mon, May 03, 2021 at 12:50:56PM +0000, Ge, Xiongzi wrote:
> Thanks, Stefan!
> It seems that libvirt does not support device-attach for filesystem type device, like virtiofs. Are there any other ways to do this hot-unplugging? 
> 
> Xiongzi
> 
> ﻿On 4/8/21, 12:21 PM, "Stefan Hajnoczi" <stefanha@redhat.com> wrote:
> 
>     On Wed, Apr 07, 2021 at 06:05:29PM +0000, Ge, Xiongzi wrote:
>     > Thanks Dr Gilbert, Vivek, Stefan, Greg!
>     > I put together the discussion into this thread and CC qemu-devel@nongnu.org. 
>     > 
>     > Problem:
>     > Current Virtio-FS does not support live migration.  Even when the virtiofs directory is not mounted on the guest, VM cannot do live migration. Any suggestions/interest If we want to make this work so we can still have the live migration feature for other purpose on that VM? 
>     > 
>     > If we already have a shared file system like Ceph, does this make it different? 
> 
>     (Marc-André: I CCed you regarding D-Bus VMState, see below.)
> 
>     During the last virtio-fs call on Wednesday we discussed how to allow
>     live migration when the file system is not mounted. This means live
>     migration of a mounted file system still wouldn't be supported, but at
>     least it would be possible to migrate when the file system is not
>     mounted.
> 
>     The easiest way to do that is to hot unplug the vhost-user-fs-pci device
>     so that QEMU can live migrate the VM and then hot plug the
>     vhost-user-fs-pci device again after migration has completed. This
>     requires either manually performing the hot plug operations or some
>     automation to do this around live migration.
> 
>     A smoother approach would be for QEMU to allow live migration when the
>     file system is not mounted. Unfortunately it turns out this is actually
>     rather involved because virtiofsd runs as a separate process from QEMU
>     and the live migration interface for vhost-user devices is currently
>     pretty basic
>     (https://qemu.readthedocs.io/en/latest/interop/dbus-vmstate.html). There
>     is currently no way for virtiofsd to communicate with QEMU to allow/deny
>     live migration depending on whether virtiofsd currently has an active
>     FUSE session (mount). It might be possible to extend the D-Bus VMState
>     interface and implement support for "migration blockers" as they are
>     known in QEMU, but I wonder whether it's not better to just work on
>     full virtio-fs live migration instead. Either task is complex and I
>     wouldn't recommend it as a first contribution to virtiofsd or QEMU.
> 
>     Can you make use of the hotplug approach to live migration?
> 
>     Stefan
> 

