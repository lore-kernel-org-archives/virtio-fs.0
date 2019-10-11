Date: Fri, 11 Oct 2019 10:21:45 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20191011092145.GE3354@work-vm>
References: <7331fd60-10c6-6076-4cf5-f5cce7bc6ef1@jp.fujitsu.com>
	<20191007143444.GA174343@work-vm> <20191009165116.GJ2893@work-vm>
	<27035e4a-bd12-e5d8-30d0-0df45e75457c@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27035e4a-bd12-e5d8-30d0-0df45e75457c@jp.fujitsu.com>
Subject: Re: [Virtio-fs] xfstest results for virtio-fs on aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>

* qi.fuli@fujitsu.com (qi.fuli@fujitsu.com) wrote:
> Hi,
> 
> Thank you for your comments.
> 
> On 10/10/19 1:51 AM, Dr. David Alan Gilbert wrote:
> > * Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
> >> * qi.fuli@fujitsu.com (qi.fuli@fujitsu.com) wrote:
> >>> Hello,
> >>>
> >>
> >> Hi,
> > 
> > In addition to the other questions, I'd appreciate
> > if you could explain your xfstests setup and the way you told
> > it about the virtio mounts.
> 
> In order to run the tests on virtio-fs, I did the following changes in 
> xfstest[1].
> 
> diff --git a/check b/check

Thanks; it would be great if you could send these changes upstream
to xfstest;  I know there's at least one other person who has written
xfstest changes.

I'm hitting some problems getting it to run; it seems to be hitting
a reliable NFS kernel client OOPS on the fedora kernels I'm using
on the host on generic/013

I have repeated the access time error you're seeing for generic/003.

Dave

