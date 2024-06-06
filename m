Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A552413A418
	for <virtio-fs@lists.linux.dev>; Thu,  6 Jun 2024 08:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717663148; cv=none; b=qbVIRqSBm6ZUeqOwZ+AmUrpHZIu3cK68ivrs2SkuJy9CWjPHICmB4qEL4wSy9b7sJoVyKB2FNkObapMJ6DJsICG9CxyuIgixnt/Qr5Wz6z6FQVI+Cl7AxaH1ozZBCXUn5+NcK43U/W9Zs74VwSfDLTAM0BeWJV44qHdxOcZk/jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717663148; c=relaxed/simple;
	bh=IfNjTpQj/5jUPl5M/IGOwb3Mt0RgpvWjMY5FJ09CoHA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=UXRIvX8tgU4lGJvok6GYiQXyVJROflAO024mQ0T1Lq5PvebBLGF9yIdKIAd76GED4AK5hDyeBuHVBfOtFzAx2ZOGB/6lJMMxIID1cEwSyj/3+WGgrM11au+4dt48/60dCMO/kgNvSU6jqQiKPzqmvHWnybLWwN9kbrmaqms+qDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WwUQjCEd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WwUQjCEd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717663145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=PrcPiljQdixba2DiD9EcpVBDB5M1HH767X6Mx2WSc60=;
	b=WwUQjCEd/9B6bjg3zbOlrDu8AmJc0/ByDYfCsEa2nAacHWopvQsSaKOQC20UG0YV/mdINF
	gzSu7Vu9O8MoHODMEzeQu9CsUM5SJtOyOzmAMcsOzUTzf4r+4SYen/wy1osA4ydMG69ynN
	T7y0Rw38pz7JdCovIuLlG12kFfEExpo=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-5nO0_KKINPuvo1doknsBXg-1; Thu, 06 Jun 2024 04:39:00 -0400
X-MC-Unique: 5nO0_KKINPuvo1doknsBXg-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2c23f2dcf46so620876a91.3
        for <virtio-fs@lists.linux.dev>; Thu, 06 Jun 2024 01:39:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717663138; x=1718267938;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PrcPiljQdixba2DiD9EcpVBDB5M1HH767X6Mx2WSc60=;
        b=LJsXkdCjBlz+7uBwGtKTuAQXpkoP7juJs6oI2rBbP9Y/2q7gd7dYcqTre+O0gqXo5Q
         wPqpI/FgKfKrYkSoFbHfiqJyNYMAP9yA3Gz1gK112zEJWQ09TZthMWRnnAjiBFCgHIGb
         1bkd8wWSWorX9rC3AcMRpthAN9eyP1JCcrpWi6Iq+QItA/pphErTGUpi42X3fkrmrMex
         MbbJEJ4+UX5Es2H0jsUiAFyTu5vX9tieIO6nagcg8ck1LJsvvCWAxUmmyQkbiVYLz4zi
         ecaa5uPZ0Cz9yMu8pFiqt3L+SSno22pQ0U6U8qJNQRNFL2QH9QEPa1xh6JMh6e0sXkhY
         UiMg==
X-Gm-Message-State: AOJu0Yy+zVeK/kpuWftUUohLpNNVWVOI7u/4NAT3EgDzO9GDyyIVvprF
	+vll/oA7CeQWLyUOcC4wLVClbVsZMZ+WmgzZX+Qmc6c0rEwktm85hxvsTBxYp3r4PND72gkDJrD
	8l2ZcG5N/kqDxflkuzW3MSMA1DcIcsdnaiafMSX4t20piScvaoZpl6d/7ci/NQcgQbZq+DdYdvn
	YTMcV9eekGKHiIemU2YX/OlpU4nHg5gJOxh/4IYJeQb2w=
X-Received: by 2002:a17:90b:4f8a:b0:2b2:6975:bf49 with SMTP id 98e67ed59e1d1-2c27dafd282mr4430925a91.6.1717663138114;
        Thu, 06 Jun 2024 01:38:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcnGvJpqYIdn54/SLj9cOyKIDdhl74zABXsbSA9bkex7RoYFcrlcgvHpaIPKsULE0QPvRQcYDnyQiIu12R3Ak=
