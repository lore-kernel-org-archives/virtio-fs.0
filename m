Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC7A19751A
	for <virtio-fs@lists.linux.dev>; Thu,  6 Jun 2024 14:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717685804; cv=none; b=K9afDQ4jtU85H/06H/KweOXdVijj/5gB6Uk8pkt73OomRkfaLYWFSwc9/wF74JgCdSyhj1XytZY1oWMS++Yx053wRU4iZ2FXGQKiKAwmviN6x1d1Gw1tQfciN6xqU93fnAtSLK6azdSqsGAgwDHIFZLPo56erGeT3zhVVvSd76A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717685804; c=relaxed/simple;
	bh=vFPgljQQM6SSBJaQjwbwYkrmGlFLJ6smWTKIatSvAE0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iKlVShzZcfCiOkaWJ8aKxPmokZ/WMx6faYhqdQKFSwbFc95+wlZh9iUPMfHsdYBS4g20rAYt1UQCEjcKz4+Tcs7OgXNifpOBISOiZ0O3k/WbgrBnDA4IF3p1+hUewWCaTF0YoeqwDQgp3pjujIH7EPTYK8fT1a6pasiNFamdVNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UkrvrLau; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UkrvrLau"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717685802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5fzUt+S5hDlo86Yu90rcSQisSsmUqsfIZO8Gph++Q8I=;
	b=UkrvrLauOarja3fdh+hHGoUP4ob+W4dfDTkh0TFqbtfkMXoKVeOnCBfDs3tJSmfR/MvTFv
	lypf7b8//RddzmW464ZJAgxg8F2B+HHkuUIN+c4O5Uq/7nCl1d6kKjTv9W2MUkcREaJ3tu
	Hsp1/kg4DS4gn9EEM+effQMShu8s/Rg=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-wdEQ3oU3MQ2UjOIUAwIb7g-1; Thu, 06 Jun 2024 10:56:40 -0400
X-MC-Unique: wdEQ3oU3MQ2UjOIUAwIb7g-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2ead987e12fso672511fa.1
        for <virtio-fs@lists.linux.dev>; Thu, 06 Jun 2024 07:56:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717685799; x=1718290599;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5fzUt+S5hDlo86Yu90rcSQisSsmUqsfIZO8Gph++Q8I=;
        b=ssa1i7QpKlPCbJdOV2mi+NaVTIP8s47vTev9Fn5+44qlgFVffh4cUSR4YEbOFu/Qq0
         65SG3fFYKAk7O7Ony5Y8ssfGP6oTBjypiLkv5p7dwxuEg+nr9FXajCNWaCDUqW6iGOMN
         9iJiSxdPBIN5BW9qkgBDpdKst/6NOMXAhkmdh7IAZamzehiBKlYRchlQEx4HvLHOlPe9
         ajqjl5MsOAmRisDA3fUGwt4JeHJyYGc/UvQ0pXIckZyjILq9/nTB0r/Ubo7FqQUTb/Tw
         YJmHNKkKYtY2hFo84BcI3HJnsYHgJdIvGGtcfV93hoE7YBqrpQ0kGxwnkB+4dov5jPVK
         808Q==
X-Gm-Message-State: AOJu0Yz+zUARxFPvKMUvKAm9AFqynXgobNtjwLna9pP7on0hWrnkklvr
	gFirv9ThwV50msn5IeUMxziqMUZhFUI8atCiNNpZItovXcNe9aNz1OHz78VB8PbgrT8bbN0+6N4
	ALOS//VcvahFjWZ9J3LtE+13TF2GuhhxT23cYXzCakUqj9skgQVOkRW70+v9AWXwbzFD6dYWim7
	m480Q3tdXbpkrNOzm+tT4sTKBLPPjmaVbv
X-Received: by 2002:a05:6512:6d1:b0:528:21dc:5364 with SMTP id 2adb3069b0e04-52bab4ca10amr373702e87.1.1717685798824;
        Thu, 06 Jun 2024 07:56:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOm2YLwZIoufD5PEQ7Xe5V5www38khB6TuAE/tOUZ/LEKwaiISIhDa6f7CU28eeWx4BqOXWoS67PXzorIlFJc=
X-Received: by 2002:a05:6512:6d1:b0:528:21dc:5364 with SMTP id
 2adb3069b0e04-52bab4ca10amr373674e87.1.1717685798370; Thu, 06 Jun 2024
 07:56:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAOssrKeJbfjhZ1rkL=Tj+zQaYxQLQmwLYYT22Cu8nYnY8nriYA@mail.gmail.com>
In-Reply-To: <CAOssrKeJbfjhZ1rkL=Tj+zQaYxQLQmwLYYT22Cu8nYnY8nriYA@mail.gmail.com>
From: German Maglione <gmaglione@redhat.com>
Date: Thu, 6 Jun 2024 16:56:01 +0200
Message-ID: <CAJh=p+6cieh6XUzuf_be4zu+t01WETdLbP-9p2gonVyTRWx22Q@mail.gmail.com>
Subject: Re: kvm crash with virtiofs
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs@lists.linux.dev, QEMU Developers <qemu-devel@nongnu.org>, 
	Eric Sandeen <sandeen@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 6, 2024 at 10:40=E2=80=AFAM Miklos Szeredi <mszeredi@redhat.com=
