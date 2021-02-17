DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=JnRiIQa/xqD86XgiFLKEbX1OcI+MqgFHAAoNBHUPRXU=;
	b=oSHaGAtmKD3bdwF/gSpntcgSiPeKzA02Q5/5EPrQycxeEBrraX/7wU7V7G3voCaUeV
	15L3r3ZaxC1gjL4k5l4rB5u8IYs5Op5wwyYMqxH5Dm0h4cY7cDpGj35a8pm/TC5J/F85
	TABwKg8A01zP3F2RCS0+YBP7Him3DxYf3QJWj5PZZ51vTTi12wBlgrADFutTCa7ld1qT
	lxZdBEGv+4sw5+6zCIDo+vqSXafy3immNpJuZI308rKPLlcj5b1Qye6QiKUe6mswqmfu
	ifaiGZ0ruYpKhW2nC4XVC2YaboNee4N1wcti7PfKPIwHQZL3jyqqrKAGFJ9qTi44HSGW
	mxMg==
MIME-Version: 1.0
References: <20210216183734.57810-1-dgilbert@redhat.com>
In-Reply-To: <20210216183734.57810-1-dgilbert@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 17 Feb 2021 19:18:21 +0000
Message-ID: <CAFEAcA9wzrta4Us2kdWe6x2XMHuF60uVU3qGFzpL98LrYVEZUw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PULL 0/6] virtiofs queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: QEMU Developers <qemu-devel@nongnu.org>, Wainer dos Santos Moschetta <wainersm@redhat.com>, virtio-fs@redhat.com, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>, vgoyal@redhat.com

On Tue, 16 Feb 2021 at 18:45, Dr. David Alan Gilbert (git)
<dgilbert@redhat.com> wrote:
>
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>
> The following changes since commit 18543229fd7a2c79dcd6818c7b1f0f62512b5220:
>
>   Merge remote-tracking branch 'remotes/cleber-gitlab/tags/python-next-pull-request' into staging (2021-02-16 14:37:57 +0000)
>
> are available in the Git repository at:
>
>   https://gitlab.com/dagrh/qemu.git tags/pull-virtiofs-20210216
>
> for you to fetch changes up to 26ec1909648e0c06ff06ebc3ddb2f88ebeeaa6a9:
>
>   virtiofsd: Do not use a thread pool by default (2021-02-16 17:54:18 +0000)
>
> ----------------------------------------------------------------
> virtiofsd pull 2021-02-16
>
> Vivek's support for new FUSE KILLPRIV_V2
> and some smaller cleanups.
>
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>

Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/6.0
for any user-visible changes.

-- PMM

