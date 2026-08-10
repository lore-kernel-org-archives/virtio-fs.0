Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45AA242D65
	for <virtio-fs@lists.linux.dev>; Mon, 10 Aug 2026 18:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786386881; cv=pass; b=M+vm5pOc1D2L/joUqfmm7vPHmYQ1PUENjcOlREkpJAiMFWFEjqv2xF8lxBC3LmnTyOBDZ7qei6Xbo8XsW8CTZU9bLZpKisPhZZRLmJneFe76+/r3+dlfygZdzC43CEPx2/espvLeYxjUC+U43i3od81/fZHG/k4kygsBaZIqWAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786386881; c=relaxed/simple;
	bh=2Sj1qjoiDR6glnLljc0DTqz969kd6edcLnopUN9nAUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I7eW+Q6mVk7LAP0LJstvA8QKC1mJntuXDwOfL+bRhWmm5fT5viS/exlN5MbLRIcZKPnSKfg4wZlpla/t0vhajQGl64cpr2Zuq84DZhNeOasm06IN2cDYxo9IK/rlB5nzBP9G5wktB1CqYcnvrUFpNPLonchOH1yLgVQpf6OKcFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qat2hvFJ; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qat2hvFJ"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5276d598b96so10631281cf.3
        for <virtio-fs@lists.linux.dev>; Mon, 10 Aug 2026 11:34:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786386879; cv=none;
        d=google.com; s=arc-20260327;
        b=Y23sn2RmMFJfx+U8r2YkZpQrypPYPrNoi/wICO+gRcQ+I3NhY8Scc7GKfiNl0Lolxb
         D35BmXp7pQrxP+QI9dVDcMs5xupqTozUrdndsWKx/dMcWiBZLOhP9aN5dEv7wanBHbzK
         Jb0VislzXPU5OKqq7FpBnTtY5YzysLwBQwORR3JgnR+wCvvpfAwDedQdjtKjrBKf3x6d
         Ig7iRn6S2DejhBkid4Ufkx1xA1d9uv4Zdg/nXh2IJ7Pz1WcTClwVXPd6h3rKYPnXytIu
         6v6M4Z0ry2bvYENPGaAa+VJsWCL/2imImodkGcGCD9i4sXtjXeqJqzAZzBzc0TdvbvmI
         Ybbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Hr6cihbYkqx29IWLF/1foWVc+mP+Em1bjQNfhGxCpaY=;
        fh=nm3kbUzPzlGnNTqHuyqRUpe/ugJ6gYz7AkTVIWbPEMs=;
        b=cgSyHyZ8zBn/hAsR3CCDwqFf10jtZxc2XWVYjCmdGymFEc1R6j4Srne+dG/Pdrl7Bb
         gBKbq0MAWNEhKN4yl6aiQUdSrlJ5zDqQtgwKX+5sgJkitJZVOzqt6DfxJiHcaJRANw8f
         dhk9qzwy12o0OLAffHZMD23PtCzSCb+ghFTysolTtYKENVMWnrHfLzgQlkggPhEW0BBP
         eRPs46YUjQTkyx73/a+xnNbWxARIW2AaDNMQDeIQKSFP1dhKkiPtKAVMAghE0tGSq1Q/
         d0v/aINmB9VHBenR+lxW05l4ldnSs7CC+/vHKXzusJa2OA6leqTZRHVkPisZIUJHhUtd
         3fQg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786386879; x=1786991679; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Hr6cihbYkqx29IWLF/1foWVc+mP+Em1bjQNfhGxCpaY=;
        b=qat2hvFJtD9hPDBWcpO/h5668bwyI7/kXyLTmmbt5kaX9ssJ/vgCTzBll4S1hMoC7/
         d+dnF69HMukF6pLxr4/R1ka7lH4h+V0duHIco8xpbC4uujO1v7DwS507CLIwt1J1/T/C
         7OuvE12osoQ+3JgDdhcL4yTcYJhqUTVZ2KubLXsMmAdnvpp8DbfcWGGkHJ6ILy5RpY/6
         i7ZCdK0qw1M5W1Dm6JHMR3/W/a/SVruh249ivUKGIHrOiBtJ7DgU+A14X8LIiAf0UnOy
         /zB4F1A4Q+OEpuu40dr7ljPqKpDThG782HFKnqQQJ51F0eFeUUZQn+W1cYFjw86+f6z9
         n3+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786386879; x=1786991679;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hr6cihbYkqx29IWLF/1foWVc+mP+Em1bjQNfhGxCpaY=;
        b=eUhSvdEjPMbQccZQkUOM5NfPCMvSTfIn4WW+82rGdJ3rIhfzH9VdkuyL1dVwX1JGDY
         RHJGCnD0kerIxVX/Wgx1sSFAXHX2g1FmZnp0hWln0uEfaMOp8+QMHetb+0DJD9Fb1WJV
         fVqfvrAtKgvcFapWanfX6CJ4nM6Ue+yo0g9q9r6LB0S3Ad601hICXTmkROINt59IPJeJ
         PU1rHsHCccXg67kZbbx1VXyxEHfuf5OzgsHCWsbfRvzJFVCO7DoQShgNxWoM0DjhgJWY
         wdBdakhYcqrXe1Jiffto/snJVIbJaU7jvseP2HiT6ufHEnVY7Fe8qmKJZavtaB0skUKr
         xtlQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp1ixJNcsbMKHrlZnq4wsRBpOUg51BgMJnXQbcpZdACL1ToWfjj4+3dmLizYYtD3WIWdWEn6ImrGx8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzcvoftn5VDkrAWq/BQTidCysEWcpPMtPVhonsbnwn0bo6bIBDP
	FEoRSU9EENS+J/+zHpWtFi/Gl0ucSVz1BIUoetvxtrdgk39LwntGy6I6mdpsp7SpNiZO3AptaOr
	uhWNNjX/xvjMRhYfPkc1dKmf8Qu1gIBI=
