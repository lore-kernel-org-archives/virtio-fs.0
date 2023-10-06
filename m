Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1696625611; x=1697230411; darn=redhat.com;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=kuLACqjs8ut0bAk+buG0eQ4Qk0kx2QAaHMPo4L8iR4E=;
 b=OBGcehc+kS0exep6DdapKgFRbAvwo/Cjt7ZuUxx5w8iwKUObSBpnM8Hyvjn3OMmX+P
 clisiK9BcCX/MjocaddloXuot1UHpesHr2OAVYP24RsFLVUasy1vxkkgbA2X22YR6LRp
 RPXpnhLd9Jss1Ac1mLIMIYV2GBOfFwaCBU9XmRLz4Z0Tfv+KtWufSdf3oqLe8VpF1fJR
 1OfqWIC043vf7bchEPqjgmXLfR0GxMEl68YKMQrpHd5rLe4JYFoeZFfnwtssiS/nkLHt
 72O08H6jpEw/JHmP3/46J/gQhuNEtDC89ceWny74X4yjdAevT+bZOGz7pVMiqm7FCobl
 SmmA==
References: <20231004125904.110781-1-hreitz@redhat.com>
 <20231004125904.110781-2-hreitz@redhat.com>
 <20231005170852.GB1342722@fedora>
 <20231005131352-mutt-send-email-mst@kernel.org>
 <00272da3-0a48-5544-6ba8-5dfde00be241@redhat.com>
 <20231006043518-mutt-send-email-mst@kernel.org>
 <a8b9d842-0925-38d0-2f0d-f2560bab251b@redhat.com>
 <20231006051802-mutt-send-email-mst@kernel.org>
 <a4af0357-12ee-fc7f-e249-239da34409b0@redhat.com>
 <20231006055229-mutt-send-email-mst@kernel.org>
 <d9c2d2c4-5ab3-a3f3-8925-155e1c4ff73a@redhat.com>
 <87il7jg4oe.fsf@linaro.org>
 <2ba3ef6b-4af1-9c65-f542-bfcc8412e99c@redhat.com>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Fri, 06 Oct 2023 21:49:30 +0100
In-reply-to: <2ba3ef6b-4af1-9c65-f542-bfcc8412e99c@redhat.com>
Message-ID: <875y3j4gmu.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] (no subject)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Eugenio =?utf-8?Q?P=C3=A9rez?= <eperezma@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Yajun Wu <yajunw@nvidia.com>, qemu-devel@nongnu.org


Hanna Czenczek <hreitz@redhat.com> writes:

> On 06.10.23 17:17, Alex Benn=C3=A9e wrote:
>> Hanna Czenczek <hreitz@redhat.com> writes:
>>
>>> On 06.10.23 12:34, Michael S. Tsirkin wrote:
>>>> On Fri, Oct 06, 2023 at 11:47:55AM +0200, Hanna Czenczek wrote:
>>>>> On 06.10.23 11:26, Michael S. Tsirkin wrote:
>>>>>> On Fri, Oct 06, 2023 at 11:15:55AM +0200, Hanna Czenczek wrote:
>>>>>>> On 06.10.23 10:45, Michael S. Tsirkin wrote:
>>>>>>>> On Fri, Oct 06, 2023 at 09:48:14AM +0200, Hanna Czenczek wrote:
>>>>>>>>> On 05.10.23 19:15, Michael S. Tsirkin wrote:
>>>>>>>>>> On Thu, Oct 05, 2023 at 01:08:52PM -0400, Stefan Hajnoczi wrote:
>>>>>>>>>>> On Wed, Oct 04, 2023 at 02:58:57PM +0200, Hanna Czenczek wrote:
>> <snip>
>>>>> What I=E2=80=99m saying is, 923b8921d21 introduced SET_STATUS calls t=
hat broke all
>>>>> devices that would implement them as per virtio spec, and even today =
it=E2=80=99s
>>>>> broken for stateful devices.=C2=A0 The mentioned performance issue is=
 likely
>>>>> real, but we can=E2=80=99t address it by making up SET_STATUS calls t=
hat are wrong.
>>>>>
>>>>> I concede that I didn=E2=80=99t think about DRIVER_OK.=C2=A0 Personal=
ly, I would do all
>>>>> final configuration that would happen upon a DRIVER_OK once the first=
 vring
>>>>> is started (i.e. receives a kick).=C2=A0 That has the added benefit o=
f being
>>>>> asynchronous because it doesn=E2=80=99t block any vhost-user messages=
 (which are
>>>>> synchronous, and thus block downtime).
>>>>>
>>>>> Hanna
>>>> For better or worse kick is per ring. It's out of spec to start rings
>>>> that were not kicked but I guess you could do configuration ...
>>>> Seems somewhat asymmetrical though.
>>> I meant to take the first ring being started as the signal to do the
>>> global configuration, i.e. not do this once per vring, but once
>>> globally.
>>>
>>>> Let's wait until next week, hopefully Yajun Wu will answer.
>>> I mean, personally I don=E2=80=99t really care about the whole SET_STAT=
US
>>> thing.=C2=A0 It=E2=80=99s clear that it=E2=80=99s broken for stateful d=
evices.=C2=A0 The fact
>>> that it took until 6f8be29ec17d to fix it for just any device that
>>> would implement it according to spec to me is a strong indication that
>>> nobody does implement it according to spec, and is currently only used
>>> to signal to some specific back-end that all rings have been set up
>>> and should be configured in a single block.
>> I'm certainly using [GS]ET_STATUS for the proposed F_TRANSPORT
>> extensions where everything is off-loaded to the vhost-user backend.
>
> How do these back-ends work with the fact that qemu uses SET_STATUS
> incorrectly when not offloading?=C2=A0 Do you plan on fixing that?

Mainly having a common base implementation which does it right and
having very lightweight derivations for legacy stubs using it. The
aim is to eliminate the need for QEMU stubs entirely by fully specifying
the device from the vhost-user API.=20

> (I.e. that we send SET_STATUS 0 when the VM is paused, potentially
> resetting state that is not recoverable, and that we set DRIVER and
> DRIVER_OK simultaneously.)

This is QEMU simulating a SET_STATUS rather than the guest triggering
it?

>
> Hanna


--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

