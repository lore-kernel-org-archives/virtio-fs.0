Return-Path: <peter.maydell@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=0s0VL1YH65ntfDy3fXMBFn+sJNR2U5+/VIiIt1BDbnA=;
 b=KfX1MG39fvihDekAdyC/MuJWWTbn52n4ANHmAjHhLBYUM43/gabfGPRY7iNTd0e8Lx
 zDY+jwvYE8lNEVTVDIsKdoIj9alkFPT8RchHDVh5PEg1RMkYWNrVJUnbeGA4/9ctmCdd
 GdukwL6OkEN8IW3pYnWcO2fTPX2EWy3Ioqk8YB1jde4l1/MSENSZW2mrZ1/zcIAEWcWs
 VGyYQxfI1poouRbMmZYjvLf6GrhqH2PheZbFA9oExmusmQVO8snzJJv6m8qUCWCFZmGr
 MFb4+in2aL4oOBqgKfldUUahVxQedNO8Kj9242v3Pv6S1fmHUZQOGcffqXVXs82vX+Hq
 x1uw==
MIME-Version: 1.0
References: <20230216182628.126139-1-dgilbert@redhat.com>
In-Reply-To: <20230216182628.126139-1-dgilbert@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 21 Feb 2023 11:27:38 +0000
Message-ID: <CAFEAcA-0=iENOFkL5mPeDmkPkfKN0Xc7wEAqBcErT3TRB5jfZQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PULL 0/4] virtiofs queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, gmaglione@redhat.com

On Thu, 16 Feb 2023 at 18:27, Dr. David Alan Gilbert (git)
<dgilbert@redhat.com> wrote:
>
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>
> The following changes since commit 6dffbe36af79e26a4d23f94a9a1c1201de99c261:
>
>   Merge tag 'migration-20230215-pull-request' of https://gitlab.com/juan.quintela/qemu into staging (2023-02-16 13:09:51 +0000)
>
> are available in the Git repository at:
>
>   https://gitlab.com/dagrh/qemu.git tags/pull-virtiofs-20230216b
>
> for you to fetch changes up to a6bfdaed4a735a2cf59f265e6955fe2adcc99637:
>
>   virtiofsd: Swing deprecated message to removed-features (2023-02-16 18:15:08 +0000)
>
> ----------------------------------------------------------------
> Remove C virtiofsd
>
> We deprecated the C virtiofsd in commit 34deee7b6a1418f3d62a
> in v7.0 in favour of the Rust implementation at
>
>   https://gitlab.com/virtio-fs/virtiofsd
>
> since then, the Rust version has had more development and
> has held up well.  It's time to say goodbye to the C version
> that got us going.
>
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>
> ----------------------------------------------------------------


Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/8.0
for any user-visible changes.

-- PMM

