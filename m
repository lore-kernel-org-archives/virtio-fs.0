Return-Path: <philmd@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=ThKu+t6irTv73m8p7aEWsbq4mHIbv6ADWuq0AoAEUfY=;
 b=Y2zgZjUo5IIXlAStEty/liujTidtzswAGZ5IqiU+U7/E+D3agEj/UwiUFi0/rca0ZM
 m7lDi7hqbhEWBoqw3HoWAZgWH8+rUyY0RQ3GS3emoZibCAjIbZyCQw/mBX9RYzFk6HBV
 K2uQLSrhyFDlznt906bny1WDB5sHuavB8nd7rElcptClls4iGkqKl7bVst2Fo0V3VI7g
 dnRtFJQHtuxsOmToh9Bsd2uMIE0x4DjVBB/kR4a2eOSOrPmxIJjouAO/EEqy2jY8dxFe
 4ppS15OSmyWBQ5xQaDR+ZicvwdojBRLCABjZh9fmcb7xsnUCqHX6m0xpeHt7YqcmueTF
 tgow==
Message-ID: <58463615-23ab-5f08-de12-ccc5587040d6@linaro.org>
Date: Tue, 22 Nov 2022 16:10:39 +0100
MIME-Version: 1.0
References: <20221122134917.1217307-1-armbru@redhat.com>
 <20221122134917.1217307-2-armbru@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221122134917.1217307-2-armbru@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 1/2] cleanup: Tweak and re-run
 return_directly.cocci
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc: groug@kaod.org, qemu_oss@crudebyte.com, Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, berrange@redhat.com, thuth@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com

On 22/11/22 14:49, Markus Armbruster wrote:
> Tweak the semantic patch to drop redundant parenthesis around the
> return expression.
> 
> Coccinelle drops a comment in hw/rdma/vmw/pvrdma_cmd.c; restored
> manually.
> 
> Coccinelle messes up vmdk_co_create(), not sure why.  Change dropped,
> will be done manually in the next commit.
> 
> Line breaks in target/avr/cpu.h and hw/rdma/vmw/pvrdma_cmd.c tidied up
> manually.
> 
> Whitespace in tools/virtiofsd/fuse_lowlevel.c tidied up manually.
> 
> checkpatch.pl complains "return of an errno should typically be -ve"
> two times for hw/9pfs/9p-synth.c.  Preexisting, the patch merely makes
> it visible to checkpatch.pl.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   scripts/coccinelle/return_directly.cocci |  5 +--
>   include/hw/pci/pci.h                     |  7 +--
>   target/avr/cpu.h                         |  4 +-
>   hw/9pfs/9p-synth.c                       | 14 ++----
>   hw/char/sifive_uart.c                    |  4 +-
>   hw/ppc/ppc4xx_sdram.c                    |  5 +--
>   hw/rdma/vmw/pvrdma_cmd.c                 | 57 +++++++++---------------
>   hw/virtio/vhost-user.c                   |  6 +--
>   migration/dirtyrate.c                    | 10 +----
>   migration/tls.c                          |  6 +--
>   replay/replay-time.c                     |  5 +--
>   semihosting/console.c                    |  4 +-
>   softmmu/memory.c                         | 11 +----
>   softmmu/physmem.c                        |  9 +---
>   target/loongarch/cpu.c                   |  4 +-
>   target/mips/tcg/dsp_helper.c             | 15 ++-----
>   target/riscv/debug.c                     |  6 +--
>   target/riscv/vector_helper.c             | 28 +++---------
>   tests/bench/benchmark-crypto-akcipher.c  |  6 +--
>   tests/qtest/erst-test.c                  |  5 +--
>   tests/qtest/hexloader-test.c             |  6 +--
>   tests/qtest/pvpanic-pci-test.c           |  6 +--
>   tests/qtest/pvpanic-test.c               |  6 +--
>   tests/qtest/test-filter-mirror.c         |  6 +--
>   tests/qtest/virtio-ccw-test.c            |  6 +--
>   tests/tcg/multiarch/sha512.c             |  9 +---
>   tools/virtiofsd/fuse_lowlevel.c          | 24 +++-------
>   27 files changed, 70 insertions(+), 204 deletions(-)
> 
> diff --git a/scripts/coccinelle/return_directly.cocci b/scripts/coccinelle/return_directly.cocci
> index 4cf50e75ea..6cb1b3c99a 100644
> --- a/scripts/coccinelle/return_directly.cocci
> +++ b/scripts/coccinelle/return_directly.cocci
> @@ -11,9 +11,8 @@ identifier F;
>   -    T VAR;
>        ... when != VAR
>   
> --    VAR =
> -+    return
> -     E;
> +-    VAR = (E);
>   -    return VAR;
> ++    return E;
>        ... when != VAR
>    }

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

