DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc:content-transfer-encoding;
	bh=fbgKVoqPrGeZr09GqzdDJ4xjYjy3lHJup36G5PNONYI=;
	b=Nvy14FBSHik1RreB+ywTb+R9jpiba8wnNe/avsLOXLagvPFC8+ICiAhkyIS3e80Ps7
	u3vMtnkRU30/tBriQ9tbI30eyEJARNduVjz9pJ8Y/B53UKRHpCquciInpitSjYBdtdvh
	Z2sgIEagiqAuKPp/tJO6S0zERkoIU5mYxCaWMXcsvEVhFBz/8I404qPh3wzScy+bNbXR
	ShXWbfz6mWy7VfKoaPLmwlNpeq8kPQYDPej7XISuQ+yrJL6vFVoBmhVtcT+dOO7G2shs
	0IeZU6RU9Kdt83X7oU/TDkBz/41O80eLN5iQ0JF2uGJCHAVW9DEt1CKEZkvVr98Rila7
	V4NQ==
MIME-Version: 1.0
References: <20210428144813.417170-1-philmd@redhat.com>
In-Reply-To: <20210428144813.417170-1-philmd@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 28 Apr 2021 16:15:44 +0100
Message-ID: <CAFEAcA9_5C4sLwb-MXwg-yCgN+Esb0mop=baCv5kgoW58UPQzA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Meson build fixes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>, "Daniel P . Berrange" <berrange@redhat.com>, QEMU Developers <qemu-devel@nongnu.org>, virtio-fs@redhat.com, Mahmoud Mandour <ma.mandourr@gmail.com>

On Wed, 28 Apr 2021 at 15:53, Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
>
> A pair of fixes to allow building virtiofsd without sysemu/tools.
>
> Should this configuration be tested in CI?

Does the configuration make sense to support? I thought
virtiofsd was only of use with system emulation ?

thanks
-- PMM


