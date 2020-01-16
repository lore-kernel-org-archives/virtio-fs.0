Date: Thu, 16 Jan 2020 14:23:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200116192353.GD25291@redhat.com>
References: <20200114203138.GA3145@redhat.com>
	<CAPcyv4iXKFt207Pen+E1CnqCFtC1G85fxw5EXFVx+jtykGWMXA@mail.gmail.com>
	<20200114212805.GB3145@redhat.com>
	<CAPcyv4igrs40uWuCB163PPBLqyGVaVbaNfE=kCfHRPRuvZdxQA@mail.gmail.com>
	<20200115195617.GA4133@redhat.com>
	<CAPcyv4iEoN9SnBveG7-Mhvd+wQApi1XKVnuYpyYxDybrFv_YYw@mail.gmail.com>
	<x49wo9smnqc.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4hCR9NV+2MF0iAJ5rHS2uiOgTnu=+yQRfpieDJQpQz22w@mail.gmail.com>
	<20200116183900.GC25291@redhat.com>
	<CAPcyv4irezimk8m4hysrd0rst_f0Rr+iiNxeFesqbxQnWYA2Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4irezimk8m4hysrd0rst_f0Rr+iiNxeFesqbxQnWYA2Xw@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 01/19] dax: remove block device dependencies
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Dan Williams <dan.j.williams@intel.com>
Cc: virtio-fs@redhat.com, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Jan 16, 2020 at 11:09:00AM -0800, Dan Williams wrote:

[..]
> > > True, but if kpartx + udev can make this transparent then I don't
> > > think users lose any functionality. They just gain a device-mapper
> > > dependency.
> >
> > So udev rules will trigger when a /dev/pmemX device shows up and run
> > kpartx which in turn will create dm-linear devices and device nodes
> > will show up in /dev/mapper/pmemXpY.
> >
> > IOW, /dev/pmemXpY device nodes will be gone. So if any of the scripts or
> > systemd unit files are depenent on /dev/pmemXpY, these will still be
> > broken out of the box and will have to be modified to use device nodes
> > in /dev/mapper/ directory instead. Do I understand it right, Or I missed
> > the idea completely.
> 
> No, I'd write the udev rule to create links from /dev/pmemXpY to the
> /dev/mapper device, and that rule would be gated by a new pmem device
> attribute to trigger when kpartx needs to run vs the kernel native
> partitions.

Got it. This sounds much better.

Vivek