> wrote:
>
> Hi,
>
> I get the below crash when running virtio-fs on fedora 39.
>
> Note: weirdly this makes chrome running on the host also crash.
>
> Eric Sandeen also reported some bad behavior of virtio-fs on fc39,
> which might be related.
>
> Versions:
> kernel-6.8.4-200.fc39.x86_64
> qemu-kvm-8.1.3-5.fc39.x86_64
> virtiofsd-1.10.1-1.fc39.x86_64
>
> Thanks,
> Miklos
>
> /usr/libexec/virtiofsd --socket-path=3D/tmp/vhostqemu --shared-dir /home =
&
>
> qemu-system-x86_64 -enable-kvm -s -serial none -parallel none -kernel
> /home/mszeredi/git/linux/arch/x86_64/boot/bzImage -drive
> format=3Draw,file=3D/home/mszeredi/root_fs,index=3D0,if=3Dvirtio -drive
> format=3Draw,file=3D/home/mszeredi/images/ubd1,index=3D1,if=3Dvirtio -cha=
rdev
> stdio,id=3Dvirtiocon0,signal=3Doff -device virtio-serial -device
> virtconsole,chardev=3Dvirtiocon0 -cpu host -m 16G -smp 8 -object
> memory-backend-file,id=3Dmem,size=3D16G,mem-path=3D/dev/shm,share=3Don -n=
uma
> node,memdev=3Dmem -net user -net nic,model=3Dvirtio-net-pci -fsdev
> local,security_model=3Dnone,id=3Dfsdev0,path=3D/home -device virtio-rng-p=
ci
> -chardev socket,id=3Dchar0,path=3D/tmp/vhostqemu -device
> vhost-user-fs-pci,queue-size=3D1024,chardev=3Dchar0,tag=3Dmyfs -device
> virtio-9p-pci,fsdev=3Dfsdev0,mount_tag=3Dhostshare -append "root=3D/dev/v=
da
> console=3Dhvc0 "

are you running virtiofsd inside a container?, could you try

-object memory-backend-memfd,id=3Dmem,size=3D16G,share=3Don

instead of "-object memory-backend-file..."

> [...]
> root@kvm:~# time md5sum /host/mszeredi/images/ubd1
> error: kvm run failed Bad address
> RAX=3D0000000000000000 RBX=3Dffff888100044240 RCX=3D0000000000000000
> RDX=3Dffff888420c59ff0
> RSI=3D0000000000000020 RDI=3Dffff888420c59ff8 RBP=3D0000000000000000
> RSP=3Dffffc900016d3898
> R8 =3Dffff888420c59da8 R9 =3D0000000000000040 R10=3D0000000000036140
> R11=3D0000000000000005
> R12=3Dffff888420c59ff0 R13=3D000000000000000d R14=3Dffffea0010831600
> R15=3Dffff888420c59da8
> RIP=3Dffffffff82168d80 RFL=3D00010046 [---Z-P-] CPL=3D0 II=3D0 A20=3D1 SM=
M=3D0 HLT=3D0
> ES =3D0000 0000000000000000 ffffffff 00c00000
> CS =3D0010 0000000000000000 ffffffff 00a09b00 DPL=3D0 CS64 [-RA]
> SS =3D0018 0000000000000000 ffffffff 00c09300 DPL=3D0 DS   [-WA]
> DS =3D0000 0000000000000000 ffffffff 00c00000
> FS =3D0000 00007fb83cea8740 ffffffff 00c00000
> GS =3D0000 ffff88842fd40000 ffffffff 00c00000
> LDT=3D0000 0000000000000000 ffffffff 00c00000
> TR =3D0040 fffffe000012a000 00004087 00008b00 DPL=3D0 TSS64-busy
> GDT=3D     fffffe0000128000 0000007f
> IDT=3D     fffffe0000000000 00000fff
> CR0=3D80050033 CR2=3D00007f2d3bd9b0f0 CR3=3D00000001036ee005 CR4=3D00770e=
f0
> DR0=3D0000000000000000 DR1=3D0000000000000000 DR2=3D0000000000000000
> DR3=3D0000000000000000
> DR6=3D00000000ffff0ff0 DR7=3D0000000000000400
> EFER=3D0000000000000d01
> Code=3D90 90 90 90 48 c7 07 00 00 00 00 48 89 fa 48 8d 7f 08 31 c0 <48>
> c7 87 30 02 00 00 00 00 00 00 48 89 d1 48 83 e7 f8 48 29 f9 81 c1 40
> 02 00 00 c1 e9 03
>
>


--=20
German

