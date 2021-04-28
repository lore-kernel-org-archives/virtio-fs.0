DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc:content-transfer-encoding;
	bh=G/GbyKPkzgDTapgT1IsYa8jdWyNgQMx80EFgYzhgjPA=;
	b=YjzcrlpfUfueB69qdqSLD1pb6m6MVejw28untXHSWpvgvjfenxRvx2Oat0Hz+robsG
	FWNktzyj9L6OcoJfcgQkVPuzW3OwhYqw+2hBfXSqx7wzyt5628F9cu65MuDjalk+F+cd
	BGuquPi8ojEIneY/axCPFYQ7Q+ibO9lVOBL4JfTYASMmF89+I5WUWJxK+TLjC6HjDjYQ
	uMycU0zmbmZpqJpvo8dXPzJxTR2M0VCx3lZqKt9ftkcD+tDO+ggi08YfmlTKo3inzBp8
	lcZnIUEiaRp6rTeutVrEREeK8XUw+9mccADtepTqMwWMbr0WQANPOeSnK2XH/kyPEc20
	tQlg==
MIME-Version: 1.0
References: <20210428144813.417170-1-philmd@redhat.com>
	<20210428144813.417170-2-philmd@redhat.com>
In-Reply-To: <20210428144813.417170-2-philmd@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 28 Apr 2021 16:06:42 +0100
Message-ID: <CAFEAcA9chk8aEqe0jrYQouF0=UpznTrR+J8puVgNvf1VipPm2A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
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
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>, "Daniel P . Berrange" <berrange@redhat.com>, QEMU Developers <qemu-devel@nongnu.org>, virtio-fs@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, Mahmoud Mandour <ma.mandourr@gmail.com>

On Wed, 28 Apr 2021 at 15:55, Philippe Mathieu-Daudé <philmd@redhat.com> wrote:

(cc'ing Paolo for a meson.build question below...)

> When not explicitly select a sysemu target and building virtiofsd,
> the seccomp/cap-ng libraries are not resolved, leading to this error:
>
>   $ configure --target-list=i386-linux-user --disable-tools --enable-virtiofsd
>   tools/meson.build:12:6: ERROR: Problem encountered: virtiofsd requires libcap-ng-devel and seccomp-devel
>
> Fix by checking the seccomp/cap-ng libraries if virtiofsd is built.
>
> Reported-by: Mahmoud Mandour <ma.mandourr@gmail.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  meson.build | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/meson.build b/meson.build
> index c6f4b0cf5e8..b466b418fed 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -393,14 +393,14 @@
>  endif
>
>  seccomp = not_found
> -if not get_option('seccomp').auto() or have_system or have_tools
> +if not get_option('seccomp').auto() or have_system or have_tools or not get_option('virtiofsd').auto()
>    seccomp = dependency('libseccomp', version: '>=2.3.0',
>                         required: get_option('seccomp'),
>                         method: 'pkg-config', kwargs: static_kwargs)
>  endif
>
>  libcap_ng = not_found
> -if not get_option('cap_ng').auto() or have_system or have_tools
> +if not get_option('cap_ng').auto() or have_system or have_tools or not get_option('virtiofsd').auto()
>    libcap_ng = cc.find_library('cap-ng', has_headers: ['cap-ng.h'],
>                                required: get_option('cap_ng'),
>                                kwargs: static_kwargs)

Now we have "virtiofsd requires cap-ng and seccomp" recorded in three
places in different meson.build files:
 * here, if this patch goes in
 * in tools/meson.build, in its logic for setting have_virtiofsd
   (I generously do not count the "decide which error message to print"
   logic in that file as a separate item in this list...)
 * in tools/virtiofsd/meson.build, where the executable('virtiofsd', ...)
   lists them in its dependencies: setting

Is there some way to avoid this duplication?

thanks
-- PMM


