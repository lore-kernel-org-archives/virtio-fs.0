Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4978A13D886
	for <virtio-fs@lists.linux.dev>; Thu, 20 Aug 2026 01:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787188983; cv=pass; b=IhSf+pBG0frNpuPwaHpxXX8kobW+cvUNppwyUbtjNbKrg0VddEgXzgwheTJnR/ZNK3klmlHljJUQJIDshznOL3PXxHoDUFrZcoduHcE57dhH9BiIp/b+E5gRyeZIM55dCf0qEKHH3mpykqtyM5q/fXExDd1P+naeNW/omMSK7m8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787188983; c=relaxed/simple;
	bh=IzD5WkVaqb9IoNA5w11jZZ80BB1le8+DrEpLAAUIvvY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p06scWfCNS066XnohF8gMsu0PqclIUKwyfY/UMEFLDr3MkXeXSopuEmDoOB8hsYY8DB8wvhW/sZ7NA7D5dYhKElvy+hrIyQxlRr+Ldu0aZ9xYUDIapsirFZg2o7Q9eAw2cy9Ewf93BAcWcx8KyRI8mi3+eTnqvetoT5KKPAAs+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W9q+QtEn; arc=pass smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W9q+QtEn"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92f0b5ed131so148502285a.3
        for <virtio-fs@lists.linux.dev>; Wed, 19 Aug 2026 18:23:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787188981; cv=none;
        d=google.com; s=arc-20260327;
        b=bR/qaFQ0j9x4MCYDrq4x4LaJPoHpSnYQhXNcVQyANizgFMZfkPEyQTorzhYFuIcn2q
         9lN/ssEimjl44z6+XpO6K2MJYo5vjxMVPsUsregtoEzPu24B+G5v6FLL7ibsDwz7UvAe
         +yBaEdv4eVjPwIyUx+Mlu8vLxxbDcm1Ua4Bl93YzZOkwNcDkvrpVY2EZMYYbQ5kS8Zl9
         Qwin+x+V7YCc0BW7kO/L7ds0UMQsECvUhsdovy8Or3gIyQpScx1hy3Du+aDwveTzdqN+
         Q41cUa2YXCGK1ZpFdnHvEmbUdcO1F4m+v/TVr1Bsd5lxjBqj8XkJKKaFkSjCnyEUR27v
         uz8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fEPJshVvRAljzQG147X6Ty6PBl0uhRhyX5+dH7xacrU=;
        fh=VLrgB28A4OVoFR2Ra3kTdYm/Nw5cmxuikkxsIJOh98s=;
        b=KXguKdXZTfhZRU6J4fpprtAK7LFTy0n2EqzkeDeMC85KDfQNPn/8Sh6aqNAeuHKAjC
         JkaRSYdw5J8sXgQOmvWUc+HtSuETJaKaEN8o9Cvo5Rj3HrbDqbLyAxOdV/y4zr74hedo
         Z2BwYDLXZEc+1UBUzkQG04HJ/VINnblvsUkng2pbF35RGqOIiObZ4ny3zPZipeplTKRH
         rP/oXzjbl28GLglx9VEpdlq+voy8FEVide7jNedlgAT2kkj0+POYfpf8pEL9BbECq1GO
         FslzwmPKEQfq/dXUQDC9kJDaF+g36+ji0tJyo1r/SZK/KC5IoQ0mQqFkxZC6r8fkC7O9
         c1SA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787188981; x=1787793781; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fEPJshVvRAljzQG147X6Ty6PBl0uhRhyX5+dH7xacrU=;
        b=W9q+QtEnMBsLuuUIBdFkyZ4UO+23F62lu37F3mqLAqdNPBnK3dRSz6FvdCy8NfQhAv
         3Yc18Jsfa2Qa39OKtlFKdf9pSSb0ydn0y7Q+JmrPui75fJR6ev3sEQ9xCpvxnSjD94IV
         tNXhithQF/xhz+06yoSLA91WbqlEImMbQWdKmb44aUfNMLtu71K4IuBbTX3ZB+B0L94U
         dpdfd8tC8e72sHdRyX7jMrD9CjOoEwNT3o7YePuv7/Ye2tkOs7hyWdjt79naeyNrO3uZ
         JbWuuPF1Gloa0afeUiiK6JG18KPBQ5c+23YoEcm5z1l1ex+hA+rU+issVi8cew/fgbWf
         T1Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787188981; x=1787793781;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fEPJshVvRAljzQG147X6Ty6PBl0uhRhyX5+dH7xacrU=;
        b=NZBcDK5nTRvwIfHbPPQtRo+yNgHleqtwalkUU+8H8xMfSZc9gzV5+tbBz7hEEYh+Rk
         UsZMNbQGT+r0KCn5SgKBORbFknn+XMqdCiu9CoJecJ5i9xHNnDEt1do7DPYL9FijiiGr
         JFfdoZEdQttDoJotE16tTa6/zbA7o+XeOabtAS8bxZq1hxQuz2Km8Gpr2tivQNE0ncvJ
         YzQdO9awANHSyXCW9PfDT5T7hqv8WjC8Js8TIXJHdyCCUTP7KPaip4QsYLYfX00S5LRT
         u+suTnTXPDpbYppyJsitXXROrYJFdcULWhQzWEqvHhjA8+gNOpjeqGMctvNplyaPHQci
         0JTw==
