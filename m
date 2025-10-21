Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05D4239085
	for <virtio-fs@lists.linux.dev>; Tue, 21 Oct 2025 13:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761055130; cv=none; b=QuuWjPTAmS0N5ez+HS9P+7OhotYcscInghhHUB/UYTXLnpW2YT26P/PBfW2GieE1pSnyjPD/f4SL9ehLUqydt14q0IFKlccVpSakqBk3zKaqDiwurYjVztDiiW05VamAvcCJUn9DPFW7ntxydJBl5flO55PaA3YIAuURJUU9ciY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761055130; c=relaxed/simple;
	bh=a9xo5iRU2UaVqUYhP+NOFPTLpT/CvAzz5jgCqB0Tc9s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fx15Kp8hQNlKlp3rpIAbeTKoH9HDcHyV/a4qb6E22h7ogcPwi3seZIYPz7FVw+sBtRycrNvOkRQlst/FDHDOQ7yNqOeBFeU+yF6Zq6doNR1M+3fC7d69L9wEogv4ujiAPIag/pWVbaVFt9XBmWPc/r1KLc1MKY6nq0RbcPJDcFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SPqLRXDT; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SPqLRXDT"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-816ac9f9507so918700685a.1
        for <virtio-fs@lists.linux.dev>; Tue, 21 Oct 2025 06:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761055127; x=1761659927; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a9xo5iRU2UaVqUYhP+NOFPTLpT/CvAzz5jgCqB0Tc9s=;
        b=SPqLRXDTz3Q+m8SDj6a9+Eg7Y59+aevD8CPqRAEfhtAO05huleeX+MH5K7PdsSb6Kb
         XPwAV02wv/En2qcvq4ZuvUrpmXngifbe67w/3Pt4IaZCDpi0XBkgGWXg7UPboyiU+zML
         NS3ofswtc77+cwh4J4Rwg/nYB9zIzCPiedpzcU6zjAJ9NGAWbFaUXGg+Hd5IsSz2H7er
         kpFjAWsW5W8fLVk+xeqBeZNOsQVqDQNpgXYxXj8wIlqjd/jLdstFs1mhg16V96Jh17Oc
         f+QIuFcRycQfNeTqFAe6n9gTbKHsQylL6O7ozs1VrZfx1ly8HXxMaagxdS7da30jPAwX
         +0lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761055127; x=1761659927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a9xo5iRU2UaVqUYhP+NOFPTLpT/CvAzz5jgCqB0Tc9s=;
        b=LaurE/IU/Rv8oBvQzZscrc/mpPRl+v9ds00wzbKz2GJUajACOhR9rPK8+oBUaPS6QU
         OS3BWum6uw/HxcOhG7+GSkbku7zoonxfTF/ygknzcFEnPc2uuHzjRlEMnmgrYkHenY7N
         I6TDomfrvJ9VPBnogYMVNAhh4ENbpBuUDrF5MYb01TqtJy/kXjEYnDrh/ue4g3mtr3Qf
         wKfY+m7d+tgoewSAxjiFab+kqwaNJyhTTKVDaJ3EUvqOdcopbfzNO6ANXRrEXI2uz8Na
         bM8yHvCHz6XKqCw/GHZFrlwoL64PifWH5QdoN/bEfmm6XrdQlvkoiESOCqwm6JZ+nCjN
         DhOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcMjqwIgU2072vbdf7PIIVPVnl7+xeCUB+2WfNmHCPlDjpvYigk5J/bPW3+DyM7/HJPiNjVD2BvKY=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywgq//MmjoKSoYjmbqgs8D7mb+N0JNY5Rn/kAjUGCfH7dQfXTFI
	gwNhjyxbopIpK3wMLJ3uk1xm4svN7wxoDDqhiX633duHWW7Efx+0YqXGhUrkh0KZ3aoG9lRb4j1
	iGiYpkYn0q8hbI7vqnVYux+wP2Hr5e5k=
X-Gm-Gg: ASbGncuI8KTN7T2qQAIswX6N70XXRRAKPF/nwL0fyoJ0C4eDwsgYGiKI1iEC1uvtljm
	ljnkJK+7vq4p9M0qsrj1LieEEXRDluCCeSvtASbkCe16MQD6EbEkYTQekrO0fAHk0jStBNpcDNX
	fRzbz1nz6NMaBG/pQsmD2j0GUTZg3/L6gPG3z9namiSUfrWdlINFJetJoJFfeb2m9lwHVrMbaRw
	I1SGSXxG58OPNBXuleTAO1zjNz3uweb1b5ovJIypYmTjnmA3f2jLzpHwYma7TmxssqK3QkRBTu/
	nnJZmVylG0nrIZqFW8XxmWG/ijY=
X-Google-Smtp-Source: AGHT+IEASm5PEMuHtKd5e+Rzj4N98EYCKZGb9xbtNELXIkGVXPi9KMyBQu4pgO6iWCx6Ob5On+OEkhJoPBQQfEnXOkg=
X-Received: by 2002:ac8:6692:0:b0:4e8:9151:b743 with SMTP id
 d75a77b69052e-4e89151baaemr171529791cf.10.1761055127377; Tue, 21 Oct 2025
 06:58:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251021122533.721467-1-marcandre.lureau@redhat.com>
 <CAFEAcA-jPE_onLYLMxgcAOB7dWRXOLJrWcGPnR0NUdjYytPDVA@mail.gmail.com> <aPePcTKl6s4FoLCL@gallifrey>
