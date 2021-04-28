DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
	h=subject:to:cc:references:from:message-id:date:user-agent
	:mime-version:in-reply-to:content-language:content-transfer-encoding;
	bh=4LZEHcMxypBZR5IOssG2yDi20GGzjiqgvJHoLZbj4x4=;
	b=X2SdtEzgpeNS+Zno1KPUeevXFfuPf3K4BMKd5KDfYQMCofVrETTM6H7+nqy9YwZuz5
	FHPNgbXqgW3M4oTkilaz27l3yq1iVCs4wRSuzjx+G/9cURRd6809IwEKYKaC4PICEi55
	U/8SLWZISyYJbx1jYUOtjGd/NzEehUIMxp6GdG8vYyluO1i1i7I0TjXfR92byLqiBAVT
	phZ8aWkPGm+faEwWN6ik4X4+Ca3lzjXF5uNpDR/To4W1mQdv/RV2F631n6Z54DVmuPPM
	aUE4he50XQpsngQoxwhiqGgG6FbvcYC6+kJ/37q2P+DA7Ui2MDlhnkHG6qOW7H6qc0I3
	EQEw==
References: <20210428144813.417170-1-philmd@redhat.com>
	<20210428144813.417170-2-philmd@redhat.com>
From: Richard Henderson <richard.henderson@linaro.org>
Message-ID: <15dbfc38-f0ba-65f1-382c-3ce5b961f108@linaro.org>
Date: Wed, 28 Apr 2021 09:34:56 -0700
MIME-Version: 1.0
In-Reply-To: <20210428144813.417170-2-philmd@redhat.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 1/2] meson: Check for seccomp/cap-ng
 libraries if virtiofsd is enabled
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

On 4/28/21 7:48 AM, Philippe Mathieu-Daudé wrote:
>   seccomp = not_found
> -if not get_option('seccomp').auto() or have_system or have_tools
> +if not get_option('seccomp').auto() or have_system or have_tools or not get_option('virtiofsd').auto()
>     seccomp = dependency('libseccomp', version: '>=2.3.0',
>                          required: get_option('seccomp'),
>                          method: 'pkg-config', kwargs: static_kwargs)

This construct is wrong, both before and after, as I read it.

not get_option(foo).auto() is true for both enabled and disabled.  If disabled, 
why are we examining the dependency?  If auto, if we have all of the 
dependencies we want to enable the feature -- if we don't probe for the 
dependency, how can we enable it?

This error seems to be offset by the OR have_* tests, for which the logic also 
seems off.

I think the test should have been

   if (have_system or have_tools) and
      (not get_option('seccomp').disabled() or
       not get_option('virtiofsd').disabled())

Then we need to combine the required: argument, probably like

   required: get_option('seccomp').enabled() or
             get_option('virtiofsd').enabled()


r~

