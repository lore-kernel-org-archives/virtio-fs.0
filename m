Date: Tue, 22 Sep 2020 11:25:31 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200922102531.GA2837@work-vm>
References: <20200918213436.GA3520@redhat.com> <20200921153243.GK3221@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921153243.GK3221@work-vm>
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

* Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
> Hi,
>   I've been doing some of my own perf tests and I think I agree
> about the thread pool size;  my test is a kernel build
> and I've tried a bunch of different options.
> 
> My config:
>   Host: 16 core AMD EPYC (32 thread), 128G RAM,
>      5.9.0-rc4 kernel, rhel 8.2ish userspace.
>   5.1.0 qemu/virtiofsd built from git.
>   Guest: Fedora 32 from cloud image with just enough extra installed for
> a kernel build.
> 
>   git cloned and checkout v5.8 of Linux into /dev/shm/linux on the host
> fresh before each test.  Then log into the guest, make defconfig,
> time make -j 16 bzImage,  make clean; time make -j 16 bzImage 
> The numbers below are the 'real' time in the guest from the initial make
> (the subsequent makes dont vary much)
> 
> Below are the detauls of what each of these means, but here are the
> numbers first
> 
> virtiofsdefault        4m0.978s
> 9pdefault              9m41.660s
> virtiofscache=none    10m29.700s
> 9pmmappass             9m30.047s
> 9pmbigmsize           12m4.208s
> 9pmsecnone             9m21.363s
> virtiofscache=noneT1   7m17.494s
> virtiofsdefaultT1      3m43.326s
> 
> So the winner there by far is the 'virtiofsdefaultT1' - that's
> the default virtiofs settings, but with --thread-pool-size=1 - so
> yes it gives a small benefit.
> But interestingly the cache=none virtiofs performance is pretty bad,
> but thread-pool-size=1 on that makes a BIG improvement.

Here are fio runs that Vivek asked me to run in my same environment
(there are some 0's in some of the mmap cases, and I've not investigated
why yet). virtiofs is looking good here in I think all of the cases;
there's some division over which cinfig; cache=none
seems faster in some cases which surprises me.

Dave


NAME                    WORKLOAD                Bandwidth       IOPS            
9pbigmsize              seqread-psync           108(MiB/s)      27k             
9pdefault               seqread-psync           105(MiB/s)      26k             
9pmmappass              seqread-psync           107(MiB/s)      26k             
9pmsecnone              seqread-psync           107(MiB/s)      26k             
virtiofscachenoneT1     seqread-psync           135(MiB/s)      33k             
virtiofscachenone       seqread-psync           115(MiB/s)      28k             
virtiofsdefaultT1       seqread-psync           2465(MiB/s)     616k            
virtiofsdefault         seqread-psync           2468(MiB/s)     617k            

9pbigmsize              seqread-psync-multi     357(MiB/s)      89k             
9pdefault               seqread-psync-multi     358(MiB/s)      89k             
9pmmappass              seqread-psync-multi     347(MiB/s)      86k             
9pmsecnone              seqread-psync-multi     364(MiB/s)      91k             
virtiofscachenoneT1     seqread-psync-multi     479(MiB/s)      119k            
virtiofscachenone       seqread-psync-multi     385(MiB/s)      96k             
virtiofsdefaultT1       seqread-psync-multi     5916(MiB/s)     1479k           
virtiofsdefault         seqread-psync-multi     8771(MiB/s)     2192k           

9pbigmsize              seqread-mmap            111(MiB/s)      27k             
9pdefault               seqread-mmap            101(MiB/s)      25k             
9pmmappass              seqread-mmap            114(MiB/s)      28k             
9pmsecnone              seqread-mmap            107(MiB/s)      26k             
virtiofscachenoneT1     seqread-mmap            0(KiB/s)        0               
virtiofscachenone       seqread-mmap            0(KiB/s)        0               
virtiofsdefaultT1       seqread-mmap            2896(MiB/s)     724k            
virtiofsdefault         seqread-mmap            2856(MiB/s)     714k            

