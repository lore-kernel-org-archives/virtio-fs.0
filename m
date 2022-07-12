Return-Path: <vgoyal@redhat.com>
Date: Tue, 12 Jul 2022 08:33:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <Ys1qDhW/DCCt0XdS@redhat.com>
References: <BY5PR11MB42911D5BF55D9FAF501F64F68D819@BY5PR11MB4291.namprd11.prod.outlook.com>
 <3b6c8e16-3712-3402-3ab2-17bf53ec64a8@redhat.com>
 <YsPwbbiuxtkD6HSp@work-vm>
 <BY5PR11MB42912BFEA77F94B5B20D6F258D819@BY5PR11MB4291.namprd11.prod.outlook.com>
 <YsQGNk5hLv8b6DJS@work-vm>
 <BY5PR11MB4291BCA40054FB484003D4278D829@BY5PR11MB4291.namprd11.prod.outlook.com>
 <BY5PR11MB42914FD092B4312B76417A9C8D869@BY5PR11MB4291.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BY5PR11MB42914FD092B4312B76417A9C8D869@BY5PR11MB4291.namprd11.prod.outlook.com>
Subject: Re: [Virtio-fs] [Qemu] how to use viriofs in qemu without NUMA
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Zhao, Shirley" <shirley.zhao@intel.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, Thomas Huth <thuth@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>

On Tue, Jul 12, 2022 at 07:06:50AM +0000, Zhao, Shirley wrote:
> Hi, all, 
> 
> I have another question want to consult you. 
> To enable DAX in virtiofs, according to the memu https://virtio-fs.gitlab.io/howto-qemu.html. 
> I need to add "cache-size=2G" as below. 
> -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs,cache-size=2G
> 
> My qemu command is: 
> sudo qemu-system-x86_64 -M pc -cpu host --enable-kvm -smp 2 -m 4G -drive if=virtio,file=ubuntu.img -object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on -machine q35,memory-backend=mem -chardev socket,id=char0,path=/tmp/vhostqemu -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs_root,cache-size=2G -chardev stdio,mux=on,id=mon -mon chardev=mon,mode=readline -device virtio-serial-pci -device virtconsole,chardev=mon -vga none -display none
> 
> And virtiofsd command is:
> sudo ./virtiofsd --socket-path=/tmp/vhostqemu -o source=/home/shirley/testdir -o cache=always
> 
> But there is no option of "cache-size" in qemu 6.0, like below. So how to enable it? 

Hi Shirley,

DAX support in qemu is not upstream yet. We are carrying DAX patches
out of the tree on a branch here.

https://gitlab.com/virtio-fs/qemu/-/commits/virtio-fs-dev

There are some changes required and David Gilbert is looking into
making these changes. I am hoping at some point of time these patches
will make into upstream.

So for the time being, to test DAX, you will have to fetch above branch,
build it and use that qemu.

Thanks
Vivek

