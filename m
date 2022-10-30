Return-Path: <peter.maydell@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=DYdQx8QtpSWUP6nQTSR73oYUnnZqxGIsKjjT01+1nnc=;
 b=YNJBhfxpty+GHgVkrpkTc8kEZIY2d32nkmb9OUnFnIwFtJ+YpC8HSiBTSE855J1HWH
 nycfwnw2sskMp+XRbpDh4oPg2RkWmVcHEj+ElV6nW+F79o/ztnVy1MnI3kRsTtMfR097
 QU26645BFdNWGxduGZNqM/w2vTWu3l9r/aM6YGkNDhV+sIWJO8Av2aIblhHo15HQIMXG
 FdhOr+yYVKmBk2q5vqyqj2t7xaUzPSw44l8OZElCfKiKmy4rdHBfkibnReiB9RAQWLoT
 LbciNRw8axenFj9NldJtE3gmlAAViZf1kQ1rTqg+BoSmc8oK+lc7HL5KLZwScz/9/W1U
 BzoQ==
MIME-Version: 1.0
References: <20221029172515.217264-1-sw@weilnetz.de>
In-Reply-To: <20221029172515.217264-1-sw@weilnetz.de>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Sun, 30 Oct 2022 10:32:07 +0000
Message-ID: <CAFEAcA9Z7T=m3WsHs8S8_PtUrzO+pr=SXpvmNPbCVYyFgg3b8w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] Fix some typos in documentation and comments
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

On Sat, 29 Oct 2022 at 18:25, Stefan Weil <sw@weilnetz.de> wrote:
>
> Most of them were found and fixed using codespell.
>
> Signed-off-by: Stefan Weil <sw@weilnetz.de>
> ---
>
> My focus was fixing typos which are relevant for the generated documentation.
>
> codespell finds many more typos in source code, and adding it to the continuous
> integration checks looks more and more like a good idea.
>
> Stefan
>
>
>  docs/devel/qapi-code-gen.rst        | 2 +-
>  docs/devel/testing.rst              | 2 +-
>  docs/system/arm/cpu-features.rst    | 2 +-
>  docs/system/loongarch/loongson3.rst | 2 +-
>  docs/tools/virtiofsd.rst            | 2 +-
>  include/exec/memory.h               | 2 +-
>  qapi/qom.json                       | 2 +-
>  qemu-options.hx                     | 8 ++++----
>  qga/qapi-schema.json                | 2 +-
>  tests/qtest/libqtest.h              | 2 +-
>  10 files changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/docs/devel/qapi-code-gen.rst b/docs/devel/qapi-code-gen.rst
> index cd9b544376..c4c04bf755 100644
> --- a/docs/devel/qapi-code-gen.rst
> +++ b/docs/devel/qapi-code-gen.rst
> @@ -1313,7 +1313,7 @@ Removing "unreachable" stuff like events that can't be triggered
>  anymore, optional return or event data members that can't be sent
>  anymore, and return or event data member (enumeration) values that
>  can't be sent anymore makes no difference to clients, except for
> -introspection.  The latter can conceivably confuse clients, so tread
> +introspection.  The latter can conceivably confuse clients, so treat
>  carefully.

No, the current text is correct: "tread carefully" means "be cautious".

> --- a/docs/system/loongarch/loongson3.rst
> +++ b/docs/system/loongarch/loongson3.rst
> @@ -41,7 +41,7 @@ can be accessed by following steps.
>
>    $ qemu-system-loongarch64 -machine virt -m 4G -cpu la464-loongarch-cpu \
>        -smp 1 -bios QEMU_EFI.fd -kernel vmlinuz.efi -initrd initrd.img \
> -      -append "root=/dev/ram rdinit=/sbin/init consol e=ttyS0,115200" \
> +      -append "root=/dev/ram rdinit=/sbin/init console e=ttyS0,115200" \
>        --nographic

This is an error, but the fix is wrong -- the space between 'l' and 'e'
should just be deleted.


> @@ -5248,7 +5248,7 @@ SRST
>          read the colo-compare git log.
>
>      ``-object cryptodev-backend-builtin,id=id[,queues=queues]``
> -        Creates a cryptodev backend which executes crypto opreation from
> +        Creates a cryptodev backend which executes crypto operation from

Should be "operations"

>          the QEMU cipher APIS. The id parameter is a unique ID that will

This should be "APIs".

The other changes in the patch look good.

thanks
-- PMM

