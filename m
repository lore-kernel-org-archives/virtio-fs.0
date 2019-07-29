Date: Mon, 29 Jul 2019 08:48:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190729124816.GA630@redhat.com>
References: <20190726082933.13314-1-stefanha@redhat.com>
	<20190726203941.GA3706@redhat.com>
	<20190729082149.GB3369@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729082149.GB3369@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH] fuse: implement FUSE_INIT map_alignment
	field
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, Miklos Szeredi <mszeredi@redhat.com>

On Mon, Jul 29, 2019 at 09:21:49AM +0100, Stefan Hajnoczi wrote:
> On Fri, Jul 26, 2019 at 04:39:41PM -0400, Vivek Goyal wrote:
> > On Fri, Jul 26, 2019 at 09:29:33AM +0100, Stefan Hajnoczi wrote:
> > > The device communicates FUSE_SETUPMAPPING/FUSE_REMOVMAPPING alignment
> > > constraints via the FUST_INIT map_alignment field.  Parse this field and
> > > ensure our DAX mappings meet the alignment constraints.
> > 
> > Hi Stefan,
> > 
> > To meet alignment constraints, we also need to make sure dax window
> > start/end address is 2MB aligned as well?
> 
> No, because the mmap on the host is independent of the guest virtual
> address at which the BAR is mapped inside the guest.
> 
> QEMU hw/virtio/vhost-user-fs.c:vuf_device_realize() mmaps the DAX window
> on the host side and that's where the mmap alignment requirement is in
> effect.

Ok.

What about checking alignment constratins on inarg.moffset and
inarg.foffset in fuse_setup_one_mapping().

Thanks
Vivek

> 
> The guest can map the DAX window at any address compatible with its own
> virtual memory constraints (i.e. page size).
> 
> Stefan


