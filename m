References: <20210104132401.5100-1-lersek@redhat.com>
	<f296274e-3c4b-bb90-ca4a-273c3bd97f7f@de.ibm.com>
	<d9f913fa-9d1b-8d52-d98b-ae558e4406ca@redhat.com>
	<656f8775-aeb4-3feb-0373-5f9024c6c7aa@de.ibm.com>
From: Laszlo Ersek <lersek@redhat.com>
Message-ID: <62389313-313b-ce99-0522-f7d4ccc76c95@redhat.com>
Date: Mon, 11 Jan 2021 17:16:19 +0100
MIME-Version: 1.0
In-Reply-To: <656f8775-aeb4-3feb-0373-5f9024c6c7aa@de.ibm.com>
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
To: Christian Borntraeger <borntraeger@de.ibm.com>, qemu devel list <qemu-devel@nongnu.org>
Cc: Halil Pasic <pasic@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, virtio-fs@redhat.com, qemu-s390x@nongnu.org

On 01/11/21 11:07, Christian Borntraeger wrote:
> 
> 
> On 11.01.21 11:05, Laszlo Ersek wrote:
>> On 01/11/21 10:46, Christian Borntraeger wrote:
>>>
>>>
>>> On 04.01.21 14:24, Laszlo Ersek wrote:
>>>> virtio-fs qualifies as a bootable device minimally under OVMF, but
>>>> currently the necessary "bootindex" property is missing (fw_cfg kernel
>>>> boot notwithstanding).
>>>>
>>>> Add the property. For completeness, add it to the CCW device as well;
>>>> other virtio-ccw devices seem to have "bootindex" properties too.
>>>
>>> Currently we do not have boot support for virtiofs on s390x (ccw)
>>> Not sure if it is better if we should add the property now or whenever
>>> boot support is implemented. 
>>> As of today we do have bootindex for block and net. Maybe it is better
>>> to defer bootindex for virtio-fs-ccw until we can boot from it? In
>>> that way management software can detect if this is bootable or not?
>>
>> Sure, I can drop the "vhost-user-fs-ccw.c hunk".
>>
>> (I guess I could even lift the property itself (replacing the alias) to
>> "vhost-user-fs-pci.c", for now -- what's everyone's take on that?)
> 
> Keep it as is. This would simplify a later addition to ccw.
> 

Thanks!

I'll wait for some feedback from the other reviewers, before posting v2.

Laszlo

