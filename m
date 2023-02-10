Return-Path: <peter.maydell@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=kvHX3mpuSE60duCiFn6IKQuKCW0qYmKxPbhEGLYYiww=;
 b=J1mrolRRWq8Qu0XiMlZz7mccs750p6eJtH7Uey4+GoQJ8alNtu69mG0xXlHXR21MyX
 ufvIgCBgu18R7cjehi6aIyWy/UHTCudSsyxVCkX2xySATycdR4YRtx7hT9xKkRqEQTR8
 ghto8bluPPl+6aEKfXsGnRrleJozPsHoPldszBfBm16rfX6OXr8glS5XyLP3dqWXLk3f
 yH4DnFHWLoXGs+iGpVm+JWIWGvC3ipPb0+CKxmydBPuRgvA10+RVCvJzVehCnkYOzIoQ
 OMedaGTqrOzaaXTVcnAXePIPOcXZdKJXD15oqXXpGCT3PGGx3gCo9w9CfM8voA1ODeR4
 f2zA==
MIME-Version: 1.0
References: <20230209152520.434183-1-stefanha@redhat.com>
In-Reply-To: <20230209152520.434183-1-stefanha@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 10 Feb 2023 10:49:50 +0000
Message-ID: <CAFEAcA8E_egc6qL=htY-QAvWZb-rPoQOosVMTykiA2Fp+wJn-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PULL 0/6] Block patches
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, qemu-block@nongnu.org, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>

On Thu, 9 Feb 2023 at 15:25, Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> The following changes since commit 417296c8d8588f782018d01a317f88957e9786d6:
>
>   tests/qtest/netdev-socket: Raise connection timeout to 60 seconds (2023-02-09 11:23:53 +0000)
>
> are available in the Git repository at:
>
>   https://gitlab.com/stefanha/qemu.git tags/block-pull-request
>
> for you to fetch changes up to acbc8aee5b09222dc6a5cb88306b67bcbe37e30b:
>
>   iotests/detect-zeroes-registered-buf: add new test (2023-02-09 10:22:30 -0500)
>
> ----------------------------------------------------------------
> Pull request
>
> A few fixes that I've picked up.
>


Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/8.0
for any user-visible changes.

-- PMM

