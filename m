Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1696934692; x=1697539492; darn=redhat.com;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=0LS++g/ohxxCYPIIdcs8Jo1hYEcLEdbQjh4C7ZkjUuU=;
 b=TjsJk9+CKEbUQueombQ80mcLY2YRHyH/k6oKJKlb4YRSYScZESRRI08IpDkW7biOfm
 jtvKj+qRU/vLopLMJG8Fdoh2BEriowUEVzozACC5zFSlW4tUe1WfUilSzLMfrtneWog9
 CHoEJRZtEnjHQDXLuivMBr2AP3jV7MADrlE51K9s75Jn77/c6TwU3R8Z6SQy7mmGz0w4
 zp8fkT+Fkm+UZtoxoi93J1kkFPYLL2cOABvmeR7iO3d8znWY/u7qksO294fAUkECWiwB
 TwYUvKpDqG/tsxu44ux6m4aa4C9Kgx0kS2L3WByKRO5wfHW5hqF7tGCjZbXSdhsJaRHu
 2dfg==
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
 <e35f9f71-8d9d-6250-cbaa-70412b5a1149@nvidia.com>
 <3f28b1a4-d618-39df-57e6-6152f61cac6e@redhat.com>
 <8f3694c1-48d4-f34b-8f91-3bc217182ffa@redhat.com>
 <e19eb113-89b1-92ed-3375-8bc93c1ff39c@redhat.com>
 <8f51f02b-4676-c566-7304-f63e76df74ba@nvidia.com>
 <9a36a319-4567-f297-f14a-2025792ae93f@redhat.com>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Tue, 10 Oct 2023 11:36:31 +0100
In-reply-to: <9a36a319-4567-f297-f14a-2025792ae93f@redhat.com>
Message-ID: <87lecapxi4.fsf@linaro.org>
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
Cc: Yajun Wu <yajunw@nvidia.com>, "Michael S. Tsirkin" <mst@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, Eugenio =?utf-8?Q?P=C3=A9rez?= <eperezma@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Parav Pandit <parav@nvidia.com>, "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>


Hanna Czenczek <hreitz@redhat.com> writes:

> On 10.10.23 06:00, Yajun Wu wrote:
>>
>> On 10/9/2023 5:13 PM, Hanna Czenczek wrote:
>>> External email: Use caution opening links or attachments
>>>
>>>
>>> On 09.10.23 11:07, Hanna Czenczek wrote:
>>>> On 09.10.23 10:21, Hanna Czenczek wrote:
>>>>> On 07.10.23 04:22, Yajun Wu wrote:
>>>> [...]
>>>>
<snip>
> So as far as I understand, the feature is supposed to rely on
> implementation-specific behavior between specifically qemu as a
> front-end and dpdk as a back-end, nothing else.=C2=A0 Honestly, that to m=
e
> is a very good reason to deprecate it.=C2=A0 That would make it clear tha=
t
> any implementation that implements it does so because it relies on
> implementation-specific behavior from other implementations.
>
> Option 2 is to fix it.=C2=A0 It is not right to use this broadly defined
> feature with its clear protocol as given in the virtio specification
> just to set and clear a single bit (DRIVER_OK).=C2=A0 The vhost-user
> specification points to that virtio protocol.=C2=A0 We must adhere to the
> protocol.=C2=A0 And note that we must not reset devices just because the =
VM
> is paused/resumed.=C2=A0 (That is why I wanted to deprecate SET_STATUS, s=
o
> that Stefan=E2=80=99s series would introduce RESET_DEVICE where we need i=
t,
> and we can (for now) ignore the SET_STATUS 0 in vhost_dev_stop().)
>
> Option 3 would be to just be honest in the specification, and limit
> the scope of F_STATUS to say the only bit that matters is DRIVER_OK.=C2=
=A0
> I would say this is not really different from deprecating, though it
> wouldn=E2=80=99t affect your case.=C2=A0 However, I understand Alex relie=
s on a
> full status byte.=C2=A0 I=E2=80=99m still interested to know why that is.

For an F_TRANSPORT backend (or whatever the final name ends up being) we
need the backend to have full control of the status byte because all the
handling of VirtIO is deferred to it. Therefor it has to handle all the
feature negotiation and indicate when the device needs resetting.

(side note: feature negotiation is another slippery area when QEMU gets
involved in gating which feature bits may or may not be exposed to the
backend. The only one it should ever mask is F_UNUSED which is used
(sic) to trigger the vhost protocol negotiation)

> Option 4 is of course not to do anything, and leave everything as-is,
> waiting for the next person to stir the hornet=E2=80=99s nest.
>
>>>> Cc-ing Alex on this mail, because to me, this seems like an important
>>>> detail when he plans on using the byte in the future. If we need a
>>>> virtio status byte, I can=E2=80=99t see how we could use the existing =
F_STATUS
>>>> for it.

What would we use instead of F_STATUS to query the Device Status field?

>>>>
>>>> Hanna
>>


--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

