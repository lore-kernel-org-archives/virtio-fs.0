References: <16b9edb2-002c-46b8-981b-39323e918cf0@cn.fujitsu.com>
	<20190813130615.GA24174@redhat.com>
From: Cao jin <caoj.fnst@cn.fujitsu.com>
Message-ID: <51d52d8f-f05f-7e3c-b9d3-d24a0fbaa680@cn.fujitsu.com>
Date: Wed, 14 Aug 2019 14:33:05 +0800
MIME-Version: 1.0
In-Reply-To: <20190813130615.GA24174@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] issues with accessing 2 directory trees
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, =?UTF-8?B?UWksIEZ1bGkv5paJIOemj+WIqQ==?= <qi.fuli@fujitsu.com>

Hi Vivek,

On 8/13/19 9:06 PM, Vivek Goyal wrote:
> On Tue, Aug 13, 2019 at 05:03:00PM +0800, Cao jin wrote:
>> Hi,
>>
>> I am trying virtio fs for accessing 2 directory trees, but find it has
>> problem when mounting the 2nd one. Hoping to get some hints whether I made
>> mistakes or anything else.
>>
>> steps:
>> 1. start 2 daemons:
>> sudo ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu1 -o source=~/shareguest1/ -o cache=always
>> sudo ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu2 -o source=~/shareguest2/ -o cache=always
>>
>> 2. qemu command line:
>> sudo ./qemu-system-x86_64 -M q35 -cpu host --enable-kvm -smp 2 -m 4G,slots=4,maxmem=8G \
>>      -object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on -numa node,memdev=mem \
>>      -chardev socket,id=char0,path=/tmp/vhostqemu1 -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs1,cache-size=1G \
>>      -chardev socket,id=char1,path=/tmp/vhostqemu2 -device vhost-user-fs-pci,queue-size=1024,chardev=char1,tag=myfs2,cache-size=1G \
>>      --serial stdio -netdev tap,id=net0 -device virtio-net-pci,netdev=net0,id=net0,mac=52:54:00:72:20:55
>>      -drive if=virtio,file=~/iso/f28s.qcow2
>>
>> Then, guest console report error when probing 2nd virtiofs device with:
>> [    2.809341] virtio_fs virtio1: Cache len: 0x40000000 @ 0x3c0000000
>> [    2.811204] x86/PAT: systemd-udevd:266 conflicting memory types 3c0000000-408000000 write-back<->uncached-minus
>> [    2.813309] x86/PAT: reserve_memtype failed [mem 0x3c0000000-0x407ffffff], track write-back, req write-back
>> [    2.924576] virtio_fs: probe of virtio1 failed with error -16
>>
>> So, mount will not success on the 2nd directory tree.
> 
> I have seen similar issues even with single device if I try to use
> very small cache size (say 16M). 
> 
> Can you paste your /proc/iomem output. I think basic problem seems to
> be that some other component already reserved resource with certain
> properties and what we are trying reserve somehow overlaps a bit
> (due to alignement etc) with already reserved resource and hence
> reservation fails.
> 
> Can you try cache-size=4G or cache-size=8G on both the devices and see
> if that works.
> 

This cache-size setting still doesn't work for me. When setting it to 8G,
console has the same error:

[    2.983216] virtio_fs virtio1: Cache len: 0x200000000 @ 0x600000000
[    2.984481] x86/PAT: systemd-udevd:278 conflicting memory types 600000000-808000000 write-back<->uncached-minus
[    2.986346] x86/PAT: reserve_memtype failed [mem 0x600000000-0x807ffffff], track write-back, req write-back
[    3.014115] virtio_fs: probe of virtio1 failed with error -16


And, the /proc/iomem shows:

$ sudo cat /proc/iomem
00000000-00000fff : Reserved
00001000-0009fbff : System RAM 
0009fc00-0009ffff : Reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000c97ff : Video ROM 
000c9800-000ca5ff : Adapter ROM 
000ca800-000ccbff : Adapter ROM 
000f0000-000fffff : Reserved
  000f0000-000fffff : System ROM 
00100000-7ffddfff : System RAM 
  1b000000-32ffffff : Crash kernel
7ffde000-7fffffff : Reserved
b0000000-bfffffff : PCI MMCONFIG 0000 [bus 00-ff]
  b0000000-bfffffff : Reserved
c0000000-febfffff : PCI Bus 0000:00
  fd000000-fdffffff : 0000:00:01.0
  feb80000-febbffff : 0000:00:04.0
  febd0000-febd0fff : 0000:00:01.0
  febd1000-febd1fff : 0000:00:02.0
  febd2000-febd2fff : 0000:00:03.0
  febd3000-febd3fff : 0000:00:04.0
  febd4000-febd4fff : 0000:00:05.0
  febd5000-febd5fff : 0000:00:1f.2
    febd5000-febd5fff : ahci
fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : PNP0103:00
fed1c000-fed1ffff : Reserved
fee00000-fee00fff : Local APIC
feffc000-feffffff : Reserved
fffc0000-ffffffff : Reserved
100000000-17fffffff : System RAM
  119000000-119c031d0 : Kernel code
  119c031d1-11a37413f : Kernel data
  11a932000-11adfffff : Kernel bss
400000000-bffffffff : PCI Bus 0000:00
  400000000-5ffffffff : 0000:00:02.0
    400000000-5ffffffff : virtio-pci-shm
  600000000-7ffffffff : 0000:00:03.0
    600000000-7ffffffff : virtio-pci-shm
  800000000-800003fff : 0000:00:02.0
    800000000-800003fff : virtio-pci-modern
  800004000-800007fff : 0000:00:03.0
    800004000-800007fff : virtio-pci-modern
  800008000-80000bfff : 0000:00:04.0
    800008000-80000bfff : virtio-pci-modern
  80000c000-80000ffff : 0000:00:05.0
    80000c000-80000ffff : virtio-pci-modern
-- 
Sincerely,
Cao jin


