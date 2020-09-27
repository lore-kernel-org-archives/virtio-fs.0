DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=lizzy; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=Jzw1/KRabcxEaqNqC1KBDx3WhsVlJkj13T/W///NaNA=;
	b=MLbpzQIO41v6DDPt+mpLK8/962
	B4vkjOVq4HFlL/L2Djl4s29R1SObNg9CUGt1r2Bkng7EaJTL1SB/0e25oWSoGYqiaTAomJU3B6lXe
	WJ/snIanzVn9RoJtvQQ+6u2Q4rtoHibqlU6qx3FHrM74rN9jqip1zjynHd/DTjBYNfS7pfbIT+1pM
	x3D4bUyZuOFCMbnvwNracb9YkkY7ekqVNkAKYU9gEAFFyA8iCmEJD8pZ0H7SA+xz4tnunD47ssAdK
	rck/u8ZqsihsgWcPi1JxX5Cm/DeUuzhsDNYDe3D9SwY7n8lyzSytLO8aIIga1bC5T+Bo3+kLIpzje
	xEp5jS5A==
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Sun, 27 Sep 2020 14:14:43 +0200
Message-ID: <66718708.HdZnNlUTFG@silver>
In-Reply-To: <20200925185147.GS2873@work-vm>
References: <20200918213436.GA3520@redhat.com> <7085634.CctCyd8GvG@silver>
	<20200925185147.GS2873@work-vm>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [Virtio-fs] virtiofs vs 9p performance(Re: tools/virtiofs:
	Multi threading seems to hurt performance)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "Venegas Munoz, Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, "cdupontd@redhat.com" <cdupontd@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>, Vivek Goyal <vgoyal@redhat.com>

On Freitag, 25. September 2020 20:51:47 CEST Dr. David Alan Gilbert wrote:
> * Christian Schoenebeck (qemu_oss@crudebyte.com) wrote:
> > On Freitag, 25. September 2020 15:05:38 CEST Dr. David Alan Gilbert wrote:
> > > > > 9p ( mount -t 9p -o trans=virtio kernel /mnt
> > > > > -oversion=9p2000.L,cache=mmap,msize=1048576 ) test: (g=0):
> > > > > rw=randrw,
> > > > 
> > > > Bottleneck ------------------------------^
> > > > 
> > > > By increasing 'msize' you would encounter better 9P I/O results.
> > > 
> > > OK, I thought that was bigger than the default;  what number should I
> > > use?
> > 
> > It depends on the underlying storage hardware. In other words: you have to
> > try increasing the 'msize' value to a point where you no longer notice a
> > negative performance impact (or almost). Which is fortunately quite easy
> > to test on> 
> > guest like:
> > 	dd if=/dev/zero of=test.dat bs=1G count=12
> > 	time cat test.dat > /dev/null
> > 
> > I would start with an absolute minimum msize of 10MB. I would recommend
> > something around 100MB maybe for a mechanical hard drive. With a PCIe
> > flash
> > you probably would rather pick several hundred MB or even more.
> > 
> > That unpleasant 'msize' issue is a limitation of the 9p protocol: client
> > (guest) must suggest the value of msize on connection to server (host).
> > Server can only lower, but not raise it. And the client in turn obviously
> > cannot see host's storage device(s), so client is unable to pick a good
> > value by itself. So it's a suboptimal handshake issue right now.
> 
> It doesn't seem to be making a vast difference here:
> 
> 
> 
> 9p mount -t 9p -o trans=virtio kernel /mnt
> -oversion=9p2000.L,cache=mmap,msize=104857600
> 
> Run status group 0 (all jobs):
>    READ: bw=62.5MiB/s (65.6MB/s), 62.5MiB/s-62.5MiB/s (65.6MB/s-65.6MB/s),
> io=3070MiB (3219MB), run=49099-49099msec WRITE: bw=20.9MiB/s (21.9MB/s),
> 20.9MiB/s-20.9MiB/s (21.9MB/s-21.9MB/s), io=1026MiB (1076MB),
> run=49099-49099msec
> 
> 9p mount -t 9p -o trans=virtio kernel /mnt
> -oversion=9p2000.L,cache=mmap,msize=1048576000
> 
> Run status group 0 (all jobs):
>    READ: bw=65.2MiB/s (68.3MB/s), 65.2MiB/s-65.2MiB/s (68.3MB/s-68.3MB/s),
> io=3070MiB (3219MB), run=47104-47104msec WRITE: bw=21.8MiB/s (22.8MB/s),
> 21.8MiB/s-21.8MiB/s (22.8MB/s-22.8MB/s), io=1026MiB (1076MB),
> run=47104-47104msec
> 
> 
> Dave

Is that benchmark tool honoring 'iounit' to automatically run with max. I/O 
chunk sizes? What's that benchmark tool actually? And do you also see no 
improvement with a simple

	time cat largefile.dat > /dev/null

?

Best regards,
Christian Schoenebeck


