From: piaojun <piaojun@huawei.com>
Message-ID: <5D4944CC.30100@huawei.com>
Date: Tue, 6 Aug 2019 17:13:48 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] [QUESTION] Can not enable dax option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hi,

Dax could not be enabled by run the following command:

QEMU command:
qemu-system-x86_64 -M pc -cpu host --enable-kvm -smp 2 \
-m 4G,maxmem=4G -object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on -numa node,memdev=mem \
-drive if=none,id=root,format=qcow2,file=centos_7.3_64.qcow2 -device virtio-scsi -device scsi-disk,drive=root,bootindex=1 -object iothread,id=io \
-device virtio-scsi-pci,iothread=io -net nic,model=virtio -vnc 0.0.0.0:0 \
-chardev socket,id=char0,path=/tmp/vhostqemu -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs,cache-size=2G

Guest command:
# mount -t virtio_fs myfs /mnt/virtiofs -o rootmode=040000,user_id=0,group_id=0,dax

When I rmmod/insmod again, the error message shows that something is
wrong with 'cache capability':

virtio_pci_find_shm_cap: shm cap with bad size offset: 164 size: 24
virtio_fs virtio2: virtio_fs_setup_dax: No cache capability


Code url:
https://github.com/rhvgoyal/linux/commits/virtio-fs-dev-5.1
https://gitlab.com/virtio-fs/qemu/tree/virtio-fs-dev

Thanks,
Jun

