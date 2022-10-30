Return-Path: <peter.maydell@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=mea9bZUQuyEjJ3RlfvCntNcSv2SbCc3AGE3XX2UP6bU=;
 b=V+bMKVr5sPQFey6ICd2cLMPMLd8TKisnlkMIKE2rlVDCrfLkmgPcSNhQ2/IyQc0ffz
 wr7VdDQd7QHQxWT0uzL4TXMG3IWnoy/prYUtOld86gjnavx6Qcfx71fhmUBXq7hz8aHd
 sM0TE7Cnb6wQiK9nAaGziNZC2T6aaERtXgo1YzmuO/K+rUBe3q4KzePTKDYazFU0k3yS
 +V65pOnw1QIePPfQ191cuhzu7QbCdmoL00GWEnsMXtlh4JaEltb0KGiOXCq98JCyncxo
 AVtaF1UvJQsELoZ1b6EyJ/vznraasP3ecevbTyvxRNdtrd9WjDkofxs01h6hm6E7tD1A
 YIaw==
MIME-Version: 1.0
References: <20221030105944.311940-1-sw@weilnetz.de>
In-Reply-To: <20221030105944.311940-1-sw@weilnetz.de>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Sun, 30 Oct 2022 11:17:31 +0000
Message-ID: <CAFEAcA_w=9zj3F7YiStjEZwhm8xoNydh0sG_wwNqpyHwzwJt2w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v2] Fix some typos in documentation and
 comments
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Weil <sw@weilnetz.de>
Cc: qemu-devel@nongnu.org, Markus Armbruster <armbru@redhat.com>, Michael Roth <michael.roth@amd.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, Eric Blake <eblake@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Konstantin Kostiuk <kkostiuk@redhat.com>, Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org, virtio-fs@redhat.com

On Sun, 30 Oct 2022 at 10:59, Stefan Weil <sw@weilnetz.de> wrote:
>
> Most of them were found and fixed using codespell.
>
> Signed-off-by: Stefan Weil <sw@weilnetz.de>
> ---
>
> v2: Fixes from Peter Maydell's comments
>
> My focus was fixing typos which are relevant for the generated documentation.
>
> codespell finds many more typos in source code, and adding it to the continuous
> integration checks looks more and more like a good idea.

Is it possible to set it up in a way that doesn't report
false positives ?

Anyway, for this patch:

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

thanks
-- PMM

