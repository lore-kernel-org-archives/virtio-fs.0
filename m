Received: from zero.eik.bme.hu (zero.eik.bme.hu [152.66.115.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005E91A3178
	for <virtio-fs@lists.linux.dev>; Tue, 21 Oct 2025 13:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.66.115.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761054443; cv=none; b=qmCr0FfXW9cS0duKm03kw5sRU/HUzOXr+pnDMsH+dJBWwpYhQO7ELsB2IulcJfHwQm7M82E2axg6g1E6zt+ZSOLOeFwvDdIEMIQm7sYAssAAPfsKPjwnL4LWECZBkH3ydlHRO7wKNQsD/083NiosknhySTR7EeR0w/YrG4KywgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761054443; c=relaxed/simple;
	bh=1voBQQGEt5oNRpy6qnelVY5sDAm4IIgqmN/FAphLbpY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WRlpEjYs4rVxhuHHzBO4vlIcd2pLqZhIuWLksiqGJpphhx7052cidPmyRFOC2k7FcY8yGH8+dwmDikXK/wDIvtdAt5M5YS7DD1Pm0BdkBZz47UK9TxsKyYaQjNLLlNLt7KThR30CKrcgwPuyAYhkJUUjVxKddgJfCvX6CCFWUsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu; spf=pass smtp.mailfrom=eik.bme.hu; arc=none smtp.client-ip=152.66.115.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eik.bme.hu
Received: from localhost (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 832FD5972E3;
	Tue, 21 Oct 2025 15:25:07 +0200 (CEST)
X-Virus-Scanned: amavis at eik.bme.hu
Received: from zero.eik.bme.hu ([127.0.0.1])
 by localhost (zero.eik.bme.hu [127.0.0.1]) (amavis, port 10028) with ESMTP
 id Gg8qekahyVnk; Tue, 21 Oct 2025 15:25:05 +0200 (CEST)
Received: by zero.eik.bme.hu (Postfix, from userid 432)
	id 25D775972E4; Tue, 21 Oct 2025 15:25:05 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 218E05972E1;
	Tue, 21 Oct 2025 15:25:05 +0200 (CEST)
Date: Tue, 21 Oct 2025 15:25:05 +0200 (CEST)
From: BALATON Zoltan <balaton@eik.bme.hu>
To: =?ISO-8859-15?Q?Marc-Andr=E9_Lureau?= <marcandre.lureau@redhat.com>
cc: qemu-devel@nongnu.org, pbonzini@redhat.com, 
    "Michael S. Tsirkin" <mst@redhat.com>, 
    Stefano Garzarella <sgarzare@redhat.com>, 
    "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
    Zhenwei Pi <pizhenwei@bytedance.com>, Laurent Vivier <lvivier@redhat.com>, 
    Amit Shah <amit@kernel.org>, Stefan Berger <stefanb@linux.vnet.ibm.com>, 
    =?ISO-8859-15?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, 
    =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>, 
    Peter Maydell <peter.maydell@linaro.org>, 
    Igor Mitsyanko <i.mitsyanko@gmail.com>, 
    =?ISO-8859-15?Q?Cl=E9ment_Chigot?= <chigot@adacore.com>, 
    Frederic Konrad <konrad.frederic@yahoo.fr>, 
    Alberto Garcia <berto@igalia.com>, Thomas Huth <huth@tuxfamily.org>, 
    Halil Pasic <pasic@linux.ibm.com>, 
    Christian Borntraeger <borntraeger@linux.ibm.com>, 
    Jason Herne <jjherne@linux.ibm.com>, 
    Yoshinori Sato <yoshinori.sato@nifty.com>, 
    Magnus Damm <magnus.damm@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, 
    Harsh Prateek Bora <harshpb@linux.ibm.com>, 
    "Collin L. Walling" <walling@linux.ibm.com>, 
    Stefano Stabellini <sstabellini@kernel.org>, 
    Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>, 
    "Edgar E. Iglesias" <edgar.iglesias@gmail.com>, 
    Alistair Francis <alistair@alistair23.me>, 
    =?ISO-8859-15?Q?Daniel_P=2E_Berrang=E9?= <berrange@redhat.com>, 
    Eduardo Habkost <eduardo@habkost.net>, Corey Minyard <minyard@acm.org>, 
    Paul Burton <paulburton@kernel.org>, Aleksandar Rikalo <arikalo@gmail.com>, 
    Aurelien Jarno <aurelien@aurel32.net>, Palmer Dabbelt <palmer@dabbelt.com>, 
    Weiwei Li <liwei1518@gmail.com>, 
    Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
    Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, 
    Samuel Thibault <samuel.thibault@ens-lyon.org>, 
    Michael Rolnik <mrolnik@gmail.com>, 
    Antony Pavlov <antonynpavlov@gmail.com>, Joel Stanley <joel@jms.id.au>, 
    Vijai Kumar K <vijai@behindbytes.com>, Samuel Tardieu <sam@rfc1149.net>, 
    Gustavo Romero <gustavo.romero@linaro.org>, 
    Raphael Norwitz <raphael@enfabrica.net>, 
    Stefan Hajnoczi <stefanha@redhat.com>, 
    "reviewer:vhost-user-scmi" <mzamazal@redhat.com>, 
    Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
    Dmitry Osipenko <dmitry.osipenko@collabora.com>, 
    Fabiano Rosas <farosas@suse.de>, Markus Armbruster <armbru@redhat.com>, 
    "Dr. David Alan Gilbert" <dave@treblig.org>, 
    Zhang Chen <zhangckid@gmail.com>, Li Zhijian <lizhijian@fujitsu.com>, 
    Jason Wang <jasowang@redhat.com>, 
    Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, 
    Richard Henderson <richard.henderson@linaro.org>, 
    Helge Deller <deller@gmx.de>, Max Filippov <jcmvbkbc@gmail.com>, 
    Lukas Straub <lukasstraub2@web.de>, 
    "open list:Sharp SL-5500 Co..." <qemu-arm@nongnu.org>, 
    "open list:S390 SCLP-backed..." <qemu-s390x@nongnu.org>, 
    "open list:sPAPR (pseries)" <qemu-ppc@nongnu.org>, 
    "open list:X86 Xen CPUs" <xen-devel@lists.xenproject.org>, 
    "open list:RISC-V TCG CPUs" <qemu-riscv@nongnu.org>, 
    "open list:virtiofs" <virtio-fs@lists.linux.dev>, 
    "open list:Rust-related patc..." <qemu-rust@nongnu.org>
Subject: Re: [PATCH] char: rename CharBackend->CharFrontend
In-Reply-To: <20251021122533.721467-1-marcandre.lureau@redhat.com>
Message-ID: <01a51fe7-4414-e787-ddf5-5ede0c1e1e74@eik.bme.hu>
References: <20251021122533.721467-1-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3866299591-1500696156-1761053105=:49605"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--3866299591-1500696156-1761053105=:49605
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 21 Oct 2025, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
>
> The actual backend is "Chardev", CharBackend is the frontend side of it,
> let's rename it for readability.
>
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> ---
> chardev/chardev-internal.h           |  12 +-
> include/chardev/char-fe.h            |  67 +++++----
> include/chardev/char.h               |   4 +-
> include/hw/char/avr_usart.h          |   2 +-
> include/hw/char/bcm2835_aux.h        |   2 +-
> include/hw/char/cadence_uart.h       |   2 +-
> include/hw/char/cmsdk-apb-uart.h     |   2 +-
> include/hw/char/digic-uart.h         |   2 +-
> include/hw/char/escc.h               |   2 +-
> include/hw/char/goldfish_tty.h       |   2 +-
> include/hw/char/ibex_uart.h          |   2 +-
> include/hw/char/imx_serial.h         |   2 +-
> include/hw/char/max78000_uart.h      |   2 +-
> include/hw/char/nrf51_uart.h         |   2 +-
> include/hw/char/parallel.h           |   2 +-
> include/hw/char/pl011.h              |   2 +-
> include/hw/char/renesas_sci.h        |   2 +-
> include/hw/char/riscv_htif.h         |   2 +-
> include/hw/char/serial.h             |   2 +-
> include/hw/char/shakti_uart.h        |   2 +-
> include/hw/char/sifive_uart.h        |   2 +-
> include/hw/char/stm32f2xx_usart.h    |   2 +-
> include/hw/char/stm32l4x5_usart.h    |   2 +-
> include/hw/misc/ivshmem-flat.h       |   2 +-
> include/hw/qdev-properties-system.h  |   2 +-
> include/hw/virtio/vhost-user-base.h  |   2 +-
> include/hw/virtio/vhost-user-blk.h   |   2 +-
> include/hw/virtio/vhost-user-fs.h    |   2 +-
> include/hw/virtio/vhost-user-scmi.h  |   2 +-
> include/hw/virtio/vhost-user-vsock.h |   2 +-
> include/hw/virtio/vhost-user.h       |   8 +-
> include/hw/virtio/virtio-gpu.h       |   2 +-
> include/hw/virtio/virtio-scsi.h      |   2 +-
> include/system/qtest.h               |   4 +-
> include/system/vhost-user-backend.h  |   2 +-
> monitor/monitor-internal.h           |   2 +-
> backends/cryptodev-vhost-user.c      |   2 +-
> backends/rng-egd.c                   |   2 +-
> backends/tpm/tpm_emulator.c          |   4 +-
> chardev/char-fe.c                    | 142 +++++++++----------
> chardev/char-hub.c                   |  18 +--
> chardev/char-mux.c                   |  40 +++---
> chardev/char.c                       |   8 +-
> gdbstub/system.c                     |   2 +-
> hw/arm/strongarm.c                   |   2 +-
> hw/char/debugcon.c                   |   2 +-
> hw/char/exynos4210_uart.c            |   2 +-
> hw/char/grlib_apbuart.c              |   2 +-
> hw/char/ipoctal232.c                 |   2 +-
> hw/char/mcf_uart.c                   |   2 +-
> hw/char/sclpconsole-lm.c             |   2 +-
> hw/char/sclpconsole.c                |   2 +-
> hw/char/sh_serial.c                  |   2 +-
> hw/char/spapr_vty.c                  |   2 +-
> hw/char/terminal3270.c               |   2 +-
> hw/char/virtio-console.c             |   2 +-
> hw/char/xen_console.c                |   2 +-
> hw/char/xilinx_uartlite.c            |   2 +-
> hw/core/qdev-properties-system.c     |  16 +--
> hw/ipmi/ipmi_bmc_extern.c            |   2 +-
> hw/mips/boston.c                     |   2 +-
> hw/mips/malta.c                      |   2 +-
> hw/misc/ivshmem-pci.c                |   2 +-
> hw/ppc/spapr_rtas.c                  |   2 +-
> hw/riscv/riscv_hart.c                |   2 +-
> hw/usb/ccid-card-passthru.c          |   2 +-
> hw/usb/dev-serial.c                  |   2 +-
> hw/usb/redirect.c                    |   2 +-
> hw/virtio/vhost-stub.c               |   2 +-
> hw/virtio/vhost-user.c               |  20 +--
> net/colo-compare.c                   |  10 +-
> net/filter-mirror.c                  |   4 +-
> net/passt.c                          |   2 +-
> net/slirp.c                          |   2 +-
> net/vhost-user.c                     |   2 +-
> semihosting/console.c                |   6 +-
> system/qtest.c                       |  20 +--
> target/hppa/sys_helper.c             |   2 +-
> target/xtensa/xtensa-semi.c          |   2 +-
> tests/qtest/vhost-user-test.c        |  16 +--
> tests/unit/test-char.c               | 198 +++++++++++++--------------
> tests/unit/test-yank.c               |  12 +-
> rust/bindings/src/lib.rs             |   4 +-
> rust/chardev/src/bindings.rs         |   6 +-
> rust/chardev/src/chardev.rs          |  26 ++--
> rust/hw/char/pl011/src/device.rs     |  12 +-
> rust/hw/core/src/qdev.rs             |   2 +-
> 87 files changed, 392 insertions(+), 393 deletions(-)
>
> diff --git a/chardev/chardev-internal.h b/chardev/chardev-internal.h
> index 9752dd75f7..8ea10414ab 100644
> --- a/chardev/chardev-internal.h
> +++ b/chardev/chardev-internal.h
> @@ -37,9 +37,9 @@
> struct MuxChardev {
>     Chardev parent;
>     /* Linked frontends */
> -    CharBackend *backends[MAX_MUX];
> -    /* Linked backend */
> -    CharBackend chr;
> +    CharFrontend *frontends[MAX_MUX];
> +    /* frontend of the underlying muxed chardev */
> +    CharFrontend chr;
>     unsigned long mux_bitset;
>     int focus;
>     bool term_got_escape;
> @@ -64,8 +64,8 @@ typedef struct HubCharBackend HubCharBackend;
>  * `hub->backends` array
>  */
> struct HubCharBackend {
> -    HubChardev   *hub;
> -    CharBackend  be;
> +    HubChardev *hub;
> +    CharFrontend fe;
>     unsigned int be_ind;
> };
>
> @@ -108,7 +108,7 @@ DECLARE_INSTANCE_CHECKER(HubChardev, HUB_CHARDEV,
> #define CHARDEV_IS_HUB(chr)                                \
>     object_dynamic_cast(OBJECT(chr), TYPE_CHARDEV_HUB)
>
> -bool mux_chr_attach_frontend(MuxChardev *d, CharBackend *b,
> +bool mux_chr_attach_frontend(MuxChardev *d, CharFrontend *c,
>                              unsigned int *tag, Error **errp);
> bool mux_chr_detach_frontend(MuxChardev *d, unsigned int tag);
> void mux_set_focus(Chardev *chr, unsigned int focus);
> diff --git a/include/chardev/char-fe.h b/include/chardev/char-fe.h
> index 8ef05b3dd0..cb28692f38 100644
> --- a/include/chardev/char-fe.h
> +++ b/include/chardev/char-fe.h
> @@ -8,12 +8,12 @@ typedef void IOEventHandler(void *opaque, QEMUChrEvent event);
> typedef int BackendChangeHandler(void *opaque);
>
> /**
> - * struct CharBackend - back end as seen by front end
> + * struct CharFrontend - back end as seen by front end

I stopped here, haven't read the rest of the patch but the above comment 
seems to become inconsistent. Which is the front end and back end now?

Regards,
BALATON Zoltan
--3866299591-1500696156-1761053105=:49605--
