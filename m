DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sub-pop.net
	; s=mythic-beasts-k1; h=To:Subject:From:Date;
	bh=FrHj+OATBRjDv8uDkdX1QohJGCBX9qQVJcv1uklAB8Y=;
	b=wMiSBnoBd266lOvpSmcl87RZHh
	zU/IeJBIk7ERyS8sXLMpnbavbNuON5+hq8tDbCGiXdiHZLnX/uxwkvCL/XiGFMQauAoCL1ZPBeI96
	iPxio0ZmyrWFuhhf3eGchqfzb+GuzbYElxVfwH8mAXCWHA6/u3YI0XoG/MoeMPqjhSQwYNobtvZsI
	i4LbqhXvF7skToR/AIszPPZoYSTji/Aji+XmV1WXmmLv5aChjj7JigjiPkkuZ7oPqxZGTjVsSlGBi
	x6tP5eDrrNYc1/woTfuKFF5QUIKBEG/FkP0a3afa54YJAI72+21Lciyn+Nnv+g+TSWtHgDe8inmRa
	xy/Ipe2A==
Date: Mon, 07 Jun 2021 10:05:09 -0400
From: Link Dupont <link@sub-pop.net>
Message-Id: <LG4CUQ.EY2LQZQ6C9OL@sub-pop.net>
In-Reply-To: <15e860ba-5ea3-90d6-eccf-6003f6874bc7@redhat.com>
References: <2234280.ElGaqSPkdT@subpop>
	<ebd44751-333c-cb7a-5776-c63501558af6@redhat.com>
	<9W25UQ.OHKWX78P32DI3@sub-pop.net> <YLksUpVCCovgUAtq@work-vm>
	<MYJ5UQ.562L1XU7LNSJ3@sub-pop.net> <0KN5UQ.JVDR5LJRMJIQ3@sub-pop.net>
	<20210604134439.GB269481@redhat.com> <YLoxwQIyqAazPHqf@redhat.com>
	<15e860ba-5ea3-90d6-eccf-6003f6874bc7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] virtiofs mounted filesystems & SELinux
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: dwalsh@redhat.com
Cc: virtio-fs-list <virtio-fs@redhat.com>, libvirt-users@redhat.com, "Daniel P. =?iso-8859-1?q?Berrang=E9?=" <berrange@redhat.com>, Vivek Goyal <vgoyal@redhat.com>



