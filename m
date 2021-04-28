DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc:content-transfer-encoding;
	bh=hspDl4ilYQJm3YCqVfH3poxeWbfP/IepHQxmNhzct50=;
	b=REPk1zFc35K+dcaxwOa9seK+8Gw+dPVsyuFfaHicNbemTjD0bUzTiFDHqD6lrUG0hk
	4oqUrg8stHvjS1uMikJtAXbuIgOoVQ2y8kx/czQnApA1x16xm+dgIMGFFNmp3/0dSnKH
	i3u0Gmpb96Ql5M4V4iO6AdIk1o8dZPbqBFL4mAk7Ndg5ELteIfKfORidlSy6tm1Ip+WT
	BzmL1Vf+o2vQerbRzLG87JsKdlRbn+mnrU6ZVQhRxsqiEiSZXhOyA2NvsoQoZ0kMQcan
	BHQ6PnxMtlITyOwkGZlegGBmvhs3K556wxK76E6iAoNnnFjyqAZCkEy+a85QxrgV0pW3
	x+Mg==
MIME-Version: 1.0
References: <20210428144813.417170-1-philmd@redhat.com>
	<20210428144813.417170-2-philmd@redhat.com>
	<15dbfc38-f0ba-65f1-382c-3ce5b961f108@linaro.org>
	<e2f18183-2b7d-f7c1-b1a2-e624950c7627@redhat.com>
In-Reply-To: <e2f18183-2b7d-f7c1-b1a2-e624950c7627@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 28 Apr 2021 19:36:59 +0100
Message-ID: <CAFEAcA9L5R3RfbcJx+D3LMTWmT6+_-0kB9sAEm-GcmcBzKmzAQ@mail.gmail.com>
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
Cc: Thomas Huth <thuth@redhat.com>, "Daniel P . Berrange" <berrange@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, virtio-fs@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, Mahmoud Mandour <ma.mandourr@gmail.com>

On Wed, 28 Apr 2021 at 19:02, Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
> On 4/28/21 6:34 PM, Richard Henderson wrote:
> > I think the test should have been
> >
> >   if (have_system or have_tools) and
>
> Yes but virtiofsd is not a tool... It is a standalone binary.

This is not a distinction that our build/configure system
currently makes. We have three categories:
 * user-mode emulator binaries
 * system-mode emulator binaries
 * tools

where essentially a "tool" is "any binary we build that isn't
a QEMU binary proper".

If virtiofsd is genuinely not related to QEMU at all, what is
it doing in our source tree ?

thanks
-- PMM


