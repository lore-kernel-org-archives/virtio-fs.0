DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
	h=subject : to : cc :
	references : from : message-id : date : mime-version : in-reply-to :
	content-type : content-transfer-encoding; s=pp1;
	bh=E3MS8czFYe/3mwAwIxpa2VYBSzm/0iEA9DvDdJcWklk=;
	b=ds+kjwwM/e41IZ4hkRtc1Y5gasJnUHNUIrvF2gdb80q8ZFYOccCpRxy34jwPX6zz8Mg0
	9ikQ3kZN+547A7Ony2DHH8BmhoTRlica6SymnmR2AzpkPyuowUCou6K5LAunEUSs2oy4
	POFHYvqL3u6a4To/oVICUJuGsrN7GW29StrZeG8h5SSkkMWvg96nV1Ns84rJml1ZSVFC
	SLbN00NmJcM6SSJvwfEBP3r5ZDJl8s3u1xMkYkQIvPGeNGMfjM9ZpJVMYZVygJcM1RYS
	jGBXyWGVOFtHdxOvJzybAISzUYvW9xAbayw6ehAIpOZrDT41N6Xzho/I+eIAbl01ND7R
	eA==
References: <20210104132401.5100-1-lersek@redhat.com>
	<f296274e-3c4b-bb90-ca4a-273c3bd97f7f@de.ibm.com>
	<d9f913fa-9d1b-8d52-d98b-ae558e4406ca@redhat.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <656f8775-aeb4-3feb-0373-5f9024c6c7aa@de.ibm.com>
Date: Mon, 11 Jan 2021 11:07:03 +0100
MIME-Version: 1.0
In-Reply-To: <d9f913fa-9d1b-8d52-d98b-ae558e4406ca@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH] vhost-user-fs: add the "bootindex" property
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Laszlo Ersek <lersek@redhat.com>, qemu devel list <qemu-devel@nongnu.org>
Cc: virtio-fs@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, qemu-s390x@nongnu.org



On 11.01.21 11:05, Laszlo Ersek wrote:
> On 01/11/21 10:46, Christian Borntraeger wrote:
>>
>>
>> On 04.01.21 14:24, Laszlo Ersek wrote:
>>> virtio-fs qualifies as a bootable device minimally under OVMF, but
>>> currently the necessary "bootindex" property is missing (fw_cfg kernel
>>> boot notwithstanding).
>>>
>>> Add the property. For completeness, add it to the CCW device as well;
>>> other virtio-ccw devices seem to have "bootindex" properties too.
>>
>> Currently we do not have boot support for virtiofs on s390x (ccw)
>> Not sure if it is better if we should add the property now or whenever
>> boot support is implemented. 
>> As of today we do have bootindex for block and net. Maybe it is better
>> to defer bootindex for virtio-fs-ccw until we can boot from it? In
>> that way management software can detect if this is bootable or not?
> 
> Sure, I can drop the "vhost-user-fs-ccw.c hunk".
> 
> (I guess I could even lift the property itself (replacing the alias) to
> "vhost-user-fs-pci.c", for now -- what's everyone's take on that?)

Keep it as is. This would simplify a later addition to ccw.