On Mon, Jun 7 2021 at 09:01:08 AM -0400, Daniel Walsh=20
<dwalsh@redhat.com> wrote:
> On 6/4/21 09:59, Daniel P. Berrang=E9 wrote:
>> On Fri, Jun 04, 2021 at 09:44:39AM -0400, Vivek Goyal wrote:
>>> On Thu, Jun 03, 2021 at 10:14:24PM -0400, Link Dupont wrote:
>>>> On Thu, Jun 3 2021 at 08:56:46 PM -0400, Link Dupont=20
>>>> <link@sub-pop.net>
>>>> wrote:
>>>>>   reproducible scenarios
>>>> Alright. I reran my tests with a CentOS 8 guest. On CentOS 8 (with=20
>>>> a
>>>> virtiofs filesystem and with xattr on), the type of files in the=20
>>>> mounted
>>>> hierarchy are unlabeled_t. I can work around that by switching=20
>>>> SELinux in
>>>> the guest to permissive or disabled.
>>> cc Dan Walsh. I was discussing this with Dan Walsh yesterday in=20
>>> general.
>>>=20
>>> In general, if we want to enable SELinux both on host and guest,=20
>>> then
>>> both host and guest should have same SELinux policy. Otherwise there
>>> will be lot of different kind of conflicts because both host and
>>> guest will try to work with same selinux label. I guess that in
>>> practice this will be very hard to achieve as people will run
>>> different host and guest flavors and these might have different
>>> policies.
>> Yeah, I think there's little to no chance of people keeping the
>> same SELinux policy in host/guest, except in very tightly controlled
>> narrow use cases where the host admin exerts direct control over
>> the precise guest config.
>>=20
>>=20
>>> So another option is to rename selinux xattr in virtiofs so that
>>> any selinux xattr coming from guest is saved as
>>> user.virtiofs.security.selinux xattr on host. That way host and=20
>>> guest
>>> can have their separate labels without interfering with each other.
>>> David Gilbert already has added support for this. I can't remember
>>> the exact syntax but you can figure it out from documentation here
>>> in xattr remappig section.
>> For general purpose virt usage, I think remapping in some way is
>> likely to be needed as the default strategy.
>>=20
>>> https://github.com/qemu/qemu/blob/master/docs/tools/virtiofsd.rst
>>>=20
>>> But I have question with selinux xattr remapping. What will happen
>>> to initial labels when fs is exported. I mean until and unless
>>> some process in guest labels all the exported files, they all
>>> with either be unlabeled or pick some generic label for all the
>>> files.
>> I'd say you need some mechanism to force a re-label inside the
>> guest. Normally a relabel will be done in /.autorelabel file
>> is present, or in certain other scenarios like selinux policy
>> RPM updates.
>>=20
>> We wouldn't want to force a relabel neccesarily for the entire
>> FS if we're just hotplugging a new virtiofs export though. So
>> perhaps there's scope for supporting usage of a per-mount
>> point relabel trigger. eg Host creates $VIRTIOFS-ROOT/.autorelabel
>> and whenever the guest sees a new virtiofs export arriving, it
>> can look for $VIRTIOFS-MOUNT-POINT/.autorelabel
>>=20
>>> Another option is, can we use a single label for whole of the
>>> virtiofs (using context=3D<label>) option in guest. That way nothing
>>> is saved in files as such. But this means that processes in guest
>>> can't have different selinux labels on different virtiofs dir/files.
>> Forcing a single label for the entire export is passable as a
>> fallback plan. This is what people have done for years with
>> NFS v3 mounts. It has annoying usage limitations though, so
>> if at all possible remapping is a preferrable approach.
>>=20
>>> Dan, what do you think?
>>>=20
>>> Thanks
>>> Vivek
>>>=20
>>>=20
>>>> With a CentOS 7 guest, things get less usable. I digested this to a
>>>> reproducible scenario.
>>>>=20
>>>> Build a disk image with `virt-builder`, configuring the CentOS=20
>>>> Plus kernel
>>>> to get 9p support.
>>>>=20
>>>> virt-builder centos-7.8 \
>>>> --root-password password:centos \
>>>> --output centos-7.8.qcow2 \
>>>> --install yum-utils \
>>>> --run-command 'yum-config-manager --enable centosplus' \
>>>> --run-command 'sed -ie=20
>>>> "s/DEFAULTKERNEL=3Dkernel/DEFAULTKERNEL=3Dkernel-plus/"
>>>> /etc/sysconfig/kernel' \
>>>> --append-line=20
>>>> '/etc/dracut.conf.d/virtio.conf:add_drivers+=3D"virtio_scsi
>>>> virtio_pci virtio_console"' \
>>>> --append-line '/etc/modules-load.d/9pnet_virtio.conf:9pnet_virtio'=20
>>>> \
>>>> --install kernel-plus \
>>>> --append-line '/etc/fstab:home /home 9p=20
>>>> trans=3Dvirtio,version=3D9p2000.L 0 0'
>>>>=20
>>>> Install the volume into the `default` pool.
>>>>=20
>>>> sudo install -m644 centos-7.8.qcow2 /var/lib/libvirt/images
>>>>=20
>>>> Next, define a domain using the disk image (using `virt-install`=20
>>>> here for
>>>> "easy mode").
>>>>=20
>>>> virt-install \
>>>> --import \
>>>> --os-variant centos7.0 \
>>>> --name centos \
>>>> --ram 2048 \
>>>> --disk path=3D/var/lib/libvirt/images/centos-7.8.qcow2 \
>>>> --memorybacking access.mode=3Dshared \
>>>> --filesystem source=3D/home,target=3Dhome,accessmode=3Dpassthrough \
>>>> --autoconsole none
>>>>=20
>>>> Now with SELinux enforcing, I cannot list the contents of the=20
>>>> directories in
>>>> the mounted hierarchy.
>>>>=20
>>>> [root@localhost ~]# ls -lZ /home/link
>>>> ls: cannot open directory /home/link: Permission denied
>>>>=20
>>>>=20
>>>>=20
>>>> _______________________________________________
>>>> Virtio-fs mailing list
>>>> Virtio-fs@redhat.com
>>>> https://listman.redhat.com/mailman/listinfo/virtio-fs
>>>>=20
>> Regards,
>> Daniel
>=20
> The separate XAttr support would also allow virtiofsd to work with=20
> labels inside of the container when the virtiofsd is confined on the=20
> host.
>=20
>=20
> I would guess/hope virtiofsd on the host will be confined and only=20
> able to write certain labels like container_file_t or svirt_image_t. =20
> If you want to allow virt file systems within the "VM" to be able to=20
> set labels, these labels will have to be something other then SELinux=20
> labels on the host, or SELinux will prevent them from being set.
>=20

I don't think the guest needs to be able to set labels on the virtiofs=20
filesystems; as long as it can read labels that grant read and write=20
access as the guest user, I'd call it a success. The way I use this=20
feature, I'm treating my host filesystem as the "source", and really=20
only mounting it into the guest as a zero-delay synchronization. (I=20
previously did this using sync solutions like rsync or lsyncd, but=20
those have a slight delay before files sync over.)

If the labels as seen by the guest allow for reading and writing files=20
from the guest to the host filesystem, I'd be happy. Doing any=20
relabeling from the host is totally fine.