9pbigmsize              seqread-mmap-multi      364(MiB/s)      91k             
9pdefault               seqread-mmap-multi      348(MiB/s)      87k             
9pmmappass              seqread-mmap-multi      354(MiB/s)      88k             
9pmsecnone              seqread-mmap-multi      340(MiB/s)      85k             
virtiofscachenoneT1     seqread-mmap-multi      0(KiB/s)        0               
virtiofscachenone       seqread-mmap-multi      0(KiB/s)        0               
virtiofsdefaultT1       seqread-mmap-multi      6057(MiB/s)     1514k           
virtiofsdefault         seqread-mmap-multi      9585(MiB/s)     2396k           

9pbigmsize              seqread-libaio          109(MiB/s)      27k             
9pdefault               seqread-libaio          103(MiB/s)      25k             
9pmmappass              seqread-libaio          107(MiB/s)      26k             
9pmsecnone              seqread-libaio          107(MiB/s)      26k             
virtiofscachenoneT1     seqread-libaio          671(MiB/s)      167k            
virtiofscachenone       seqread-libaio          538(MiB/s)      134k            
virtiofsdefaultT1       seqread-libaio          187(MiB/s)      46k             
virtiofsdefault         seqread-libaio          541(MiB/s)      135k            

9pbigmsize              seqread-libaio-multi    354(MiB/s)      88k             
9pdefault               seqread-libaio-multi    360(MiB/s)      90k             
9pmmappass              seqread-libaio-multi    356(MiB/s)      89k             
9pmsecnone              seqread-libaio-multi    344(MiB/s)      86k             
virtiofscachenoneT1     seqread-libaio-multi    488(MiB/s)      122k            
virtiofscachenone       seqread-libaio-multi    380(MiB/s)      95k             
virtiofsdefaultT1       seqread-libaio-multi    5577(MiB/s)     1394k           
virtiofsdefault         seqread-libaio-multi    5359(MiB/s)     1339k           

9pbigmsize              randread-psync          106(MiB/s)      26k             
9pdefault               randread-psync          106(MiB/s)      26k             
9pmmappass              randread-psync          120(MiB/s)      30k             
9pmsecnone              randread-psync          105(MiB/s)      26k             
virtiofscachenoneT1     randread-psync          154(MiB/s)      38k             
virtiofscachenone       randread-psync          134(MiB/s)      33k             
virtiofsdefaultT1       randread-psync          129(MiB/s)      32k             
virtiofsdefault         randread-psync          129(MiB/s)      32k             

9pbigmsize              randread-psync-multi    349(MiB/s)      87k             
9pdefault               randread-psync-multi    354(MiB/s)      88k             
9pmmappass              randread-psync-multi    360(MiB/s)      90k             
9pmsecnone              randread-psync-multi    352(MiB/s)      88k             
virtiofscachenoneT1     randread-psync-multi    449(MiB/s)      112k            
virtiofscachenone       randread-psync-multi    383(MiB/s)      95k             
virtiofsdefaultT1       randread-psync-multi    435(MiB/s)      108k            
virtiofsdefault         randread-psync-multi    368(MiB/s)      92k             

9pbigmsize              randread-mmap           100(MiB/s)      25k             
9pdefault               randread-mmap           89(MiB/s)       22k             
9pmmappass              randread-mmap           87(MiB/s)       21k             
9pmsecnone              randread-mmap           92(MiB/s)       23k             
virtiofscachenoneT1     randread-mmap           0(KiB/s)        0               
virtiofscachenone       randread-mmap           0(KiB/s)        0               
virtiofsdefaultT1       randread-mmap           111(MiB/s)      27k             
virtiofsdefault         randread-mmap           101(MiB/s)      25k             

9pbigmsize              randread-mmap-multi     335(MiB/s)      83k             
9pdefault               randread-mmap-multi     318(MiB/s)      79k             
9pmmappass              randread-mmap-multi     335(MiB/s)      83k             
9pmsecnone              randread-mmap-multi     323(MiB/s)      80k             
virtiofscachenoneT1     randread-mmap-multi     0(KiB/s)        0               
virtiofscachenone       randread-mmap-multi     0(KiB/s)        0               
virtiofsdefaultT1       randread-mmap-multi     422(MiB/s)      105k            
virtiofsdefault         randread-mmap-multi     345(MiB/s)      86k             

