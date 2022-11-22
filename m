Return-Path: <armbru@redhat.com>
From: Markus Armbruster <armbru@redhat.com>
References: <20221121140121.1079100-1-armbru@redhat.com>
 <CAFEAcA_jnbp36Trjd3qJYzbf5-6SNNrirG7q2_-wKXkcX49ptg@mail.gmail.com>
 <7875a42b-2776-9d36-5373-78ac75cff89d@linaro.org>
 <87a64ki7zn.fsf@pond.sub.org>
 <47e0d3d8-607d-5e29-6780-c0a4364993a9@redhat.com>
Date: Tue, 22 Nov 2022 09:58:39 +0100
In-Reply-To: <47e0d3d8-607d-5e29-6780-c0a4364993a9@redhat.com> (Thomas Huth's
 message of "Mon, 21 Nov 2022 17:34:15 +0100")
Message-ID: <87h6yrfjr4.fsf@pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
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
To: Thomas Huth <thuth@redhat.com>
Cc: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org, fam@euphon.net, kwolf@redhat.com, hreitz@redhat.com, groug@kaod.org, qemu_oss@crudebyte.com, Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, jcmvbkbc@gmail.com, berrange@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-block@nongnu.org, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com

Thomas Huth <thuth@redhat.com> writes:

> On 21/11/2022 17.32, Markus Armbruster wrote:
>> Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:
>>=20
>>> On 21/11/22 15:36, Peter Maydell wrote:
>>>> On Mon, 21 Nov 2022 at 14:03, Markus Armbruster <armbru@redhat.com> wr=
ote:
>>>>>
>>>>> Tweak the semantic patch to drop redundant parenthesis around the
>>>>> return expression.
>>>>>
>>>>> Coccinelle drops comments in hw/rdma/vmw/pvrdma_cmd.c; restored
>>>>> manually.
>>>>>
>>>>> Coccinelle messes up vmdk_co_create(), not sure why.  Transformed
>>>>> manually.
>>>>>
>>>>> Line breaks in target/avr/cpu.h and hw/rdma/vmw/pvrdma_cmd.c tidied up
>>>>> manually.
>>>>>
>>>>> Whitespace in fuse_reply_iov() tidied up manually.
>>>>>
>>>>> checkpatch.pl complains "return of an errno should typically be -ve"
>>>>> two times for hw/9pfs/9p-synth.c.  Preexisting, the patch merely makes
>>>>> it visible to checkpatch.pl.
>>>>>
>>>>> checkpatch.pl complains "return is not a function, parentheses are not
>>>>> required" three times for target/mips/tcg/dsp_helper.c.  False
>>>>> positives.
>>>>>
>>>>> Signed-off-by: Markus Armbruster <armbru@redhat.com>
>>>>
>>>>>    .../user/ase/msa/bit-count/test_msa_nloc_b.c  |   9 +-
>>>>>    .../user/ase/msa/bit-count/test_msa_nloc_d.c  |   9 +-
>>>> [snip long list of other mips test files]
>>>>
>>>>>    328 files changed, 989 insertions(+), 2099 deletions(-)
>>>> This patch seems to almost entirely be huge because of these
>>>> mips test case files. Are they specific to QEMU or are they
>>>> effectively a 3rd-party import that it doesn't make sense
>>>> to make local changes to?
>>>
>>> They are imported and will unlikely be modified.
>>=20
>> Not obvious to me from git-log.
>>=20
>> Should I drop the changes to tests/tcg/mips/?
>
> I'd say yes. At least move them to a separate patch.

Possible status of tests/tcg/mips/:

1. Imported, should not be modified

   Drop from the patch.

2. Not imported, should be modified

2a. To be reviewed separately from the remainder of the patch

    Split off.

2b. Likewise, but nobody will care to review, realistically

    Split off and merge anyway, or drop.  I'd go for the latter.

2c. To be reviewed together with the remainder of the patch

    Keep as is.

Which one is it?

>                                                      Otherwise reviewing=
=20
> this patch here is no fun at all.

I don't think complete detailed review is necessary or even sensible.

Review should start with the Coccinelle script:

    // replace 'R =3D X; return R;' with 'return X;'
    @@
    identifier VAR;
    expression E;
    type T;
    identifier F;
    @@
     T F(...)
     {
         ...
    -    T VAR;
         ... when !=3D VAR

    -    VAR =3D (E);
    -    return VAR;
    +    return E;
         ... when !=3D VAR
     }

What could go wrong?  Not a rhetorical question!

The simple part is executing the rule.  It'll *delete* variable VAR, and
*preserve* expression E.

The tricky part is deciding whether the rule matches, in particular
proving that there are no other uses of VAR.  If Coccinelle gets that
wrong, the code no longer compiles *unless* there is another, global VAR
of suitable type.

Turns out Coccinelle does get it wrong for vmdk_co_create(), and the
compiler duly rejects it.  I don't understand why it gets it wrong.

To help understand the script, and as a sanity check, reviewing some of
its patches is advisable.  Reviewing all of them feels impractical.
