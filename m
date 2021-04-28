DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=subject:to:cc:references:from:message-id:date:user-agent
	:mime-version:in-reply-to:content-transfer-encoding:content-language;
	bh=nDED6uGDcNJ8RYJmmEhHhwGZgQqxHsl6xrI1QYYKNx8=;
	b=i3Es1IGUxj2HxcvhFc6wRWUCd9eDJ8C9wmm8EIG3UcKXXjzwp79EHW0NDRT/cycnho
	VI8TbOB9VncgwlSyO+yaIthBcQbMDsFANXam3pj+IZU1jzjUugVJvWAgsSdWGffbKU/H
	Z7/IcaZWkOHPOTj+cdLWbOhTZyhpQVeU0cJliwsxgr60kc2IqTZiQS1ssma/T+25jYox
	iCzOrkT4WNwili889BzCgoV4cP60QO3rTRl2dBOrf8HqkV7ADn9pWzA5hr0i59z/VwfM
	Og+4yDnS6Odc2AdAVjzmhMn7lvAgfJd++tHrFTvjSn9BOtZ45a4mv3RuhkmDSmEMb5T/
	2Hog==
References: <6b2e27a4-8bee-3649-95a4-a2cea45a18e4@gmail.com>
	<YIkZhqKaLat6Q9YH@work-vm>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <afb9df25-cf79-19d1-0085-fd72c6225013@gmail.com>
Date: Wed, 28 Apr 2021 16:00:40 -0500
MIME-Version: 1.0
In-Reply-To: <YIkZhqKaLat6Q9YH@work-vm>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] Min host / vm kernel rev for basic DAX ops?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com


On 4/28/21 3:15 AM, Dr. David Alan Gilbert wrote:
> * Harry G. Coin (hgcoin@gmail.com) wrote:
>> Kindly answer a couple 'basic' virtiofs questions:
>>
>> 1) Which mainline kernel version is necessary for the host, and for the
>> vm to enable reliable DAX operations -- supposing no shared host
>> activity on the underlying fs.
> I don't think there's any host kernel dependency for DAX
> currently.
> (You do need a guest with the DAX support)

At least the version of the 'virt-manager' on fedora 33 doesn't support
the 'cache-size' host option, which as I understand from a post a few
days ago should be around 4G.  That's why I asked about the host
requirements.


