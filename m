Return-Path: <philmd@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=520OhGqupNZR20qXPew608iecNLLax9WTeOJwvrzNq8=;
 b=ADhsMwZ1Vl9F8K0T3Te4SY85k6hqTwIDJgt4GfQV9sTGNx9bZawSFxer+77Vy/Pmft
 tfNa/jYEpIZcpfT9xOH7/qoFn3pk43oPACsID95lLXj1QvyNw27ISytXefg8o0VlJ4lW
 FRG3rxRBMLP3z1U92N8X7duGX3YSIK824llKXagdX2oMS9vBOrisO8SUyaYGt2ejXw+X
 veLJEcro30jwVDAJeWq5L7tvbh896UOhVrfwnYNcpmNWDCA9yHRCRhUB890Q+f3Q7fGu
 jnHvK2TLlES2Af5nDxL5kAj1zUMedXbgUoWAQ0UTkC8Iwz+MhiGfOiTSFQx0242vzemR
 PWpA==
Message-ID: <98e366c2-704a-cd21-0ae6-4ded79f21641@linaro.org>
Date: Tue, 22 Nov 2022 16:05:42 +0100
MIME-Version: 1.0
References: <20221122134917.1217307-1-armbru@redhat.com>
 <20221122134917.1217307-3-armbru@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221122134917.1217307-3-armbru@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
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
To: Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc: groug@kaod.org, qemu_oss@crudebyte.com, Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, berrange@redhat.com, thuth@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com, Fam Zheng <fam@euphon.net>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, qemu-block@nongnu.org

On 22/11/22 14:49, Markus Armbruster wrote:
> Cc: Fam Zheng <fam@euphon.net>
> Cc: Kevin Wolf <kwolf@redhat.com>
> Cc: Hanna Reitz <hreitz@redhat.com>
> Cc: qemu-block@nongnu.org
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   block/vmdk.c | 28 +++++++++++-----------------
>   1 file changed, 11 insertions(+), 17 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

