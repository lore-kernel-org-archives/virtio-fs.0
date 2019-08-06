References: <5D4944CC.30100@huawei.com> <20190806094259.GC3066@work-vm>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D4963F5.7030407@huawei.com>
Date: Tue, 6 Aug 2019 19:26:45 +0800
MIME-Version: 1.0
In-Reply-To: <20190806094259.GC3066@work-vm>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [QUESTION] Can not enable dax option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com

Hi Dave,

On 2019/8/6 17:42, Dr. David Alan Gilbert wrote:
> * piaojun (piaojun@huawei.com) wrote:
>> Hi,
>>
>> Dax could not be enabled by run the following command:
>>
>> QEMU command:
>> qemu-system-x86_64 -M pc -cpu host --enable-kvm -smp 2 \
>> -m 4G,maxmem=4G -object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on -numa node,memdev=mem \
>> -drive if=none,id=root,format=qcow2,file=centos_7.3_64.qcow2 -device virtio-scsi -device scsi-disk,drive=root,bootindex=1 -object iothread,id=io \
>> -device virtio-scsi-pci,iothread=io -net nic,model=virtio -vnc 0.0.0.0:0 \
>> -chardev socket,id=char0,path=/tmp/vhostqemu -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs,cache-size=2G
>>
>> Guest command:
>> # mount -t virtio_fs myfs /mnt/virtiofs -o rootmode=040000,user_id=0,group_id=0,dax
>>
>> When I rmmod/insmod again, the error message shows that something is
>> wrong with 'cache capability':
>>
>> virtio_pci_find_shm_cap: shm cap with bad size offset: 164 size: 24
>> virtio_fs virtio2: virtio_fs_setup_dax: No cache capability
> 
> That's odd; because '24' seems the right size for a 'struct
> virtio_pci_cap64' and is what I get on my machine.
> 
> Can you add:
> 
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index fcdabe85d82d..34e89474a8b7 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -473,6 +473,7 @@ static int virtio_pci_find_shm_cap(struct pci_dev *dev,
>                                 __func__, pos, cap_len);
>                          continue;
>                  }
> +                printk(KERN_INFO "%s: cap_len should be: %d\n", __func__, sizeof(struct virtio_pci_cap64));
>  
>                 pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
>                                                           id),
> 
> and tell us what it says?
> 
> Just check that your kernel's include/uapi/linux/virtio_pci.h and
> daemon's include/standard-headers/linux/virtio_pci.h  both match
> and show the same definition for virtio_pci_cap64
> 
> Dave

Thanks for your help, and I solved this problem by reinstalling Guest
kernel:

# make modules_install -j 16
# make install -j 16

1. The virtio_pci.h has the same definition for virtio_pci_cap64 in
both kernel and daemon;
2. As you said, the reason is probably that Guest kernel still used
virtio_pci_cap which not matches virtio_pci_cap64. I guess the Guest
still used the old virtio driver which cause the problem.

Thanks,
Jun

> 
> 
>>
>> Code url:
>> https://github.com/rhvgoyal/linux/commits/virtio-fs-dev-5.1
>> https://gitlab.com/virtio-fs/qemu/tree/virtio-fs-dev
>>
>> Thanks,
>> Jun
>>
>> _______________________________________________
>> Virtio-fs mailing list
>> Virtio-fs@redhat.com
>> https://www.redhat.com/mailman/listinfo/virtio-fs
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> .
> 

