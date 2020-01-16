DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=intel-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=6nsG4OiSI74VDUNjgH/EGPUC6QzQOOzMAIB017xQliU=;
	b=J79PjTiwui87Gtdaft875ciI4awf5xIZ2OlEVeWr6PK1j7HDrzdets/eOiB9gFbjxU
	N8a+VDYTOh/zAoGUZWE4w1cYgXKFMyIY5mxDDqaoQWFa6T9HxfH2fP9PLUP1uKEVP7xo
	SFvhifCBTkknEhBzZWrz1h+yDcMOzcy1CAiSWM1LLzIaCNgg2JOGV1Bsk6VwLRFyGzsl
	3oI19Df8dP3bwMD1fbOXbUBm44Ixpu94cRB2oRYOQ/+C0gKdgTy/EpALksKs5ue92Nlt
	bvnoL/8n6PK1nwQDhUpD7aFZSXwTnAcIEDKECZAVt2HboWTI3XccHsyHaJHIW0AO8xHe
	C2gg==
MIME-Version: 1.0
References: <20200109112447.GG27035@quack2.suse.cz>
	<CAPcyv4j5Mra8qeLO3=+BYZMeXNAxFXv7Ex7tL9gra1TbhOgiqg@mail.gmail.com>
	<20200114203138.GA3145@redhat.com>
	<CAPcyv4iXKFt207Pen+E1CnqCFtC1G85fxw5EXFVx+jtykGWMXA@mail.gmail.com>
	<20200114212805.GB3145@redhat.com>
	<CAPcyv4igrs40uWuCB163PPBLqyGVaVbaNfE=kCfHRPRuvZdxQA@mail.gmail.com>
	<20200115195617.GA4133@redhat.com>
	<CAPcyv4iEoN9SnBveG7-Mhvd+wQApi1XKVnuYpyYxDybrFv_YYw@mail.gmail.com>
	<x49wo9smnqc.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4hCR9NV+2MF0iAJ5rHS2uiOgTnu=+yQRfpieDJQpQz22w@mail.gmail.com>
	<20200116183900.GC25291@redhat.com>
In-Reply-To: <20200116183900.GC25291@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Jan 2020 11:09:00 -0800
Message-ID: <CAPcyv4irezimk8m4hysrd0rst_f0Rr+iiNxeFesqbxQnWYA2Xw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 01/19] dax: remove block device dependencies
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Jan 16, 2020 at 10:39 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Thu, Jan 16, 2020 at 10:09:46AM -0800, Dan Williams wrote:
> > On Wed, Jan 15, 2020 at 1:08 PM Jeff Moyer <jmoyer@redhat.com> wrote:
> > >
> > > Hi, Dan,
> > >
> > > Dan Williams <dan.j.williams@intel.com> writes:
> > >
> > > > I'm going to take a look at how hard it would be to develop a kpartx
> > > > fallback in udev. If that can live across the driver transition then
> > > > maybe this can be a non-event for end users that already have that
> > > > udev update deployed.
> > >
> > > I just wanted to remind you that label-less dimms still exist, and are
> > > still being shipped.  For those devices, the only way to subdivide the
> > > storage is via partitioning.
> >
> > True, but if kpartx + udev can make this transparent then I don't
> > think users lose any functionality. They just gain a device-mapper
> > dependency.
>
> So udev rules will trigger when a /dev/pmemX device shows up and run
> kpartx which in turn will create dm-linear devices and device nodes
> will show up in /dev/mapper/pmemXpY.
>
> IOW, /dev/pmemXpY device nodes will be gone. So if any of the scripts or
> systemd unit files are depenent on /dev/pmemXpY, these will still be
> broken out of the box and will have to be modified to use device nodes
> in /dev/mapper/ directory instead. Do I understand it right, Or I missed
> the idea completely.

No, I'd write the udev rule to create links from /dev/pmemXpY to the
/dev/mapper device, and that rule would be gated by a new pmem device
attribute to trigger when kpartx needs to run vs the kernel native
partitions.


