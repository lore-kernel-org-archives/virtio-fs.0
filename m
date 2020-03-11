DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=vhWEqnexHgncpvxDS2l8sBNTUU1im25PrBPC7w+tOLk=;
	b=FQioROWeCZRT5RbT70b6aS3L4z5A8Xh9+TkXcRo1x7CAqq0IA0ua0MEGE5Uykqe0FL
	s7mGcH8etLLtylbbbK6FSbTb6IJjRhs43A8ysMHl6swkDiSbevywH8PsYFGAc5tuTu4F
	hx5OcZDYIvjseSVuRKJfka41SHIGYvXKH88DsabLaszJEEo8W3EyzPcO//PwBEE3M3gH
	e8lIZX3B3ofO7IvWP08ivloJcQzyEW6krILi2rllnwhYD/9lqaIRca+M2m313QFn0KyF
	ArCoRx8xQTINJyLzKbBhKUuuPeE0059amPOESX5qE3B8OeqEICFbnYjaivOd08jIc7RP
	nwqA==
MIME-Version: 1.0
References: <20200304165845.3081-1-vgoyal@redhat.com>
In-Reply-To: <20200304165845.3081-1-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Mar 2020 07:22:51 +0200
Message-ID: <CAOQ4uxi_Xrf+iyP6KVugFgLOfzUvscMr0de0KxQo+jHNBCA9oA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 00/20] virtiofs: Add DAX support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-kernel <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, mst@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Mar 4, 2020 at 7:01 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Hi,
>
> This patch series adds DAX support to virtiofs filesystem. This allows
> bypassing guest page cache and allows mapping host page cache directly
> in guest address space.
>
> When a page of file is needed, guest sends a request to map that page
> (in host page cache) in qemu address space. Inside guest this is
> a physical memory range controlled by virtiofs device. And guest
> directly maps this physical address range using DAX and hence gets
> access to file data on host.
>
> This can speed up things considerably in many situations. Also this
> can result in substantial memory savings as file data does not have
> to be copied in guest and it is directly accessed from host page
> cache.
>
> Most of the changes are limited to fuse/virtiofs. There are couple
> of changes needed in generic dax infrastructure and couple of changes
> in virtio to be able to access shared memory region.
>
> These patches apply on top of 5.6-rc4 and are also available here.
>
> https://github.com/rhvgoyal/linux/commits/vivek-04-march-2020
>
> Any review or feedback is welcome.
>
[...]
>  drivers/dax/super.c                |    3 +-
>  drivers/virtio/virtio_mmio.c       |   32 +
>  drivers/virtio/virtio_pci_modern.c |  107 +++
>  fs/dax.c                           |   66 +-
>  fs/fuse/dir.c                      |    2 +
>  fs/fuse/file.c                     | 1162 +++++++++++++++++++++++++++-

That's a big addition to already big file.c.
Maybe split dax specific code to dax.c?
Can be a post series cleanup too.

Thanks,
Amir.


