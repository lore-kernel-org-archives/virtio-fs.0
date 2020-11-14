DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:from:subject:message-id:date:user-agent:mime-version
	:content-transfer-encoding:content-language;
	bh=bjkqti83SqPjD5IwjVEGo4Pnr8Zwz2xxMhXMVoFUG2E=;
	b=o2oW/uZO5D8K9Qa0p/O7mHLVUPFF8v0eyAihV0mWN4hqd7IimDdhXRXpTAmqd+28QJ
	QhcAsC0M/I/TqWD0jY0L0/+zL41k/kLcZ0BdOp4jSjFgFUisyqeqWQF9EJixxGq1m/am
	NbTKSa9a9DtODAUN5fa+0a31wfe8J5TBIwLrSoYy4XygFZlhyBtQBFFscr2Qb4nzUI76
	PxcasaBM45SSvHEyqeGvuYUQFXRFmC+88jg/NuVpv1t2QewWL8CDc+lol0BaB7ldfYLl
	9BttkTIdVcTuXEqIMz1dExypE+etsXLZrwb76zZEnBepWPyke2a8m3oJu4K3ZK7/vMvR
	gPXQ==
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <f51a7a42-1dc9-1f61-7fe0-a5edba8c68d9@gmail.com>
Date: Sat, 14 Nov 2020 13:49:25 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] Convenience vmlinuz link auto-update patch for
	direct-kernel booting
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

It's bothersome to require VM hosts using direct kernel virtio-fs
booting to have to puzzle out what the latest kernel / initramfs rev is
in the guest.

If in the guest you create /etc/kernel/postinst.d/update_boot_links

with this:

#!/bin/bash
#Used by vm host to boot latest kernel without having to update kernel
spec in the host.
KERNEL_VERSION="$1"
#KERNEL_IMAGE="$2"

cd /boot
ln -sf vmlinuz-$KERNEL_VERSION /boot/vmlinuz
ln -sf initramfs-$KERNEL_VERSION.img /boot/initrd.img

then

chmod 0755 /etc/kernel/postinst.d/update_boot_links

Then in on the host under 'boot options' put as the kernel path

/path/to/guest/vmlinuz  

and

/path/to/guest/initrd.img

in the initrd path and

root=virtiofs:myfs  rd.shell

in the kernel args (and have updated dracut as indicated in the message
titled

HOWTO: direct kernel 'root=virtiofs:myfs' boot on 'vanilla'
Fedora/RHEL/Centos releases.

)

Your vm will boot the most recently installed kernel without your having
to update the xml spec in the host.

Hope this helps!

Harry Coin







