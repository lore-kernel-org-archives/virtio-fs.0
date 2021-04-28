DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
	h=subject:to:cc:references:from:message-id:date:user-agent
	:mime-version:in-reply-to:content-language:content-transfer-encoding;
	bh=iVSVHhA9vb7hyg4ixCNUXcIqNKVHe/Df9cZogeilUfA=;
	b=RUKlpVcvuaXJ/p0q49U5T7rJ2MF6NsebYL52bbcKk1MsabpxkL8vdoFkSRb7z9hH8p
	TXC9zv3Dof9NIA0N2u7obgd2pDm0PwleaHAPDYofhJaI8k+mhBH0JFKmUK32yTzTu9me
	kSL1kOqi1JUg+KzUxOTCd+Ve31OannJLo8auybR6OKwiWAJMWZp1LVsy8LQ6ERZzy/i8
	6LZU4VXV2Ur1FIsGOhjvEAjKj19Y6RgR5jtYzd8UwPDvjX8skkVuZ3vIUYN/RWd4mEbL
	xEaHHCCMTWSCujvoxNIPFJiR69ESiNEu+aJ+k6/HoKnKeR902As9yx+dsYunnNB/IPKE
	WwiQ==
References: <20210428144813.417170-1-philmd@redhat.com>
	<20210428144813.417170-3-philmd@redhat.com>
	<e06f3f24-9ff2-bf3c-91c4-178af60c6c59@linaro.org>
	<160e4c85-e8c0-304d-7151-1040f8d310ba@redhat.com>
From: Richard Henderson <richard.henderson@linaro.org>
Message-ID: <a4dabeaf-4df8-2779-f028-3d135fe84bef@linaro.org>
Date: Wed, 28 Apr 2021 12:24:20 -0700
MIME-Version: 1.0
In-Reply-To: <160e4c85-e8c0-304d-7151-1040f8d310ba@redhat.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 2/2] util/meson: Build
 iov/hexdump/buffer_is_zero with virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>, qemu-devel@nongnu.org
Cc: Thomas Huth <thuth@redhat.com>, "Daniel P . Berrange" <berrange@redhat.com>, virtio-fs@redhat.com, Mahmoud Mandour <ma.mandourr@gmail.com>

On 4/28/21 10:56 AM, Philippe Mathieu-Daudé wrote:
> Are you suggesting to remove the 'if have_block' check? This makes build
> a the files pointlessly for user-mode-only builds...

But since the objects are not included in the binary, I don't care.

The build system is already too complex, and building a couple of extra small 
files makes only milliseconds of difference.


r~

