Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A908817745
	for <virtio-fs@lists.linux.dev>; Sat, 15 Aug 2026 23:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786835212; cv=pass; b=kanDfsEwIiNE4DF8JoHmQmwmGsOuvJPGE9jv3dGWELINol96SpjmsjXDTDWoZj7+hlrWCh1ILjlBS9073TSEqnYj41fcFztmyi5LWhj4Dj7Q6Sq+pEfYKGTh8K5roC6Rm9uHpDBJ2GvtNtU0k6R+Hp3TeAB7LXpWjPMdcZ0kyJM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786835212; c=relaxed/simple;
	bh=SXHY5XQEJE+f6QflRNKov5QKXTMfGOMMRtdIN9qwj5Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tZ/2Mmqb2m+14eUAqr5iNnfslCmVIE4gBLjGuj8uQtEgaI3z6SZGiNpqwaCrNYNkPXwytmRNWOukpA52BG9yMQIoBrM/cwSUARKfe3f5fU5JAk2At+sR7E/El9WtEL6RYJ1AyHL1WXekr4wfVJKmXjBW+/EsAmvKEPkhBbLGyoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s7++CAuh; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s7++CAuh"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51c0cea8883so17017191cf.1
        for <virtio-fs@lists.linux.dev>; Sat, 15 Aug 2026 16:06:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786835209; cv=none;
        d=google.com; s=arc-20260327;
        b=Ha9spw0orau/MX2ivK+33A68yRa448cNn/kkhskXdU/Ny6TAVGUNx+HZ5XMV4Agy9u
         qmjJoQn0an51COSQz23oUX+MZzVlskQ9XpQUTcbQZI9/Yft6t0tcHHYpT4d541606NeR
         v62TcGoDiq610qHTqsY7zh0IKvATUbo4nldLucP2wFP7RCAIJIPAtwAkoDePdM+QuVgx
         TCSLzlI3p9+VzRqFJ0Zsyweeof0vF/5yM9NyCWmVFfVwZvUgwlWHkwo3M+2b6kKHvVGM
         /NII3FX3ZByko1EkPBZIEfg/tFZvKmuuY6qbhjP/bQYC1dLPz8dMAmxpNnW9oInEU966
         pNUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ACamN608LlVcQYgc7KvwUxPHxL2uAxs3qXDqYIboXB4=;
        fh=JFVnEYh+BV92hSk1VPxzShDdQXAUCVXtqB4lDgM3MkM=;
        b=Ly+8Ps7GM7+J72pOtuDqwZFgKGpIhBzMQ8bW39YNUuUB8+DKHPEnsNc26H5lYWZc2T
         3qdbEgoNl8uGG8iBUBAHCPsRvpanA4LMaT1DMntIerciqwtHiHJwNHh4JU0eupx7Nepp
         2065P/Xsldv6SKnFd9soecW4z050ndYKKcwWwBHLQ9kUKXaXxsTqH3u0sOXLPsyFUx7c
         a6kHRGcG9Tnlh6zR57aftNnBaepZk8WGI5vhweS4IHNxmuNcTkZz8TUNDRQlQ8Mxu7oY
         EAiy8qN4Y+dIF3sAjDpOFz+K16BZUzK6HpmnjYYBquTJrHW7r/6J8adYPSX3HUezB+9D
         bAiw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786835209; x=1787440009; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ACamN608LlVcQYgc7KvwUxPHxL2uAxs3qXDqYIboXB4=;
        b=s7++CAuh5ZPdBPIJyrl5U2NXrhGow/E53PScCJU/zecAm7wGxsrxLgobDWiuDHZaKW
         SctZitZLa6JmW91DsW6qZ83scTJu9ZKhXeOP86kxCe21LTqEY1chdPzwidvzgaXmMn4L
         FS1jGP3lVmBtQjr2CGhlaOxLvwWterjgviT4qYVkrnAOAh46r1dK7x9/TYHhgfzE5QgC
         +Iern5BagrQr5AoLFMBSz5oluB2QRBp6mYmwnWkP/gsajt48OPB/D5iRZLct97juy0Pi
         KQFsmViVFFEY2t7g94Jgp6vJSf4vK/HgB7VPGrWdBHJhm5mc+B1qwIqs6C9LfpQ8CB2I
         0HyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786835209; x=1787440009;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ACamN608LlVcQYgc7KvwUxPHxL2uAxs3qXDqYIboXB4=;
        b=BINfOsuOZW/woFvrofzCbBG+Kp3o5HcJOtpzH/ZRwBZg+yU0KQwcSI8sfTRuSX/7ZY
         8XD8X2ZulTDKFcH9/pZpXznP91YQeKflFilmqbSWtQQqoVgEhllDJu89Cgj9aavYkI8m
         WBDozyzASanQfTcK5KXWv11kfCTMjQcfLYd3Qw08Kkhxuzy2M3h3p7Krr9bXFcUMwN+5
         FrY4meIY3vTh+FpLlSgTOTL5ElIUCaJVgnr6Rvz5IO0m9bkLRMDXyGGEwsHtcOIIpDwH
         tty5glcWN9AGCavRmVwpxzYrfOwzdpL32ZXzonOnraLyk9GZmxNML8RG/hsf95AmGVOS
         FvJQ==
X-Forwarded-Encrypted: i=1; AHgh+RoUPyvYZ1Bl3sMZ/FGGZvFYHOM2hz+7yalxSBjzwpg3Qtty6Hw1S5bWg3tQP9uDFFK7NFpUzaHGgvE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+d3mYgnovNXihpAfVQVCTMvhmcq4hG/tcglNJ95BzLnT/7tOH
	oMP/XbBbHk9/tMRkIPD+1Lqgmumga1uOE78AWen3hfaA4uaoTmhmlvj0atJkVLIevjAFcS1G68x
	ZWw3tOuWzyrqfLi4Qmlsv2dELFv9o5uM=
