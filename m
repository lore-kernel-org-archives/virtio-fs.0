DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=LW9iI821/xJSwupKP3hAvo89HaSGrW16JKe4cQxwZ58=;
	b=EMH6X4F3L2eJix0JQOcYkpLDi83y+T+ezp+PGrhuWT2gw9MMNUwFG/CHL0xkRunkX7ttyblw9+5tmm9+XcC2+RNC6c3kYGriWXGGQRP0wW3LEzJbmjUjwn4nl6zZ4LvSjwae7vXaiszBoPfPcwlkiSk4a9e1TryHCzxdA8NBZUM=
From: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Date: Thu, 7 Nov 2019 08:03:02 +0000
Message-ID: <OSBPR01MB3783BF39AA8A2C16CC94CDDEE5780@OSBPR01MB3783.jpnprd01.prod.outlook.com>
References: <7331fd60-10c6-6076-4cf5-f5cce7bc6ef1@jp.fujitsu.com>
	<20191106121348.GA5701@work-vm>
In-Reply-To: <20191106121348.GA5701@work-vm>
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
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
To: "'Dr. David Alan Gilbert'" <dgilbert@redhat.com>, "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>

> > Hello,
> >
> > We have run the generic tests of xfstest for virtio-fs[1] on
> > aarch64[2], here we selected some tests that did not run or failed to
> > run, and we categorized them, basing on the reasons in our understanding.
> 
> Hi,
>   Apologies for taking a while to respond.
> What I've done is to repeat these and create gitlab issues for each categroy that you defined.  Now we can go and look at these
> inidividually.

Hi,

Thanks for making gitlab issues. I have collected some clues so I will comment on each issue.

Misono

> 
> >   * Category 1: generic/003, generic/192
> >     Error: access time error
> >     Reason: file_accessed() not run
> 
> https://gitlab.com/virtio-fs/qemu/issues/8
> 
> >   * Category 2: generic/089, generic/478, generic/484, generic/504
> >     Error: lock error
> 
> https://gitlab.com/virtio-fs/qemu/issues/9
> 
> >   * Category 3: generic/426, generic/467, generic/477
> >     Error: open_by_handle error
> 
> https://gitlab.com/virtio-fs/qemu/issues/10
> 
> >   * Category 4: generic/551
> >     Error: kvm panic
> 
> This for me just caused an OOM; when I increased the guest size to 32G it was fine; can you retest?  I'm not sure how much RAM
> xfstests expects.
> 
> >   * Category 5: generic/011, generic/013
> >     Error: cannot remove file
> >     Reason: NFS backend
> 
> https://gitlab.com/virtio-fs/qemu/issues/11
> 
> >   * Category 6: generic/035
> >     Error: nlink is 1, should be 0
> 
> https://gitlab.com/virtio-fs/qemu/issues/12
> 
> >   * Category 7: generic/125, generic/193, generic/314
> >     Error: open/chown/mkdir permission error
> 
> There were OK for me after I'd created the users/groups that the xfstests manual asked for (fsgqa, and 123456-fsgqa) - can you
> confirm the error you saw.
> 
> >   * Category 8: generic/469
> >     Error: fallocate keep_size is needed
> 
> https://gitlab.com/virtio-fs/qemu/issues/13
> 
> >     Reason: NFS4.0 backend
> >   * Category 9: generic/323
> >     Error: system hang
> >     Reason: fd is close before AIO finished
> 
> https://gitlab.com/virtio-fs/qemu/issues/14
> 
> I reproduced all these on x86, so they're not aarch specific.
> 
> > We would like to know if virtio-fs does not support these tests in the
> > specification or they are bugs that need to be fixed.
> > It would be very appreciated if anyone could give some comments.
> 
> Now I've got them reproduced easily and also on x86, we'll dig into them and figure out what's going on.
> 
> Dave
> 
> > [1] qemu: https://gitlab.com/virtio-fs/qemu/tree/virtio-fs-dev
> >      start qemu script:
> >      $VIRTIOFSD -o vhost_user_socket=/tmp/vhostqemu1 -o
> > source=/root/virtio-fs/test1/ -o cache=always -o xattr -o flock -d &
> >      $VIRTIOFSD -o vhost_user_socket=/tmp/vhostqemu2 -o
> > source=/root/virtio-fs/test2/ -o cache=always -o xattr -o flock -d &
> >      $QEMU -M virt,accel=kvm,gic_version=3 \
> >          -cpu host \
> >          -smp 8 \
> >          -m 8192\
> >          -nographic \
> >          -serial mon:stdio \
> >          -netdev tap,id=net0 -device
> > virtio-net-pci,netdev=net0,id=net0,mac=XX:XX:XX:XX:XX:XX \
> >          -object
> > memory-backend-file,id=mem,size=8G,mem-path=/dev/shm,share=on \
> >          -numa node,memdev=mem \
> >          -drive
> > file=/root/virtio-fs/AAVMF/AAVMF_CODE.fd,if=pflash,format=raw,unit=0,r
> > eadonly=on
> > \
> >          -drive file=$VARS,if=pflash,format=raw,unit=1 \
> >          -chardev socket,id=char1,path=/tmp/vhostqemu1 \
> >          -device
> > vhost-user-fs-pci,queue-size=1024,chardev=char1,tag=myfs1,cache-size=0 \
> >          -chardev socket,id=char2,path=/tmp/vhostqemu2 \
> >          -device
> > vhost-user-fs-pci,queue-size=1024,chardev=char2,tag=myfs2,cache-size=0 \
> >          -drive if=virtio,file=/var/lib/libvirt/images/guest.img
> >
> > [2] host kernel: 4.18.0-80.4.2.el8_0.aarch64
> >      guest kernel: 5.4-rc1
> >      Arch: Arm64
> >      backend: NFS 4.0
> >
> > Thanks,
> > QI Fuli
> >
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


