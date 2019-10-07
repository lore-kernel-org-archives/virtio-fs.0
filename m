DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=msLm151viEAW1rKdRltoTuRrXLPmiyy6CwFLxrmv1Rw=;
	b=DBmHyh6mXP0lB8liPdhGXUC3t9zpAhfIdKIavwNmk+PGWaKRMXi5zlwHPMOMZSF8tzrMMPKwIJ3ZhbMbriG/y1JRJ7GbTIMVVGcSUzzLM3tguiiLmwlfs4DB6WITNoSZTpYefnu/cy0A2twhSkn06r9hP0ErAs4AS0q5JCGrBgk=
From: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
Date: Mon, 7 Oct 2019 12:11:57 +0000
Message-ID: <7331fd60-10c6-6076-4cf5-f5cce7bc6ef1@jp.fujitsu.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <A58DC08E78213D4B8A8A684FB7ACBBD7@jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs]  xfstest results for virtio-fs on aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "virtio-fs@redhat.com" <virtio-fs@redhat.com>
Cc: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>

Hello,

We have run the generic tests of xfstest for virtio-fs[1] on aarch64[2],
here we selected some tests that did not run or failed to run,
and we categorized them, basing on the reasons in our understanding.

  * Category 1: generic/003, generic/192
    Error: access time error
    Reason: file_accessed() not run
  * Category 2: generic/089, generic/478, generic/484, generic/504
    Error: lock error
  * Category 3: generic/426, generic/467, generic/477
    Error: open_by_handle error
  * Category 4: generic/551
    Error: kvm panic
  * Category 5: generic/011, generic/013
    Error: cannot remove file
    Reason: NFS backend
  * Category 6: generic/035
    Error: nlink is 1, should be 0
  * Category 7: generic/125, generic/193, generic/314
    Error: open/chown/mkdir permission error
  * Category 8: generic/469
    Error: fallocate keep_size is needed
    Reason: NFS4.0 backend
  * Category 9: generic/323
    Error: system hang
    Reason: fd is close before AIO finished

We would like to know if virtio-fs does not support these tests in
the specification or they are bugs that need to be fixed.
It would be very appreciated if anyone could give some comments.

[1] qemu: https://gitlab.com/virtio-fs/qemu/tree/virtio-fs-dev
     start qemu script:
     $VIRTIOFSD -o vhost_user_socket=/tmp/vhostqemu1 -o 
source=/root/virtio-fs/test1/ -o cache=always -o xattr -o flock -d &
     $VIRTIOFSD -o vhost_user_socket=/tmp/vhostqemu2 -o 
source=/root/virtio-fs/test2/ -o cache=always -o xattr -o flock -d &
     $QEMU -M virt,accel=kvm,gic_version=3 \
         -cpu host \
         -smp 8 \
         -m 8192\
         -nographic \
         -serial mon:stdio \
         -netdev tap,id=net0 -device 
virtio-net-pci,netdev=net0,id=net0,mac=XX:XX:XX:XX:XX:XX \
         -object 
memory-backend-file,id=mem,size=8G,mem-path=/dev/shm,share=on \
         -numa node,memdev=mem \
         -drive 
file=/root/virtio-fs/AAVMF/AAVMF_CODE.fd,if=pflash,format=raw,unit=0,readonly=on 
\
         -drive file=$VARS,if=pflash,format=raw,unit=1 \
         -chardev socket,id=char1,path=/tmp/vhostqemu1 \
         -device 
vhost-user-fs-pci,queue-size=1024,chardev=char1,tag=myfs1,cache-size=0 \
         -chardev socket,id=char2,path=/tmp/vhostqemu2 \
         -device 
vhost-user-fs-pci,queue-size=1024,chardev=char2,tag=myfs2,cache-size=0 \
         -drive if=virtio,file=/var/lib/libvirt/images/guest.img

[2] host kernel: 4.18.0-80.4.2.el8_0.aarch64
     guest kernel: 5.4-rc1
     Arch: Arm64
     backend: NFS 4.0

Thanks,
QI Fuli

