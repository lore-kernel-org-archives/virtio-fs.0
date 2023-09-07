Return-Path: <hao.xu@linux.dev>
Message-ID: <8a8321ba-3ad3-49e2-41bc-d8ee42c0f0fc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1694060398;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=95+eboJApKm8MWKtY+9fHi/Cd+2e7rZuHtsnNsp99UA=;
 b=eRe6jYLCbM/ti9WWcx5GY+kkTlMEMLMUGS7CJnkJKlVnTF3dSTxFcIdYyTw0d/le2PYi2M
 Yu3CtexaP3brpXmoyM5LR8ub7bikC5dqiE74DgKpRONrOxTjU6GTnrWpk12PmMA5wfRke1
 souTjtxLiiyJAeWMW7HrJa+D32oEsoY=
Date: Thu, 7 Sep 2023 12:19:50 +0800
MIME-Version: 1.0
References: <87v8grlzu9.fsf@linaro.org>
 <CAJSP0QX+NeJ8Z5d+2ocUUVj4EGopxKT+trmEfacgvhE7TqCokQ@mail.gmail.com>
 <5e6b1bbd-bc0a-cff5-119c-639a9d15e72a@linux.dev>
 <CAJSP0QUZ51y4bBTRgp_g6AO_6iEFamhOqMbcfFi5UiWBCkJQJQ@mail.gmail.com>
From: Hao Xu <hao.xu@linux.dev>
In-Reply-To: <CAJSP0QUZ51y4bBTRgp_g6AO_6iEFamhOqMbcfFi5UiWBCkJQJQ@mail.gmail.com>
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
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Vivek Goyal <vgoyal@redhat.com>


On 9/6/23 21:57, Stefan Hajnoczi wrote:
> On Wed, 6 Sept 2023 at 09:07, Hao Xu <hao.xu@linux.dev> wrote:
>> On 5/18/23 00:26, Stefan Hajnoczi wrote:
>>> On Wed, 17 May 2023 at 11:54, Alex Benn=C3=A9e <alex.bennee@linaro.org>=
 wrote:
>>> Hi Alex,
>>> There were two unresolved issues:
>>>
>>> 1. How to inject SIGBUS when the guest accesses a page that's beyond
>>> the end-of-file.
>> Hi Stefan,
>> Does this SIGBUS issue exist if the guest kernel can be trusted? Since i=
n
>>
>> that case, we can check the offset value in guest kernel.
> The scenario is:
> 1. A guest userspace process has a DAX file mmapped.
> 2. The host or another guest that is also sharing the directory
> truncates the file. The pages mmapped by our guest are no longer
> valid.
> 3. The guest loads from an mmapped page and a vmexit occurs.
> 4. Now the host must inject a SIGBUS into the guest. There is
> currently no way to do this.
>
> I believe this scenario doesn't happen within a single guest, because
> the guest kernel will raise SIGBUS itself without a vmexit if another
> process inside that same guest truncates the file.
>
> Another scenario is when the guest kernel access the DAX pages. A
> vmexit can occur here too.
>
> If you trust the host and all guests sharing the directory not to
> truncate files that are mmapped, then this issue will not occur.
>
> Stefan


I see, my use case should be fine since the directory is not shared and=20
fs is read-only.

Thanks for detail explanation.


Regards,

Hao

