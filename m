Return-Path: <dgilbert@redhat.com>
Date: Tue, 5 Jul 2022 10:36:54 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YsQGNk5hLv8b6DJS@work-vm>
References: <BY5PR11MB42911D5BF55D9FAF501F64F68D819@BY5PR11MB4291.namprd11.prod.outlook.com>
 <3b6c8e16-3712-3402-3ab2-17bf53ec64a8@redhat.com>
 <YsPwbbiuxtkD6HSp@work-vm>
 <BY5PR11MB42912BFEA77F94B5B20D6F258D819@BY5PR11MB4291.namprd11.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <BY5PR11MB42912BFEA77F94B5B20D6F258D819@BY5PR11MB4291.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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
Cc: Thomas Huth <thuth@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>

* Zhao, Shirley (shirley.zhao@intel.com) wrote:
> Thanks for the information. 
> Yes, I also found the memory backend options on s390x, and also copy the command to x86, but failed. 
> 
> The following is the command used to start qemu + virtiofs + ubuntu 20.04. 
> One is worked well using NUMA, another one is failed without NUMA. 
> Is there anything wrong? 
> 
> The worked one with NUMA options: 
> 
> qemu-system-x86_64 -M pc -cpu host --enable-kvm -smp 2 -m 4G -object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on -numa node,memdev=mem -chardev socket,id=char0,path=/tmp/vfsd.sock -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs -chardev stdio,mux=on,id=mon -mon chardev=mon,mode=readline -device virtio-serial-pci -device virtconsole,chardev=mon -vga none -display none -drive if=virtio,file=ubuntu.img
> 
> The failed one without NUMA options: 
> 
> qemu-system-x86_64 -M pc -cpu host --enable-kvm -smp 2 -m 4G -object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on -machine q35,memory-backend=mem -chardev socket,id=char0,path=/tmp/vfsd.sock -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs -chardev stdio,mux=on,id=mon -mon chardev=mon,mode=readline -device virtio-serial-pci -device virtconsole,chardev=mon -vga none -display none -drive if=virtio,file=ubuntu.img

What error did it give?

20.04 is quite old, what qemu version is it?

I'd have to check when the memdev= went in.

Dave

> 
> Thanks. 
> - Shirley 
> 
> -----Original Message-----
> From: Dr. David Alan Gilbert <dgilbert@redhat.com> 
> Sent: Tuesday, July 5, 2022 4:04 PM
> To: Thomas Huth <thuth@redhat.com>
> Cc: Zhao, Shirley <shirley.zhao@intel.com>; qemu-devel@nongnu.org; virtio-fs@redhat.com; Stefan Hajnoczi <stefanha@redhat.com>
> Subject: Re: [Qemu] how to use viriofs in qemu without NUMA
> 
> * Thomas Huth (thuth@redhat.com) wrote:
> > On 05/07/2022 03.02, Zhao, Shirley wrote:
> > > Hi, all,
> > > 
> > > I want to use virtiofs to share folder between host and guest.
> > > 
> > >  From the guide, it must set the NUMA node.
> > > https://virtio-fs.gitlab.io/howto-qemu.html
> > > 
> > > But my guest doesn’t support NUMA.
> > > 
> > > Is there any guide to use qemu + virtiofs without NUMA?
> > > 
> > > Or does qemu have any plan to support it?
> > 
> >  Hi!
> > 
> > At least on s390x, you can also specify the memory backend via the 
> > -machine option instead of using the -numa option, e.g.:
> > 
> >  qemu-system-s390x -machine memory-backend=mem \
> >   -object memory-backend-file,id=mem,...
> > 
> > Not sure whether that works on other architectures, too, though. 
> > Stefan, David, do you know?
> 
> Right, that's the way I do it on x86.
> We wrote virtiofs before the memory-backend option existed, which is why the old docs talk about using the NUMA stuff.
> 
> Dave
> 
> >  Thomas
> > 
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

