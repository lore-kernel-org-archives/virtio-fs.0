DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:cc:references:from:subject:message-id:date:user-agent
	:mime-version:in-reply-to:content-transfer-encoding:content-language;
	bh=WgDdFC9LyeqAZL05FbBDlv9/pXFqVQqUYkzAMloDy78=;
	b=bmiJS6cj4JL1iOK15/sSmWzkEXhfEioYMz+5x6EHpBI0kD4KICw4lgRJ8nuvmlxub1
	g9ikJOmtRNWMLZtyKcQpy+RClZGgFF3YaDpA2kW2+g9Y0KTpqj1GcUD1jJeOUlYTn6ti
	tyC2BVYicBGICAztfk/3PxzNnReCdMYo8kgIO5p7ldrOvYESWHaAO8aj3PAzgKgKlaze
	oRlPbc1vCaK31PPSaN28oshvIKSCBNF45C2jaYIk4rV4b24DnyQ5voxpcMz0uGENeD2r
	h/V/j/nuDnUfWFAhr3buO64qFUq+P2KlqWu06/nh4lgIAZMrINlNvziO4qwupnKtC5vk
	bfsg==
References: <20210608153524.GB504497@redhat.com>
	<YMCPPCbjbRoPAEcL@stefanha-x1.localdomain>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <af0fc557-c90c-4343-ed0e-a3a94dc07137@gmail.com>
Date: Wed, 9 Jun 2021 09:13:17 -0500
MIME-Version: 1.0
In-Reply-To: <YMCPPCbjbRoPAEcL@stefanha-x1.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] init/do_mounts.c: Add root="fstag:<tag>"
 syntax for root device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard.weinberger@gmail.com>, Dominique Martinet <asmadeus@codewreck.org>, linux kernel mailing list <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net


On 6/9/21 4:51 AM, Stefan Hajnoczi wrote:
> On Tue, Jun 08, 2021 at 11:35:24AM -0400, Vivek Goyal wrote:
>> We want to be able to mount virtiofs as rootfs and pass appropriate
>> kernel command line. Right now there does not seem to be a good way
>> to do that. If I specify "root=myfs rootfstype=virtiofs", system
>> panics.
>>
>> virtio-fs: tag </dev/root> not found
>> ..
>> ..
>> [ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0) ]
>>
>> Basic problem here is that kernel assumes that device identifier
>> passed in "root=" is a block device. But there are few execptions
>> to this rule to take care of the needs of mtd, ubi, NFS and CIFS.
>>
>> For example, mtd and ubi prefix "mtd:" or "ubi:" respectively.
>>
>> "root=mtd:<identifier>" or "root=ubi:<identifier>"
>>
>> NFS and CIFS use "root=/dev/nfs" and CIFS passes "root=/dev/cifs" and
>> actual root device details come from filesystem specific kernel
>> command line options.
>>
>> virtiofs does not seem to fit in any of the above categories. In fact
>> we have 9pfs which can be used to boot from but it also does not
>> have a proper syntax to specify rootfs and does not fit into any of
>> the existing syntax. They both expect a device "tag" to be passed
>> in a device to be mounted. And filesystem knows how to parse and
>> use "tag".
>>
>> So this patch proposes that we add a new prefix "fstag:" which specifies
>> that identifier which follows is filesystem specific tag and its not
>> a block device. Just pass this tag to filesystem and filesystem will
>> figure out how to mount it.
>>
>> For example, "root=fstag:<tag>".
>>
>> In case of virtiofs, I can specify "root=fstag:myfs rootfstype=virtiofs"
>> and it works.
>>
>> I think this should work for 9p as well. "root=fstag:myfs rootfstype=9p".
>> Though I have yet to test it.
>>
>> This kind of syntax should be able to address wide variety of use cases
>> where root device is not a block device and is simply some kind of
>> tag/label understood by filesystem.
> "fstag" is kind of virtio-9p/fs specific. The intended effect is really
> to specify the file system source (like in mount(2)) without it being
> interpreted as a block device.
>
> In a previous discussion David Gilbert suggested detecting file systems
> that do not need a block device:
> https://patchwork.kernel.org/project/linux-fsdevel/patch/20190906100324.8492-1-stefanha@redhat.com/
>
> I never got around to doing it, but can do_mounts.c just look at struct
> file_system_type::fs_flags FS_REQUIRES_DEV to detect non-block device
> file systems?
>
> That way it would know to just mount with root= as the source instead of
> treating it as a block device. No root= prefix would be required and it
> would handle NFS, virtiofs, virtio-9p, etc without introducing the
> concept of a "tag".
>
>   root=myfs rootfstype=virtiofs rootflags=...
>
> I wrote this up quickly after not thinking about the topic for 2 years,
> so the idea may not work at all :).

I plead for the long term goal of syntax harmony between the kernel
command line and the first three fields of /etc/fstab.

Let's do one thing one way, even if it is specified more than one place.

HC





