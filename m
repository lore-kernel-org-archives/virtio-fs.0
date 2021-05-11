DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=Itbc+MfmGLBMUTcUcELl/tiyn5Dn5aegR1Exr/slsDw=;
	b=HsMMf9QEX0Ks1yzt8tnphrs/smWSRfiHUlrRrd/Tam1RHIvUgFvrDqDzCVb42vEI6l
	008hy5+F97U07P9vCHU9cH5UKUkalNYFP3qOM7IHR1MhRVOLC/E/2ADw9AATSxwBvg8E
	necGgBAFCCRmSd21o8SgxQ5HjWOXlGtwpKxPLmE1bADAuxShc/jwHArxaqfwXaS4zoRs
	ES8FQppouT5NtSzZtbTjdX6a23sENgsonNsbPjO25bs3Vw82g5IrThX8Zz8BI0daflZF
	hK/I35G6yeL1VEA5aQRsfZEbclJ9HW5Y1ALhmbHa2glGCCzFJFUSpUhL3KBFrZpKMECk
	RRmQ==
MIME-Version: 1.0
References: <20210506185641.284821-1-dgilbert@redhat.com>
In-Reply-To: <20210506185641.284821-1-dgilbert@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 11 May 2021 16:05:49 +0100
Message-ID: <CAFEAcA9h47gUWtUHOmtgWskaXEVgXs9T6FiD2EO-wJgZCKmK6g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PULL 00/12] virtiofs queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: jose.carlos.venegas.munoz@intel.com, QEMU Developers <qemu-devel@nongnu.org>, virtio-fs@redhat.com, Mahmoud Mandour <ma.mandourr@gmail.com>, vgoyal@redhat.com

On Thu, 6 May 2021 at 20:05, Dr. David Alan Gilbert (git)
<dgilbert@redhat.com> wrote:
>
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>
> The following changes since commit d90f154867ec0ec22fd719164b88716e8fd48672:
>
>   Merge remote-tracking branch 'remotes/dg-gitlab/tags/ppc-for-6.1-20210504' into staging (2021-05-05 20:29:14 +0100)
>
> are available in the Git repository at:
>
>   https://gitlab.com/dagrh/qemu.git tags/pull-virtiofs-20210506
>
> for you to fetch changes up to 67a010f64cc9e33ba19ab389dedaa52013a9de8a:
>
>   virtiofsd/fuse_virtio.c: Changed allocations of locals to GLib (2021-05-06 19:47:44 +0100)
>
> ----------------------------------------------------------------
> virtiofsd pull 2021-05-06
>
> A pile of cleanups:
>
>   Use of glib allocators from Mahmoud
>   Virtio spec compliance and printf cleanup from me.
>   Sugar to turn on xattr when defining xattr mapping from Carlos
>   an assert cleanup from Greg
>
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>


Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/6.1
for any user-visible changes.

-- PMM

