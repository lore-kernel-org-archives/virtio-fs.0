DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=54GpJGtyR145B33wSc2aV8lkBniVUGl7MaAv9knKJaM=;
	b=ao6lXMFUyEuLaIQtE0Ex90m6Gchh76LuEuWnbYuJbE5d+s1t186JQWw8Vz0Dzdq7Vz
	EM28Ne0PtK7P6ZapukBL/sRH+Z5W399f61CYdH7MR2/7Ty+wZcJPd5VlB3Rg1EvSNJLk
	zg5hB0vBqm0upMCdkPZ/JnNFVYWIjH1aRpniHX3ioe+REF9wkRMkWmvo2rAKV2abVEhV
	58bSqXW29HhUHsXjn3awSnM0f6OkM6EbdIT15HuF1ilfFCFkSU9wd6T8cLpVCXRuM8km
	173qKylDiNSgQio54p8tFFT14FhG09WwU+orCyc1dyDhgQt1fAkS0t9AR5TKlVyR99ew
	Va8A==
MIME-Version: 1.0
References: <20220209165040.56062-1-dgilbert@redhat.com>
In-Reply-To: <20220209165040.56062-1-dgilbert@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 9 Feb 2022 20:47:49 +0000
Message-ID: <CAFEAcA-JwQDQWQcY7tNSOb5LS8FNBjFi-msTyxUyV_q=OymXaw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] Deprecate C virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

On Wed, 9 Feb 2022 at 16:57, Dr. David Alan Gilbert (git)
<dgilbert@redhat.com> wrote:
>
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>
> There's a nice new Rust implementation out there; recommend people
> do new work on that.
>
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  docs/about/deprecated.rst | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
> index 47a594a3b6..3a0e15f8f5 100644
> --- a/docs/about/deprecated.rst
> +++ b/docs/about/deprecated.rst
> @@ -454,3 +454,17 @@ nanoMIPS ISA
>
>  The ``nanoMIPS`` ISA has never been upstreamed to any compiler toolchain.
>  As it is hard to generate binaries for it, declare it deprecated.
> +
> +Tools
> +-----
> +
> +virtiofsd
> +'''''''''
> +
> +There is a new Rust implementation of ``virtiofs`` at

I guess there's a missing "d" here ?

> +``https://gitlab.com/virtio-fs/virtiofsd``;
> +since this is now marked stable, new development should be done on that
> +rather than the existing C version in the QEMU tree.
> +The C version will still accept fixes and patches that
> +are already in development for the moment.

thanks
-- PMM

