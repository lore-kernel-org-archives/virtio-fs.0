Return-Path: <borntraeger@linux.ibm.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=K9KRjG67TpeFEnUrk/bSbQHxPqfw6kC46QRcm6DCuFs=;
 b=JD6sjBH8szUYzEJMVag5Vvwy/YcGzltxLXMB9xN5oKZpxy4UNU6rpxs4bhB5xEIDTQCT
 i6Ja0pB+y871zfPX03YbCUlPtlEttUk9tzZRf94SY7JMnEAXI4MkCHZgihP63pfOAJoR
 W/SeSF1jefeJtA6tlSAA2Pz+AYJN5cxgeAE9cyzjcGVVOl0BPrLVS4faaZsfglqZaH2m
 uo/48OtQMWh37hgyvIPry5UzClWJZex+zSJSbeAmarC0/hSDB9NR8J9WVPXTmj6nKDg8
 qGu6EL1Rk6Bc2iuFuI2AQR4eYFWYbBGMfuYjTg/EaTH6DMPW7cs/0Qfv5t60//VHdgU2 5g==
Message-ID: <a0fdeb2a-7b95-d07b-dfce-ae5c6efd6c60@linux.ibm.com>
Date: Tue, 15 Nov 2022 08:44:31 +0100
MIME-Version: 1.0
References: <20221108092308.1717426-1-alex.bennee@linaro.org>
 <20221108092308.1717426-6-alex.bennee@linaro.org>
 <2277569a-c218-30d1-4d88-9b77d3604513@linux.ibm.com>
 <20221114113518-mutt-send-email-mst@kernel.org>
 <aaae3f2a-c5bb-8e62-09d4-4f6f43efe37b@linux.ibm.com>
 <20221114115549-mutt-send-email-mst@kernel.org>
 <2bd5f801-a203-2598-3e6e-ed8f5dad5159@linux.ibm.com>
 <20221114121959-mutt-send-email-mst@kernel.org>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221114121959-mutt-send-email-mst@kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v1 5/9] hw/virtio: introduce
 virtio_device_should_start
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, qemu-devel@nongnu.org, fam@euphon.net, berrange@redhat.com, f4bug@amsat.org, aurelien@aurel32.net, pbonzini@redhat.com, stefanha@redhat.com, crosa@redhat.com, Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "open list:Block layer core" <qemu-block@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>



Am 14.11.22 um 18:20 schrieb Michael S. Tsirkin:
[...]

>>>>>
>>>>>> This does not seem to fix the regression that I have reported.
>>>>>
>>>>> This was applied on top of 9f6bcfd99f which IIUC does, right?

Just dobble checked,

9f6bcfd99f was the patch that created the original problem, no?

