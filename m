Date: Thu, 9 Jan 2020 12:24:47 +0100
From: Jan Kara <jack@suse.cz>
Message-ID: <20200109112447.GG27035@quack2.suse.cz>
References: <CAPcyv4jGEAbYSJef2zLzgg6Arozsuz7eN_vZL1iTcd1XQuNT4Q@mail.gmail.com>
	<20191216181014.GA30106@redhat.com>
	<20200107125159.GA15745@infradead.org>
	<CAPcyv4jZE35sbDo6J4ihioEUFTuekJ3_h0=2Ra4PY+xn2xn1cQ@mail.gmail.com>
	<20200107170731.GA472641@magnolia>
	<CAPcyv4ggH7-QhYg+YOOWn_m25uds+-0L46=N09ap-LALeGuU_A@mail.gmail.com>
	<20200107180101.GC15920@redhat.com>
	<CAPcyv4gmdoqpwwwy4dS3D2eZFjmJ_Zi39k=1a4wn-_ksm-UV4A@mail.gmail.com>
	<20200107183307.GD15920@redhat.com>
	<CAPcyv4ggoS4dWjq-1KbcuaDtroHKEi5Vu19ggJ-qgycs6w1eCA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4ggoS4dWjq-1KbcuaDtroHKEi5Vu19ggJ-qgycs6w1eCA@mail.gmail.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: virtio-fs@redhat.com, linux-nvdimm <linux-nvdimm@lists.01.org>, Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Vivek Goyal <vgoyal@redhat.com>

On Tue 07-01-20 10:49:55, Dan Williams wrote:
> On Tue, Jan 7, 2020 at 10:33 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > W.r.t partitioning, bdev_dax_pgoff() seems to be the pain point where
> > dax code refers back to block device to figure out partition offset in
> > dax device. If we create a dax object corresponding to "struct block_device"
> > and store sector offset in that, then we could pass that object to dax
> > code and not worry about referring back to bdev. I have written some
> > proof of concept code and called that object "dax_handle". I can post
> > that code if there is interest.
> 
> I don't think it's worth it in the end especially considering
> filesystems are looking to operate on /dev/dax devices directly and
> remove block entanglements entirely.
> 
> > IMHO, it feels useful to be able to partition and use a dax capable
> > block device in same way as non-dax block device. It will be really
> > odd to think that if filesystem is on /dev/pmem0p1, then dax can't
> > be enabled but if filesystem is on /dev/mapper/pmem0p1, then dax
> > will work.
> 
> That can already happen today. If you do not properly align the
> partition then dax operations will be disabled. This proposal just
> extends that existing failure domain to make all partitions fail to
> support dax.

Well, I have some sympathy with the sysadmin that has /dev/pmem0 device,
decides to create partitions on it for whatever (possibly misguided)
reason and then ponders why the hell DAX is not working? And PAGE_SIZE
partition alignment is so obvious and widespread that I don't count it as a
realistic error case sysadmins would be pondering about currently.

So I'd find two options reasonably consistent:
1) Keep status quo where partitions are created and support DAX.
2) Stop partition creation altogether, if anyones wants to split pmem
device further, he can use dm-linear for that (i.e., kpartx).

But I'm not sure if the ship hasn't already sailed for option 2) to be
feasible without angry users and Linus reverting the change.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR


