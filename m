From: wangyan <wangyan122@huawei.com>
Message-ID: <484b6fd5-fa26-ce94-a18f-63c8c41692ee@huawei.com>
Date: Thu, 8 Aug 2019 19:25:25 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] A performance problem for buffer write
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "virtio-fs@redhat.com" <virtio-fs@redhat.com>
Cc: "Fangyi (C)" <eric.fangyi@huawei.com>

Hi all,
	I meet a performance problem when I test buffer write.
	
	Test environment:
		Guest Kernel:
			https://github.com/rhvgoyal/linux/tree/virtio-fs-dev-5.1
		Host Qemu:
			https://gitlab.com/virtio-fs/qemu/tree/virtio-fs-dev

	I format a ramdisk to be a ext4 filesystem, and mount it for a shared 
folder.
	In the qemu build directory, run:
		./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o 
source=/mnt/9pshare/ -o cache=always -o writeback
	and
		./x86_64-softmmu/qemu-system-x86_64 -M pc -cpu host --enable-kvm -smp 
2 -m 8G,maxmem=8G -object 
memory-backend-file,id=mem,size=8G,mem-path=/dev/hugepages,share=on 
-numa node,memdev=mem -drive 
if=none,id=root,format=qcow2,file=/mnt/sdb/mirrors/os.qcow2 -device 
virtio-scsi -device scsi-disk,drive=root,bootindex=1 -object 
iothread,id=io -device virtio-scsi-pci,iothread=io -net nic,model=virtio 
-net tap,ifname=tap0,script=/etc/qemu-ifup,downscript=no -vnc 0.0.0.0:0 
-chardev socket,id=char0,path=/tmp/vhostqemu -device 
vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs,cache-size=2G

	Test Result:
		1. the bandwidth of buffer write is just 691894KB/s, it is very bad. 
The test model:
			fio -filename=/mnt/virtiofs/test -rw=write -bs=1M -size=1G -iodepth=1 
-ioengine=psync -numjobs=1 -group_reporting -name=1M -time_based -runtime=30
			1M: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=psync, iodepth=1
			fio-2.13
			Starting 1 process
			4K: Laying out IO file(s) (1 file(s) / 1024MB)
			Jobs: 1 (f=1): [W(1)] [100.0% done] [0KB/695.2MB/0KB /s] [0/695/0 
iops] [eta 00m:00s]
			4K: (groupid=0, jobs=1): err= 0: pid=5580: Thu Aug  8 18:29:20 2019
			  write: io=20271MB, bw=691894KB/s, iops=675, runt= 30001msec
				clat (usec): min=359, max=12348, avg=1423.88, stdev=1587.96
				 lat (usec): min=407, max=12399, avg=1475.98, stdev=1588.17


		2. the avg lat is 6.64usec, it is very high. The test model:
			fio -filename=/mnt/virtiofs/test -rw=write -bs=4K -size=1G -iodepth=1 
-ioengine=psync -numjobs=1 -group_reporting -name=4K -time_based -runtime=30
			4K: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
			fio-2.13
			Starting 1 process
			Jobs: 1 (f=1): [W(1)] [100.0% done] [0KB/478.9MB/0KB /s] [0/123K/0 
iops] [eta 00m:00s]
			4K: (groupid=0, jobs=1): err= 0: pid=5685: Thu Aug  8 18:35:51 2019
			  write: io=13302MB, bw=454013KB/s, iops=113503, runt= 30001msec
				clat (usec): min=2, max=7196, avg= 6.03, stdev=75.27
				lat (usec): min=3, max=7196, avg= 6.64, stdev=75.27

	I found that the judgement statement 'if (!TestSetPageDirty(page))' 
always true in function '__set_page_dirty_nobuffers', it will waste much 
time to mark inode dirty, no one page is dirty when write it the second 
time.
	The buffer write stack:
		fuse_file_write_iter
			->fuse_cache_write_iter
				->generic_file_write_iter
					->__generic_file_write_iter
						->generic_perform_write
							->fuse_write_end
								->set_page_dirty
									->__set_page_dirty_nobuffers
	
	The reason for 'if (!TestSetPageDirty(page))' always true may be the 
pdflush process will call the function fuse_writepages, and it will 
clean the page's dirty sign in write_cache_pages, and call 
fuse_writepages_send to flush all pages to the disk of the host. So when 
the page is write the second time, it always not dirty.
	
	I want to know is there any problems in this write-back procedure.

Thanks,
Yan wang