In-Reply-To: <aPePcTKl6s4FoLCL@gallifrey>
From: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@gmail.com>
Date: Tue, 21 Oct 2025 17:58:34 +0400
X-Gm-Features: AS18NWDhwyu6RSAqqb6h7ri3_0htqQRas44BMuTIvGK_fnZ9NOk0aSqeN68Q1lo
Message-ID: <CAJ+F1C+bGKtY6nf3LCXrwhZ2aEdu2npXJ9FapmsqgX0uLL5TUw@mail.gmail.com>
Subject: Re: [PATCH] char: rename CharBackend->CharFrontend
To: "Dr. David Alan Gilbert" <dave@treblig.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org, pbonzini@redhat.com, 
	"Michael S. Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	"Gonglei (Arei)" <arei.gonglei@huawei.com>, Zhenwei Pi <pizhenwei@bytedance.com>, 
	Laurent Vivier <lvivier@redhat.com>, Amit Shah <amit@kernel.org>, 
	Stefan Berger <stefanb@linux.vnet.ibm.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Igor Mitsyanko <i.mitsyanko@gmail.com>, =?UTF-8?Q?Cl=C3=A9ment_Chigot?= <chigot@adacore.com>, 
	Frederic Konrad <konrad.frederic@yahoo.fr>, Alberto Garcia <berto@igalia.com>, 
	Thomas Huth <huth@tuxfamily.org>, Halil Pasic <pasic@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>, 
	Yoshinori Sato <yoshinori.sato@nifty.com>, Magnus Damm <magnus.damm@gmail.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Harsh Prateek Bora <harshpb@linux.ibm.com>, 
	"Collin L. Walling" <walling@linux.ibm.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>, 
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>, Alistair Francis <alistair@alistair23.me>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Corey Minyard <minyard@acm.org>, 
	Paul Burton <paulburton@kernel.org>, Aleksandar Rikalo <arikalo@gmail.com>, 
	Aurelien Jarno <aurelien@aurel32.net>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Weiwei Li <liwei1518@gmail.com>, Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, 
	Samuel Thibault <samuel.thibault@ens-lyon.org>, Michael Rolnik <mrolnik@gmail.com>, 
	Antony Pavlov <antonynpavlov@gmail.com>, Joel Stanley <joel@jms.id.au>, 
	Vijai Kumar K <vijai@behindbytes.com>, Samuel Tardieu <sam@rfc1149.net>, 
	Gustavo Romero <gustavo.romero@linaro.org>, Raphael Norwitz <raphael@enfabrica.net>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "reviewer:vhost-user-scmi" <mzamazal@redhat.com>, 
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, Fabiano Rosas <farosas@suse.de>, 
	Markus Armbruster <armbru@redhat.com>, Zhang Chen <zhangckid@gmail.com>, 
	Li Zhijian <lizhijian@fujitsu.com>, Jason Wang <jasowang@redhat.com>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, 
	Richard Henderson <richard.henderson@linaro.org>, Helge Deller <deller@gmx.de>, 
	Max Filippov <jcmvbkbc@gmail.com>, Lukas Straub <lukasstraub2@web.de>, 
	"open list:Sharp SL-5500 Co..." <qemu-arm@nongnu.org>, 
	"open list:S390 SCLP-backed..." <qemu-s390x@nongnu.org>, "open list:sPAPR (pseries)" <qemu-ppc@nongnu.org>, 
	"open list:X86 Xen CPUs" <xen-devel@lists.xenproject.org>, 
	"open list:RISC-V TCG CPUs" <qemu-riscv@nongnu.org>, "open list:virtiofs" <virtio-fs@lists.linux.dev>, 
	"open list:Rust-related patc..." <qemu-rust@nongnu.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi

On Tue, Oct 21, 2025 at 5:52=E2=80=AFPM Dr. David Alan Gilbert <dave@trebli=
g.org> wrote:
>
> * Peter Maydell (peter.maydell@linaro.org) wrote:
> > Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com> wrote:
> > > The actual backend is "Chardev", CharBackend is the frontend side of =
it,
> > > let's rename it for readability.
> >
> > I always thought the "frontend" was the device the guest
> > saw (the 16650 UART or whatever). invocation.html has bits
> > talking about "virtio hvc console frontend device" which
> > seem like they also use that terminology.
> >
> > If we want to clean up the naming it might be helpful to have
> > a comment somewhere documenting the different components and
> > what names we give them and how they fit together (or even
> > better, something in docs/devel/...)
>
> Or something more descriptive like 'CharGuestSide'

If we are talking about the Chardev frontend or user, that's too
restrictive. We have generic stream handling code (think
mux/hub/tests/client/server etc) that do not fit that usage naming.


--=20
Marc-Andr=C3=A9 Lureau
