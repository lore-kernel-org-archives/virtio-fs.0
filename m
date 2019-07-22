Date: Mon, 22 Jul 2019 17:47:09 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190722164709.GE3035@work-vm>
References: <4221bd26-c6a0-6853-e455-aee8239349bd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4221bd26-c6a0-6853-e455-aee8239349bd@gmail.com>
Subject: Re: [Virtio-fs] Failure as Operation not permitted on aarch64
	machine
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: virtio-fs@redhat.com

* Masayoshi Mizuma (msys.mizuma@gmail.com) wrote:
> Hello,

Hi Masa,

> I would appreciate if you could help me to resolve following failure.
> 
> I tried to use virtio-fs on aarch64 [1], however, qemu [2] failed to boot
> as Operation not permitted.
> 
>   ---
>   # ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o source=/tmp/share -o cache=none &
> 
>   # qemu-system-aarch64 -machine virt,accel=kvm,gic-version=3 -cpu host -smp 8 ... [3]
> 
>   UEFI firmware starting.
>   kvm_set_phys_mem: error registering slot: Operation not permitted
>   ---
> 
> >From the ftrace log, the error happened because kvm_set_user_memory_region()
> returned as -1 (EPERM).
> 
>   ---
>   qemu-system-aar-28381 [003] ....  6683.601097: tracing_mark_write: kvm_set_user_memory Slot#3 flags=0x0 gpa=0x8000000000 size=0x40000000 ua=0xfffe0ba00000 ret=-1
>   ---
> 
> kvm_set_user_memory_region() returned -1 because kvm_arch_prepare_memory_region()
> in kernel returned as -EPERM.

Right, yes we know this is a problem on aarch64;  for aarch we disable
the DAX mode;  if you check out our -dev branches and apply the
following hack to the kernel:


diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 3f3c018571ee..60a9724f9c71 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -541,7 +541,7 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
                                           (u8)VIRTIO_FS_SHMCAP_ID_CACHE);
        if (!have_cache) {
                dev_err(&vdev->dev, "%s: No cache capability\n", __func__);
-               return -ENXIO;
+               return 0;
        } else {
                dev_notice(&vdev->dev, "Cache len: 0x%llx @ 0x%llx\n",
                           cache_reg.len, cache_reg.addr);

and start the qemu with:
-device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs,cache-size=0

it should start up for you.

>    ---
>    int kvm_arch_prepare_memory_region(struct kvm *kvm,
>                                    struct kvm_memory_slot *memslot,
>                                    const struct kvm_userspace_memory_region *mem,
>                                    enum kvm_mr_change change)
>    {
>    ...
>                    if (writable && !(vma->vm_flags & VM_WRITE)) {
>                            ret = -EPERM;
>                            break;
>                    }
>    ---
> 
> Actually, the /proc/PID/maps showed ua=0xfffe0ba00000 didn't have PROT_WRITE.
> 
>   ---
>   ...
>   014b0000-014f0000 rw-p 00000000 00:00 0 
>   1c840000-1d470000 rw-p 00000000 00:00 0                                  [heap]
>   fffe0ba00000-fffe4ba00000 ---p 00000000 00:00 0 <===
>   fffe4ba00000-fffe4ba10000 ---p 00000000 00:00 0 
>   fffe4bc00000-fffe4fc00000 rw-p 00000000 00:00 0 
>   fffe4fc00000-fffe4fc10000 ---p 00000000 00:00 0 
>   fffe4fe00000-fffe53e00000 rw-p 00000000 00:00 0 
>   fffe53e00000-fffe53e10000 ---p 00000000 00:00 0 
>   ...
>   ---
> 
> I'm not sure why ua=0xfffe0ba00000 didn't have PROT_WRITE because the memory
> was allocated by qemu_anon_ram_alloc() and it should set PROT_READ | PROT_WRITE.

Because we explicitly mprotect it later (and in current versions we
allocate with PROT_NONE) - on x86 this works fine, but aarch doesn't
like it; we've not quite figured the rules why yet.

Dave

> 
>   ---
>   qemu-system-aar-28372 [022] ....  6674.795027: tracing_mark_write: qemu_anon_ram_alloc size 1073741824 ptr 0xfffe0ba00000
>   ---
> 
> qemu boots successfully if I remove "-device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs",
> so I suppose the option is related to the failure...
> 
> 
> [1]: host kernel is 5.2.0.
>      guest kernel is https://github.com/rhvgoyal/linux/, branch: virtio-fs-dev-5.1.
> 
> [2]: I got the qemu from:
>      https://gitlab.com/virtio-fs/qemu.git
> 
> [3]: Qemu option is:
> 
> $QEMU -machine virt,accel=kvm,gic-version=3 \
> 	-cpu host \
> 	-smp 8 \
>         -m 4G,maxmem=4G \
> 	-object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on \
> 	-numa node,memdev=mem \
>         -drive file=/usr/share/AAVMF/AAVMF_CODE.fd,if=pflash,format=raw,unit=0,readonly=on \
>         -drive file=$VARS,if=pflash,format=raw,unit=1 \
> 	-chardev socket,id=char0,path=/tmp/vhostqemu \
> 	-device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs \
> 	-nographic \
> 	-serial mon:stdio \
> 	--trace events=/tmp/qemu-trace-events \
> 	-drive if=virtio,file=/var/lib/libvirt/images/guest.qcow2
> 
> Thanks,
> Masa
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

