DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.com; s=mail;
	t=1591916543; bh=vnOGJzuIj7hlpvQ+R+pny/pxbegxtIlQBePLVf74HcY=;
	h=Message-Id:Date:Subject:To:From;
	b=WR12WepN3UCyL9AY3qA0swq5phzDEyzcZCambKYBjEHw/je7OChmv8lz21b3Hx52/
	X5O6A/Cngr8xXSXu2W1GIak8alI1xpuA4qu7Ctgcfhr9Ch31H5PyuoXVH8GjD2cFqt
	cGFI+/tR/d3Ut9NndTuJmK7PtGbOecO/wRcpCXHY=
From: Aa Aa <jimbothom@yandex.com>
MIME-Version: 1.0
Date: Fri, 12 Jun 2020 09:02:23 +1000
Message-Id: <1099751591915615@mail.yandex.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] How is the daemon meant to be started?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hi

I have a few questions about using virtiofsd. I currently have multiple vms share the same mountpoint for their rootfs using 9p, in read only (9p had a permissions issue but that was overcome). I can start qemu for each of them as non root with say only allowing access to /dev/kvm and even have some of the VM running with a different user name.

If I wish to change to using virtiofsd, I can just change the init to:
  mount -t virtiofs -onoatime,nodiratime,noauto,ro rootfs /new  | mount -t 9p -onoatime,nodiratime,noauto,ro,trans=virtio,cache=loose root /new
and the qemu command line from using 9p to using a vhost-user-fs-pci device.

The problem is how do I start virtiofsd. The daemon needs root permissions from what I can tell, to start. Thereafter, it listens on the socket and only accepts a single connection on the socket. In my case, I have a single mount point that I wish to use multiple times. You cannot listen on the socket multiple times, so I cannot say that /mnt/root socket will be exported as /run/virtiofsd/mounts/mnt-root.socket by something that has been started by root independently of qemu, but rather it would appear that I need to be root and create a socket for each qemu task then drop permissions. Is this correct or is there another way to achieve this.

Cheers

JT


