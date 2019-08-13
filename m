Date: Tue, 13 Aug 2019 09:06:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190813130615.GA24174@redhat.com>
References: <16b9edb2-002c-46b8-981b-39323e918cf0@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16b9edb2-002c-46b8-981b-39323e918cf0@cn.fujitsu.com>
Subject: Re: [Virtio-fs] issues with accessing 2 directory trees
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Cao jin <caoj.fnst@cn.fujitsu.com>
Cc: virtio-fs@redhat.com, =?utf-8?B?5Yip?= <qi.fuli@fujitsu.com>, =?UTF-8?B?UWksIEZ1bGkv5paJIOemjw==?=@redhat.com

On Tue, Aug 13, 2019 at 05:03:00PM +0800, Cao jin wrote:
> Hi,
> 
> I am trying virtio fs for accessing 2 directory trees, but find it has
> problem when mounting the 2nd one. Hoping to get some hints whether I made
> mistakes or anything else.
> 
> steps:
> 1. start 2 daemons:
> sudo ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu1 -o source=~/shareguest1/ -o cache=always
> sudo ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu2 -o source=~/shareguest2/ -o cache=always
> 
> 2. qemu command line:
> sudo ./qemu-system-x86_64 -M q35 -cpu host --enable-kvm -smp 2 -m 4G,slots=4,maxmem=8G \
>      -object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on -numa node,memdev=mem \
>      -chardev socket,id=char0,path=/tmp/vhostqemu1 -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs1,cache-size=1G \
>      -chardev socket,id=char1,path=/tmp/vhostqemu2 -device vhost-user-fs-pci,queue-size=1024,chardev=char1,tag=myfs2,cache-size=1G \
>      --serial stdio -netdev tap,id=net0 -device virtio-net-pci,netdev=net0,id=net0,mac=52:54:00:72:20:55
>      -drive if=virtio,file=~/iso/f28s.qcow2
> 
> Then, guest console report error when probing 2nd virtiofs device with:
> [    2.809341] virtio_fs virtio1: Cache len: 0x40000000 @ 0x3c0000000
> [    2.811204] x86/PAT: systemd-udevd:266 conflicting memory types 3c0000000-408000000 write-back<->uncached-minus
> [    2.813309] x86/PAT: reserve_memtype failed [mem 0x3c0000000-0x407ffffff], track write-back, req write-back
> [    2.924576] virtio_fs: probe of virtio1 failed with error -16
> 
> So, mount will not success on the 2nd directory tree.

I have seen similar issues even with single device if I try to use
very small cache size (say 16M). 

Can you paste your /proc/iomem output. I think basic problem seems to
be that some other component already reserved resource with certain
properties and what we are trying reserve somehow overlaps a bit
(due to alignement etc) with already reserved resource and hence
reservation fails.

Can you try cache-size=4G or cache-size=8G on both the devices and see
if that works.

Thanks
Vivek

