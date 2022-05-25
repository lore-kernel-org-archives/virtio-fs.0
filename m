Return-Path: <richard.henderson@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :cc:references:from:in-reply-to:content-transfer-encoding;
 bh=fqMfvaNrGFXhAYRs0q/MprE5PxALdisd+UrJ3i/TB4Q=;
 b=KU4F8q6shT3JzjSzW7VoMO/LyTJQ7ff2Sq+MUwa5n6IjmVNdS8jvYvqYaNri0Tc1hu
 fnjNvt374wqAce5nyCpQVYzF7Nkqn7/fr8UfBbyeWGynJXusnqzxyswtArYRjQYe6/dv
 snzlXvmwMp7kxbaa59y9pidn+C4O21oqUuzK/Zlg4naEqQLV5KxbRC8wzPYVGkMMQOZQ
 gRTb+MZyohq1hGrKs3idnOovt/A+YEScKUSC44LiDNE0KihGL4ojKd1GumO5VUQBkI/E
 pHvuyBISDxfuaxdOSzlJ7n1iMQAdIfXlzNaH28zrMi0TQ4fTvY7UjcZEje4ADGPZzd+p
 rKWg==
Message-ID: <bcd6d672-f14d-8f52-dc47-2cfafbf09f23@linaro.org>
Date: Wed, 25 May 2022 11:35:41 -0700
MIME-Version: 1.0
References: <20220525124909.867787-1-stefanha@redhat.com>
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20220525124909.867787-1-stefanha@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PULL 0/1] Block patches
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, virtio-fs@redhat.com, qemu-block@nongnu.org

On 5/25/22 05:49, Stefan Hajnoczi wrote:
> The following changes since commit 0cac736e73723850a99e5142e35d14d8f8efb232:
> 
>    Merge tag 'pull-riscv-to-apply-20220525' of github.com:alistair23/qemu into staging (2022-05-24 15:55:12 -0700)
> 
> are available in the Git repository at:
> 
>    https://gitlab.com/stefanha/qemu.git tags/block-pull-request
> 
> for you to fetch changes up to 29320530cf6684646b3a642fdbb5bc77ee8039de:
> 
>    docs: Correct the default thread-pool-size (2022-05-25 11:01:38 +0100)
> 
> ----------------------------------------------------------------
> Pull request
> 
> A small documentation fix.

Applied, thanks.  Please update https://wiki.qemu.org/ChangeLog/7.1 as appropriate.


r~


> 
> ----------------------------------------------------------------
> 
> Liu Yiding (1):
>    docs: Correct the default thread-pool-size
> 
>   docs/tools/virtiofsd.rst | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

