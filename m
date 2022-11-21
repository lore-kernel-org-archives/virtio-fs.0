Return-Path: <peter.maydell@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=MF0QvKrp6hOQBtpvzpbZb9Nyv7bn72nzIE9/cJbusOs=;
 b=gAF9+h1FXftdn93KZTEjjDjaUCyTsHBSfToTrxl4r+YHMi8217bNdmt8rUp15v69yz
 pJobNxAirgRt/WgG8aM2N9KWOH38GLcekaDFXyvNucTfg3VMCIR1/wW3ZD1A1EQTFOXa
 HJFiAiKwOwDK2L1loNXFrILdB6Cl+9GipWvvJ4ALhi/BT/LMmi0yoXZzfHbUb2H0Z+0x
 OyJ+cTLxJi1qhIBIRGnUuNIpd1czWWcgm58y1co5I0A44i9Y5aIgPBhIwo4fdBEp0u0o
 Lb/JRsVglFquVnJi6KlZXPCmzemQRNxdpoNdo6U7Qng0qy1m+qjI8IFNczK7FKNs1Bva
 R7AA==
MIME-Version: 1.0
References: <20221121140121.1079100-1-armbru@redhat.com>
In-Reply-To: <20221121140121.1079100-1-armbru@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 21 Nov 2022 14:36:56 +0000
Message-ID: <CAFEAcA_jnbp36Trjd3qJYzbf5-6SNNrirG7q2_-wKXkcX49ptg@mail.gmail.com>
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
Cc: qemu-devel@nongnu.org, fam@euphon.net, kwolf@redhat.com, hreitz@redhat.com, groug@kaod.org, qemu_oss@crudebyte.com, Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, philmd@linaro.org, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, jcmvbkbc@gmail.com, berrange@redhat.com, thuth@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-block@nongnu.org, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com

On Mon, 21 Nov 2022 at 14:03, Markus Armbruster <armbru@redhat.com> wrote:
>
> Tweak the semantic patch to drop redundant parenthesis around the
> return expression.
>
> Coccinelle drops comments in hw/rdma/vmw/pvrdma_cmd.c; restored
> manually.
>
> Coccinelle messes up vmdk_co_create(), not sure why.  Transformed
> manually.
>
> Line breaks in target/avr/cpu.h and hw/rdma/vmw/pvrdma_cmd.c tidied up
> manually.
>
> Whitespace in fuse_reply_iov() tidied up manually.
>
> checkpatch.pl complains "return of an errno should typically be -ve"
> two times for hw/9pfs/9p-synth.c.  Preexisting, the patch merely makes
> it visible to checkpatch.pl.
>
> checkpatch.pl complains "return is not a function, parentheses are not
> required" three times for target/mips/tcg/dsp_helper.c.  False
> positives.
>
> Signed-off-by: Markus Armbruster <armbru@redhat.com>

>  .../user/ase/msa/bit-count/test_msa_nloc_b.c  |   9 +-
>  .../user/ase/msa/bit-count/test_msa_nloc_d.c  |   9 +-
[snip long list of other mips test files]

>  328 files changed, 989 insertions(+), 2099 deletions(-)

This patch seems to almost entirely be huge because of these
mips test case files. Are they specific to QEMU or are they
effectively a 3rd-party import that it doesn't make sense
to make local changes to?

I definitely don't think you should put manual tidying changes
in the same patch as 3000 lines of automated changes: that
is in my opinion un-reviewable.

thanks
-- PMM

