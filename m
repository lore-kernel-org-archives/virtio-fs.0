Return-Path: <hao.xu@linux.dev>
Message-ID: <5e6b1bbd-bc0a-cff5-119c-639a9d15e72a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1694005649;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=IGoDnKeHLbn6LihaQjYmsdl+qed6fld3ewWmJXgDQDU=;
 b=xa084eLAUybsKxGSZqgPfzGKgn30InWq1ZMFDYcOHLf7JVDhr74CnZnDqTaxo/XVhmOTZw
 07mKD8SjLlIBHr3n7KO5VYB06CUz5CV/7jElBYg+dnb1qMccnOY/3d5AZIjjcTQjxRUvRE
 41W9qWxSxddUwzkzS2a7G/zUWErcZ74=
Date: Wed, 6 Sep 2023 21:07:16 +0800
MIME-Version: 1.0
References: <87v8grlzu9.fsf@linaro.org>
 <CAJSP0QX+NeJ8Z5d+2ocUUVj4EGopxKT+trmEfacgvhE7TqCokQ@mail.gmail.com>
From: Hao Xu <hao.xu@linux.dev>
In-Reply-To: <CAJSP0QX+NeJ8Z5d+2ocUUVj4EGopxKT+trmEfacgvhE7TqCokQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] Status of DAX for virtio-fs/virtiofsd?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@gmail.com>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
Cc: virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Vivek Goyal <vgoyal@redhat.com>


On 5/18/23 00:26, Stefan Hajnoczi wrote:
> On Wed, 17 May 2023 at 11:54, Alex Benn=C3=A9e <alex.bennee@linaro.org> w=
rote:
> Hi Alex,
> There were two unresolved issues:
>
> 1. How to inject SIGBUS when the guest accesses a page that's beyond
> the end-of-file.

Hi Stefan,
Does this SIGBUS issue exist if the guest kernel can be trusted? Since in

that case, we can check the offset value in guest kernel.


Thanks,

Hao

