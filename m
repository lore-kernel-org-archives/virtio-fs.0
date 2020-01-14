Date: Tue, 14 Jan 2020 15:31:38 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200114203138.GA3145@redhat.com>
References: <20200107125159.GA15745@infradead.org>
	<CAPcyv4jZE35sbDo6J4ihioEUFTuekJ3_h0=2Ra4PY+xn2xn1cQ@mail.gmail.com>
	<20200107170731.GA472641@magnolia>
	<CAPcyv4ggH7-QhYg+YOOWn_m25uds+-0L46=N09ap-LALeGuU_A@mail.gmail.com>
	<20200107180101.GC15920@redhat.com>
	<CAPcyv4gmdoqpwwwy4dS3D2eZFjmJ_Zi39k=1a4wn-_ksm-UV4A@mail.gmail.com>
	<20200107183307.GD15920@redhat.com>
	<CAPcyv4ggoS4dWjq-1KbcuaDtroHKEi5Vu19ggJ-qgycs6w1eCA@mail.gmail.com>
	<20200109112447.GG27035@quack2.suse.cz>
	<CAPcyv4j5Mra8qeLO3=+BYZMeXNAxFXv7Ex7tL9gra1TbhOgiqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4j5Mra8qeLO3=+BYZMeXNAxFXv7Ex7tL9gra1TbhOgiqg@mail.gmail.com>
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
Cc: virtio-fs@redhat.com, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Thu, Jan 09, 2020 at 12:03:01PM -0800, Dan Williams wrote:
> On Thu, Jan 9, 2020 at 3:27 AM Jan Kara <jack@suse.cz> wrote:
> >
> > On Tue 07-01-20 10:49:55, Dan Williams wrote:
> > > On Tue, Jan 7, 2020 at 10:33 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > W.r.t partitioning, bdev_dax_pgoff() seems to be the pain point where
> > > > dax code refers back to block device to figure out partition offset in
> > > > dax device. If we create a dax object corresponding to "struct block_device"
> > > > and store sector offset in that, then we could pass that object to dax
> > > > code and not worry about referring back to bdev. I have written some
> > > > proof of concept code and called that object "dax_handle". I can post
> > > > that code if there is interest.
> > >
> > > I don't think it's worth it in the end especially considering
> > > filesystems are looking to operate on /dev/dax devices directly and
> > > remove block entanglements entirely.
> > >
> > > > IMHO, it feels useful to be able to partition and use a dax capable
> > > > block device in same way as non-dax block device. It will be really
> > > > odd to think that if filesystem is on /dev/pmem0p1, then dax can't
> > > > be enabled but if filesystem is on /dev/mapper/pmem0p1, then dax
> > > > will work.
> > >
> > > That can already happen today. If you do not properly align the
> > > partition then dax operations will be disabled. This proposal just
> > > extends that existing failure domain to make all partitions fail to
> > > support dax.
> >
> > Well, I have some sympathy with the sysadmin that has /dev/pmem0 device,
> > decides to create partitions on it for whatever (possibly misguided)
> > reason and then ponders why the hell DAX is not working? And PAGE_SIZE
> > partition alignment is so obvious and widespread that I don't count it as a
> > realistic error case sysadmins would be pondering about currently.
> >
> > So I'd find two options reasonably consistent:
> > 1) Keep status quo where partitions are created and support DAX.
> > 2) Stop partition creation altogether, if anyones wants to split pmem
> > device further, he can use dm-linear for that (i.e., kpartx).
> >
> > But I'm not sure if the ship hasn't already sailed for option 2) to be
> > feasible without angry users and Linus reverting the change.
> 
> Christoph? I feel myself leaning more and more to the "keep pmem
> partitions" camp.
> 
> I don't see "drop partition support" effort ending well given the long
> standing "ext4 fails to mount when dax is not available" precedent.
> 
> I think the next least bad option is to have a dax_get_by_host()
> variant that passes an offset and length pair rather than requiring a
> later bdev_dax_pgoff() to recall the offset. This also prevents
> needing to add another dax-device object representation.

I am wondering what's the conclusion on this. I want to this to make
progress in some direction so that I can make progress on virtiofs DAX
support.

Thanks
Vivek

