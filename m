Date: Mon, 21 Sep 2020 16:32:43 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200921153243.GK3221@work-vm>
References: <20200918213436.GA3520@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918213436.GA3520@redhat.com>
Subject: Re: [Virtio-fs] tools/virtiofs: Multi threading seems to hurt
	performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jose.carlos.venegas.munoz@intel.com, qemu-devel@nongnu.org, cdupontd@redhat.com, virtio-fs-list <virtio-fs@redhat.com>, archana.m.shinde@intel.com

Hi,
  I've been doing some of my own perf tests and I think I agree
about the thread pool size;  my test is a kernel build
and I've tried a bunch of different options.

My config:
  Host: 16 core AMD EPYC (32 thread), 128G RAM,
     5.9.0-rc4 kernel, rhel 8.2ish userspace.
  5.1.0 qemu/virtiofsd built from git.
  Guest: Fedora 32 from cloud image with just enough extra installed for
a kernel build.

  git cloned and checkout v5.8 of Linux into /dev/shm/linux on the host
fresh before each test.  Then log into the guest, make defconfig,
time make -j 16 bzImage,  make clean; time make -j 16 bzImage 
The numbers below are the 'real' time in the guest from the initial make
(the subsequent makes dont vary much)

Below are the detauls of what each of these means, but here are the
numbers first

virtiofsdefault        4m0.978s
9pdefault              9m41.660s
virtiofscache=none    10m29.700s
9pmmappass             9m30.047s
9pmbigmsize           12m4.208s
9pmsecnone             9m21.363s
virtiofscache=noneT1   7m17.494s
virtiofsdefaultT1      3m43.326s

So the winner there by far is the 'virtiofsdefaultT1' - that's
the default virtiofs settings, but with --thread-pool-size=1 - so
yes it gives a small benefit.
But interestingly the cache=none virtiofs performance is pretty bad,
but thread-pool-size=1 on that makes a BIG improvement.


virtiofsdefault:
  ./virtiofsd --socket-path=/tmp/vhostqemu -o source=/dev/shm/linux
  ./x86_64-softmmu/qemu-system-x86_64 -M pc,memory-backend=mem,accel=kvm -smp 8 -cpu host -m 32G,maxmem=64G,slots=1 -object memory-backend-memfd,id=mem,size=32G,share=on -drive if=virtio,file=/home/images/f-32-kernel.qcow2 -nographic -chardev socket,id=char0,path=/tmp/vhostqemu -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=kernel
  mount -t virtiofs kernel /mnt

9pdefault
  ./x86_64-softmmu/qemu-system-x86_64 -M pc,accel=kvm -smp 8 -cpu host -m 32G -drive if=virtio,file=/home/images/f-32-kernel.qcow2 -nographic -virtfs local,path=/dev/shm/linux,mount_tag=kernel,security_model=passthrough
  mount -t 9p -o trans=virtio kernel /mnt -oversion=9p2000.L

virtiofscache=none
  ./virtiofsd --socket-path=/tmp/vhostqemu -o source=/dev/shm/linux -o cache=none
  ./x86_64-softmmu/qemu-system-x86_64 -M pc,memory-backend=mem,accel=kvm -smp 8 -cpu host -m 32G,maxmem=64G,slots=1 -object memory-backend-memfd,id=mem,size=32G,share=on -drive if=virtio,file=/home/images/f-32-kernel.qcow2 -nographic -chardev socket,id=char0,path=/tmp/vhostqemu -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=kernel
  mount -t virtiofs kernel /mnt

9pmmappass
  ./x86_64-softmmu/qemu-system-x86_64 -M pc,accel=kvm -smp 8 -cpu host -m 32G -drive if=virtio,file=/home/images/f-32-kernel.qcow2 -nographic -virtfs local,path=/dev/shm/linux,mount_tag=kernel,security_model=passthrough
  mount -t 9p -o trans=virtio kernel /mnt -oversion=9p2000.L,cache=mmap

9pmbigmsize
   ./x86_64-softmmu/qemu-system-x86_64 -M pc,accel=kvm -smp 8 -cpu host -m 32G -drive if=virtio,file=/home/images/f-32-kernel.qcow2 -nographic -virtfs local,path=/dev/shm/linux,mount_tag=kernel,security_model=passthrough
   mount -t 9p -o trans=virtio kernel /mnt -oversion=9p2000.L,cache=mmap,msize=1048576

9pmsecnone
   ./x86_64-softmmu/qemu-system-x86_64 -M pc,accel=kvm -smp 8 -cpu host -m 32G -drive if=virtio,file=/home/images/f-32-kernel.qcow2 -nographic -virtfs local,path=/dev/shm/linux,mount_tag=kernel,security_model=none
   mount -t 9p -o trans=virtio kernel /mnt -oversion=9p2000.L

virtiofscache=noneT1
   ./virtiofsd --socket-path=/tmp/vhostqemu -o source=/dev/shm/linux -o cache=none --thread-pool-size=1
   mount -t virtiofs kernel /mnt

virtiofsdefaultT1
   ./virtiofsd --socket-path=/tmp/vhostqemu -o source=/dev/shm/linux --thread-pool-size=1
    ./x86_64-softmmu/qemu-system-x86_64 -M pc,memory-backend=mem,accel=kvm -smp 8 -cpu host -m 32G,maxmem=64G,slots=1 -object memory-backend-memfd,id=mem,size=32G,share=on -drive if=virtio,file=/home/images/f-32-kernel.qcow2 -nographic -chardev socket,id=char0,path=/tmp/vhostqemu -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=kernel
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

