DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=intel-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=EMbN1Woq544EfOz/nfTttJ7Xl0GliaVxV4hQJh4QosE=;
	b=C57IauRMqinuAWTYCo5F6FpoAxD6l1tnXRkUV9Yp8jG0u5XVdw7Tq1FtkDft9QMAsM
	e91sVxxfbB7VV/SdDxU7ia89cdtc/wFaKJPoZdZWBISOQXj9aEK3Qoa3KEWF0UbNmCI4
	ToId79vINoXMj3VmXCSiXoWS5YnHK8S68mVrpm8kYb6guvcXGETqDN/05svyPuhGTkJD
	J1XEnETkz4oaJd5S+3iL3sDuEyAQdO5Z1R9xyCCj5YRS8hCiacAXzo/h/BhZmANiro1i
	krRoo5aKVW4r9YNdl+5pWKl9DAmz/y0agtKvABl07X/vusocmjng6K5HDyPO6/fpt4wR
	ysWg==
MIME-Version: 1.0
References: <20200107170731.GA472641@magnolia>
	<CAPcyv4ggH7-QhYg+YOOWn_m25uds+-0L46=N09ap-LALeGuU_A@mail.gmail.com>
	<20200107180101.GC15920@redhat.com>
	<CAPcyv4gmdoqpwwwy4dS3D2eZFjmJ_Zi39k=1a4wn-_ksm-UV4A@mail.gmail.com>
	<20200107183307.GD15920@redhat.com>
	<CAPcyv4ggoS4dWjq-1KbcuaDtroHKEi5Vu19ggJ-qgycs6w1eCA@mail.gmail.com>
	<20200109112447.GG27035@quack2.suse.cz>
	<CAPcyv4j5Mra8qeLO3=+BYZMeXNAxFXv7Ex7tL9gra1TbhOgiqg@mail.gmail.com>
	<20200114203138.GA3145@redhat.com>
	<CAPcyv4iXKFt207Pen+E1CnqCFtC1G85fxw5EXFVx+jtykGWMXA@mail.gmail.com>
	<20200114212805.GB3145@redhat.com>