X-Gm-Gg: AR+sD114D/Tlf9nrsE1nPQyBQoADBEqTILYtub/WasNQaHEKfCs+H/YlIQ+4Q0NVajX
	v0PRaPqez3uojSUnwCi0x/SBkUu2GlveHXupnxwIitmustyK2626nafXgqIHJNqcIe5pmrivwYr
	ngTTjXW6h8JXloJpu9YrYELKGOS/i75R7EaBCOmds2TeFBh6MkUATWFkKu3LRUNdWWGtUuuAWG1
	9oR5A3npl51eQ0MuEg4ExJm43LZWV4frtcmNRixUs1kDLLOKRM8OBCG0lyGxlpUafZgu4EvWR+y
	FBRNGWvDBGit1eJOV2NN+1PAqSIojmF5NhfCKiKxydSeGJvSmLgKVVKE56xgbTsF6NjpUKT/7GN
	pPnc=
X-Received: by 2002:a05:622a:5c08:b0:528:ce0:e9f8 with SMTP id
 d75a77b69052e-52d74a35420mr251080611cf.3.1786835209204; Sat, 15 Aug 2026
 16:06:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-13-6b97c439eb28@gmail.com>
 <13594665-16ec-47e5-9075-f7bd5552b0a3@redhat.com> <CA+spn3r7+pEb7e6=8JixTpk7M3rNhWv=JkGZchj2-3FK9ZQGYQ@mail.gmail.com>
 <c549061c-8e9e-48a6-a149-2da743154c10@redhat.com>
In-Reply-To: <c549061c-8e9e-48a6-a149-2da743154c10@redhat.com>
From: Connor Kite <connorkite@gmail.com>
Date: Sat, 15 Aug 2026 16:06:37 -0700
X-Gm-Features: AUfX_mxgB49cuSbTwPK00Nmro3M7CZjdoHhWzzFGXSUGQymC0ePi45vIit5flQA
Message-ID: <CA+spn3rcK7c5xoCPP_t+M96UmZUWCaNDpNno-L6q9AoOoddw5w@mail.gmail.com>
Subject: Re: [PATCH RFC 13/15] hw/virtio/vhost-user: add shadow virtqueues and
 eventfd intercepts
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 11, 2026 at 4:42=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> =
wrote:
>
> On 11.08.26 04:32, Connor Kite wrote:
> > On Mon, Aug 3, 2026 at 6:52=E2=80=AFAM Hanna Czenczek <hreitz@redhat.co=
m> wrote:
> >>> +    struct vhost_user *u =3D dev->opaque;
> >>> +    int svq_idx =3D file->index - dev->vq_index;
> >>> +    if (u->user->memory_isolation) {
> >>> +        VhostShadowVirtqueue *svq =3D g_ptr_array_index(u->shadow_vq=
s,
> >>> +                                                      svq_idx);
> >> Bounds checking via `vhost_user_get_vq_index()` would be nice. (Same b=
elow.)
> >>
> > Adding the bounds checking outside of the memory-isolation only code pa=
th, since
> > file->index wasn't being checked previously.
> >
> >>> +        if (svq->hdev_kick.initialized =3D=3D false) {
> >>> +            int r =3D event_notifier_init(&svq->hdev_kick, 0);
> >>> +            if (r) {
> >>> +                error_report("Failed to create kick event notifier")=
;
> >>> +                return r;
> >>> +            }
> >>> +        }
> >>> +
> >>> +        file->fd =3D event_notifier_get_fd(&svq->hdev_kick);
> >> What if `file->fd` was -1, i.e. `VHOST_FILE_UNBIND`? Should we put a
> >> real FD here then or just continue with -1?
> >>
> > Good point!  I think we need to propagate the -1 to the backend device,=
 and
> > run event_notifier_cleanup on the existing svq->hdev_kick.
> >
> > ...
> >
> >>> +
> >>> +        if (svq->hdev_call.initialized =3D=3D false) {
> >>> +            int r =3D event_notifier_init(&svq->hdev_call, 0);
> >> Do we need to check if the call event FD is already active?
> >>
> > Do you mean, do we need to call event_notifier_test_and_clear to see if=
 it's
> > been set and potentially run the call handler at this stage?
>
> Yes, that is what I=E2=80=99m wondering. `vhost_svq_set_svq_kick_fd()` ha=
s this
> comment:
>
>  > event_notifier_set_handler already checks for guest's notifications if
>  > they arrive at the new file descriptor in the switch, so there is no
>  > need to explicitly check for them.
>
> So it sounds like there is some mechanism that will ensure that when the
> kick FD is set on a shadow virtqueue, it is checked for activity
> (notification), and if it is active, this is=E2=80=A6 handled? Which I su=
ppose
> means the installed handler will be called.
>
> But it=E2=80=99s entirely possible I misunderstand something because the =
same
> code in `vhost_svq_set_svq_kick_fd()` also just calls
> `event_notifier_set(svq_kick)`, so=E2=80=A6 kinda always emulates a kick,=
 I assume?
>
> In any case, there seems to be worry about pending checking kicks from
> the guest in this switch, and so I wonder if the same needs to be done
> for the call FD.
>
> Hanna
>

I haven't noticed any difference from setting the notifier here, and
on further thought,
I think I know why.  I do not believe a call notifier FD is ever sent
to the back-end without
getting intercepted in vhost_user_set_vring_call, and once
svq->hdev_call is initialized,
it should never change unless the device is reset.  Since
svq->hdev_call is the only
notifier shared with the back-end, it should never miss notifications
from the device.

Connor
