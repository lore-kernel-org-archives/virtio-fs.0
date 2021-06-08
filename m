DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:cc:references:from:subject:message-id:date:user-agent
	:mime-version:in-reply-to:content-transfer-encoding:content-language;
	bh=Haq0YPA4rRTEboTMq/srqauEYHmbuV8PWUShNR4iohk=;
	b=PVKsbw60mkC8RpXyNr0BZLkqvkHsBxGq8GBSWhSy+ExzMC+eOXN7KBfCUcSELnIyxo
	bxhjS54o6cTRBHg+QJDLBFQA1rWktVKtbWGTtSoZ5DfMbblpggDcT1KqA8M1+j11D0iS
	AGrTcueRm3xLrQrA1OXFKFnay53nSIVzda4PDjGhZcSSY9cLcWllfmF4u1abhdhaFUZQ
	C9sUfuy8NA4YsZ2Dmi1XFJ7qCWiXimhiav7dTAj82/ebNM/VZc8C/sYLUjCwx1/cBx7x
	3MNwPs/BMRSreLBPMQnbqYGxaBoeFNAC8nI2dt0KLZccr6FnU7kmuxWE0iDB4Y2S5DXt
	dyxA==
References: <20210608153524.GB504497@redhat.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <8929c252-3d99-8cdb-1c56-5fdb1fd29fc2@gmail.com>
Date: Tue, 8 Jun 2021 13:38:56 -0500
MIME-Version: 1.0
In-Reply-To: <20210608153524.GB504497@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard.weinberger@gmail.com>, Dominique Martinet <asmadeus@codewreck.org>, David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk, v9fs-developer@lists.sourceforge.net

On 6/8/21 10:35 AM, Vivek Goyal wrote:
> We want to be able to mount virtiofs as rootfs and pass appropriate
> kernel command line. Right now there does not seem to be a good way
> to do that. If I specify "root=myfs rootfstype=virtiofs", system
> panics.
>
> virtio-fs: tag </dev/root> not found
> ..
> ..
> [ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0) ]

Whatever the best direction forward might be for kernel patches
regarding 'not block device as root', it would ease learning curves if
'the patterns that set config issue X' were the same across root 'not
block device options' whether cephfs, nfs, 9p, virtiofs.  All of them
will have to handle the selinux xattr/issue, posix and flock issues,
caching etc.  While by definition virtiofs has to exist only in a vm
guest, the others could be baremetal or vm guest roots.  (How much 9p's
other-than-guest transports are used I don't know).

FYI (though patching the kernel may be the best option)  there is a case
that does not have those kernel panics for virtiofs-root and 9p root
using stock fc34.  As 9p, the virtiofs method uses the initrd creation
mechanisms provided by 'dracut' or 'initramfs' to provide the 'sysroot
pivot glue'.

On the fc34 guest a successful 'direct kernel boot' today looks like:

kernel path: /vmsystems/fedora_generic/boot/vmlinuz

initrd path: /vmsystems/fedora_generic/boot/initrd.img

Kernel args: root=virtiofs:myfs rd.shell rd.fstab


The xml to pass through virtio-fs is:

<filesystem type="mount" accessmode="passthrough">
  <driver type="virtiofs" queue="1024"/>
  <binary xattr="on">
    <lock posix="on" flock="on"/>
  </binary>
  <source dir="/vmsystems/fedora_generic"/>
  <target dir="myfs"/>
</filesystem>

The guest fstab is:

myfs / virtiofs defaults 0 0

HTH

Harry Coin




