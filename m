Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0076440756E
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 12:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785760031; cv=none; b=Q6NAQlTInxGMkT2IWSSKC3beohiNgfjnHmUTbogyLCCuIuky9GoJdBmZJD+/NqnrLOm/p1PDyY3yX32CAoYyO67mUDAJFZUrZ7mUQ13iG34OjEV5AAGtYvfOslBinENkcrw4qwBaBUj8dSuI48O/FXwmzuL/1vP/guy707Sfq8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785760031; c=relaxed/simple;
	bh=KkQC0kXuQLRO1jWE2WefKNwq2nBfBpq+52wP02Ln3s0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ebHXWIqm+N6CN1cxp7aDDnMqUyDlJMYcO6fRAog/rR8BTiPdAJgW0p8apTUM2ia/weajBltIXNoub5J7SzlVejJqCizGEGv0UQ5tQkcdJS/GDLYtw8MaP3ARc58IGilJFRsE/IWxM4Z3CU/EBus3+9+FCYkKhq5+FUNnVZq1DMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MxIPKFQ9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MxIPKFQ9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785760027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kI4s89XDYGPNsnyejJHNkn52INgL7JiA8hxwCbXttYM=;
	b=MxIPKFQ9TTDnwl8CHx+OMbO0Yl8WFX0MLAM+aLDMnVHiDtjFxBPkZFKTcUf7HZ+WA1kiWV
	fnaht6JKyolXVNI6MgHn6TT/pHd7rBj7QRlhrqhqJ/mYbDtyDZI6fLHfLG6aowKuDiVxPF
	5SEnNPE3RtjOjOOn0VQUCFPQhNEAJ80=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-jNU4mV2LM7WLUCGFIvpZUg-1; Mon, 03 Aug 2026 08:27:06 -0400
X-MC-Unique: jNU4mV2LM7WLUCGFIvpZUg-1
X-Mimecast-MFC-AGG-ID: jNU4mV2LM7WLUCGFIvpZUg_1785760025
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4740be00302so3207592f8f.2
        for <virtio-fs@lists.linux.dev>; Mon, 03 Aug 2026 05:27:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785760025; x=1786364825;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kI4s89XDYGPNsnyejJHNkn52INgL7JiA8hxwCbXttYM=;
        b=q+yHWdrdNIG+uRZWlPUtsf9c3sKJHDyidXpZm9lYwO1GMbTI9/d6JxFiyiBiWFFZPx
         UWS8i8hVmkJCKYmcKJVzW4vudYTAcj7yBZ9XtIlS6LugBdE0fF8bQhwgwUoqvR7JIAJz
         X7dJo4+8ivHmjVog1mOnoisH5M5W7vlrXtEb6/F21FreOKK/FmfnHH7WzUru3ihgEJLC
         geuNTn3vVNzArrQ9FHDE+3fC2f8NGKTVWUkdQwJKRdjgdQ1X3a2oGdjwQuIt9WIcjWRU
         FPNtob1phAncBPZ1KiZYfWjdXcHzfhK+kqLHvSatobSNLQC8b5M9ffG2T+SHFe+5BJHX
         pgMQ==
X-Forwarded-Encrypted: i=1; AHgh+RrziAvmmrr+GT9s7vZ/1EBIt1XynroJiIviabarOpXC719XlNj4R+8bsSxK9UIQtiOpunCypFzP8OU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQgKYUneBfsT8HCdVr+j134r2sDdaJZZ6NW1n0NTKww9rLciOj
	jrAdIgS9fP/sNXkAxLboWsjiKWRV6YqTmYCPS7OXHq3uxJ6V+LXkTPRYnLDLz4Hg/A9RdWFTjDP
	2p9UZMvmqz9Np6waHCia2HAiOigqE0j7PZEKxHLYC2I08wph6iBzPU502HPgD2A==
