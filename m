DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=y32vxz9x1qc63b3FAytiQh7xliH1PIF40xM+koHzE8o=;
	b=st8Db+DjZDCpIr4P0J1/8QCpKr7AivBtn0ZuGT8CsyFgMvCs6ykoVlTptRL6CAdGrH
	OVAyTeX3gdUsKZyBVlCmHVsQ6VK0tPGWRO3dUw4dqEwVFZFJNsav7EA5J0MBhgHSmLXW
	oEItzjcxXckTWiS1EiAKeUjojOupnP4RQBTfcLbVqU3Mn1RhRGYFcobypqRHptZddGh4
	x9zYE17pYLuUUlKONOsIw1BEd4K4ZSMMTtjYHpQImNgCQDBr1KLX2mmTgbk9hhfXLukC
	PWQgP62csYxB22BiqIFWbnpe/iS2lpEFeMxL2wEvj0W7qxIzr+JsfDER8Yzft9ft01VP
	3MLw==
MIME-Version: 1.0
References: <20210204183439.546918-1-dgilbert@redhat.com>
In-Reply-To: <20210204183439.546918-1-dgilbert@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 5 Feb 2021 10:08:53 +0000
Message-ID: <CAFEAcA8EEi21Xsfq6+VX4bbY+nutbmekYo3EyVWSKYzHa4jkmg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PULL 0/5] virtiofs queue: Security fix
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-stable <qemu-stable@nongnu.org>, QEMU Developers <qemu-devel@nongnu.org>

On Thu, 4 Feb 2021 at 19:14, Dr. David Alan Gilbert (git)
<dgilbert@redhat.com> wrote:
>
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>
> The following changes since commit 1ba089f2255bfdb071be3ce6ac6c3069e8012179:
>
>   Merge remote-tracking branch 'remotes/armbru/tags/pull-qmp-2021-02-04' into staging (2021-02-04 14:15:35 +0000)
>
> are available in the Git repository at:
>
>   https://gitlab.com/dagrh/qemu.git tags/pull-virtiofs-20210204
>
> for you to fetch changes up to cf269ff8032392bbdd700e7bfd21823ad9eee3a9:
>
>   virtiofsd: Add restart_syscall to the seccomp whitelist (2021-02-04 17:50:08 +0000)
>
> ----------------------------------------------------------------
> virtiofs: Security pull 2021-02-04
>
> This contains an important CVE fix for virtiofsd,
> together with two fixes for over-eager seccomp rules.
>
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>
> ----------------------------------------------------------------



Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/6.0
for any user-visible changes.

-- PMM