X-Gm-Gg: AR+sD12UuszloO2f75x1V84UGHuwttvXqKB+c4eygnTcVU3yje3++fAoYODqN8Iudla
	fLuLIFUUqm9+7eaPDL4uFglzf29g4KuyFZOWrFx07oKbLDtodXf36cxcev5ILEBc5xGBuPWLkzW
	yt0uteMkM8L2Pa4zX/kfRkKpJ3Aa+zWPYnYzjzPVqGxSlrD0c4luYn8eRO0KwIVHI6JFM9VQs+g
	jY49YqV29iC3aPc/RjFjLc25wJjqHY3yF+UcQXRzVujV6JQgud9M5ySb+1RABLEaUOzTwTSjrgZ
	sqWLI9TDRxXlCPl2WtXA47ck8EiSRGueHYVXG8nbAfDSFlz223d0t7SDnzixv3lteQhuEMLzqo+
	GNLc=
X-Received: by 2002:ac8:7f41:0:b0:519:ef86:127d with SMTP id
 d75a77b69052e-52d4bb91b9fmr43999341cf.18.1786386878572; Mon, 10 Aug 2026
 11:34:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-12-6b97c439eb28@gmail.com> <20260728191620.GJ371693@fedora>
In-Reply-To: <20260728191620.GJ371693@fedora>
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 10 Aug 2026 11:34:27 -0700
X-Gm-Features: AUfX_mx13giUuvX-hbDhUA3IfZr33kHhSI6mODwDcXgUvbs8e9uPSKvTAI5Wv70
Message-ID: <CA+spn3q+mgPhnHYmge7BOoZYrKnBQk-fjOx-woF4LsNPy_70Qw@mail.gmail.com>
Subject: Re: [PATCH RFC 12/15] hw/virtio/vhost-user: send isolation regions to device
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Milan Zamazal <mzamazal@redhat.com>, Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 12:16=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.c=
om> wrote:
>
> >
> > -__attribute__((unused))
> > +struct iova_tree_traversal_args {
>
> QEMU coding style:
>
>   typedef struct {
>       ...
>   } IOVATreeTraversalArgs;
>

...

Got it!  This is now fixed.

> > +    VhostUserMsg *msg;
> > +    struct vhost_user *u;
> > +    int *fds;
> > +    size_t *fd_num;
>
> This field is also used to index into msg->payload.memory.regions[], so
> "fd_num" is a misnomer. I suggest something like "region_idx" or just
> "idx".
>

I'll rename it to idx since it acts as an index to multiple arrays.

> > +};
> > +
> > +static gboolean vhost_user_iova_tree_traverse_funct(gpointer key,
> > +                                                    gpointer value,
> > +                                                    gpointer data)
> > +{
> > +    struct iova_tree_traversal_args *args =3D data;
> > +    struct vhost_memory_region msg_region;
> > +    VhostUserMemoryRegion region_buffer;
> > +    DMAMap *map =3D key;
> > +    args->fds[*args->fd_num] =3D args->u->iso_memory.iso_fd;
> > +
> > +    msg_region.guest_phys_addr =3D map->iova;
> > +    msg_region.memory_size =3D map->size + 1;
> > +    msg_region.userspace_addr =3D map->iova;
> > +    vhost_user_fill_msg_region_iso(&region_buffer, args->u, &msg_regio=
n);
> > +    args->msg->payload.memory.regions[*args->fd_num] =3D region_buffer=
;
>
> I'm confused by this code. VhostUserMemoryRegion region_buffer is the
> vhost-user protocol struct that is being filled in, but there is also a
> struct vhost_memory_region msg_region from the Linux kernel headers?
>
> msg_region and vhost_user_fill_msg_region_iso() make it harder to see
> what is going on. Can you open code the region_buffer struct field
> assignments instead?
>

I've consolidated this code significantly now.  Will delete
vhost_user_fill_msg_region_iso as it's logic has been incorporated in
the traversal callback.
