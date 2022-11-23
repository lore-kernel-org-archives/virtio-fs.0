Return-Path: <borntraeger@linux.ibm.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=f3va+/SphwP6sdsNM5q5RK2LYlnN4U9KOUFr9dso2XE=;
 b=r7ZvOyKaJ3cs60igpThWrmTdofZTMHfrn6Es/SyvMyrnMoRlLMGAYutUu6YJ4iSzAEF+
 npAxCt+VitKdFFAxZuCRbgNiOucuJqBd3Bnrd1o0OvwgLPCdh4HPVGEg0s2UNuP58LBL
 XPHfX2OwkLAXQCStniFhaul37d75cEFjK4mKwcu67OBSYIrwMujxbKsnhfXn7vjjTHvD
 Jw6ziaeA1q4g5Pw06bFTpjJwLpdaLJsE4heY+2GY5WZeK1hHeBO+VdMu4In0m0z/n6r1
 L8+JKYW2MHd/MIb9O/GptdXZ6K99sIlia88uZvFJuwQuef44Y2jbVAw4fLrSOyXfx2Ci 5g==
Message-ID: <7599e943-d7b2-df26-6827-9e25102dd39b@linux.ibm.com>
Date: Wed, 23 Nov 2022 07:27:40 +0100
MIME-Version: 1.0
References: <20221114113518-mutt-send-email-mst@kernel.org>
 <aaae3f2a-c5bb-8e62-09d4-4f6f43efe37b@linux.ibm.com>
 <20221114115549-mutt-send-email-mst@kernel.org>
 <2bd5f801-a203-2598-3e6e-ed8f5dad5159@linux.ibm.com>
 <20221114121959-mutt-send-email-mst@kernel.org> <87tu309tlk.fsf@linaro.org>
 <26b4e8d8-784d-d1ce-67a3-b61896701bf7@linux.ibm.com>
 <87leoc9p98.fsf@linaro.org>
 <471b71ad-1892-8ab4-a94b-c0ec3d34e6b1@linux.ibm.com>
 <1bfc2fee-5972-676e-563e-e245814e54c3@linux.ibm.com>
 <20221121173656-mutt-send-email-mst@kernel.org>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221121173656-mutt-send-email-mst@kernel.org>
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

Am 21.11.22 um 23:37 schrieb Michael S. Tsirkin:
[...]
>> qemu-system-x86_64: ../hw/virtio/vhost-vsock-common.c:203: vhost_vsock_common_pre_save: Assertion `!vhost_dev_is_started(&vvc->vhost_dev)' failed.
>> 2022-11-15 16:38:46.096+0000: shutting down, reason=crashed
> 
> Alex were you able to replicate? Just curious.

Ping?

