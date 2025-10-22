Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BC22FB0B2
	for <virtio-fs@lists.linux.dev>; Wed, 22 Oct 2025 08:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761120588; cv=none; b=um+yOxw8RDq+ncFxh2csxVE5CaCnK6Yy/Tnpet19OyIowefLAzjFTCjSSuzg8RVvKfQYyoOjWbCM7D9OsUkQqjdYEHXUiWXCpc/+MJMXLnhcMMXFxHRmfnV6KJcMqs28IhkDPshVE0Mjnh2L40sVTuEg4I+xy+pY/+PBGG6JECQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761120588; c=relaxed/simple;
	bh=JZGioFCRnZhnVYXnYyEgwnlO0wpgmU74OVJ3g/yF9Fg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ejYBOvHp20XIGa4NYWBqh4G6kHO8Mt0ZX6VfnRXfwZYRMHglD/AYA3tyz/XLO8VlcGoFR72fNluWYhTCKG1s0kOLyPyY7snPXdTuzyoHWdT7IoEqJrxgPBOXTefvTR6pzPjjaBSUkGF0VI4FwHN0DiN3CX04Qre11i6jKlkcKvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mojlTO1p; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mojlTO1p"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4711810948aso45686475e9.2
        for <virtio-fs@lists.linux.dev>; Wed, 22 Oct 2025 01:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761120585; x=1761725385; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r5W3vw0dKWSTSqpjqiTpD1sBd7qgaB5sDy0DD3Bgxoo=;
        b=mojlTO1pHGHIvSV0+Fda2Zo9NYaxfeEN9rkW6r7gGhcoXLS4+7dqpSyakzCF4+u6Bj
         49GEuInfomZbH4mxcNuRh1jJwSYIU+HLE2vB0EUsugytMGHWHHO/LtQB/CNs+rHArtXU
         v4bJ7zNuy5WS4PtCo8WUGgvthZTREGaoxCwkDi3+o6ngHGxA4JP6H55ErKQx5kzIfMmP
         tyCoudZ4+t/6rgVh63O62B40+l2ui+5XkXhhjoKVSnSEiBadncFB+wokcP/MZkqKEyu2
         cVbjPzkIGrj2CboZHXO+max8hckt955962kBy2sloC2GCKEfb7yf8A9OH27agygVI5iP
         REPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761120585; x=1761725385;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r5W3vw0dKWSTSqpjqiTpD1sBd7qgaB5sDy0DD3Bgxoo=;
        b=j2iPImpUCfderuh/14uUvrYqhDtOnwwAEXh8kwPFq/8/62AYCoNJ006ioBqNJqbW76
         VromoZBl0T6ZQkhKLu3jk/irjV2j6zfMLiyrfrszw/PYuTRsU8vtaWWYKHuQbghyZhmv
         DFeXPTJ9ac94Z4u6GxVeGyJtHWFlAXYvrZkOrN8x3+YfaMZtpI2z3BtX4XdlxWrJZlb0
         ENQWJ1WzFp13Tt4xmZAtCCTHeOA/ZzUDP25ZxxUll1ud81UXtnWzn+bFrk6AL0ZI6hJO
         hoxLKrLCoCTn9QytBlpm5Vhimd3egWM4YtFwovjP4LvGIzyhzYJqwwgJAHdjNWmWOgZQ
         rDyQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmiePZzz6HVedTJXWLbyskckq9TUaPINXyEZvhBPTE/DT/Fr7QHltvzl43cuNB26PYyfkWw1GngY8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCWvuiwulbhgNGpphiDvcuwP7X448ZgL6jC7Fu4jvQSfFBOkpD
	QtuRroXVjmbme/sPnVQXEkQxn1WVRr0a0Lu5MBHgpwgaEKOrEZOB83d05+Jgdh6K7W4=
X-Gm-Gg: ASbGncucuLszGOQKgV7NQ0kUJt//ZPfqsNv8bJaVBxGQ0RWi4IyRcd53pGakizeAPy6
	LFIT5XmZGdl8mbSasMRYWkNw17mSGmM8D3tKEVJ24K9PG6aIrU7SIzUuPgZTD66PykQb/VN7fjb
	F1Iz4EaMo/TqMQ2MkeQRFFAliBGnmtbf49BN/lDshf94Ce+m/rMsqo3LMOMvoeQUDv43SIcneGk
	1qLSXKUQj7kksnbQyEzIUPXQOgY0RLp7tKPmQQlivrbrJiNVfI3lsQkuU3/XpBZv84CF4o7PfD3
	tnzqF7BPLx3N2QOY5h/oE9/IlZ4RWZJNBVlZusb3SieS/lEdkeD/t8ndVvU3UadweSRDBvm1UYf
	pca/WtDl0rjowrOkapx6yolpV02xjaoWyIcRVVFZDvOcZCkrI4u9LbTleRptp+6v0gEAs0r0c2V
	fZ0dqKWBOhYrNR/dkQZfNsGB8QSmmHC+bJr2tZOPKziOG9qCWLE+ez3WDDJDgOy32K
