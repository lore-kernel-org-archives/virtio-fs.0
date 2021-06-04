DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:cc:references:from:subject:message-id:date:user-agent
	:mime-version:in-reply-to:content-transfer-encoding:content-language;
	bh=hbCJyKP1FPKCyDBbNQYa2nJPG1jKSTDt+YXNkf9fbIs=;
	b=tUYFmiMMn+ak9oy8wP6oNbidgkYp+oSi4ilJQYm8CPPJ6yhH1hUV9I67gz545bJNSZ
	f8TsC3DqeXe0uw80pwKSDtpNXzhfr/vVedQvh8nTpeC1u4HvYVi+pwzxw3c5JxpSbjQe
	+NqFnEd6/N+xS206c0RDnoIgKlK2Rhz8qTOxXdansUc2+3W2/DBEcIyIukkC1Y6EpfE4
	Ev0HuxhPCAtkCWtWg5YpnHLlXVuTZ3RWbh6TsG6ObCe1PjB1TMceSoVUu0X+frV3lKGY
	a1quVppM7sqj59+Xf3ASDhGgavN3+Ks95u8HxOJGgkBDBIj4HC94oSI68FzMCHKfVf4S
	ZMQg==
References: <2234280.ElGaqSPkdT@subpop>
	<ebd44751-333c-cb7a-5776-c63501558af6@redhat.com>
	<9W25UQ.OHKWX78P32DI3@sub-pop.net> <YLksUpVCCovgUAtq@work-vm>
	<MYJ5UQ.562L1XU7LNSJ3@sub-pop.net> <0KN5UQ.JVDR5LJRMJIQ3@sub-pop.net>
	<8440ac8b-e72d-b9c4-9b43-1d788b9041b1@gmail.com>
	<20210604141147.GD269481@redhat.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <fd336c79-b715-5548-ce3c-f357c44f14ed@gmail.com>
Date: Fri, 4 Jun 2021 09:50:34 -0500
MIME-Version: 1.0
In-Reply-To: <20210604141147.GD269481@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com

Hi Vivek,

I've cut the o.p.'s text as your questions and my answers are off-topic
to his interest.

On 6/4/21 9:11 AM, Vivek Goyal wrote:

> You are using virtiofs as rootfs and upgrade breaks? If virtiofs is
> being used only as volumes, then its outside the upgrade path. Will
> like to know what broke for you. Was it all SELinux related or something
> else.

Seems 100% selinux related -- even in permissive mode on the guest. 
Here's your short-and-sweet 100% reproducer:  
https://bugs.launchpad.net/ubuntu/+source/qemu/+bug/1930756  There's a
similar bug report on redhat.

Even with selinux set to permissive in the guest, no selinux installed
in the host, but with xattrs on, no and no xattr mapping, lsetfilecon
returns with a permission error.  The files on the host are entirely
dedicated to the guest -- no use of those files is made on the host. 
Underlying fs on the host is btrfs.
>> You'll have to learn a fair few quite obscure selinux
>> commands to get it to comprehend virtiofs is a filesystem and not flood
>> your logs, use the 'xml' features of virtual machine manager to get the
>> bits of virtiofs you want enabled properly (like 'numa',
> I am assumig libvirt takes care of specifying "numa" stuff? Is that
> not the case?

Not outside the lab.  There is no virt-manager GUI way to coordinate
memory allocation with hugepages/numa.  Hand-editing the xml is required
to manually match the numa set-aside with the memory allocation.  If
reliability is important, unless you use systctl.d to set aside the
hugepages the system can randomly not launch the guests owing to lack of
sufficient contiguous memory at guest launch time.

>> learn what
>> 'hugepages' are and do the math on each host to set enough of those
>> aside with in sysctl.d (e.g. vm.nr_hugepages = 11776) ,
> What's the virtiofs dependency on vm.nr_hugepages? I think I am not
> aware of this aspect.

Detailed here https://libvirt.org/kbase/virtiofs.html


>
>> and also accept
>> some versions of hosts and guests will develop incompatibilities so
>> severe you'll have to restore to backups and downgrades from time to
>> time.  And you won't be able to use virtiofs as a root filesystem
>> without patching dracut config directories (search this list) or
>> compiling your own custom kernel.  But you will learn a whole lot.
> Agreed that dracut does not seem to have support to mount virtiofs
> as rootfs. That's one TODO item. 

I've done it. It's been working for months, automatically maintained and
updated through both host and guest kernel upgrades.  I haven't posted
the bit that updates the kernel / initrd links for direct kernel launch
(using initrds) but I have posted what's needed for dracut to make
rootfs virtiofs work.

All that's required for stability -- for now -- is for the host to treat
the files shared on the guest as 'unusable' while the guest is running
-- or at least 'read only'.

> I am assuming you prefer using virtiofs as rootfs for your VMs and
> that's why running into these dracut related issues.

Let me restate -- I am NOT having a dracut issue.  I solved that long
ago and it works very well.   In fact the whole virtiofs thing was
working very well (without dax as main-distro kernels still lack the pci
bar in the host) -- until a regression in the last few weeks that broke
rpm / dnf / yum (noted above, even with permissive on the guest
lsetfilecon returns a permission error blocking all dnf operations). 
The only 'maintainable' way forward I can see is to reduce the number of
core packages involved.  The disk space required for a basic workstation
or server image is 'small' by today's storage standards.  I see no
reason multiply complexities by implementing one host-guest relationship
for 'booting' a guest and another for 'the files on the guest'.  Making
it possible to just snapshot one directory tree on the host and know
everything important to the guest is there -- that's a big win.

Harry




