Date: Mon, 22 Feb 2021 13:18:14 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210222131814.28e06428@bahia.lan>
In-Reply-To: <2337260.PURPEL5hZR@silver>
References: <20200918213436.GA3520@redhat.com> <2709384.cAWMFGR5kF@silver>
	<20210219190112.GC3270@redhat.com> <2337260.PURPEL5hZR@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] Can not set high msize with virtio-9p (Was: Re:
 virtiofs vs 9p performance)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christian Schoenebeck <qemu_oss@crudebyte.com>
Cc: "Venegas Munoz, Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, qemu-devel@nongnu.org, "cdupontd@redhat.com" <cdupontd@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>, Vivek Goyal <vgoyal@redhat.com>

On Sat, 20 Feb 2021 16:38:35 +0100
Christian Schoenebeck <qemu_oss@crudebyte.com> wrote:

> On Freitag, 19. Februar 2021 20:01:12 CET Vivek Goyal wrote:
> > On Fri, Feb 19, 2021 at 06:33:46PM +0100, Christian Schoenebeck wrote:
> > > On Freitag, 19. Februar 2021 17:08:48 CET Vivek Goyal wrote:
> > > > On Fri, Sep 25, 2020 at 10:06:41AM +0200, Christian Schoenebeck wrote:
> > > > > On Freitag, 25. September 2020 00:10:23 CEST Vivek Goyal wrote:
> > > > > > In my testing, with cache=none, virtiofs performed better than 9p in
> > > > > > all the fio jobs I was running. For the case of cache=auto  for
> > > > > > virtiofs
> > > > > > (with xattr enabled), 9p performed better in certain write
> > > > > > workloads. I
> > > > > > have identified root cause of that problem and working on
> > > > > > HANDLE_KILLPRIV_V2 patches to improve WRITE performance of virtiofs
> > > > > > with cache=auto and xattr enabled.
> > > > > 
> > > > > Please note, when it comes to performance aspects, you should set a
> > > > > reasonable high value for 'msize' on 9p client side:
> > > > > https://wiki.qemu.org/Documentation/9psetup#msize
> > > > 
> > > > Hi Christian,
> > > > 
> > > > I am not able to set msize to a higher value. If I try to specify msize
> > > > 16MB, and then read back msize from /proc/mounts, it sees to cap it
> > > > at 512000. Is that intended?
> > > 
> > > 9p server side in QEMU does not perform any msize capping. The code in
> > > this
> > > case is very simple, it's just what you see in function v9fs_version():
> > > 
> > > https://github.com/qemu/qemu/blob/6de76c5f324904c93e69f9a1e8e4fd0bd6f6b57a
> > > /hw/9pfs/9p.c#L1332> 
> > > > $ mount -t 9p -o trans=virtio,version=9p2000.L,cache=none,msize=16777216
> > > > hostShared /mnt/virtio-9p
> > > > 
> > > > $ cat /proc/mounts | grep 9p
> > > > hostShared /mnt/virtio-9p 9p
> > > > rw,sync,dirsync,relatime,access=client,msize=512000,trans=virtio 0 0
> > > > 
> > > > I am using 5.11 kernel.
> > > 
> > > Must be something on client (guest kernel) side. I don't see this here
> > > with
> > > guest kernel 4.9.0 happening with my setup in a quick test:
> > > 
> > > $ cat /etc/mtab | grep 9p
> > > svnRoot / 9p
> > > rw,dirsync,relatime,trans=virtio,version=9p2000.L,msize=104857600,cache=m
> > > map 0 0 $
> > > 
> > > Looks like the root cause of your issue is this:
> > > 
> > > struct p9_client *p9_client_create(const char *dev_name, char *options)
> > > {
> > > 
> > > 	...
> > > 	if (clnt->msize > clnt->trans_mod->maxsize)
> > > 	
> > > 		clnt->msize = clnt->trans_mod->maxsize;
> > > 
> > > https://github.com/torvalds/linux/blob/f40ddce88593482919761f74910f42f4b84
> > > c004b/net/9p/client.c#L1045
> > That was introduced by a patch 2011.
> > 
> > commit c9ffb05ca5b5098d6ea468c909dd384d90da7d54
> > Author: Venkateswararao Jujjuri (JV) <jvrao@linux.vnet.ibm.com>
> > Date:   Wed Jun 29 18:06:33 2011 -0700
> > 
> >     net/9p: Fix the msize calculation.
> > 
> >     msize represents the maximum PDU size that includes P9_IOHDRSZ.
> > 
> > 
> > You kernel 4.9 is newer than this. So most likely you have this commit
> > too. I will spend some time later trying to debug this.
> > 
> > Vivek
> 

Hi Vivek and Christian,

I reproduce with an up-to-date fedora rawhide guest.

Capping comes from here:

net/9p/trans_virtio.c:  .maxsize = PAGE_SIZE * (VIRTQUEUE_NUM - 3),

i.e. 4096 * (128 - 3) == 512000

AFAICT this has been around since 2011, i.e. always for me as a
maintainer and I admit I had never tried such high msize settings
before.

commit b49d8b5d7007a673796f3f99688b46931293873e
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Wed Aug 17 16:56:04 2011 +0000

    net/9p: Fix kernel crash with msize 512K
    
    With msize equal to 512K (PAGE_SIZE * VIRTQUEUE_NUM), we hit multiple
    crashes. This patch fix those.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>

Changelog doesn't help much but it looks like it was a bandaid
for some more severe issues.

> As the kernel code sais trans_mod->maxsize, maybe its something in virtio on
> qemu side that does an automatic step back for some reason. I don't see
> something in the 9pfs virtio transport driver (hw/9pfs/virtio-9p-device.c on
> QEMU side) that would do this, so I would also need to dig deeper.
> 
> Do you have some RAM limitation in your setup somewhere?
> 
> For comparison, this is how I started the VM:
> 
> ~/git/qemu/build/qemu-system-x86_64 \
> -machine pc,accel=kvm,usb=off,dump-guest-core=off -m 2048 \
> -smp 4,sockets=4,cores=1,threads=1 -rtc base=utc \
> -boot strict=on -kernel /home/bee/vm/stretch/boot/vmlinuz-4.9.0-13-amd64 \
> -initrd /home/bee/vm/stretch/boot/initrd.img-4.9.0-13-amd64 \
> -append 'root=svnRoot rw rootfstype=9p rootflags=trans=virtio,version=9p2000.L,msize=104857600,cache=mmap console=ttyS0' \

First obvious difference I see between your setup and mine is that
you're mounting the 9pfs as root from the kernel command line. For
some reason, maybe this has an impact on the check in p9_client_create() ?

Can you reproduce with a scenario like Vivek's one ?

> -fsdev local,security_model=mapped,multidevs=remap,id=fsdev-fs0,path=/home/bee/vm/stretch/ \
> -device virtio-9p-pci,id=fs0,fsdev=fsdev-fs0,mount_tag=svnRoot \
> -sandbox on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny \
> -nographic
> 
> So the guest system is running entirely and solely on top of 9pfs (as root fs)
> and hence it's mounted by above's CL i.e. immediately when the guest is
> booted, and RAM size is set to 2 GB.
> 
> Best regards,
> Christian Schoenebeck
> 
> 