X-Google-Smtp-Source: AGHT+IG5BpeXiJ6nHMocdx8fLCUYDlkFMY0PuWuFCGQMHFAZ8n3dQ7nToTymecUtEebWDB9IZS4Cfw==
X-Received: by 2002:a05:600c:3149:b0:470:bcc4:b0a0 with SMTP id 5b1f17b1804b1-47117925919mr168171395e9.34.1761120584565;
        Wed, 22 Oct 2025 01:09:44 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00b985esm24733044f8f.34.2025.10.22.01.09.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 01:09:43 -0700 (PDT)
Message-ID: <36b8e200-10ab-48b0-beda-9ca2c42f2b48@linaro.org>
Date: Wed, 22 Oct 2025 10:09:40 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] char: rename CharBackend->CharFrontend
Content-Language: en-US
To: marcandre.lureau@redhat.com, qemu-devel@nongnu.org
Cc: "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 Zhenwei Pi <pizhenwei@bytedance.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Laurent Vivier
 <lvivier@redhat.com>, Amit Shah <amit@kernel.org>,
 Stefan Berger <stefanb@linux.vnet.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Peter Maydell <peter.maydell@linaro.org>,
 Igor Mitsyanko <i.mitsyanko@gmail.com>, =?UTF-8?Q?Cl=C3=A9ment_Chigot?=
 <chigot@adacore.com>, Frederic Konrad <konrad.frederic@yahoo.fr>,
 Alberto Garcia <berto@igalia.com>, Thomas Huth <huth@tuxfamily.org>,
 Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Jason Herne <jjherne@linux.ibm.com>,
 Yoshinori Sato <yoshinori.sato@nifty.com>,
 Magnus Damm <magnus.damm@gmail.com>, Nicholas Piggin <npiggin@gmail.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 "Collin L. Walling" <walling@linux.ibm.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Alistair Francis <alistair@alistair23.me>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Richard Henderson <richard.henderson@linaro.org>,
 Helge Deller <deller@gmx.de>, Corey Minyard <minyard@acm.org>,
 Paul Burton <paulburton@kernel.org>, Aleksandar Rikalo <arikalo@gmail.com>,
 Aurelien Jarno <aurelien@aurel32.net>, Palmer Dabbelt <palmer@dabbelt.com>,
 Weiwei Li <liwei1518@gmail.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Samuel Thibault <samuel.thibault@ens-lyon.org>,
 Michael Rolnik <mrolnik@gmail.com>, Antony Pavlov <antonynpavlov@gmail.com>,
 Joel Stanley <joel@jms.id.au>, Vijai Kumar K <vijai@behindbytes.com>,
 Samuel Tardieu <sam@rfc1149.net>, Gustavo Romero
 <gustavo.romero@linaro.org>, Raphael Norwitz <raphael@enfabrica.net>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 "reviewer:vhost-user-scmi" <mzamazal@redhat.com>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Dmitry Osipenko <dmitry.osipenko@collabora.com>,
 Fabiano Rosas <farosas@suse.de>, Markus Armbruster <armbru@redhat.com>,
 "Dr. David Alan Gilbert" <dave@treblig.org>, Zhang Chen
 <zhangckid@gmail.com>, Li Zhijian <lizhijian@fujitsu.com>,
 Jason Wang <jasowang@redhat.com>,
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
 Max Filippov <jcmvbkbc@gmail.com>, Lukas Straub <lukasstraub2@web.de>,
 "open list:Sharp SL-5500 Co..." <qemu-arm@nongnu.org>,
 "open list:S390 SCLP-backed..." <qemu-s390x@nongnu.org>,
 "open list:sPAPR (pseries)" <qemu-ppc@nongnu.org>,
 "open list:X86 Xen CPUs" <xen-devel@lists.xenproject.org>,
 "open list:RISC-V TCG CPUs" <qemu-riscv@nongnu.org>,
 "open list:virtiofs" <virtio-fs@lists.linux.dev>,
 "open list:Rust-related patc..." <qemu-rust@nongnu.org>
