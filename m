Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D226434409
	for <virtio-fs@lists.linux.dev>; Tue, 11 Aug 2026 11:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786448529; cv=none; b=LhLj3RHVJIbO5wE2HeQDUNlXCSXqUHhtoFJ/yXNBiG4LXHGYxs8/e1IeuHqaiVxZ+vKgYSox/nni6vN5t1S2GXtMdxAV9fvwD5pLJIKm2RaAEVZXPxEgzzwc2DtINnnmGnlN/P6Aat6yNOUf14I8M9dU7IC8nM9HLasXfvJ59nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786448529; c=relaxed/simple;
	bh=9tWgvo/v+8h0ckmaBnjUiH3GTEi67n7RfkcCkJwgErw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FgoowQOF8wKB4dfRTBgEw2vKRoN0aziQtI7KecHrNYLOmGdhvCdI58HJJMId+lBgALxip/Z1VGqBjsvBZyghgfzx7H6AoUwYNiNP6QP0BZGRfwpBl5Jam31gf3ljCP95ckde4scxZ1A2G1tRVbsFVhAIOH5WNWj8vgN4Jh4jYMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N/eBRVuc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N/eBRVuc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786448527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=83Z7giIsXRjL+pG88JPHrWsQSLh0SWtxmdOYGdneAnU=;
	b=N/eBRVucu5RVQeS3y+Nz0EVzrtSei3RVyRvnR/9i0zRkKS79VpW/dtMsqbVFJLJbyCNv25
	Fjdmf3IlRt848SoQShkPgW6cTft4PZqHvOGxZElZpAaDC+Ld0S5Ym2k5TVTjOSwr77jJub
	QSqaPk1q9f+aWVJt3Nb5h2cgH0S7zAE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-yP5WQTFzPYuxqyCD-qSaeg-1; Tue, 11 Aug 2026 07:42:05 -0400
X-MC-Unique: yP5WQTFzPYuxqyCD-qSaeg-1
X-Mimecast-MFC-AGG-ID: yP5WQTFzPYuxqyCD-qSaeg_1786448524
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-47f4bff865cso448709f8f.0
        for <virtio-fs@lists.linux.dev>; Tue, 11 Aug 2026 04:42:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786448524; x=1787053324;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=83Z7giIsXRjL+pG88JPHrWsQSLh0SWtxmdOYGdneAnU=;
        b=kvhtdqkWnG7ueMTY+lajuBAtnhIOWVj252ND6/qwiXrEM8IfexXnkB9V3nHkSgNrJ4
         eY4uI3tvxNSpzPfJnnsdhpK8gsKoR4oHlcLwJ195XtDVy6aEymbCAt5UNjAZCMPLG2gi
         9bSISvBlR6RXVJMZi1k9PwiR3aJMeJCN2X+bOyTNBZqq4JT9psJl2oiUU0Q2HdQo+Aya
         7cNVDzjNPnGGYU/WrIIzG4ILLjl9cDvIbyeWs5JRMg/v7H/zhmiyubVh69NXa4dZlQGP
         SK+TnArYk4OVy3nY4MjBLvT6rvi8Of7tkl7pnkWGEdXIKiG9iVMb50cPJD5ZcNF4Kzgs
         qj9g==
X-Forwarded-Encrypted: i=1; AHgh+RrN1Mz0oLhKLVxUorSeXpFKmoVIAZ7JOfitxZ6nij8Ft9rxgYrEaHsIlFo+dETqY6LuRnF1NTJPyyk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAWlWnciF48D5sjOm2jItxiyU6pX/qi1NpF2GxDwF0o2uMYXMm
	XXhBfkpokpysOeDmgh81cxvbZhXSd+SVyCV01OiWVuP0WNlhsdvT+540Hjb70i9VPMuTGpl53Ol
	ioo5/H2CBZE6cnQwXxq6s4cqa1oYCRqsa64FQxjcV578drbcZB7PcYoJZ5zxNgCsJ86Av5A==
X-Gm-Gg: AR+sD10277I/ADUaxtpt7xcXvszRMWOr0RFQ4h29xNNpAx140AeKwtDlX622vYW1iit
	kZKmKgwemRnCp3Krd7kQuF7zFlibmSBmU+MHol621Pezwjg6Z//mEgp41/+nhS2gcaBMm+fzfZP
	5ciujq6fnLssXU0IVQ8SRqPo9k1Vg3ZIyzKHbmR/V95EWOXKzxShXTZH1IBUfi8wldTSV5jQgYd
	jLX8kLItkpcWZ1/Z8wG0lxdpA2Va+h+zXqXpzJOj6iSio/S1oFtIqlIYQVPuEF1eJ5y5+lqppgl
	kNMBToN8728RInGTC9AWyoE3P9ZGrt+qo9irtgY51un9+wkVNKG/Fp0jqOr1ALJ2Dkogl+wT36X
	pXp5lm/05JHWrpE6lwl6M3b0eOO6ce1wRUmmYwupafgp+us2OtRBn5Yl2YTutioIrFEoXeH5e5u
	FPCn++J+GqcawkDus6P5LIMEO2669fRA==
X-Received: by 2002:a05:6000:60c:b0:481:98d:b24 with SMTP id ffacd0b85a97d-4814adbd65amr3736973f8f.19.1786448524447;
        Tue, 11 Aug 2026 04:42:04 -0700 (PDT)
