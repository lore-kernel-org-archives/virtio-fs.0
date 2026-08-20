Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437CE145B27
	for <virtio-fs@lists.linux.dev>; Thu, 20 Aug 2026 01:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787188004; cv=pass; b=ReLQ3gOB6iv5JVL7yFBDUfCi2qhuJCbwQfu62scuQY2ybRa1sVfVIwV+JDNHEEUEmbWBFCQLr/V6WuRHnqRCDBTeiOZCbhUuRxB9ozlAygBeEb4ILtmDOeAYD9B8LpSFdsmG9Atbs35PiaxABRXc6x/by/v6jrJG/lR2YPdaa1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787188004; c=relaxed/simple;
	bh=DQwQIh7JWR3BSaP+Z16UoM/z0GvwsKDlhiuv0AYd4S4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lRdTIX4fpH5iKb5u9RQ06vjAmB74Aj6CifgMdWggp9XufyXH1BlIejFzAWK0MuRwWXRV5ZW+74hNnHO0vqu/+EYzsjhPOkFCJY7KXD0NxlFNPCrL5unNLSiTyXAIYKATtkr9SKQHpw3AfRBwwUYIE+7NoNPE/tNsEqEBMgeDONg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kME74a1i; arc=pass smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kME74a1i"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-936d00181abso85172685a.2
        for <virtio-fs@lists.linux.dev>; Wed, 19 Aug 2026 18:06:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787188002; cv=none;
        d=google.com; s=arc-20260327;
        b=NDOJJM838Tp7dt0mqSaBc+iAAij2LXZ6f3CsRBbeAFzSQGlMZGuXzIlWxfRYPAPniq
         n4Ze+kbevxqYZ8NzPGzpT4iGul1MMyKY8i810QVK7DNGHcpATaTo9IVtbvhipsG5GBRk
         GO0dTAih7xAVqGMYjymqptlgDniUEaJnSyVZZeqXKFuT8utOU5Amc2ZcVIlE+zrwdx8J
         hLX3qn/i2PiAGsyfoAIHD8GxkunivdEtNN2g+Y724OfHck0W5kNGWqzD5GJroJB5GhkE
         N1HeJPU7GY6t2WazKA2p7vxKSdnJCg9q/OD1nxuUnjzUvrh9oS4hzpPy9VXlfJdP7BWt
         9AEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vsWCscNzkxiVMmU/QBKBdlqpIVF9XvSYTxKTjjRPnYA=;
        fh=xffSJC2yMC0tnidGp07KaClMqoEn4Do6Hck9+h6wgJQ=;
        b=mxO08cDK+SblSXMfHWb6W3ElEeHAoopQnCndglIRUvkh9E5jh0THtZcOCAyaNy03ZY
         DGHJigXPSb5ISwEKP7XMV0mLF1iOahiec8w8+XggpSTvON1RdOu7tidKSxTaZEdIhL1F
         +KFirX10Klo6pbPCZQIafJs9qo+b4F0Fdr2bjUMuKLX3FLQnVhnIDXBD2214LVnI06yw
         4F1UZNAk8koY0MS4kpyIgcXACjecVYB7rYSNVOvBICwag2pvk31yJx8k11puehaqrFCx
         DAfi7l2Y0gebztykYJt5zYMayvkKT8D2QPtLx3Byt819UFzj/ELwghJl1gm5JOn0V2Ea
         vioQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787188002; x=1787792802; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vsWCscNzkxiVMmU/QBKBdlqpIVF9XvSYTxKTjjRPnYA=;
        b=kME74a1iVwj1kDd1jXYEvfIrNZDgEm/+Mzr86xy9evNO7vnjmAqRyM3RnZs/6v6ird
         f5lCXuMFPO9WBUWLR3YZX0TsuXrRzdmmO866lOQOACygGdRQSGeijolzy1zhWHZW4Sau
         VkanO+seQCENXo76SCwTAypB65xBaG+RoRwZi35N5/zipD3C6MirGwi6tJa2j4PxEju4
         U6Nji6VCkAZBCF5bjGFiQhgNiSYts95LKMy8R16nX2UmBQME7dVYZB8SInsgtnmfZ6tb
         IH4i+7lLK6Zjd8sHFM3vgWbRdzSbbp8fWh9nUqN+HCP0Dvif+huZA8THxhrTfbqffXMe
         Lj4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787188002; x=1787792802;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vsWCscNzkxiVMmU/QBKBdlqpIVF9XvSYTxKTjjRPnYA=;
        b=ZSEBRrRfuuOzIlDisETnj4W1MNAKVUXrqBv05Ep4klGDaoW5dgmvy2BhGs+fxyYNKx
         PHzmKuNx1+enGmaDI/EUllAetSTMhZtS1OYEToPJoULSpqvV3m2ikwPE/Ats4x9Xdfrr
         pmRBDSIYyKec6cswZ15D+VN6m8F6ewwSj40jd6KLyv9jd4z8mH6Lo1L2YVzlhatSheCH
         9FzcDcrII7SQmZHvLcoPdv1xjotadMwGKsXO2vYzubJnCUjxGScN1YBpqg542qSMpIfa
         aMIHPj+ClrZ7ey4iLGsWy36ZP2p9aCh+I0FW6dNygQ7FyDA6VYqUKlhTREiutxlsubeX
         vNtA==
