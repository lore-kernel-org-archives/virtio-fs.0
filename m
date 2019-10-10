DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=bNU5LGhRQJyG5CKkZyvupSxxHeGwkkoY7P8cuMIJ1XA=;
	b=k6LwQkRC1DuPr20jWn2rZ5KQd/A6ezMaKSg5OUCaeIjLY+p4W/pVwTD+VUVocDwqx+UpsPZYGKUqrZFcXzfgnYyfA8/x92L83gh26MshOlfc/Pr4qpMXKgQt1GABKAsLKiHGCA0AIuCEGiGEPr3m7pz/gr9yfneb0p7+3kwUjL8=
From: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
Date: Thu, 10 Oct 2019 09:57:59 +0000
Message-ID: <27035e4a-bd12-e5d8-30d0-0df45e75457c@jp.fujitsu.com>
References: <7331fd60-10c6-6076-4cf5-f5cce7bc6ef1@jp.fujitsu.com>
	<20191007143444.GA174343@work-vm> <20191009165116.GJ2893@work-vm>
In-Reply-To: <20191009165116.GJ2893@work-vm>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <02909021C2641D439BC57E3C7290964F@jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] xfstest results for virtio-fs on aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>

Hi,

Thank you for your comments.

On 10/10/19 1:51 AM, Dr. David Alan Gilbert wrote:
> * Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
>> * qi.fuli@fujitsu.com (qi.fuli@fujitsu.com) wrote:
>>> Hello,
>>>
>>
>> Hi,
> 
> In addition to the other questions, I'd appreciate
> if you could explain your xfstests setup and the way you told
> it about the virtio mounts.

In order to run the tests on virtio-fs, I did the following changes in 
xfstest[1].

diff --git a/check b/check
index c7f1dc5e..2e148e57 100755
--- a/check
+++ b/check
@@ -56,6 +56,7 @@ check options
      -glusterfs         test GlusterFS
      -cifs              test CIFS
      -9p                        test 9p
+    -virtiofs          test virtiofs
      -overlay           test overlay
      -pvfs2             test PVFS2
      -tmpfs             test TMPFS
@@ -268,6 +269,7 @@ while [ $# -gt 0 ]; do
         -glusterfs)     FSTYP=glusterfs ;;
         -cifs)          FSTYP=cifs ;;
         -9p)            FSTYP=9p ;;
+       -virtiofs)      FSTYP=virtiofs ;;
         -overlay)       FSTYP=overlay; export OVERLAY=true ;;
         -pvfs2)         FSTYP=pvfs2 ;;
         -tmpfs)         FSTYP=tmpfs ;;
diff --git a/common/config b/common/config
index 4eda36c7..551fed33 100644
--- a/common/config
+++ b/common/config
@@ -478,7 +478,7 @@ _check_device()
         fi

         case "$FSTYP" in
-       9p|tmpfs)
+       9p|tmpfs|virtiofs)
                 # 9p mount tags are just plain strings, so anything is 
allowed
                 # tmpfs doesn't use mount source, ignore
                 ;;
diff --git a/common/rc b/common/rc
index cfaabf10..3d5c8b23 100644
--- a/common/rc
+++ b/common/rc
@@ -603,6 +603,9 @@ _test_mkfs()
      9p)
         # do nothing for 9p
         ;;
+    virtiofs)
+       # do nothing for virtiofs
+       ;;
      ceph)
         # do nothing for ceph
         ;;
@@ -640,6 +643,9 @@ _mkfs_dev()
      9p)
         # do nothing for 9p
         ;;
+    virtiofs)
+       # do nothing for virtiofs
+       ;;
      overlay)
         # do nothing for overlay
         ;;
@@ -704,7 +710,7 @@ _scratch_mkfs()
         local mkfs_status

         case $FSTYP in
