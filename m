DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=subject:to:references:from:message-id:date:user-agent:mime-version
	:in-reply-to:content-transfer-encoding:content-language;
	bh=HiWmPLa7TLaR4RJ1Es/gJLhzG+EGw0pYszgIhF+j9i8=;
	b=symk5EhCUbZP2PfbWJ55REP4HgJdA2YZnxoquHDGrl9Rw+4ye80lpZsM6Ek4CivCOJ
	esEzNhSw2oWHUTauhxPhOppabr9EgdKFrx8VUE28GbpSSgGBioQHJqS2LZULtpAd0OBW
	4XkWoQEn3tMsOq9BqizVkoaW1RxuOB2SsN/3QOxAnNIn03Kdqc9KyKSrnOOaLwAGmt/e
	6DleQgY8bJlaHYh0gKj6h9y3U8EOJBsb65+W9pzEV07HPzO05Ba2/RozO3Oyuk3tt59G
	UJBMrA8MfMTVvDGO3wT/Qf4ZkpqABfJI05SJ6B5nia2VNAnkD/DmU7QW7AoUz2p6gIWU
	eo5g==
References: <2234280.ElGaqSPkdT@subpop>
	<ebd44751-333c-cb7a-5776-c63501558af6@redhat.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <69a1e77f-55c2-74ff-0930-32dc3c5941a7@gmail.com>
Date: Wed, 2 Jun 2021 16:18:14 -0500
MIME-Version: 1.0
In-Reply-To: <ebd44751-333c-cb7a-5776-c63501558af6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Subject: Re: [Virtio-fs] virtiofs mounted filesystems & SELinux
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com


On 6/2/21 3:55 PM, Connor Kuehl wrote:
> On 5/21/21 11:59 AM, Link Dupont wrote:
>
> Adding the virtio-fs mailing list.
>
>> I am mounting a filesystem into a domain using the virtiofs driver.
>>
>> <filesystem accessmode="passthrough" type="mount">
>>       <source dir="/home"/>
>>       <target dir="/home"/>
>>       <driver type="virtiofs"/>
>> </filesystem>
>>
>> Both my host (Fedora 34) and guest (CentOS 8.4) are running with SELinux 
>> enforcing. From my host, I can see that the SELinux context type is set to 
>> user_home_dir_t.
>>
>> $ ls -ldZ /home/link
>> drwxr-xr-x. 61 link link system_u:object_r:user_home_dir_t:s0 8192 May 21 
>> 12:41 /home/link
>>
>> >From within the guest however, the volume is unlabeled_t
>>
>> $ ls -lZd /home/link
>> drwxr-xr-x. 61 link link system_u:object_r:unlabeled_t:s0 8192 May 21 12:53 /
>> home/link
>>
>> Is there a way to pass the SELinux context through to the guest? Or mount the 
>> volume with the correct options to map SELinux contexts?
>>
>>
> Hi,
>
> I'm afraid I actually don't know that much about SELinux but I read
> that it relies on using extended attributes in the file system to
> accomplish its labeling.
>
> Do you still experience this issue when you enable extended attribute
> support[1] in virtiofsd? The example in the optional parameters snippet
> enables extended attributes with the xattr='on' element.
>
> Connor
>
> [1] https://libvirt.org/kbase/virtiofs.html#optional-parameters


Take a look at this thread. There you will find commands that will allow
what you want until they become standard.

https://listman.redhat.com/archives/virtio-fs/2020-November/msg00110.html