X-Forwarded-Encrypted: i=1; AHgh+RoSqj/bwK/hJ7zdtmU2t+Brvl2lsU3rMcHDIk/8pJNfXbAon4zdi1kBwhjXZsrlF3IUSKDjpWF1L8w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+SL2jfxSuRaBXdjO5BjS9QmK/HmRnekzkGWivqNivFXe6W9Ai
	f1I45z7dDggf+SJxh/GcdWK0nvBijp6De1pjSuRcF2bYclO8CCOvOOD7EMf5opQcUCOoSXADpNh
	0lNQIDHwyf3XAiGqdW+qScUevE32PxS4=
X-Gm-Gg: AR+sD125QhT3MBMfLW4Bj7vI192a75Tbjzf6ZMspqzsvlbz4PmLDtJUD/DzYWC7LM2H
	mwfBo2jAT0lB+iur28BNccdJRZLSLNfH8cQhu3F+ScVtGe5E3O5tcJBkYG1QSLSJKxYjeZHKbVz
	12rRZtbKpm+HclJfgXkgtA1Slkf1TZBWYsol7UpOaVOKeNuwmqfdoQcHGAuAzP30J1Qi0uDmicM
	+hl0268zXp7XZFiv9mDJkK4Ki+qzYUNRDFuy9wviu/VhJxEnlMTMW6Sh7r+4DDONRf/gnpwvZsg
	MDI5FewuxsUquVaJg++sIxn2IzohzkiiooYMwmwk0kmZfMuP5HzU4sblTrjUiJKeuZ7y3xRTG0o
	/NOU=
X-Received: by 2002:a05:620a:470a:b0:92c:103d:63dd with SMTP id
 af79cd13be357-9371e30d64bmr825382685a.39.1787188981058; Wed, 19 Aug 2026
 18:23:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
 <20260817-vhost-user-isolated-memory-v2-13-948aae960abb@gmail.com> <15427c56-a585-48ff-b024-e48a2fdea697@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <15427c56-a585-48ff-b024-e48a2fdea697@rsg.ci.i.u-tokyo.ac.jp>
From: Connor Kite <connorkite@gmail.com>
Date: Wed, 19 Aug 2026 18:22:48 -0700
X-Gm-Features: AcwNN1WYAAFsNg32RpeVzWj-vcYKbWhQ5GN-92FmFalaloYu8x_uy2_lP3Y2MrY
Message-ID: <CA+spn3qZ9psOFGyVR-5=ou8hExDFZg0Yg0TdUxeC91tNKmhCTA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 13/13] net/vhost-user: add memory isolation
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2026 at 12:37=E2=80=AFAM Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
> On 2026/08/18 14:12, Connor Kite wrote:
> > Add a memory-isolation property to NetdevPassOptions and
> > NetDevVhostUserOptions in net.json.  This property will
> > be used for vhost-user devices to disable access to guest
> > memory from vhost-user backends.
>
> The cover letter says multiqueue is not supported but the code just
> continues with multiqueue and breaks.
>
> Regards,
> Akihiko Odaki
>
> >

Adding multiqueue support is my main focus for Rev 3!  My testing so
far hasn't included backends with the multiqueue option, but I will
correct that.

Thanks!
Connor