In-Reply-To: <20200114212805.GB3145@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 14 Jan 2020 14:23:04 -0800
Message-ID: <CAPcyv4igrs40uWuCB163PPBLqyGVaVbaNfE=kCfHRPRuvZdxQA@mail.gmail.com>
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
Cc: virtio-fs@redhat.com, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Tue, Jan 14, 2020 at 1:28 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Jan 14, 2020 at 12:39:00PM -0800, Dan Williams wrote:
> > On Tue, Jan 14, 2020 at 12:31 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Thu, Jan 09, 2020 at 12:03:01PM -0800, Dan Williams wrote:
> > > > On Thu, Jan 9, 2020 at 3:27 AM Jan Kara <jack@suse.cz> wrote:
> > > > >
> > > > > On Tue 07-01-20 10:49:55, Dan Williams wrote:
> > > > > > On Tue, Jan 7, 2020 at 10:33 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > > > > W.r.t partitioning, bdev_dax_pgoff() seems to be the pain point where
> > > > > > > dax code refers back to block device to figure out partition offset in
> > > > > > > dax device. If we create a dax object corresponding to "struct block_device"
> > > > > > > and store sector offset in that, then we could pass that object to dax
> > > > > > > code and not worry about referring back to bdev. I have written some
> > > > > > > proof of concept code and called that object "dax_handle". I can post
> > > > > > > that code if there is interest.
> > > > > >
> > > > > > I don't think it's worth it in the end especially considering
> > > > > > filesystems are looking to operate on /dev/dax devices directly and
> > > > > > remove block entanglements entirely.
> > > > > >
> > > > > > > IMHO, it feels useful to be able to partition and use a dax capable
> > > > > > > block device in same way as non-dax block device. It will be really
> > > > > > > odd to think that if filesystem is on /dev/pmem0p1, then dax can't
> > > > > > > be enabled but if filesystem is on /dev/mapper/pmem0p1, then dax
> > > > > > > will work.
> > > > > >
> > > > > > That can already happen today. If you do not properly align the
> > > > > > partition then dax operations will be disabled. This proposal just
> > > > > > extends that existing failure domain to make all partitions fail to
> > > > > > support dax.
> > > > >
> > > > > Well, I have some sympathy with the sysadmin that has /dev/pmem0 device,
> > > > > decides to create partitions on it for whatever (possibly misguided)
> > > > > reason and then ponders why the hell DAX is not working? And PAGE_SIZE
> > > > > partition alignment is so obvious and widespread that I don't count it as a
> > > > > realistic error case sysadmins would be pondering about currently.
> > > > >
> > > > > So I'd find two options reasonably consistent:
> > > > > 1) Keep status quo where partitions are created and support DAX.
> > > > > 2) Stop partition creation altogether, if anyones wants to split pmem
> > > > > device further, he can use dm-linear for that (i.e., kpartx).
> > > > >
> > > > > But I'm not sure if the ship hasn't already sailed for option 2) to be
> > > > > feasible without angry users and Linus reverting the change.
> > > >
> > > > Christoph? I feel myself leaning more and more to the "keep pmem
> > > > partitions" camp.
> > > >
> > > > I don't see "drop partition support" effort ending well given the long
> > > > standing "ext4 fails to mount when dax is not available" precedent.
> > > >
> > > > I think the next least bad option is to have a dax_get_by_host()
> > > > variant that passes an offset and length pair rather than requiring a
> > > > later bdev_dax_pgoff() to recall the offset. This also prevents
> > > > needing to add another dax-device object representation.
> > >
> > > I am wondering what's the conclusion on this. I want to this to make
> > > progress in some direction so that I can make progress on virtiofs DAX
> > > support.
> >
> > I think we should at least try to delete the partition support and see
> > if anyone screams. Have a module option to revert the behavior so
> > people are not stuck waiting for the revert to land, but if it stays
> > quiet then we're in a better place with that support pushed out of the
> > dax core.
>
> Hi Dan,
>
> So basically keep partition support code just that disable it by default
> and it is enabled by some knob say kernel command line option/module
> option.

Yes.

> At what point of time will we remove that code completely. I mean what
> if people scream after two kernel releases, after we have removed the
> code.

I'd follow the typical timelines of Documentation/ABI/obsolete which
is a year or more.

>
> Also, from distribution's perspective, we might not hear from our
> customers for a very long time (till we backport that code in to
> existing releases or release this new code in next major release). From
> that view point I will not like to break existing user visible behavior.
>
> How bad it is to keep partition support around. To me it feels reasonaly
> simple where we just have to store offset into dax device into another
> dax object:

If we end up keeping partition support, we're not adding another object.

> and pass that object around (instead of dax_device). If that's
> the case, I am not sure why to even venture into a direction where some
> user's setup might be broken.

It was a mistake to support them. If that mistake can be undone
without breaking existing deployments the code base is better off
without the concept.

> Also from an application perspective, /dev/pmem is a block device, so it
> should behave like a block device, (including kernel partition table support).
> From that view, dax looks like just an additional feature of that device
> which can be enabled by passing option "-o dax".

dax via block devices was a crutch that we leaned on too heavily, and
the implementation has slowly been moving away from it ever since.

> IOW, can we reconsider the idea of not supporting kernel partition tables
> for dax capable block devices. I can only see downsides of removing kernel
> partition table support and only upside seems to be little cleanup of dax
> core code.

Can you help find end users that depend on it? Even the Red Hat
installation guide example shows mounting on pmem0 directly. [1]

My primary concern is people that might be booting from pmem as boot
support requires an EFI partition table, and initramfs images would
need to be respun to move to kpartx.

[1]: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html-single/storage_administration_guide/index#Configuring-Persistent-Memory-for-File-System-Direct-Access-DAX


