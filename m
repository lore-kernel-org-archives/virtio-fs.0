Date: Mon, 22 Feb 2021 18:11:59 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210222181159.6b274945@bahia.lan>
In-Reply-To: <2848338.ij5OB8EVuP@silver>
References: <20200918213436.GA3520@redhat.com> <2337260.PURPEL5hZR@silver>
	<20210222131814.28e06428@bahia.lan> <2848338.ij5OB8EVuP@silver>
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
Cc: "Shinde, Archana M" <archana.m.shinde@intel.com>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, qemu-devel@nongnu.org, virtio-fs-list <virtio-fs@redhat.com>, "cdupontd@redhat.com" <cdupontd@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Mon, 22 Feb 2021 16:08:04 +0100
Christian Schoenebeck <qemu_oss@crudebyte.com> wrote:

[...]

> I did not ever have a kernel crash when I boot a Linux guest with a 9pfs root 
> fs and 100 MiB msize.

Interesting.

> Should we ask virtio or 9p Linux client maintainers if 
> they can add some info what this is about?
> 

Probably worth to try that first, even if I'm not sure anyone has a
answer for that since all the people who worked on virtio-9p at
the time have somehow deserted the project.

> > > As the kernel code sais trans_mod->maxsize, maybe its something in virtio
> > > on qemu side that does an automatic step back for some reason. I don't
> > > see something in the 9pfs virtio transport driver
> > > (hw/9pfs/virtio-9p-device.c on QEMU side) that would do this, so I would
> > > also need to dig deeper.
> > > 
> > > Do you have some RAM limitation in your setup somewhere?
> > > 
> > > For comparison, this is how I started the VM:
> > > 
> > > ~/git/qemu/build/qemu-system-x86_64 \
> > > -machine pc,accel=kvm,usb=off,dump-guest-core=off -m 2048 \
> > > -smp 4,sockets=4,cores=1,threads=1 -rtc base=utc \
> > > -boot strict=on -kernel /home/bee/vm/stretch/boot/vmlinuz-4.9.0-13-amd64 \
> > > -initrd /home/bee/vm/stretch/boot/initrd.img-4.9.0-13-amd64 \
> > > -append 'root=svnRoot rw rootfstype=9p
> > > rootflags=trans=virtio,version=9p2000.L,msize=104857600,cache=mmap
> > > console=ttyS0' \
> > First obvious difference I see between your setup and mine is that
> > you're mounting the 9pfs as root from the kernel command line. For
> > some reason, maybe this has an impact on the check in p9_client_create() ?
> > 
> > Can you reproduce with a scenario like Vivek's one ?
> 
> Yep, confirmed. If I boot a guest from an image file first and then try to 
> manually mount a 9pfs share after guest booted, then I get indeed that msize 
> capping of just 512 kiB as well. That's far too small. :/
> 

Maybe worth digging : 
- why no capping happens in your scenario ?
- is capping really needed ?

Cheers,

--
Greg

> Best regards,
> Christian Schoenebeck
> 
> 

