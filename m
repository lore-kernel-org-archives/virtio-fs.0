DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=subject:to:cc:references:from:message-id:date:user-agent
	:mime-version:in-reply-to:content-transfer-encoding:content-language;
	bh=krE+VHleX8hMBhpiZHRMh7vj2Z3Y90e8U1Z640QMJ3Y=;
	b=ltRdJ7+E5MtoIVkH7KTai+7eKVfMHrgOOf84RGCge89fTf6nycOI20ef3E1x2foSmD
	EgYBbk+OOfSSmVr42VmTSpSl/c7ILltFZgrU7n6Mw60egG7PSWbm1MD7O95X3+SS8H4p
	D6Gr0IXqQOFT5zK4psKO7J0SvoGDD3ai6hLC5ew9Jl8E9p5phMIMmSc5Kf5KrUiOGizr
	bIIL3QV7QDEn8+t5LLR/Cok6r3Z4ilu5ngp2zYtSDLKodBjKiWjOy0DpmhTvTa/JrxQm
	kLnCELLOPU/0DDo6XvLmPrMKOP4z8xQ1e7iJ4UlciQx6eNmgvQHdGTxjl9hrkX4WI+o0
	Tppw==
References: <756d5044-e567-b403-b4b2-784b3c284ed6@gmail.com>
	<20210604205817.GA323260@redhat.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <040a0a58-10f1-b959-5294-404d113a212e@gmail.com>
Date: Fri, 4 Jun 2021 16:53:50 -0500
MIME-Version: 1.0
In-Reply-To: <20210604205817.GA323260@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] Virtiofs Kernel Boot howto
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>


On 6/4/21 3:58 PM, Vivek Goyal wrote:
> On Fri, Jun 04, 2021 at 11:28:42AM -0500, Harry G. Coin wrote:
>> Mentioned up-list, here's a further little helper to allow virtio-fs root.
> Hi Harry,
>
> Thanks for posting instructions on how to boot with virtiofs as rootfs.
>
> [..]
>> and as 'kernel args' (presuming you've built dracut with the added conf
>> files I published on this list previously):
>>
>> root=virtiofs:myfs rd.shell rd.fstab
> Ok, this is interesting bit that how virtiofs root should be specified
> so that it can be parsed both by kernel as well as initramfs module.
>
> I don't think "root=virtiofs:myfs" is recognized by kernel. So you must
> have coded dracut module to parse it appropriately.

Actually, until recent kernels the addition of 'virtiofs:...' was not
required, only rootfstype=virtiofs and 'the tag was just that, any
tag'.  However recent kernels failed to boot, so I had to specify that.

My suggestion, if you like standards, is to notice how 9p does it, and
follow that.  The reason I suggest that is I suspect nearly everyone
that presently uses 9p will move to this if their systems support it,
once it doesn't take a Ph.D. in five or six things to 'seem as good as
installing from ISO to a block device'.



