Return-Path: <jcmvbkbc@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=ZLb5iz6wZn4vgEUOAWPohUMEl9ae/EirPj26Kd0lqis=;
 b=D5DwOjIHLxl2vQU/wAX7ro9G755wMcfX1dj5ei4qyZ3E2YiPwsVDnFGqVDpLbiABpa
 3gUDec7f2HeLUFW9jOsptSNGs9BGDIiOz1Ssb6clk/KpWDfZ02OMm8KH1ZEvWu5dONkz
 uA23M4JpHPrmgBQh0wta4jK/ujF5fSPHYr7uAtOmCJuk2Gz872rwxDchaF+d/aY5TL9L
 FH8uYgSZnh9v91RyRhhY4G2pO7NqhijSxfeOgNuQPBEpLcE6WYbwKRVr3S552dcg6rWU
 yX/Q7hw6WrBsWwqGqKQlJkXxUhaZizHpXwqPxMUEAAZd9+YdZbAVP/dAJVJ3o5I65CS7
 1EIw==
MIME-Version: 1.0
References: <20221121140121.1079100-1-armbru@redhat.com>
In-Reply-To: <20221121140121.1079100-1-armbru@redhat.com>
From: Max Filippov <jcmvbkbc@gmail.com>
Date: Mon, 21 Nov 2022 08:42:30 -0800
Message-ID: <CAMo8BfKxve8=RKqT6S8XXy1E7hczF0VO9XXZeUpha_4xNSV6WA@mail.gmail.com>
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
Cc: qemu-devel@nongnu.org, fam@euphon.net, kwolf@redhat.com, hreitz@redhat.com, groug@kaod.org, qemu_oss@crudebyte.com, Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, philmd@linaro.org, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, berrange@redhat.com, thuth@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-block@nongnu.org, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com

On Mon, Nov 21, 2022 at 6:01 AM Markus Armbruster <armbru@redhat.com> wrote:
>  .../xtensa/core-dsp3400/xtensa-modules.c.inc  | 136 +++++-------------
>  target/xtensa/core-lx106/xtensa-modules.c.inc |  16 +--

These files are generated and were imported from xtensa configuration
overlays, they're not supposed to be changed.

-- 
Thanks.
-- Max