X-Forwarded-Encrypted: i=1; AHgh+RqTaIgyxkvhQPoesUgtckCbNBNzozKT4R3Cj7Lg0bTndQvep5OCkIGMxP8JrtoloYN18bEtt+vgqLQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzG9jHDuOOlk3sHqocmFsbb5ol6Dzfde/gAA2aMDEEDCU5TmAyE
	m2zsfhJG6svsJVIha1JGse2I4zkiJMXbLKMR4tS4rSmDvrSt5QjRGV6+XpJoXAVnYYVmn8/PWJH
	BZg9DJ+lJK5MzNho9MS/H5nZG5f9+R9s=
X-Gm-Gg: AR+sD13de9UsMQE/a/9KviUJrYwvd50OT0eH+MBiJXTPnVfCAHzwDZiCYum2PhJTFCx
	Ld3Xzd/IhlpjrpCl3wGtDLcgqtrhN19X4A9/0FKqTe/cERf+1NB4wf3JLLEDQiEN7iWcCGg0fn9
	z34Kd2BgqZcSfApFQp+BQ52p5i1V68XTAmfdTM0E0IGAJXbOuaCVV88u10K8/I/xhTS2rX0IKLC
	t185IPFxgFUbLIXYJOyRjK19+HL/982xpJ3vO0jE2gbIUynqIDgx/rbMjZsd5Oq8OZu+PJhBipi
	PFbQhYI/aKUw0EgCEGEx0VQk45NOl9bxvu9ZrbdgOX9LWPju07DLF/u6vMOX/9dIqit0Qmb/yFB
	YP68=
X-Received: by 2002:a05:620a:6015:b0:92e:7cc9:a888 with SMTP id
 af79cd13be357-9371e2cf759mr924864285a.2.1787188002133; Wed, 19 Aug 2026
 18:06:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
 <20260817-vhost-user-isolated-memory-v2-4-948aae960abb@gmail.com> <b6f79ec9-7842-47ff-b210-855036712547@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <b6f79ec9-7842-47ff-b210-855036712547@rsg.ci.i.u-tokyo.ac.jp>
From: Connor Kite <connorkite@gmail.com>
Date: Wed, 19 Aug 2026 18:06:30 -0700
X-Gm-Features: AcwNN1Vitk5XJi1kg1YAvcpdy9Kk9-83pUVn-HXmmhlZta59p0cOti38aI4rTGg
Message-ID: <CA+spn3rouMQ=yG1m2fS=vm40c-zWWMZPK+yk0K_ip5iXzLZWow@mail.gmail.com>
Subject: Re: [PATCH RFC v2 04/13] hw/virtio/vhost-shadow-virtqueue: used callback
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
	Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>, 
	20260817233147.2867623-1-connorkite@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 11:23=E2=80=AFPM Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
> > +
> > +                if (r < 0) {
> > +                    /* VQ or handler is broken. Do not set guest notif=
ier */
>
> This comment is extraneous. It is obvious that event_notifier_set()
> below is not called, and it is same with the existing error path below.
>
> What matters here is the difference with the existing error path. Why
> doesn't it call virtqueue_fill() nor virtqueue_flush()? They need to be
> addressed here.
>
> Regards,
> Akihiko Odaki
>

Here, apart from not calling event_notifier_set (not notifying the
guest), we are also not calling vhost_svq_enable_notification, so the
device is directed not to send any more call notifications.  If the
guest isn't receiving notifications, and the device isn't sending
them, is there a purpose to flushing the current element?  With the
current implementation, I'm not sure there is a path to re-enable
calls on either the front-end or back-end, but maybe a case could be
made that it's good hygiene to flush the known bad element?  For now,
I will add the calls to add and flush the element

Thank you!
Connor