9pbigmsize              randread-libaio         84(MiB/s)       21k             
9pdefault               randread-libaio         89(MiB/s)       22k             
9pmmappass              randread-libaio         87(MiB/s)       21k             
9pmsecnone              randread-libaio         82(MiB/s)       20k             
virtiofscachenoneT1     randread-libaio         641(MiB/s)      160k            
virtiofscachenone       randread-libaio         527(MiB/s)      131k            
virtiofsdefaultT1       randread-libaio         205(MiB/s)      51k             
virtiofsdefault         randread-libaio         536(MiB/s)      134k            

9pbigmsize              randread-libaio-multi   265(MiB/s)      66k             
9pdefault               randread-libaio-multi   267(MiB/s)      66k             
9pmmappass              randread-libaio-multi   266(MiB/s)      66k             
9pmsecnone              randread-libaio-multi   269(MiB/s)      67k             
virtiofscachenoneT1     randread-libaio-multi   615(MiB/s)      153k            
virtiofscachenone       randread-libaio-multi   542(MiB/s)      135k            
virtiofsdefaultT1       randread-libaio-multi   595(MiB/s)      148k            
virtiofsdefault         randread-libaio-multi   552(MiB/s)      138k            

9pbigmsize              seqwrite-psync          106(MiB/s)      26k             
9pdefault               seqwrite-psync          106(MiB/s)      26k             
9pmmappass              seqwrite-psync          107(MiB/s)      26k             
9pmsecnone              seqwrite-psync          107(MiB/s)      26k             
virtiofscachenoneT1     seqwrite-psync          136(MiB/s)      34k             
virtiofscachenone       seqwrite-psync          112(MiB/s)      28k             
virtiofsdefaultT1       seqwrite-psync          132(MiB/s)      33k             
virtiofsdefault         seqwrite-psync          109(MiB/s)      27k             

9pbigmsize              seqwrite-psync-multi    353(MiB/s)      88k             
9pdefault               seqwrite-psync-multi    364(MiB/s)      91k             
9pmmappass              seqwrite-psync-multi    345(MiB/s)      86k             
9pmsecnone              seqwrite-psync-multi    350(MiB/s)      87k             
virtiofscachenoneT1     seqwrite-psync-multi    470(MiB/s)      117k            
virtiofscachenone       seqwrite-psync-multi    374(MiB/s)      93k             
virtiofsdefaultT1       seqwrite-psync-multi    470(MiB/s)      117k            
virtiofsdefault         seqwrite-psync-multi    373(MiB/s)      93k             

9pbigmsize              seqwrite-mmap           195(MiB/s)      48k             
9pdefault               seqwrite-mmap           0(KiB/s)        0               
9pmmappass              seqwrite-mmap           196(MiB/s)      49k             
9pmsecnone              seqwrite-mmap           0(KiB/s)        0               
virtiofscachenoneT1     seqwrite-mmap           0(KiB/s)        0               
virtiofscachenone       seqwrite-mmap           0(KiB/s)        0               
virtiofsdefaultT1       seqwrite-mmap           603(MiB/s)      150k            
virtiofsdefault         seqwrite-mmap           629(MiB/s)      157k            

9pbigmsize              seqwrite-mmap-multi     247(MiB/s)      61k             
9pdefault               seqwrite-mmap-multi     0(KiB/s)        0               
9pmmappass              seqwrite-mmap-multi     246(MiB/s)      61k             
9pmsecnone              seqwrite-mmap-multi     0(KiB/s)        0               
virtiofscachenoneT1     seqwrite-mmap-multi     0(KiB/s)        0               
virtiofscachenone       seqwrite-mmap-multi     0(KiB/s)        0               
virtiofsdefaultT1       seqwrite-mmap-multi     1787(MiB/s)     446k            
virtiofsdefault         seqwrite-mmap-multi     1692(MiB/s)     423k            

9pbigmsize              seqwrite-libaio         107(MiB/s)      26k             
9pdefault               seqwrite-libaio         107(MiB/s)      26k             
9pmmappass              seqwrite-libaio         106(MiB/s)      26k             
9pmsecnone              seqwrite-libaio         108(MiB/s)      27k             
virtiofscachenoneT1     seqwrite-libaio         595(MiB/s)      148k            
virtiofscachenone       seqwrite-libaio         524(MiB/s)      131k            
virtiofsdefaultT1       seqwrite-libaio         575(MiB/s)      143k            
virtiofsdefault         seqwrite-libaio         538(MiB/s)      134k            