References: <20251022074612.1258413-1-marcandre.lureau@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251022074612.1258413-1-marcandre.lureau@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 22/10/25 09:46, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> The actual backend is "Chardev", CharBackend is the frontend side of
> it (whatever talks to the backend), let's rename it for readability.
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> ---
>   chardev/chardev-internal.h           |  12 +-
>   include/chardev/char-fe.h            |  67 +++++----
>   include/chardev/char.h               |   4 +-
...

> diff --git a/chardev/chardev-internal.h b/chardev/chardev-internal.h
> index 9752dd75f7..8ea10414ab 100644
> --- a/chardev/chardev-internal.h
> +++ b/chardev/chardev-internal.h
> @@ -37,9 +37,9 @@
>   struct MuxChardev {
>       Chardev parent;
>       /* Linked frontends */
> -    CharBackend *backends[MAX_MUX];
> -    /* Linked backend */
> -    CharBackend chr;
> +    CharFrontend *frontends[MAX_MUX];
> +    /* frontend of the underlying muxed chardev */
> +    CharFrontend chr;
>       unsigned long mux_bitset;
>       int focus;
>       bool term_got_escape;
> diff --git a/include/chardev/char-fe.h b/include/chardev/char-fe.h
> index 8ef05b3dd0..7901856f95 100644
> --- a/include/chardev/char-fe.h
> +++ b/include/chardev/char-fe.h
> @@ -8,12 +8,12 @@ typedef void IOEventHandler(void *opaque, QEMUChrEvent event);
>   typedef int BackendChangeHandler(void *opaque);
>   
>   /**
> - * struct CharBackend - back end as seen by front end
> + * struct CharFrontend - Chardev as seen by front end
>    * @fe_is_open: the front end is ready for IO
>    *
>    * The actual backend is Chardev
>    */
> -struct CharBackend {
> +struct CharFrontend {
>       Chardev *chr;
>       IOEventHandler *chr_event;
>       IOCanReadHandler *chr_can_read;
> @@ -27,53 +27,52 @@ struct CharBackend {
>   /**
>    * qemu_chr_fe_init:
>    *
> - * Initializes a front end for the given CharBackend and
> - * Chardev. Call qemu_chr_fe_deinit() to remove the association and
> - * release the driver.
> + * Initializes the frontend @c for the given Chardev backend @s. Call
> + * qemu_chr_fe_deinit() to remove the association and release the backend.
>    *
>    * Returns: false on error.
>    */
> -bool qemu_chr_fe_init(CharBackend *b, Chardev *s, Error **errp);
> +bool qemu_chr_fe_init(CharFrontend *c, Chardev *s, Error **errp);

IMO even clearer for this API would be to use:

   bool qemu_chr_fe_init(CharFrontend *fe, Chardev *be, Error **errp);

and update documentation accordingly.

>   
>   /**
>    * qemu_chr_fe_deinit:
> - * @b: a CharBackend
> + * @c: a CharFrontend
>    * @del: if true, delete the chardev backend
>   *
> - * Dissociate the CharBackend from the Chardev.
> + * Dissociate the CharFrontend from the Chardev.
>    *
>    * Safe to call without associated Chardev.
>    */
> -void qemu_chr_fe_deinit(CharBackend *b, bool del);
> +void qemu_chr_fe_deinit(CharFrontend *c, bool del);
>   
>   /**
>    * qemu_chr_fe_get_driver:
>    *
> - * Returns: the driver associated with a CharBackend or NULL if no
> + * Returns: the driver associated with a CharFrontend or NULL if no
>    * associated Chardev.
>    * Note: avoid this function as the driver should never be accessed directly,
>    *       especially by the frontends that support chardevice hotswap.
>    *       Consider qemu_chr_fe_backend_connected() to check for driver existence
>    */
> -Chardev *qemu_chr_fe_get_driver(CharBackend *be);
> +Chardev *qemu_chr_fe_get_driver(CharFrontend *c);
>   
>   /**
>    * qemu_chr_fe_backend_connected:
>    *
> - * Returns: true if there is a chardevice associated with @be.
> + * Returns: true if there is a backend associated with @c.
>    */
> -bool qemu_chr_fe_backend_connected(CharBackend *be);
> +bool qemu_chr_fe_backend_connected(CharFrontend *c);

LGTM otherwise!
