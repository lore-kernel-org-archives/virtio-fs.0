Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF112737F2
	for <virtio-fs@lists.linux.dev>; Tue, 21 Oct 2025 14:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761056893; cv=none; b=kxU+05EYhB/tMCF7GLigYVvg2aBtNtqS/SHulQVpeVkvM8JOyPEhrVf/IQGe0Xn3WUnYIHQE0NzkdMLPAga/2YAcimQbp3mHJWddm9NoGei9zwMzVJ9qLzXPXAI63gW9VSmnvNy2oU6iZB1UcPXYYBjB8PLvBwYRUIYy+hT3v+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761056893; c=relaxed/simple;
	bh=fOkDZIYP624hXJ84QvSPoENvTgmCF83wfkY593GGoOU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QbxUsgAEMkKwQ6dwIZblNYgModFZATk2hSC0G29jBKvMN1RDCF5tKDHoAaurgKxYdeZ5L2dMrE8Wmhzdv4V+kt5lj6WLTnGOi3nYSPLINOCPEmYFzgqKdKXBqFa7BUTDQxZxKnenirSgkBCS1o5+wzDLjuUzn14UuImb+dg/HQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RC5qwg6T; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RC5qwg6T"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-87c11268b97so89281556d6.3
        for <virtio-fs@lists.linux.dev>; Tue, 21 Oct 2025 07:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761056890; x=1761661690; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fOkDZIYP624hXJ84QvSPoENvTgmCF83wfkY593GGoOU=;
        b=RC5qwg6TGbpQFfewwZ53kuR13Crp9aN2UIgcHC9K0cnuI8uZN6NmM1T4lTIXz41uCs
         zf0iDrb3YEV3BXJUQYB53sAa9AGhnKYz0/pjaoMJPrzqeploq0TUmGwK8BCxqMcfv5Aa
         fJF4PDoNtEuuHQo3OISYZ+VCDRvnhMawSlK6YtnqenZu5w6UMEwIPRJpJBLuDQzPyGkQ
         FdaJv4neuUESpP6bn9iCmTnxs8ShZzwXw+gL2t7Y9h29ql6d5xo2SHC6HXf6AWF9PZsp
         BcXiqUytY9ZAPmgJ65wBo525kngD+OQMBzJ9DMyvuQO68hY8B/cHtmKYSRSdG0Hk99YZ
         byTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761056890; x=1761661690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fOkDZIYP624hXJ84QvSPoENvTgmCF83wfkY593GGoOU=;
        b=EabQmLaBwAyNzHZoGB2+KFV9tTPpc1AZ+i7sJ9LcmuJlsyScOh6oE9/sCefVUt21Cl
         0YjTqK8U1XFrtE8XRDYkFZ2rU/IMfYIcvWGvTGdn9UjLJNGAPfRxSjrpUKVkqGwtaFLI
         dKf8luwYK8YuEFKzP49Ty6nhjeSX8UB5CGVk8kAUyfzpqs/s5+3TTScGEizNI9XnYzX5
         RjmGBzCIRFl7Uxi4iZcpBY7UWMb0IkAGMN+Bh5iwQlJ0Vdzaj4jsjhSo8lsJ8BGWXhu9
         +Q7NlG18N3D4n84g6obuldvk/cK88liOE4eDUHyOwJywq/lZvfEP+OnI9pksbzhOp46u
         2kuw==
X-Forwarded-Encrypted: i=1; AJvYcCXvHlnxDIoFxJPkXQy4RW3VKiXw3RR+rnwsCks2817Qcs5nHEpDRtWAti1Pr1g6Yz9308EeuIEo1y0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzpxAy2g+BeBB4y1bNVDH4fMz6+l81QrouQVEyP8MBlso6D4aLF
	ZX3tFMTVlpgdcP2nnSoCab1LEH2UpIQWAeG5/VcZB5cjaWAK2FcAAjsS7mwY8xQtoJYuKW8IRil
	h8Hrd84NfgNWf+5+McgTcToGzp/vsgF8=