-       nfs*|cifs|ceph|overlay|glusterfs|pvfs2|9p)
+       nfs*|cifs|ceph|overlay|glusterfs|pvfs2|9p|virtiofs)
                 # unable to re-create this fstyp, just remove all files in
                 # $SCRATCH_MNT to avoid EEXIST caused by the leftover files
                 # created in previous runs
@@ -1467,7 +1473,7 @@ _require_scratch_nocheck()
                         _notrun "this test requires a valid \$SCRATCH_MNT"
                 fi
                 ;;
-       9p)
+       9p|virtiofs)
                 if [ -z "$SCRATCH_DEV" ]; then
                         _notrun "this test requires a valid \$SCRATCH_DEV"
                 fi
@@ -1591,7 +1597,7 @@ _require_test()
                         _notrun "this test requires a valid \$TEST_DIR"
                 fi
                 ;;
-       9p)
+       9p|virtiofs)
                 if [ -z "$TEST_DEV" ]; then
                         _notrun "this test requires a valid \$TEST_DEV"
                 fi
@@ -2686,6 +2692,9 @@ _check_test_fs()
      9p)
         # no way to check consistency for 9p
         ;;
+    virtiofs)
+       # no way to check consistency for virtiofs
+       ;;
      ceph)
         # no way to check consistency for CephFS
         ;;
@@ -2744,6 +2753,9 @@ _check_scratch_fs()
      9p)
         # no way to check consistency for 9p
         ;;
+    virtiofs)
+       # no way to check consistency for virtiofs
+       ;;
      ceph)
         # no way to check consistency for CephFS
         ;;

And my local.config is:

# cat ../xfstest-dev/local.config
export TEST_DEV=myfs1
export TEST_DIR=/test1
export SCRATCH_DEV=myfs2
export SCRATCH_MNT=/test2
export MOUNT_OPTIONS=""
export TEST_FS_MOUNT_OPTS=""

The command to run xfstests for virtio-fs is:
$ ./check -virtiofs generic/???

[1] https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git

> 
> Dave
> 
>>
>>> We have run the generic tests of xfstest for virtio-fs[1] on aarch64[2],
>>> here we selected some tests that did not run or failed to run,
>>> and we categorized them, basing on the reasons in our understanding.
>>
>> Thanks for sharing your test results.
>>
>>>    * Category 1: generic/003, generic/192
>>>      Error: access time error
>>>      Reason: file_accessed() not run
>>>    * Category 2: generic/089, generic/478, generic/484, generic/504
>>>      Error: lock error
>>>    * Category 3: generic/426, generic/467, generic/477
>>>      Error: open_by_handle error
>>>    * Category 4: generic/551
>>>      Error: kvm panic
>>
>> I'm not expecting a KVM panic; can you give us a copy of the
>> oops/panic/backtrace you're seeing?

Sorry, In my recent tests, the KVM panic didn't happen, but the OOM 
event occurred. I will expand the memory and test it again, please give 
me a little more time.

>>
>>>    * Category 5: generic/011, generic/013
>>>      Error: cannot remove file
>>>      Reason: NFS backend
>>>    * Category 6: generic/035
>>>      Error: nlink is 1, should be 0
>>>    * Category 7: generic/125, generic/193, generic/314
>>>      Error: open/chown/mkdir permission error
>>>    * Category 8: generic/469
>>>      Error: fallocate keep_size is needed
>>>      Reason: NFS4.0 backend
>>>    * Category 9: generic/323
>>>      Error: system hang
>>>      Reason: fd is close before AIO finished
>>
>> When you 'say system hang' - you mean the whole guest hanging?
>> Did the virtiofsd process hang or crash?

No, not the whole guest, only the test process hanging. The virtiofsd 
process keeps working. Here are some debug messages:

