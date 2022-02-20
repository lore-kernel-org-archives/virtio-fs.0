DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=mfoaHmtYn7qQB93RGFLpowS77DV1zylNQFTokSnR44s=;
	b=mfJaFZA+WVxHnKlaKPES8d/dIVZ6cyh/NafzQm3btcrR9g2Vkt2A6W1W/OOkSbYVES
	rziXsDH6uEaiqcaJ+bG/R7BgVH5kAXyjxJmc7mreDIRh1NBW8xwRZL77XTbrRY+3qixQ
	f35oUB/1N+LyR/7eMeNUztALjkIKR8J+R+S/kC0eoPAyh0bZq0C+oA2yvfaeEOwuOumb
	ENEQnh56DYiIEtun95lxWyY1dWtXJXApJY+tHaYFtdbr1AKBG3tJqT2KTzsdLOXfqrk4
	9sFWRcyb4WzuPqeHmMfwnN4IDUDwC+a05E2t2TRZH+wr7Vy1oYbxHodH+9zkNih/+GyY
	1/Ww==
MIME-Version: 1.0
References: <20220217172500.60500-1-dgilbert@redhat.com>
In-Reply-To: <20220217172500.60500-1-dgilbert@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Sun, 20 Feb 2022 15:05:30 +0000
Message-ID: <CAFEAcA8TQJ8Wx0+Ns4XoFCG3JKC8VrcnTJ-=Oo+WuBhtd_qkUg@mail.gmail.com>
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
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, vgoyal@redhat.com

On Thu, 17 Feb 2022 at 17:30, Dr. David Alan Gilbert (git)
<dgilbert@redhat.com> wrote:
>
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>
> The following changes since commit c13b8e9973635f34f3ce4356af27a311c993729c:
>
>   Merge remote-tracking branch 'remotes/alistair/tags/pull-riscv-to-apply-20220216' into staging (2022-02-16 09:57:11 +0000)
>
> are available in the Git repository at:
>
>   https://gitlab.com/dagrh/qemu.git tags/pull-virtiofs-20220217b
>
> for you to fetch changes up to 45b04ef48dbbeb18d93c2631bf5584ac493de749:
>
>   virtiofsd: Add basic support for FUSE_SYNCFS request (2022-02-17 17:22:26 +0000)
>
> ----------------------------------------------------------------
> V3: virtiofs pull 2022-02-17
>
> Security label improvements from Vivek
>   - includes a fix for building against new kernel headers
>   [V3: checkpatch style fixes]
>   [V2: Fix building on old Linux]
> Blocking flock disable from Sebastian
> SYNCFS support from Greg
>
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>


Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/7.0
for any user-visible changes.

-- PMM