9pbigmsize              seqwrite-libaio-multi   355(MiB/s)      88k             
9pdefault               seqwrite-libaio-multi   341(MiB/s)      85k             
9pmmappass              seqwrite-libaio-multi   354(MiB/s)      88k             
9pmsecnone              seqwrite-libaio-multi   350(MiB/s)      87k             
virtiofscachenoneT1     seqwrite-libaio-multi   609(MiB/s)      152k            
virtiofscachenone       seqwrite-libaio-multi   536(MiB/s)      134k            
virtiofsdefaultT1       seqwrite-libaio-multi   609(MiB/s)      152k            
virtiofsdefault         seqwrite-libaio-multi   538(MiB/s)      134k            

9pbigmsize              randwrite-psync         104(MiB/s)      26k             
9pdefault               randwrite-psync         106(MiB/s)      26k             
9pmmappass              randwrite-psync         105(MiB/s)      26k             
9pmsecnone              randwrite-psync         103(MiB/s)      25k             
virtiofscachenoneT1     randwrite-psync         125(MiB/s)      31k             
virtiofscachenone       randwrite-psync         110(MiB/s)      27k             
virtiofsdefaultT1       randwrite-psync         129(MiB/s)      32k             
virtiofsdefault         randwrite-psync         112(MiB/s)      28k             

9pbigmsize              randwrite-psync-multi   355(MiB/s)      88k             
9pdefault               randwrite-psync-multi   339(MiB/s)      84k             
9pmmappass              randwrite-psync-multi   343(MiB/s)      85k             
9pmsecnone              randwrite-psync-multi   344(MiB/s)      86k             
virtiofscachenoneT1     randwrite-psync-multi   461(MiB/s)      115k            
virtiofscachenone       randwrite-psync-multi   370(MiB/s)      92k             
virtiofsdefaultT1       randwrite-psync-multi   449(MiB/s)      112k            
virtiofsdefault         randwrite-psync-multi   364(MiB/s)      91k             

9pbigmsize              randwrite-mmap          98(MiB/s)       24k             
9pdefault               randwrite-mmap          0(KiB/s)        0               
9pmmappass              randwrite-mmap          97(MiB/s)       24k             
9pmsecnone              randwrite-mmap          0(KiB/s)        0               
virtiofscachenoneT1     randwrite-mmap          0(KiB/s)        0               
virtiofscachenone       randwrite-mmap          0(KiB/s)        0               
virtiofsdefaultT1       randwrite-mmap          102(MiB/s)      25k             
virtiofsdefault         randwrite-mmap          92(MiB/s)       23k             

9pbigmsize              randwrite-mmap-multi    246(MiB/s)      61k             
9pdefault               randwrite-mmap-multi    0(KiB/s)        0               
9pmmappass              randwrite-mmap-multi    239(MiB/s)      59k             
9pmsecnone              randwrite-mmap-multi    0(KiB/s)        0               
virtiofscachenoneT1     randwrite-mmap-multi    0(KiB/s)        0               
virtiofscachenone       randwrite-mmap-multi    0(KiB/s)        0               
virtiofsdefaultT1       randwrite-mmap-multi    279(MiB/s)      69k             
virtiofsdefault         randwrite-mmap-multi    225(MiB/s)      56k             

9pbigmsize              randwrite-libaio        110(MiB/s)      27k             
9pdefault               randwrite-libaio        111(MiB/s)      27k             
9pmmappass              randwrite-libaio        103(MiB/s)      25k             
9pmsecnone              randwrite-libaio        102(MiB/s)      25k             
virtiofscachenoneT1     randwrite-libaio        601(MiB/s)      150k            
virtiofscachenone       randwrite-libaio        525(MiB/s)      131k            
virtiofsdefaultT1       randwrite-libaio        618(MiB/s)      154k            
virtiofsdefault         randwrite-libaio        527(MiB/s)      131k            