X-Received: by 2002:a17:90b:4f8a:b0:2b2:6975:bf49 with SMTP id
 98e67ed59e1d1-2c27dafd282mr4430914a91.6.1717663137693; Thu, 06 Jun 2024
 01:38:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 6 Jun 2024 10:38:46 +0200
Message-ID: <CAOssrKeJbfjhZ1rkL=Tj+zQaYxQLQmwLYYT22Cu8nYnY8nriYA@mail.gmail.com>
Subject: kvm crash with virtiofs
To: virtio-fs@lists.linux.dev, QEMU Developers <qemu-devel@nongnu.org>
Cc: Eric Sandeen <sandeen@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Hi,

I get the below crash when running virtio-fs on fedora 39.

Note: weirdly this makes chrome running on the host also crash.

Eric Sandeen also reported some bad behavior of virtio-fs on fc39,
which might be related.

Versions:
kernel-6.8.4-200.fc39.x86_64
qemu-kvm-8.1.3-5.fc39.x86_64
virtiofsd-1.10.1-1.fc39.x86_64

Thanks,
Miklos

/usr/libexec/virtiofsd --socket-path=/tmp/vhostqemu --shared-dir /home &

qemu-system-x86_64 -enable-kvm -s -serial none -parallel none -kernel
/home/mszeredi/git/linux/arch/x86_64/boot/bzImage -drive
format=raw,file=/home/mszeredi/root_fs,index=0,if=virtio -drive
format=raw,file=/home/mszeredi/images/ubd1,index=1,if=virtio -chardev
stdio,id=virtiocon0,signal=off -device virtio-serial -device
virtconsole,chardev=virtiocon0 -cpu host -m 16G -smp 8 -object
memory-backend-file,id=mem,size=16G,mem-path=/dev/shm,share=on -numa
node,memdev=mem -net user -net nic,model=virtio-net-pci -fsdev
local,security_model=none,id=fsdev0,path=/home -device virtio-rng-pci
-chardev socket,id=char0,path=/tmp/vhostqemu -device
vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs -device
virtio-9p-pci,fsdev=fsdev0,mount_tag=hostshare -append "root=/dev/vda
console=hvc0 "
[...]
root@kvm:~# time md5sum /host/mszeredi/images/ubd1
error: kvm run failed Bad address
RAX=0000000000000000 RBX=ffff888100044240 RCX=0000000000000000
RDX=ffff888420c59ff0
RSI=0000000000000020 RDI=ffff888420c59ff8 RBP=0000000000000000
RSP=ffffc900016d3898
R8 =ffff888420c59da8 R9 =0000000000000040 R10=0000000000036140
R11=0000000000000005
R12=ffff888420c59ff0 R13=000000000000000d R14=ffffea0010831600
R15=ffff888420c59da8
RIP=ffffffff82168d80 RFL=00010046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 0000000000000000 ffffffff 00c00000
CS =0010 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
SS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0000 0000000000000000 ffffffff 00c00000
FS =0000 00007fb83cea8740 ffffffff 00c00000
GS =0000 ffff88842fd40000 ffffffff 00c00000
LDT=0000 0000000000000000 ffffffff 00c00000
TR =0040 fffffe000012a000 00004087 00008b00 DPL=0 TSS64-busy
GDT=     fffffe0000128000 0000007f
IDT=     fffffe0000000000 00000fff
CR0=80050033 CR2=00007f2d3bd9b0f0 CR3=00000001036ee005 CR4=00770ef0
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000d01
Code=90 90 90 90 48 c7 07 00 00 00 00 48 89 fa 48 8d 7f 08 31 c0 <48>
c7 87 30 02 00 00 00 00 00 00 48 89 d1 48 83 e7 f8 48 29 f9 81 c1 40
02 00 00 c1 e9 03

