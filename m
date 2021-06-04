DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sub-pop.net
	; s=mythic-beasts-k1; h=To:Subject:From:Date;
	bh=EPwFQiyrxnHXY3VMBopyCvLvtUzw8qHZkEefiXxWVus=;
	b=bx6TpAWXGGFn3nLccvSnKtiXDA
	CiSf9lb7Pa49b+xni5XPM+qPZKVBfGZVjFxZYM/g4Xt63sA/SBzclawZg9OsZcBi7lls5QDO4NsbR
	0XC1BxEPbnp64ZwzIX0qbN/fG7HUwrlwKwG7ghXNbOkdkIYsU9hUgW9pZYOcAcwIvJVKm1/Nm7BCi
	WH9+fJtc9YbTO3C98JDeQ4MhaVia91prSnDIUHhAqM+S3D6/hJgMOHcs/suRI2eLyOsu2rEbikxpr
	e9c4sTLh6K+6pZ4g/MCuPEh7JuEM6jkWewvbOOt33b7qVhrKpCdjQ/txLUtbYvhsATwMnl+a6Z+o/
	7Y4VxXWQ==
Date: Thu, 03 Jun 2021 22:14:24 -0400
From: Link Dupont <link@sub-pop.net>
Message-Id: <0KN5UQ.JVDR5LJRMJIQ3@sub-pop.net>
In-Reply-To: <MYJ5UQ.562L1XU7LNSJ3@sub-pop.net>
References: <2234280.ElGaqSPkdT@subpop>
	<ebd44751-333c-cb7a-5776-c63501558af6@redhat.com>
	<9W25UQ.OHKWX78P32DI3@sub-pop.net> <YLksUpVCCovgUAtq@work-vm>
	<MYJ5UQ.562L1XU7LNSJ3@sub-pop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Subject: Re: [Virtio-fs] virtiofs mounted filesystems & SELinux
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, libvirt-users@redhat.com

On Thu, Jun 3 2021 at 08:56:46 PM -0400, Link Dupont <link@sub-pop.net> 
wrote:
>  reproducible scenarios

Alright. I reran my tests with a CentOS 8 guest. On CentOS 8 (with a 
virtiofs filesystem and with xattr on), the type of files in the 
mounted hierarchy are unlabeled_t. I can work around that by switching 
SELinux in the guest to permissive or disabled.

With a CentOS 7 guest, things get less usable. I digested this to a 
reproducible scenario.

Build a disk image with `virt-builder`, configuring the CentOS Plus 
kernel to get 9p support.

virt-builder centos-7.8 \
 --root-password password:centos \
 --output centos-7.8.qcow2 \
 --install yum-utils \
 --run-command 'yum-config-manager --enable centosplus' \
 --run-command 'sed -ie 
"s/DEFAULTKERNEL=kernel/DEFAULTKERNEL=kernel-plus/" 
/etc/sysconfig/kernel' \
 --append-line 
'/etc/dracut.conf.d/virtio.conf:add_drivers+="virtio_scsi virtio_pci 
virtio_console"' \
 --append-line '/etc/modules-load.d/9pnet_virtio.conf:9pnet_virtio' \
 --install kernel-plus \
 --append-line '/etc/fstab:home /home 9p trans=virtio,version=9p2000.L 
0 0'

Install the volume into the `default` pool.

sudo install -m644 centos-7.8.qcow2 /var/lib/libvirt/images

Next, define a domain using the disk image (using `virt-install` here 
for "easy mode").

virt-install \
 --import \
 --os-variant centos7.0 \
 --name centos \
 --ram 2048 \
 --disk path=/var/lib/libvirt/images/centos-7.8.qcow2 \
 --memorybacking access.mode=shared \
 --filesystem source=/home,target=home,accessmode=passthrough \
 --autoconsole none

Now with SELinux enforcing, I cannot list the contents of the 
directories in the mounted hierarchy.

[root@localhost ~]# ls -lZ /home/link
ls: cannot open directory /home/link: Permission denied