[ 7740.126845] INFO: task aio-last-ref-he:3361 blocked for more than 122 
seconds.
[ 7740.128884]       Not tainted 5.4.0-rc1-aarch64-5.4-rc1 #1
[ 7740.130364] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 7740.132472] aio-last-ref-he D    0  3361   3143 0x00000220
[ 7740.133954] Call trace:
[ 7740.134627]  __switch_to+0x98/0x1e0
[ 7740.135579]  __schedule+0x29c/0x688
[ 7740.136527]  schedule+0x38/0xb8
[ 7740.137615]  schedule_timeout+0x258/0x358
[ 7740.139160]  wait_for_completion+0x174/0x400
[ 7740.140322]  exit_aio+0x118/0x6c0
[ 7740.141226]  mmput+0x6c/0x1c0
[ 7740.142036]  do_exit+0x29c/0xa58
[ 7740.142915]  do_group_exit+0x48/0xb0
[ 7740.143888]  get_signal+0x168/0x8b0
[ 7740.144836]  do_notify_resume+0x174/0x3d8
[ 7740.145925]  work_pending+0x8/0x10
[ 7863.006847] INFO: task aio-last-ref-he:3361 blocked for more than 245 
seconds.
[ 7863.008876]       Not tainted 5.4.0-rc1-aarch64-5.4-rc1 #1

Thanks,
QI Fuli

>>>
>>> We would like to know if virtio-fs does not support these tests in
>>> the specification or they are bugs that need to be fixed.
>>> It would be very appreciated if anyone could give some comments.
>>
>> It'll take us a few days to go through and figure that out; we'll
>> try and replicate it.
>>
>> Dave
>>
>>>
>>> [1] qemu: https://gitlab.com/virtio-fs/qemu/tree/virtio-fs-dev
>>>       start qemu script:
>>>       $VIRTIOFSD -o vhost_user_socket=/tmp/vhostqemu1 -o
>>> source=/root/virtio-fs/test1/ -o cache=always -o xattr -o flock -d &
>>>       $VIRTIOFSD -o vhost_user_socket=/tmp/vhostqemu2 -o
>>> source=/root/virtio-fs/test2/ -o cache=always -o xattr -o flock -d &
>>>       $QEMU -M virt,accel=kvm,gic_version=3 \
>>>           -cpu host \
>>>           -smp 8 \
>>>           -m 8192\
>>>           -nographic \
>>>           -serial mon:stdio \
>>>           -netdev tap,id=net0 -device
>>> virtio-net-pci,netdev=net0,id=net0,mac=XX:XX:XX:XX:XX:XX \
>>>           -object
>>> memory-backend-file,id=mem,size=8G,mem-path=/dev/shm,share=on \
>>>           -numa node,memdev=mem \
>>>           -drive
>>> file=/root/virtio-fs/AAVMF/AAVMF_CODE.fd,if=pflash,format=raw,unit=0,readonly=on
>>> \
>>>           -drive file=$VARS,if=pflash,format=raw,unit=1 \
>>>           -chardev socket,id=char1,path=/tmp/vhostqemu1 \
>>>           -device
>>> vhost-user-fs-pci,queue-size=1024,chardev=char1,tag=myfs1,cache-size=0 \
>>>           -chardev socket,id=char2,path=/tmp/vhostqemu2 \
>>>           -device
>>> vhost-user-fs-pci,queue-size=1024,chardev=char2,tag=myfs2,cache-size=0 \
>>>           -drive if=virtio,file=/var/lib/libvirt/images/guest.img
>>>
>>> [2] host kernel: 4.18.0-80.4.2.el8_0.aarch64
>>>       guest kernel: 5.4-rc1
>>>       Arch: Arm64
>>>       backend: NFS 4.0
>>>
>>> Thanks,
>>> QI Fuli
>>>
>>> _______________________________________________
>>> Virtio-fs mailing list
>>> Virtio-fs@redhat.com
>>> https://www.redhat.com/mailman/listinfo/virtio-fs
>> --
>> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>>
>> _______________________________________________
>> Virtio-fs mailing list
>> Virtio-fs@redhat.com
>> https://www.redhat.com/mailman/listinfo/virtio-fs
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 

