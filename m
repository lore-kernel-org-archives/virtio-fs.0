DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=TacXGm0yUALIKf0NNmUteMlWj7hp0bwcpOLuk6Yh51w=;
	b=feOiEfPTL68eZ6di6nyd30J7mDG5CrL+czwXWQf8kZffdC5NEg+p1UAkmWF012Nepb
	cS9CLUm+GBPHfUR1Sp2U88KM4xi5F1Pnm8kPKByryi1ZDTGdm78G+lDNLo77JEsTaEnc
	2qvk/xTnGERMiOpilW9iHLw9vSzuv2y7Mv6RlZ4lEoBNB9M8wIcP4AvKr28ZGFCK4c5R
	rb/RgmB9HUExqpKf2tVXxgAoU5k5KIpHkOghQKNn+Xr6MREwPTts9bZjVhKVMCQ/+8U6
	lTqpSm2g+lHCs05FllE/AqHrV0rRx4zq69Vpaol9Au5+oNJ+pYailc514mEEc3VoWDxW
	Zubg==
MIME-Version: 1.0
References: <20201026184331.272953-1-dgilbert@redhat.com>
In-Reply-To: <20201026184331.272953-1-dgilbert@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 27 Oct 2020 16:58:23 +0000
Message-ID: <CAFEAcA8mcgk2ansZGStesf+Whdg8swkS466rVYvXuFMUWDzVAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PULL 00/16] virtiofs queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: QEMU Developers <qemu-devel@nongnu.org>, virtio-fs@redhat.com, Max Reitz <mreitz@redhat.com>, vgoyal@redhat.com

On Mon, 26 Oct 2020 at 18:51, Dr. David Alan Gilbert (git)
<dgilbert@redhat.com> wrote:
>
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>
> The following changes since commit a95e0396c805735c491a049b01de6f5a713fb91b:
>
>   Merge remote-tracking branch 'remotes/bonzini-gitlab/tags/for-upstream' into staging (2020-10-26 15:49:11 +0000)
>
> are available in the Git repository at:
>
>   https://gitlab.com/dagrh/qemu.git tags/pull-virtiofs-20201026
>
> for you to fetch changes up to c93a656f7b6585d9b6f8639d1fbb74dd944be239:
>
>   tests/acceptance: Add virtiofs_submounts.py (2020-10-26 18:35:32 +0000)
>
> ----------------------------------------------------------------
> virtiofsd pull 2020-10-26
>
> Misono
>    Set default log level to info
>    Explicit build option for virtiofsd
>
> Me
>    xattr name mapping
>
> Stefan
>   Alternative chroot sandbox method
>
> Max
>   Submount mechanism
>
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>


Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/5.2
for any user-visible changes.

-- PMM

