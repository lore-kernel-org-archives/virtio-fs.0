Return-Path: <peter.maydell@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=xbzPrvxw2h7QjvfNhdzgLlnm6lp5QdzEPwm67XjpXOk=;
 b=KzxzDmjt3znUwalezP3CogqSzCZmmSdieXsuEUbDMNJQ9BxfDXUwc+Jjh1RAQGzk0D
 M7x9r/SjnqM10pYpZuCABWbQ7V1g5C6osSxkT6Br6avxn8juEptKc8jM4Zvy97pWqkze
 a8IhFy6/udMHHmWkgjN3UJLA59FPoimJ6EvSnpSku0EgcjhXX5wga4zyoA5osPg4IxXg
 wVpMsJvg3h7CXeilGTVRazsQaWbmJ5LcklLQYwA14AMp07Y8iYKTwh29nF/HOjAPjHse
 OWfDTIDIxGNoLOhSEHOa0Kb9Q07dZKa6Ol7dw0NPlaAlaBB7hX9CWrCoZ9w5z7seAnKb
 m/1Q==
MIME-Version: 1.0
References: <20221122134917.1217307-1-armbru@redhat.com>
 <20221122134917.1217307-3-armbru@redhat.com>
In-Reply-To: <20221122134917.1217307-3-armbru@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 22 Nov 2022 13:52:58 +0000
Message-ID: <CAFEAcA9q=zAL-PrpRpmpv-4wyobdbFGLzYeWdjvkDoSQLwktOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v2 2/2] block/vmdk: Simplify
 vmdk_co_create() to return directly
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, groug@kaod.org, qemu_oss@crudebyte.com, Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, philmd@linaro.org, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, berrange@redhat.com, thuth@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com, Fam Zheng <fam@euphon.net>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, qemu-block@nongnu.org

On Tue, 22 Nov 2022 at 13:51, Markus Armbruster <armbru@redhat.com> wrote:
>
> Cc: Fam Zheng <fam@euphon.net>
> Cc: Kevin Wolf <kwolf@redhat.com>
> Cc: Hanna Reitz <hreitz@redhat.com>
> Cc: qemu-block@nongnu.org
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>  block/vmdk.c | 28 +++++++++++-----------------
>  1 file changed, 11 insertions(+), 17 deletions(-)
>

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

thanks
-- PMM