X-Gm-Gg: AR+sD10VkLXaPDkfty4OMUku3gcAOlLnG7P1/4aQEuaf+yK8aJFIy+fgpj2+hgGp2t0
	1crlbQctZOcfXPuk90WoGB4NofTxFHwCuSOGMm8BJgGIHjXhdbzSr0E53h6B3/BisYFHMjTc//F
	MLPoMIMo3QwHJZUwfJpCfU0AqkbyYG2YvschzwsL0AsgFEG/NEwL047dQsxkI/pwxNIO1E0m1AT
	Kq3JSTy0aXgpKriu3MpMwadv6UDX88zOCso+4J1N04Ccp+J1T2z/8f6eqyXzDd6v6izjn9cIcFf
	KHjcQ2ALeBxz47XPlQWW4ZNBSzxJzWaZWxsDIcJIIlGxU4Br260dO9ymz1BlAYXSqVGXtT1Nmh2
	bmPCSn9NLSZt9UGvElRamnl3xlwKalL/9Iuyqlit7ZAMfWscCFEHk9dLE3294Q3FP32MN8dJcoJ
	6iJYMYHBdQ1GojsfljRcImjejbsXC40Q==
X-Received: by 2002:a05:6000:43d4:10b0:47f:90df:4ec6 with SMTP id ffacd0b85a97d-47fd72a00bemr21145793f8f.6.1785760024861;
        Mon, 03 Aug 2026 05:27:04 -0700 (PDT)
X-Received: by 2002:a05:6000:43d4:10b0:47f:90df:4ec6 with SMTP id ffacd0b85a97d-47fd72a00bemr21145611f8f.6.1785760024284;
        Mon, 03 Aug 2026 05:27:04 -0700 (PDT)
Received: from ?IPV6:2003:cf:d73d:549a:e584:7c7b:2611:32a1? (p200300cfd73d549ae5847c7b261132a1.dip0.t-ipconnect.de. [2003:cf:d73d:549a:e584:7c7b:2611:32a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd45a0ae0sm33696154f8f.33.2026.08.03.05.27.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 05:27:03 -0700 (PDT)
Message-ID: <6f915ae4-f9b7-4e27-9c3a-3a99917b499f@redhat.com>
Date: Mon, 3 Aug 2026 14:27:01 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 04/15] net/vhost-user: add memory isolation
To: Connor Kite <connorkite@gmail.com>, qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
 Haixu Cui <quic_haixcui@quicinc.com>, Raphael Norwitz <rnorwitz@nvidia.com>,
 Kevin Wolf <kwolf@redhat.com>,
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
 <20260723-vhost-user-isolated-memory-v1-4-6b97c439eb28@gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-4-6b97c439eb28@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: G9888wktSzUzmfQ5rFn6e4KMRbhv8x_jtWSOLYnWhWY_1785760025
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 24.07.26 00:30, Connor Kite wrote:
> Add a memory-isolation property to NetdevPassOptions and
> NetDevVhostUserOptions in net.json.  This property will
> be used for vhost-user devices to disable access to guest
> memory from devices.
>
> It will be passed into vhost_user_init() in a future patch.
>
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   net/passt.c      |  7 +++++++
>   net/vhost-user.c |  4 ++++
>   qapi/net.json    | 15 +++++++++++----
>   3 files changed, 22 insertions(+), 4 deletions(-)

[...]

> diff --git a/qapi/net.json b/qapi/net.json
> index 1a6382825c..4588c7014b 100644
> --- a/qapi/net.json
> +++ b/qapi/net.json
> @@ -213,6 +213,9 @@
>   #
>   # @param: parameter to pass to passt command
>   #
> +# @memory-isolation: enable memory isolation.  Only has effect if
> +#     using vhost-user.  (default: false)
> +#
>   # Since: 10.1
>   ##
>   { 'struct': 'NetdevPasstOptions',
> @@ -250,7 +253,8 @@
>       '*ipv6':               'bool',
>       '*tcp-ports':          ['PasstPortForward'],
>       '*udp-ports':          ['PasstPortForward'],
> -    '*param':              ['PasstParameter'] },
> +    '*param':              ['PasstParameter'],
> +    '*memory-isolation':   'bool'},
>       'if': 'CONFIG_PASST' }

I have a gut feeling there ought to be a better way to add an option the 
only works for vhost-user, but maybe not. I certainly don’t have a 
constructive suggestions. :)

(Apart from that, my only comments would be the QAPI “since” field 
missing, as Markus noted on the previous patch, and the patch ordering 
Stefan has noted.)

Hanna