X-Gm-Gg: ASbGnctanBYpCQUMaMXs790HaqXznhyi8Rn8TwLgMVmgJg6EaAYGhHyZSPkB6K14y5S
	aGrZJ01zkVqXfK4C1oqmOG7AJd5YNysEY9U4DKyru1TFlJ8Z+i72lJYlyK3rxVlTIpZfKvdPWvp
	gHRFkkVCbc5YpIVgjwTgGMDhQUnCDjV4mcZKOcfrlkYZvUNTfGTB8KztyC15V2Z27H+HPQQq0Pz
	b9E+y0eCP9avWe9MaeUs5Fs4TIWy+Qz+2hohG4/VHEONfzUD5eCeZZzhk0QaYzCZOMwH9Xrp+gc
	QowwPc5zaOyNftLT
X-Google-Smtp-Source: AGHT+IGp+zf0u9SIF08iLE3a5Asq68ZbyrbibcTK8YXdD3xNkn5pXcBzDMuiMfZHuV9n++d97YerVbPf0S+nqo2EBIc=
X-Received: by 2002:a05:622a:310:b0:4d9:dea6:4ff0 with SMTP id
 d75a77b69052e-4e89d3d5924mr245955091cf.56.1761056889597; Tue, 21 Oct 2025
 07:28:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251021122533.721467-1-marcandre.lureau@redhat.com>
 <CAFEAcA-jPE_onLYLMxgcAOB7dWRXOLJrWcGPnR0NUdjYytPDVA@mail.gmail.com>
 <aPePcTKl6s4FoLCL@gallifrey> <CAJ+F1C+bGKtY6nf3LCXrwhZ2aEdu2npXJ9FapmsqgX0uLL5TUw@mail.gmail.com>
 <f764e4cf-d134-4c4d-a313-a5b7dd6620d0@linaro.org>
In-Reply-To: <f764e4cf-d134-4c4d-a313-a5b7dd6620d0@linaro.org>
From: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@gmail.com>
Date: Tue, 21 Oct 2025 18:27:58 +0400
X-Gm-Features: AS18NWCtKDmDRRz11NBqNv3KECG8ofxt09PdE7ub3r-ykIF5WUP85WNT3b3fqdE
Message-ID: <CAJ+F1CKG1G=5o+bDBXmLm6ywWDD19z1OFBwQQnDMxMFytFQ2SQ@mail.gmail.com>
Subject: Re: [PATCH] char: rename CharBackend->CharFrontend
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: "Dr. David Alan Gilbert" <dave@treblig.org>, Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org, 
	pbonzini@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	Zhenwei Pi <pizhenwei@bytedance.com>, Laurent Vivier <lvivier@redhat.com>, 
	Amit Shah <amit@kernel.org>, Stefan Berger <stefanb@linux.vnet.ibm.com>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
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

On Tue, Oct 21, 2025 at 6:23=E2=80=AFPM Philippe Mathieu-Daud=C3=A9
<philmd@linaro.org> wrote:
>
> On 21/10/25 15:58, Marc-Andr=C3=A9 Lureau wrote:
> > Hi
> >
> > On Tue, Oct 21, 2025 at 5:52=E2=80=AFPM Dr. David Alan Gilbert <dave@tr=
eblig.org> wrote:
> >>
> >> * Peter Maydell (peter.maydell@linaro.org) wrote:
> >>> Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com> wrote:
> >>>> The actual backend is "Chardev", CharBackend is the frontend side of=
 it,
> >>>> let's rename it for readability.
> >>>
> >>> I always thought the "frontend" was the device the guest
> >>> saw (the 16650 UART or whatever). invocation.html has bits
> >>> talking about "virtio hvc console frontend device" which
> >>> seem like they also use that terminology.
> >>>
> >>> If we want to clean up the naming it might be helpful to have
> >>> a comment somewhere documenting the different components and
> >>> what names we give them and how they fit together (or even
> >>> better, something in docs/devel/...)
> >>
> >> Or something more descriptive like 'CharGuestSide'
> >
> > If we are talking about the Chardev frontend or user, that's too
> > restrictive. We have generic stream handling code (think
> > mux/hub/tests/client/server etc) that do not fit that usage naming.
>
> Isn't it
>
> - backend -> host adapter
> - frontend -> implementation used by guest
>

Sort of, but I think it's too restrictive to name them after "host"
and "guest", as they also have different purposes than strictly VM
components/side usage.

I believe talking about backend and frontend is usually the preferred
convention.


--=20
Marc-Andr=C3=A9 Lureau
