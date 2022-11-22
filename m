Return-Path: <peter.maydell@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=JFxsDQv6CSq9GlpH150Z29J2XyCbNQXqprtE7CsKApA=;
 b=IhQz5NKwo5HSqcfJsohSjWqXDmoKbpH9U5+GYIc3Y95g7VWiYfQuxKHL9nvw88vl1X
 4eUE8NeS7WxWrJteQ8znbCRFIbTjtI4BoNIP20YtiqZI2Lm1hKj2x6cote+2SYw49sZn
 s6f0LXvlYrxZibY97aycRKWWgUiV5/WuAX8Of2Ilv0Ep/fUyC0v+LA3H7zI9aTvlFUJE
 UNJfN9MRCgxr2a1a1lDjTVSHuc8Wwo6YYoLxijUTwqWzkCH9jbA770ChFM6PeFYAKqnJ
 VUjQ0j+ud3KiczZGPTpxH6aPaQq7AMFNmiFmV+Ueu8c6MP9+2vLjkuuhWNziAU62xTIq
 vdmw==
MIME-Version: 1.0
References: <20221121140121.1079100-1-armbru@redhat.com>
 <CAFEAcA_jnbp36Trjd3qJYzbf5-6SNNrirG7q2_-wKXkcX49ptg@mail.gmail.com>
 <7875a42b-2776-9d36-5373-78ac75cff89d@linaro.org>
 <87a64ki7zn.fsf@pond.sub.org>
 <47e0d3d8-607d-5e29-6780-c0a4364993a9@redhat.com>
 <87h6yrfjr4.fsf@pond.sub.org>
In-Reply-To: <87h6yrfjr4.fsf@pond.sub.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 22 Nov 2022 12:44:37 +0000
Message-ID: <CAFEAcA-8tyYDMaZgYvhrG5G001HzgkCUoTUMbChDteJ+q-r8yA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] cleanup: Tweak and re-run
 return_directly.cocci
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Markus Armbruster <armbru@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, qemu-devel@nongnu.org, fam@euphon.net, kwolf@redhat.com, hreitz@redhat.com, groug@kaod.org, qemu_oss@crudebyte.com, Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, jcmvbkbc@gmail.com, berrange@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-block@nongnu.org, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com

On Tue, 22 Nov 2022 at 08:58, Markus Armbruster <armbru@redhat.com> wrote:
> I don't think complete detailed review is necessary or even sensible.
>
> Review should start with the Coccinelle script:
>
>     // replace 'R = X; return R;' with 'return X;'
>     @@
>     identifier VAR;
>     expression E;
>     type T;
>     identifier F;
>     @@
>      T F(...)
>      {
>          ...
>     -    T VAR;
>          ... when != VAR
>
>     -    VAR = (E);
>     -    return VAR;
>     +    return E;
>          ... when != VAR
>      }
>
> What could go wrong?  Not a rhetorical question!

The obvious answer is "you might have got your manual tweaking
wrong". A purely mechanised patch I can review by looking at
the script and maybe eyeballing a few instances of the change;
a change that is 99% mechanised and 1% hand-written I need to
run through to find the hand-written parts.

But mostly this patch is hard to review for its sheer size,
mechanical changes or not. A 3000 line patchmail is so big that
the UI on my mail client gets pretty unwieldy.

-- PMM

