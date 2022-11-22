Return-Path: <armbru@redhat.com>
From: Markus Armbruster <armbru@redhat.com>
References: <20221121140121.1079100-1-armbru@redhat.com>
 <CAFEAcA_jnbp36Trjd3qJYzbf5-6SNNrirG7q2_-wKXkcX49ptg@mail.gmail.com>
 <7875a42b-2776-9d36-5373-78ac75cff89d@linaro.org>
 <87a64ki7zn.fsf@pond.sub.org>
 <47e0d3d8-607d-5e29-6780-c0a4364993a9@redhat.com>
 <87h6yrfjr4.fsf@pond.sub.org>
 <CAFEAcA-8tyYDMaZgYvhrG5G001HzgkCUoTUMbChDteJ+q-r8yA@mail.gmail.com>
Date: Tue, 22 Nov 2022 14:26:54 +0100
In-Reply-To: <CAFEAcA-8tyYDMaZgYvhrG5G001HzgkCUoTUMbChDteJ+q-r8yA@mail.gmail.com>
 (Peter Maydell's message of "Tue, 22 Nov 2022 12:44:37 +0000")
Message-ID: <875yf7ce75.fsf@pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain
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
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Thomas Huth <thuth@redhat.com>, Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, qemu-devel@nongnu.org, fam@euphon.net, kwolf@redhat.com, hreitz@redhat.com, groug@kaod.org, qemu_oss@crudebyte.com, Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, jcmvbkbc@gmail.com, berrange@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-block@nongnu.org, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com

Peter Maydell <peter.maydell@linaro.org> writes:

> On Tue, 22 Nov 2022 at 08:58, Markus Armbruster <armbru@redhat.com> wrote:
>> I don't think complete detailed review is necessary or even sensible.
>>
>> Review should start with the Coccinelle script:
>>
>>     // replace 'R = X; return R;' with 'return X;'
>>     @@
>>     identifier VAR;
>>     expression E;
>>     type T;
>>     identifier F;
>>     @@
>>      T F(...)
>>      {
>>          ...
>>     -    T VAR;
>>          ... when != VAR
>>
>>     -    VAR = (E);
>>     -    return VAR;
>>     +    return E;
>>          ... when != VAR
>>      }
>>
>> What could go wrong?  Not a rhetorical question!
>
> The obvious answer is "you might have got your manual tweaking
> wrong". A purely mechanised patch I can review by looking at
> the script and maybe eyeballing a few instances of the change;
> a change that is 99% mechanised and 1% hand-written I need to
> run through to find the hand-written parts.

Define "handwritten" :)

If reverting unwanted line-breaks and blank lines counts, then I can
make two patches, one straight from Coccinelle, and one that reverts the
unwanted crap.  The first one will be larger and more annoying to review
than this one.  A clear loss in my book, but I'm the patch submitter,
not a patch reviewer, so my book doesn't matter.

Else, we're down to one file, which I already offered to split off.

> But mostly this patch is hard to review for its sheer size,
> mechanical changes or not. A 3000 line patchmail is so big that
> the UI on my mail client gets pretty unwieldy.

With the manual one split off, target/xtensa/ dropped as requested by
Max, and tests/tcg/mips/ dropped because its status is unclear (and I
start to find it hard to care), we're down to

 28 files changed, 81 insertions(+), 221 deletions(-)

This will be v2.
