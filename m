Date: Fri, 4 Jun 2021 16:58:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210604205817.GA323260@redhat.com>
References: <756d5044-e567-b403-b4b2-784b3c284ed6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <756d5044-e567-b403-b4b2-784b3c284ed6@gmail.com>
Subject: Re: [Virtio-fs] Virtiofs Kernel Boot howto
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Harry G. Coin" <hgcoin@gmail.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Fri, Jun 04, 2021 at 11:28:42AM -0500, Harry G. Coin wrote:
> Mentioned up-list, here's a further little helper to allow virtio-fs root.

Hi Harry,

Thanks for posting instructions on how to boot with virtiofs as rootfs.

[..]
> and as 'kernel args' (presuming you've built dracut with the added conf
> files I published on this list previously):
> 
> root=virtiofs:myfs rd.shell rd.fstab

Ok, this is interesting bit that how virtiofs root should be specified
so that it can be parsed both by kernel as well as initramfs module.

I don't think "root=virtiofs:myfs" is recognized by kernel. So you must
have coded dracut module to parse it appropriately.

I just want to make sure that we have a common agreed upon format
to specify virtiofs as root device. Stefan had posted some pathces
to kernel in the past but I think review suggested more work and
things did not progress after that.

https://lore.kernel.org/linux-fsdevel/20190906100324.8492-1-stefanha@redhat.com/

Stefan had suggested syntax "rootfstype=virtiofs root=myfs rw".

Now various kind of hacks are being used. Atleast I am aware of two.

- For vhost-user-fs-pci device use "tag=mtdmyfs" and pass following in
  kernel command line. This hack was proposed by stefan.

  "root=mtdmyfs rootfstype=virtiofs rw"

- For vhost-user-fs-pci device use "tag=/dev/root" and pass following in
  kernel command line.

  "rootfstype=virtiofs rw"

Anyway, point being that instead of using hacks, will be good if we
can fix kernel to accept an option for virtiofs and then fix
dracut accordingly. Don't want two different ways of doing things
for dracut and kernel.

Thanks
Vivek

