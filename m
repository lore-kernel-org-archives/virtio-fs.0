DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:references:from:subject:message-id:date:user-agent:mime-version
	:in-reply-to:content-transfer-encoding:content-language;
	bh=7KbW/ICNTlO29CpSDKmdMvv3oVrevn7pd2hxUa36XAo=;
	b=f7R8Tz4BNtrDa4+2YexF31LwTIepv/xnoWQ+eT8bSaa+0wX68/HcNIRmiqRlRxvnOp
	5x3nano0NRCipV9HjsA/VBOqup0VN5dr+ma7PwmPsWRUHQBMfvAxCRURufMsSx9vrcPn
	sc0aag4Idbn07V4XQfSEFq/cOHmypfrOsNx2duW69RVekE9nn26Kc0fOA5lEPFGkQs9q
	qJx1vsHQdFI04ZTYwpKEteLQEjn6B0SHyTtqva34KLukwzVd0OffeTgxOBhu0tK+rRgF
	LRcsBO9mfosh12XbG0ic7fVK24Ep0HoGZu/5r3a4MRJHmDoX3l47wXI51xtf7pwkjKOF
	ERJQ==
References: <2234280.ElGaqSPkdT@subpop>
	<ebd44751-333c-cb7a-5776-c63501558af6@redhat.com>
	<9W25UQ.OHKWX78P32DI3@sub-pop.net> <YLksUpVCCovgUAtq@work-vm>
	<MYJ5UQ.562L1XU7LNSJ3@sub-pop.net> <0KN5UQ.JVDR5LJRMJIQ3@sub-pop.net>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <8440ac8b-e72d-b9c4-9b43-1d788b9041b1@gmail.com>
Date: Fri, 4 Jun 2021 08:30:26 -0500
MIME-Version: 1.0
In-Reply-To: <0KN5UQ.JVDR5LJRMJIQ3@sub-pop.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
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


On 6/3/21 9:14 PM, Link Dupont wrote:
> On Thu, Jun 3 2021 at 08:56:46 PM -0400, Link Dupont
> <link@sub-pop.net> wrote:
>>  reproducible scenarios
>
> Alright. I reran my tests with a CentOS 8 guest. On CentOS 8 (with a
> virtiofs filesystem and with xattr on), the type of files in the
> mounted hierarchy are unlabeled_t. I can work around that by switching
> SELinux in the guest to permissive or disabled.
>
> With a CentOS 7 guest, things get less usable. I digested this to a
> reproducible scenario.
>
> Build a disk image with `virt-builder`, configuring the CentOS Plus
> kernel to get 9p support.
>
> virt-builder centos-7.8 \
> --root-password password:centos \
> --output centos-7.8.qcow2 \
> --install yum-utils \
> --run-command 'yum-config-manager --enable centosplus' \
> --run-command 'sed -ie
> "s/DEFAULTKERNEL=kernel/DEFAULTKERNEL=kernel-plus/"
> /etc/sysconfig/kernel' \
> --append-line
> '/etc/dracut.conf.d/virtio.conf:add_drivers+="virtio_scsi virtio_pci
> virtio_console"' \
> --append-line '/etc/modules-load.d/9pnet_virtio.conf:9pnet_virtio' \
> --install kernel-plus \
> --append-line '/etc/fstab:home /home 9p trans=virtio,version=9p2000.L
> 0 0'
>
> Install the volume into the `default` pool.
>
> sudo install -m644 centos-7.8.qcow2 /var/lib/libvirt/images
>
> Next, define a domain using the disk image (using `virt-install` here
> for "easy mode").
>
> virt-install \
> --import \
> --os-variant centos7.0 \
> --name centos \
> --ram 2048 \
> --disk path=/var/lib/libvirt/images/centos-7.8.qcow2 \
> --memorybacking access.mode=shared \
> --filesystem source=/home,target=home,accessmode=passthrough \
> --autoconsole none
>
> Now with SELinux enforcing, I cannot list the contents of the
> directories in the mounted hierarchy.
>
> [root@localhost ~]# ls -lZ /home/link
> ls: cannot open directory /home/link: Permission denied
>
>
Link, You have four choices right now:

1) Stick with rhel/centos/fedora type distros and ignore virtiofs for at
least 6 months, more like a year, for virtiofs to be implemented
properly by the typical GUI enabled virt-manager/qemu/kvm resources you
know about, and also not just wedge (worse than crash) your system by
breaking things like 'dnf' and 'rpm' randomly when upgrades happen --
blocking upgrades (and that's with 'permissive').   The big speed
advantage to virtiofs comes with a feature termed 'dax', and what it
takes to make that work is a whole lot of 'by hand' right now.  It's
going to be so fast I bet nearly everyone will migrate to it in due
course, but it's not ready for non-experts yet.

2) Switch to debian type distros (ubuntu, mint, debian, etc.) which do
not have selinux, instead apparmor, and enjoy virtiofs without dax in a
fairly stable way so long as you're ok with the promise of 'dax' coming
and it will all 'just work and get super fast almost automagically' with
typical upgrades in due course.  Just know that good operations will
only happen if the shared directory on the host is not used by anything
whatsoever of importance on the host while the guest is running.  You
can take 'snapshots' on the host that 'back up' the (not then running)
guest very easily.

3) Make virtiofs an area you want to develop deep knowledge about, be
willing to accept your systems won't be stable enough for anything
outside a lab or workshop, at least one thing you care about will break
in some way at least  one time per every four 'dnf upgrades' and switch
to fedora.  You'll have to learn a fair few quite obscure selinux
commands to get it to comprehend virtiofs is a filesystem and not flood
your logs, use the 'xml' features of virtual machine manager to get the
bits of virtiofs you want enabled properly (like 'numa', learn what
'hugepages' are and do the math on each host to set enough of those
aside with in sysctl.d (e.g. vm.nr_hugepages = 11776) , and also accept
some versions of hosts and guests will develop incompatibilities so
severe you'll have to restore to backups and downgrades from time to
time.  And you won't be able to use virtiofs as a root filesystem
without patching dracut config directories (search this list) or
compiling your own custom kernel.  But you will learn a whole lot.

4)  Stick with rhel/fedora/centos, create a file on the host (check on
fallocate and chattr +C) use that as a block disk image for the guest,
and watch and wait until virtiofs becomes 'real' on stable systems, then
bring the guest down, unpack the file into a directory tree, use the
then available 'all good' drop down list to 'pick' virtiofs and have a
rocket -- about a year from now or so.

That's pretty much where we are today I think.

Harry





