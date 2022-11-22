Return-Path: <peter.maydell@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=1nJ5dQ+5Lp1BlK2QZdz2R4+7V24gqPvT5Ivb3k58a10=;
 b=EZ5o4DoE6gKVEK5uM6jPzg/pwusG8OxEpdOq6ND6QSMXA4pKvOm/NAZopy+AQq1cHQ
 2ZjXMV46bEfqDwrfpo/8N32R3Z/0AOOP5aeGZWEL58zKHQzlgtZs8aOhKpIR0fJDBwnz
 z2gehbiLgAr2vlTwoiOzF8CsJiksUQgu1JKBg0zkGGcKZaLjno5EhI0W5s+baz8dWl0o
 D49DWtqFctlfIf7K+SNxytX5XBLx2lortFsc0K8c9wh7imOkOJXS9FkZ/F5cO2U3CYPq
 auZsfoifz0Pq2e/pXBeABRP1dyfyc/RhzDSMBXfFKOQIkvJzk65fnMxYhyTxTh2oPF9P
 GYPQ==
MIME-Version: 1.0
References: <20221121140121.1079100-1-armbru@redhat.com>
 <CAMo8BfKxve8=RKqT6S8XXy1E7hczF0VO9XXZeUpha_4xNSV6WA@mail.gmail.com>
 <506afd42-89ab-cc6a-42d7-4544244f8672@linaro.org>
In-Reply-To: <506afd42-89ab-cc6a-42d7-4544244f8672@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 22 Nov 2022 15:12:01 +0000
Message-ID: <CAFEAcA87eRD2Y8PrXTQLF=LK63RnDN6sp4D2R+KOUd7Pp8y-yw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
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
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>, Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org, fam@euphon.net, kwolf@redhat.com, hreitz@redhat.com, groug@kaod.org, qemu_oss@crudebyte.com, Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, berrange@redhat.com, thuth@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-block@nongnu.org, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com

On Tue, 22 Nov 2022 at 15:04, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.or=
g> wrote:
>
> On 21/11/22 17:42, Max Filippov wrote:
> > On Mon, Nov 21, 2022 at 6:01 AM Markus Armbruster <armbru@redhat.com> w=
rote:
> >>   .../xtensa/core-dsp3400/xtensa-modules.c.inc  | 136 +++++-----------=
--
> >>   target/xtensa/core-lx106/xtensa-modules.c.inc |  16 +--
> >
> > These files are generated and were imported from xtensa configuration
> > overlays, they're not supposed to be changed.
>
> Tools can get the repository file list using 'git ls-files', which
> itself support file pattern exclusion [*].
>
> We can create i.e. 'scripts/imported-files.txt' with:
>
>    linux-headers/
>    target/hexagon/imported/
>    target/xtensa/core*
>    tests/tcg/mips/user/

Good idea. scripts/clean-header-guards.pl also has these to add
to the exclude list:

include/standard-headers/
pc-bios/
tests/tcg/
tests/multiboot/

thanks
-- PMM

