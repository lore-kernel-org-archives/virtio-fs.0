Return-Path: <richard.henderson@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :cc:references:from:in-reply-to:content-transfer-encoding;
 bh=28K+JLIxMAw/ud6crVH6+SBchG8dHL/Ih0iPmrFKUp8=;
 b=nhZ1kc2lse7ORlH4o7va3TfbnI8sxkJPK4ruS9I2giG+z67v1H1PD96uK7Sa8eu5t0
 vk11ntVZAxCUGVtep/iJ4ybSC7rVFtUJSbsqrAVPp9fveuJmV2WXnboVvvzl7bEeEZl9
 BN060jtJC/0C3/PDfxlagBncDXstozM4t75VRg3qIKtDkncOq5Vyct/+WyKTXrHNzFBA
 KnoOVFN/2qjWf+UwKlfxKnnFmqzExfnMYBY6mfYjJmxuMkYyVDOEBIRDSfJPFuRBrHqy
 HnsiYBdqrTHhfQAP+19HJclsnUbk/FSqplLrQYNQVO/D5N6GGAFLHGgqLQxxp5RdPexF
 BIrg==
Message-ID: <a4688ccf-a8c9-5e7d-f570-001b417a0025@linaro.org>
Date: Thu, 4 Aug 2022 17:20:19 -0700
MIME-Version: 1.0
References: <20220804190258.20226-1-stefanha@redhat.com>
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20220804190258.20226-1-stefanha@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PULL for-7.1 0/1] Block patches
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-block@nongnu.org, virtio-fs@redhat.com

On 8/4/22 12:02, Stefan Hajnoczi wrote:
> The following changes since commit 2480f3bbd03814b0651a1f74959f5c6631ee5819:
> 
>    Merge tag 'linux-user-for-7.1-pull-request' of https://gitlab.com/laurent_vivier/qemu into staging (2022-08-03 08:32:44 -0700)
> 
> are available in the Git repository at:
> 
>    https://gitlab.com/stefanha/qemu.git tags/block-pull-request
> 
> for you to fetch changes up to 7b0ca313647532a2c7007379ff800c9a2415c95d:
> 
>    virtiofsd: Fix format strings (2022-08-04 14:44:25 -0400)
> 
> ----------------------------------------------------------------
> Pull request
> 
> - Format string portability fix in virtiofsd


Applied, thanks.  Please update https://wiki.qemu.org/ChangeLog/7.1 as appropriate.


r~


> 
> ----------------------------------------------------------------
> 
> Stefan Weil (1):
>    virtiofsd: Fix format strings
> 
>   tools/virtiofsd/fuse_lowlevel.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 

