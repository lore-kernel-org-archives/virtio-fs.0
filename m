Date: Wed, 11 Mar 2020 15:39:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200311193943.GE83257@redhat.com>
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<CAOQ4uxi_Xrf+iyP6KVugFgLOfzUvscMr0de0KxQo+jHNBCA9oA@mail.gmail.com>
	<20200311184830.GC83257@redhat.com>
	<CAOQ4uxjja3cReO28qOd-YGmhU-_KrLxOCaBeqZYydxPAte9_pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjja3cReO28qOd-YGmhU-_KrLxOCaBeqZYydxPAte9_pg@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 00/20] virtiofs: Add DAX support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-kernel <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, mst@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Mar 11, 2020 at 09:32:17PM +0200, Amir Goldstein wrote:
> On Wed, Mar 11, 2020 at 8:48 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Wed, Mar 11, 2020 at 07:22:51AM +0200, Amir Goldstein wrote:
> > > On Wed, Mar 4, 2020 at 7:01 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > This patch series adds DAX support to virtiofs filesystem. This allows
> > > > bypassing guest page cache and allows mapping host page cache directly
> > > > in guest address space.
> > > >
> > > > When a page of file is needed, guest sends a request to map that page
> > > > (in host page cache) in qemu address space. Inside guest this is
> > > > a physical memory range controlled by virtiofs device. And guest
> > > > directly maps this physical address range using DAX and hence gets
> > > > access to file data on host.
> > > >
> > > > This can speed up things considerably in many situations. Also this
> > > > can result in substantial memory savings as file data does not have
> > > > to be copied in guest and it is directly accessed from host page
> > > > cache.
> > > >
> > > > Most of the changes are limited to fuse/virtiofs. There are couple
> > > > of changes needed in generic dax infrastructure and couple of changes
> > > > in virtio to be able to access shared memory region.
> > > >
> > > > These patches apply on top of 5.6-rc4 and are also available here.
> > > >
> > > > https://github.com/rhvgoyal/linux/commits/vivek-04-march-2020
> > > >
> > > > Any review or feedback is welcome.
> > > >
> > > [...]
> > > >  drivers/dax/super.c                |    3 +-
> > > >  drivers/virtio/virtio_mmio.c       |   32 +
> > > >  drivers/virtio/virtio_pci_modern.c |  107 +++
> > > >  fs/dax.c                           |   66 +-
> > > >  fs/fuse/dir.c                      |    2 +
> > > >  fs/fuse/file.c                     | 1162 +++++++++++++++++++++++++++-
> > >
> > > That's a big addition to already big file.c.
> > > Maybe split dax specific code to dax.c?
> > > Can be a post series cleanup too.
> >
> > How about fs/fuse/iomap.c instead. This will have all the iomap related logic
> > as well as all the dax range allocation/free logic which is required
> > by iomap logic. That moves about 900 lines of code from file.c to iomap.c
> >
> 
> Fine by me. I didn't take time to study the code in file.c
> I just noticed is has grown a lot bigger and wasn't sure that
> it made sense. Up to you. Only if you think the result would be nicer
> to maintain.

I am happy to move this code to a separate file. In fact I think we could
probably break it further into another file say dax-mapping.c or something
like that where all the memory range allocation/reclaim logic goes and
iomap logic remains in iomap.c.

But that's probably a future cleanup if code in this file continues to grow.

Vivek

