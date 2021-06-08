DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:cc:references:from:subject:message-id:date:user-agent
	:mime-version:in-reply-to:content-transfer-encoding:content-language;
	bh=Y/Ff8rqADy27tdtG8Art5Dx6DPCBrcW/tL3HXgpktt0=;
	b=psno8ePBY5SfkME9n0gSPekyG3CTH7C9VbepesuY7XZUMK+DCgVLMDRRCKaamLLvfS
	Jkyjm9BiSuCbsmJm0zYjsQ0jbpkej/ack9VweHIiUgoh6nzgAHSsx7yhXpfW/P95bpRv
	7LTOxrYCXUn9tMeBnM4fuCK2hB3/b0ezZ2MDkiSxGqHZWfTyOEC2ZzFqpQApEYph8H1E
	hVZxhurAZLsNDUvLZ4HksdvMQNMZYTxLy0NtMhJT/KFxGbeaqxdYJ+Zwfts/98XgygJG
	7sMVwEKvRNqAYo505TeE+ioCTXsX3tOo3vGdIx9ZBJYQd5AUZ9gb+IS3+zFRScBSSEBL
	UH2Q==
References: <20210608153524.GB504497@redhat.com>
	<8929c252-3d99-8cdb-1c56-5fdb1fd29fc2@gmail.com>
	<20210608192617.GC504497@redhat.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <97078f1e-0267-5ddf-15c0-51423e738487@gmail.com>
Date: Tue, 8 Jun 2021 14:49:12 -0500
MIME-Version: 1.0
In-Reply-To: <20210608192617.GC504497@redhat.com>
Content-Type: text/plain; charset="utf-8"
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard.weinberger@gmail.com>, Dominique Martinet <asmadeus@codewreck.org>, linux kernel mailing list <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net


On 6/8/21 2:26 PM, Vivek Goyal wrote:
> On Tue, Jun 08, 2021 at 01:38:56PM -0500, Harry G. Coin wrote:
>> On 6/8/21 10:35 AM, Vivek Goyal wrote:
>>> We want to be able to mount virtiofs as rootfs and pass appropriate
>>> kernel command line. Right now there does not seem to be a good way
>>> to do that. If I specify "root=myfs rootfstype=virtiofs", system
>>> panics.
>>>
>>> virtio-fs: tag </dev/root> not found
>>> ..
>>> ..
>>> [ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0) ]
>> Whatever the best direction forward might be for kernel patches
>> regarding 'not block device as root', it would ease learning curves if
>> 'the patterns that set config issue X' were the same across root 'not
>> block device options' whether cephfs, nfs, 9p, virtiofs.
> I think achieveing same pattern for all non-block options is pretty
> hard. There are too many varieits, mtd, ubifs, nfs, cifs, and you
> just mentioned cephfs.
>
> It would be nice if somebody can achieve it. But that should not be
> a blocker for this patch. Goal of this patch is to take care of virtiofs
> and 9p. And any other filesystem which can work with this pattern.
>
> I think ubi and mtd should be able to work with "root=fstag:<tag>"
> as well. Something like "root=fstag:ubi:foo". And then ubi:foo
> will should be passed to ubifs. I think only thing missing is
> that current code assumes there is one filesystem passed in
> rootfstype. If we want to try mounting device with multiple
> filesystems then one can modify the code to call do_mount_root()
> in a loop from a filesystem list.
>
> Right now I did not need it, so I did not add it.
>
>> All of them
>> will have to handle the selinux xattr/issue, posix and flock issues,
>> caching etc.
> Filesystem specific flags will be passed by rootflags=.
>
>> While by definition virtiofs has to exist only in a vm
>> guest, the others could be baremetal or vm guest roots.  (How much 9p's
>> other-than-guest transports are used I don't know).
>>
>> FYI (though patching the kernel may be the best option)  there is a case
>> that does not have those kernel panics for virtiofs-root and 9p root
>> using stock fc34.  As 9p, the virtiofs method uses the initrd creation
>> mechanisms provided by 'dracut' or 'initramfs' to provide the 'sysroot
>> pivot glue'.
>>
>> On the fc34 guest a successful 'direct kernel boot' today looks like:
>>
>> kernel path: /vmsystems/fedora_generic/boot/vmlinuz
>>
>> initrd path: /vmsystems/fedora_generic/boot/initrd.img
>>
>> Kernel args: root=virtiofs:myfs rd.shell rd.fstab
> Does it work with upstream dracut or you have modified dracut to
> parse "root=virtiofs:myfs" option.

It works with dracut and stock fs34 kernel right now by exactly the
three files 9p upstream works with dracut to root fs boot, except
'virtiofs' instead of '9p' in the dracut.conf.d files.  Note it requires
the virtiofs: in the root= line, but not in the fstab and qemu configs.

re: cephfs Here's a cephfs approach to the problem: 
https://github.com/jurashka/dracut-ceph-module