> qemu-6.0.0$ qemu-system-x86_64 -device vhost-user-fs-pci,help
> vhost-user-fs-pci options:
>   acpi-index=<uint32>    -  (default: 0)
>   addr=<int32>           - Slot and optional function number, example: 06.0 or 06 (default: -1)
>   aer=<bool>             - on/off (default: false)
>   any_layout=<bool>      - on/off (default: true)
>   ats=<bool>             - on/off (default: false)
>   bootindex=<int32>
>   chardev=<str>          - ID of a chardev to use as a backend
>   event_idx=<bool>       - on/off (default: true)
>   failover_pair_id=<str>
>   indirect_desc=<bool>   - on/off (default: true)
>   iommu_platform=<bool>  - on/off (default: false)
>   migrate-extra=<bool>   - on/off (default: true)
>   modern-pio-notify=<bool> - on/off (default: false)
>   multifunction=<bool>   - on/off (default: false)
>   notify_on_empty=<bool> - on/off (default: true)
>   num-request-queues=<uint16> -  (default: 1)
>   packed=<bool>          - on/off (default: false)
>   page-per-vq=<bool>     - on/off (default: false)
>   queue-size=<uint16>    -  (default: 128)
>   rombar=<uint32>        -  (default: 1)
>   romfile=<str>
>   romsize=<uint32>       -  (default: 4294967295)
>   tag=<str>
>   use-disabled-flag=<bool> -  (default: true)
>   use-started=<bool>     -  (default: true)
>   vectors=<uint32>       -  (default: 4294967295)
>   virtio-backend=<child<vhost-user-fs-device>>
>   virtio-pci-bus-master-bug-migration=<bool> - on/off (default: false)
>   x-ats-page-aligned=<bool> - on/off (default: true)
>   x-disable-legacy-check=<bool> -  (default: false)
>   x-disable-pcie=<bool>  - on/off (default: false)
>   x-ignore-backend-features=<bool> -  (default: false)
>   x-pcie-deverr-init=<bool> - on/off (default: true)
>   x-pcie-extcap-init=<bool> - on/off (default: true)
>   x-pcie-flr-init=<bool> - on/off (default: true)
>   x-pcie-lnkctl-init=<bool> - on/off (default: true)
>   x-pcie-lnksta-dllla=<bool> - on/off (default: true)
>   x-pcie-pm-init=<bool>  - on/off (default: true) 
> 
> 
> -----Original Message-----
> From: Zhao, Shirley 
> Sent: Friday, July 8, 2022 8:40 AM
> To: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Cc: Thomas Huth <thuth@redhat.com>; qemu-devel@nongnu.org; virtio-fs@redhat.com; Stefan Hajnoczi <stefanha@redhat.com>
> Subject: RE: [Qemu] how to use viriofs in qemu without NUMA
> 
> Yes, the qemu version is too old. 
> My previous qemu version is 4.2, and I upgraded it into 6.0, and it worked now. 
> Thanks a lot. 
> 
> - Shirley 
> 
> -----Original Message-----
> From: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Sent: Tuesday, July 5, 2022 5:37 PM
> To: Zhao, Shirley <shirley.zhao@intel.com>
> Cc: Thomas Huth <thuth@redhat.com>; qemu-devel@nongnu.org; virtio-fs@redhat.com; Stefan Hajnoczi <stefanha@redhat.com>
> Subject: Re: [Qemu] how to use viriofs in qemu without NUMA
> 
> * Zhao, Shirley (shirley.zhao@intel.com) wrote:
> > Thanks for the information. 
> > Yes, I also found the memory backend options on s390x, and also copy the command to x86, but failed. 
> > 
> > The following is the command used to start qemu + virtiofs + ubuntu 20.04. 
> > One is worked well using NUMA, another one is failed without NUMA. 
> > Is there anything wrong? 
> > 
> > The worked one with NUMA options: 
> > 
> > qemu-system-x86_64 -M pc -cpu host --enable-kvm -smp 2 -m 4G -object 
> > memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on -numa 
> > node,memdev=mem -chardev socket,id=char0,path=/tmp/vfsd.sock -device 
> > vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs -chardev 
> > stdio,mux=on,id=mon -mon chardev=mon,mode=readline -device 
> > virtio-serial-pci -device virtconsole,chardev=mon -vga none -display 
> > none -drive if=virtio,file=ubuntu.img
> > 
> > The failed one without NUMA options: 
> > 
> > qemu-system-x86_64 -M pc -cpu host --enable-kvm -smp 2 -m 4G -object 
> > memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on -machine 
> > q35,memory-backend=mem -chardev socket,id=char0,path=/tmp/vfsd.sock
> > -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs
> > -chardev stdio,mux=on,id=mon -mon chardev=mon,mode=readline -device 
> > virtio-serial-pci -device virtconsole,chardev=mon -vga none -display 
> > none -drive if=virtio,file=ubuntu.img
> 
> What error did it give?
> 
> 20.04 is quite old, what qemu version is it?
> 
> I'd have to check when the memdev= went in.
> 
> Dave
> 
> > 
> > Thanks. 
> > - Shirley
> > 
> > -----Original Message-----
> > From: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > Sent: Tuesday, July 5, 2022 4:04 PM
> > To: Thomas Huth <thuth@redhat.com>
> > Cc: Zhao, Shirley <shirley.zhao@intel.com>; qemu-devel@nongnu.org; 
> > virtio-fs@redhat.com; Stefan Hajnoczi <stefanha@redhat.com>
> > Subject: Re: [Qemu] how to use viriofs in qemu without NUMA
> > 
> > * Thomas Huth (thuth@redhat.com) wrote:
> > > On 05/07/2022 03.02, Zhao, Shirley wrote:
> > > > Hi, all,
> > > > 
> > > > I want to use virtiofs to share folder between host and guest.
> > > > 
> > > >  From the guide, it must set the NUMA node.
> > > > https://virtio-fs.gitlab.io/howto-qemu.html
> > > > 
> > > > But my guest doesn’t support NUMA.
> > > > 
> > > > Is there any guide to use qemu + virtiofs without NUMA?
> > > > 
> > > > Or does qemu have any plan to support it?
> > > 
> > >  Hi!
> > > 
> > > At least on s390x, you can also specify the memory backend via the 
> > > -machine option instead of using the -numa option, e.g.:
> > > 
> > >  qemu-system-s390x -machine memory-backend=mem \
> > >   -object memory-backend-file,id=mem,...
> > > 
> > > Not sure whether that works on other architectures, too, though. 
> > > Stefan, David, do you know?
> > 
> > Right, that's the way I do it on x86.
> > We wrote virtiofs before the memory-backend option existed, which is why the old docs talk about using the NUMA stuff.
> > 
> > Dave
> > 
> > >  Thomas
> > > 
> > --
> > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> > 
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