9pbigmsize              randwrite-libaio-multi  332(MiB/s)      83k             
9pdefault               randwrite-libaio-multi  343(MiB/s)      85k             
9pmmappass              randwrite-libaio-multi  350(MiB/s)      87k             
9pmsecnone              randwrite-libaio-multi  334(MiB/s)      83k             
virtiofscachenoneT1     randwrite-libaio-multi  611(MiB/s)      152k            
virtiofscachenone       randwrite-libaio-multi  533(MiB/s)      133k            
virtiofsdefaultT1       randwrite-libaio-multi  599(MiB/s)      149k            
virtiofsdefault         randwrite-libaio-multi  531(MiB/s)      132k            

> 
> virtiofsdefault:
>   ./virtiofsd --socket-path=/tmp/vhostqemu -o source=/dev/shm/linux
>   ./x86_64-softmmu/qemu-system-x86_64 -M pc,memory-backend=mem,accel=kvm -smp 8 -cpu host -m 32G,maxmem=64G,slots=1 -object memory-backend-memfd,id=mem,size=32G,share=on -drive if=virtio,file=/home/images/f-32-kernel.qcow2 -nographic -chardev socket,id=char0,path=/tmp/vhostqemu -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=kernel
>   mount -t virtiofs kernel /mnt
> 
> 9pdefault
>   ./x86_64-softmmu/qemu-system-x86_64 -M pc,accel=kvm -smp 8 -cpu host -m 32G -drive if=virtio,file=/home/images/f-32-kernel.qcow2 -nographic -virtfs local,path=/dev/shm/linux,mount_tag=kernel,security_model=passthrough
>   mount -t 9p -o trans=virtio kernel /mnt -oversion=9p2000.L
> 
> virtiofscache=none
>   ./virtiofsd --socket-path=/tmp/vhostqemu -o source=/dev/shm/linux -o cache=none
>   ./x86_64-softmmu/qemu-system-x86_64 -M pc,memory-backend=mem,accel=kvm -smp 8 -cpu host -m 32G,maxmem=64G,slots=1 -object memory-backend-memfd,id=mem,size=32G,share=on -drive if=virtio,file=/home/images/f-32-kernel.qcow2 -nographic -chardev socket,id=char0,path=/tmp/vhostqemu -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=kernel
>   mount -t virtiofs kernel /mnt
> 
> 9pmmappass
>   ./x86_64-softmmu/qemu-system-x86_64 -M pc,accel=kvm -smp 8 -cpu host -m 32G -drive if=virtio,file=/home/images/f-32-kernel.qcow2 -nographic -virtfs local,path=/dev/shm/linux,mount_tag=kernel,security_model=passthrough
>   mount -t 9p -o trans=virtio kernel /mnt -oversion=9p2000.L,cache=mmap
> 
> 9pmbigmsize
>    ./x86_64-softmmu/qemu-system-x86_64 -M pc,accel=kvm -smp 8 -cpu host -m 32G -drive if=virtio,file=/home/images/f-32-kernel.qcow2 -nographic -virtfs local,path=/dev/shm/linux,mount_tag=kernel,security_model=passthrough
>    mount -t 9p -o trans=virtio kernel /mnt -oversion=9p2000.L,cache=mmap,msize=1048576
> 
> 9pmsecnone
>    ./x86_64-softmmu/qemu-system-x86_64 -M pc,accel=kvm -smp 8 -cpu host -m 32G -drive if=virtio,file=/home/images/f-32-kernel.qcow2 -nographic -virtfs local,path=/dev/shm/linux,mount_tag=kernel,security_model=none
>    mount -t 9p -o trans=virtio kernel /mnt -oversion=9p2000.L
> 
> virtiofscache=noneT1
>    ./virtiofsd --socket-path=/tmp/vhostqemu -o source=/dev/shm/linux -o cache=none --thread-pool-size=1
>    mount -t virtiofs kernel /mnt
> 
> virtiofsdefaultT1
>    ./virtiofsd --socket-path=/tmp/vhostqemu -o source=/dev/shm/linux --thread-pool-size=1
>     ./x86_64-softmmu/qemu-system-x86_64 -M pc,memory-backend=mem,accel=kvm -smp 8 -cpu host -m 32G,maxmem=64G,slots=1 -object memory-backend-memfd,id=mem,size=32G,share=on -drive if=virtio,file=/home/images/f-32-kernel.qcow2 -nographic -chardev socket,id=char0,path=/tmp/vhostqemu -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=kernel
> -- 
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

