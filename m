Date: Fri, 4 Jun 2021 09:44:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210604134439.GB269481@redhat.com>
References: <2234280.ElGaqSPkdT@subpop>
	<ebd44751-333c-cb7a-5776-c63501558af6@redhat.com>
	<9W25UQ.OHKWX78P32DI3@sub-pop.net> <YLksUpVCCovgUAtq@work-vm>
	<MYJ5UQ.562L1XU7LNSJ3@sub-pop.net>
	<0KN5UQ.JVDR5LJRMJIQ3@sub-pop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0KN5UQ.JVDR5LJRMJIQ3@sub-pop.net>
Subject: Re: [Virtio-fs] virtiofs mounted filesystems & SELinux
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Link Dupont <link@sub-pop.net>
Cc: virtio-fs-list <virtio-fs@redhat.com>, libvirt-users@redhat.com

On Thu, Jun 03, 2021 at 10:14:24PM -0400, Link Dupont wrote:
> On Thu, Jun 3 2021 at 08:56:46 PM -0400, Link Dupont <link@sub-pop.net>
> wrote:
> >  reproducible scenarios
> 
> Alright. I reran my tests with a CentOS 8 guest. On CentOS 8 (with a
> virtiofs filesystem and with xattr on), the type of files in the mounted
> hierarchy are unlabeled_t. I can work around that by switching SELinux in
> the guest to permissive or disabled.

cc Dan Walsh. I was discussing this with Dan Walsh yesterday in general.

In general, if we want to enable SELinux both on host and guest, then
both host and guest should have same SELinux policy. Otherwise there
will be lot of different kind of conflicts because both host and
guest will try to work with same selinux label. I guess that in
practice this will be very hard to achieve as people will run
different host and guest flavors and these might have different
policies.

So another option is to rename selinux xattr in virtiofs so that
any selinux xattr coming from guest is saved as
user.virtiofs.security.selinux xattr on host. That way host and guest
can have their separate labels without interfering with each other.
David Gilbert already has added support for this. I can't remember
the exact syntax but you can figure it out from documentation here
in xattr remappig section.

https://github.com/qemu/qemu/blob/master/docs/tools/virtiofsd.rst

But I have question with selinux xattr remapping. What will happen
to initial labels when fs is exported. I mean until and unless
some process in guest labels all the exported files, they all
with either be unlabeled or pick some generic label for all the
files.

Another option is, can we use a single label for whole of the
virtiofs (using context=<label>) option in guest. That way nothing
is saved in files as such. But this means that processes in guest
can't have different selinux labels on different virtiofs dir/files.

Dan, what do you think?

Thanks
Vivek


> 
> With a CentOS 7 guest, things get less usable. I digested this to a
> reproducible scenario.
> 
> Build a disk image with `virt-builder`, configuring the CentOS Plus kernel
> to get 9p support.
> 
> virt-builder centos-7.8 \
> --root-password password:centos \
> --output centos-7.8.qcow2 \
> --install yum-utils \
> --run-command 'yum-config-manager --enable centosplus' \
> --run-command 'sed -ie "s/DEFAULTKERNEL=kernel/DEFAULTKERNEL=kernel-plus/"
> /etc/sysconfig/kernel' \
> --append-line '/etc/dracut.conf.d/virtio.conf:add_drivers+="virtio_scsi
> virtio_pci virtio_console"' \
> --append-line '/etc/modules-load.d/9pnet_virtio.conf:9pnet_virtio' \
> --install kernel-plus \
> --append-line '/etc/fstab:home /home 9p trans=virtio,version=9p2000.L 0 0'
> 
> Install the volume into the `default` pool.
> 
> sudo install -m644 centos-7.8.qcow2 /var/lib/libvirt/images
> 
> Next, define a domain using the disk image (using `virt-install` here for
> "easy mode").
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
> Now with SELinux enforcing, I cannot list the contents of the directories in
> the mounted hierarchy.
> 
> [root@localhost ~]# ls -lZ /home/link
> ls: cannot open directory /home/link: Permission denied
> 
> 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
> 