X-Received: by 2002:a05:6000:60c:b0:481:98d:b24 with SMTP id ffacd0b85a97d-4814adbd65amr3736878f8f.19.1786448523950;
        Tue, 11 Aug 2026 04:42:03 -0700 (PDT)
Received: from ?IPV6:2003:cf:d706:f1cb:272a:2c7d:bb01:94e8? (p200300cfd706f1cb272a2c7dbb0194e8.dip0.t-ipconnect.de. [2003:cf:d706:f1cb:272a:2c7d:bb01:94e8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4814a709624sm4220464f8f.22.2026.08.11.04.42.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 04:42:03 -0700 (PDT)
Message-ID: <c549061c-8e9e-48a6-a149-2da743154c10@redhat.com>
Date: Tue, 11 Aug 2026 13:42:00 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 13/15] hw/virtio/vhost-user: add shadow virtqueues and
 eventfd intercepts
To: Connor Kite <connorkite@gmail.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
 Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
 Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org,
 virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Alyssa Ross <hi@alyssa.is>,
 Demi Marie Obenour <demiobenour@gmail.com>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-13-6b97c439eb28@gmail.com>
 <13594665-16ec-47e5-9075-f7bd5552b0a3@redhat.com>
 <CA+spn3r7+pEb7e6=8JixTpk7M3rNhWv=JkGZchj2-3FK9ZQGYQ@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CA+spn3r7+pEb7e6=8JixTpk7M3rNhWv=JkGZchj2-3FK9ZQGYQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fsrQd-hJ3lVEwy0ABYLKo0fR5a_fHhvrs1X2tSHtb0s_1786448524
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11.08.26 04:32, Connor Kite wrote:
> On Mon, Aug 3, 2026 at 6:52 AM Hanna Czenczek <hreitz@redhat.com> wrote:
>>> +    struct vhost_user *u = dev->opaque;
>>> +    int svq_idx = file->index - dev->vq_index;
>>> +    if (u->user->memory_isolation) {
>>> +        VhostShadowVirtqueue *svq = g_ptr_array_index(u->shadow_vqs,
>>> +                                                      svq_idx);
>> Bounds checking via `vhost_user_get_vq_index()` would be nice. (Same below.)
>>
> Adding the bounds checking outside of the memory-isolation only code path, since
> file->index wasn't being checked previously.
>
>>> +        if (svq->hdev_kick.initialized == false) {
>>> +            int r = event_notifier_init(&svq->hdev_kick, 0);
>>> +            if (r) {
>>> +                error_report("Failed to create kick event notifier");
>>> +                return r;
>>> +            }
>>> +        }
>>> +
>>> +        file->fd = event_notifier_get_fd(&svq->hdev_kick);
>> What if `file->fd` was -1, i.e. `VHOST_FILE_UNBIND`? Should we put a
>> real FD here then or just continue with -1?
>>
> Good point!  I think we need to propagate the -1 to the backend device, and
> run event_notifier_cleanup on the existing svq->hdev_kick.
>
> ...
>
>>> +
>>> +        if (svq->hdev_call.initialized == false) {
>>> +            int r = event_notifier_init(&svq->hdev_call, 0);
>> Do we need to check if the call event FD is already active?
>>
> Do you mean, do we need to call event_notifier_test_and_clear to see if it's
> been set and potentially run the call handler at this stage?

Yes, that is what I’m wondering. `vhost_svq_set_svq_kick_fd()` has this 
comment:

 > event_notifier_set_handler already checks for guest's notifications if
 > they arrive at the new file descriptor in the switch, so there is no
 > need to explicitly check for them.

So it sounds like there is some mechanism that will ensure that when the 
kick FD is set on a shadow virtqueue, it is checked for activity 
(notification), and if it is active, this is… handled? Which I suppose 
means the installed handler will be called.

But it’s entirely possible I misunderstand something because the same 
code in `vhost_svq_set_svq_kick_fd()` also just calls 
`event_notifier_set(svq_kick)`, so… kinda always emulates a kick, I assume?

In any case, there seems to be worry about pending checking kicks from 
the guest in this switch, and so I wonder if the same needs to be done 
for the call FD.

Hanna

> If so, this might be where some of the intricacies of when things happen in
> vhost-user vs in vhost would require some extra care, unless isolation mode
> implementation moved up into vhost.
>
> ...
>
>>> +    /*Modified from vhost-vdpa*/
>>> +    u->shadow_vqs = g_ptr_array_new_full(dev->nvqs, vhost_svq_free);
>>> +    for (int i = 0; i < dev->nvqs; i++) {
>>> +        VhostShadowVirtqueue *svq;
>>> +        svq = vhost_svq_new(NULL, NULL);
>> Patch 15 adds clean-up for this; I would squash it into here, as far as
>> possible. Ideally, a patch series can be stopped at any step and not
>> break anything, so if an allocation is added, the accompanying freeing
>> should come with it.
>>
>> Hanna
>>
> In hindsight I shouldn't have considered cleanup a separate stage in the
> development.  Too easy to introduce bugs that way.  I'll move cleanup up
> and comment in the Patch 15 thread.
>