> The command to run xfstests for virtio-fs is:
> $ ./check -virtiofs generic/???
> 
> [1] https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> 
> > 
> > Dave
> > 
> >>
> >>> We have run the generic tests of xfstest for virtio-fs[1] on aarch64[2],
> >>> here we selected some tests that did not run or failed to run,
> >>> and we categorized them, basing on the reasons in our understanding.
> >>
> >> Thanks for sharing your test results.
> >>
> >>>    * Category 1: generic/003, generic/192
> >>>      Error: access time error
> >>>      Reason: file_accessed() not run
> >>>    * Category 2: generic/089, generic/478, generic/484, generic/504
> >>>      Error: lock error
> >>>    * Category 3: generic/426, generic/467, generic/477
> >>>      Error: open_by_handle error
> >>>    * Category 4: generic/551
> >>>      Error: kvm panic
> >>
> >> I'm not expecting a KVM panic; can you give us a copy of the
> >> oops/panic/backtrace you're seeing?
> 
> Sorry, In my recent tests, the KVM panic didn't happen, but the OOM 
> event occurred. I will expand the memory and test it again, please give 
> me a little more time.
> 
> >>
> >>>    * Category 5: generic/011, generic/013
> >>>      Error: cannot remove file
> >>>      Reason: NFS backend
> >>>    * Category 6: generic/035
> >>>      Error: nlink is 1, should be 0
> >>>    * Category 7: generic/125, generic/193, generic/314
> >>>      Error: open/chown/mkdir permission error
> >>>    * Category 8: generic/469
> >>>      Error: fallocate keep_size is needed
> >>>      Reason: NFS4.0 backend
> >>>    * Category 9: generic/323
> >>>      Error: system hang
> >>>      Reason: fd is close before AIO finished
> >>
> >> When you 'say system hang' - you mean the whole guest hanging?
> >> Did the virtiofsd process hang or crash?
> 
> No, not the whole guest, only the test process hanging. The virtiofsd 
> process keeps working. Here are some debug messages:
> 
> [ 7740.126845] INFO: task aio-last-ref-he:3361 blocked for more than 122 
> seconds.
> [ 7740.128884]       Not tainted 5.4.0-rc1-aarch64-5.4-rc1 #1
> [ 7740.130364] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [ 7740.132472] aio-last-ref-he D    0  3361   3143 0x00000220
> [ 7740.133954] Call trace:
> [ 7740.134627]  __switch_to+0x98/0x1e0
> [ 7740.135579]  __schedule+0x29c/0x688
> [ 7740.136527]  schedule+0x38/0xb8
> [ 7740.137615]  schedule_timeout+0x258/0x358
> [ 7740.139160]  wait_for_completion+0x174/0x400
> [ 7740.140322]  exit_aio+0x118/0x6c0
> [ 7740.141226]  mmput+0x6c/0x1c0
> [ 7740.142036]  do_exit+0x29c/0xa58
> [ 7740.142915]  do_group_exit+0x48/0xb0
> [ 7740.143888]  get_signal+0x168/0x8b0
> [ 7740.144836]  do_notify_resume+0x174/0x3d8
> [ 7740.145925]  work_pending+0x8/0x10
> [ 7863.006847] INFO: task aio-last-ref-he:3361 blocked for more than 245 
> seconds.
> [ 7863.008876]       Not tainted 5.4.0-rc1-aarch64-5.4-rc1 #1
> 
> Thanks,
> QI Fuli
> 
> >>>
> >>> We would like to know if virtio-fs does not support these tests in
> >>> the specification or they are bugs that need to be fixed.
> >>> It would be very appreciated if anyone could give some comments.
> >>
> >> It'll take us a few days to go through and figure that out; we'll
> >> try and replicate it.
> >>
> >> Dave
> >>
> >>>
> >>> [1] qemu: https://gitlab.com/virtio-fs/qemu/tree/virtio-fs-dev
> >>>       start qemu script:
> >>>       $VIRTIOFSD -o vhost_user_socket=/tmp/vhostqemu1 -o
> >>> source=/root/virtio-fs/test1/ -o cache=always -o xattr -o flock -d &
> >>>       $VIRTIOFSD -o vhost_user_socket=/tmp/vhostqemu2 -o
> >>> source=/root/virtio-fs/test2/ -o cache=always -o xattr -o flock -d &
> >>>       $QEMU -M virt,accel=kvm,gic_version=3 \
> >>>           -cpu host \
> >>>           -smp 8 \
> >>>           -m 8192\
> >>>           -nographic \
> >>>           -serial mon:stdio \
> >>>           -netdev tap,id=net0 -device
> >>> virtio-net-pci,netdev=net0,id=net0,mac=XX:XX:XX:XX:XX:XX \
> >>>           -object
> >>> memory-backend-file,id=mem,size=8G,mem-path=/dev/shm,share=on \
> >>>           -numa node,memdev=mem \
> >>>           -drive
> >>> file=/root/virtio-fs/AAVMF/AAVMF_CODE.fd,if=pflash,format=raw,unit=0,readonly=on
> >>> \
> >>>           -drive file=$VARS,if=pflash,format=raw,unit=1 \
> >>>           -chardev socket,id=char1,path=/tmp/vhostqemu1 \
> >>>           -device
> >>> vhost-user-fs-pci,queue-size=1024,chardev=char1,tag=myfs1,cache-size=0 \
> >>>           -chardev socket,id=char2,path=/tmp/vhostqemu2 \
> >>>           -device
> >>> vhost-user-fs-pci,queue-size=1024,chardev=char2,tag=myfs2,cache-size=0 \
> >>>           -drive if=virtio,file=/var/lib/libvirt/images/guest.img
> >>>
> >>> [2] host kernel: 4.18.0-80.4.2.el8_0.aarch64
> >>>       guest kernel: 5.4-rc1
> >>>       Arch: Arm64
> >>>       backend: NFS 4.0
> >>>
> >>> Thanks,
> >>> QI Fuli
> >>>
> >>> _______________________________________________
> >>> Virtio-fs mailing list
> >>> Virtio-fs@redhat.com
> >>> https://www.redhat.com/mailman/listinfo/virtio-fs
> >> --
> >> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> >>
> >> _______________________________________________
> >> Virtio-fs mailing list
> >> Virtio-fs@redhat.com
> >> https://www.redhat.com/mailman/listinfo/virtio-fs
> > --
> > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> > 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

