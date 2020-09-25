DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=lizzy; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=Mtlvd6/JfhA7bnxupmXQsyc+Nnh9ngRKS9o/dIotvbc=;
	b=IfClmXIutjsdqvoNX99L9xC3oe
	YCEz9m2MvrGsIjAAE+9uLZQaJlTfWO6hu3Z15E3qqCQBLfLags3LehZrwOh55bRQ6WnNTctMf1kmI
	jNMPvrU9XsxzcuJwvSptERsB4lxgL5exLWj10nwwaX3aXT4p3PYtStX2T9RpzqSfcbpZi1zJFVYlu
	qL/GEhy3Ljn7FH7uIAnjv4nJ4Ya8X7sRLKRb/GfXdLF5PyPrY9q/XYdILENhl+Ert6hb6UG1h5QsP
	70emr140Mbq1fF7Gb3w3w0Ydbld7khu7PHN00UF/g+WYhRoOEEHy824BbkmqPXS407lJty2G5zLzR
	Lbng2wQA==
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Fri, 25 Sep 2020 18:33:08 +0200
Message-ID: <1726614.lvKUr2j5NN@silver>
In-Reply-To: <7085634.CctCyd8GvG@silver>
References: <20200918213436.GA3520@redhat.com> <20200925130538.GK2873@work-vm>
	<7085634.CctCyd8GvG@silver>
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

On Freitag, 25. September 2020 18:05:17 CEST Christian Schoenebeck wrote:
> On Freitag, 25. September 2020 15:05:38 CEST Dr. David Alan Gilbert wrote:
> > > > 9p ( mount -t 9p -o trans=virtio kernel /mnt
> > > > -oversion=9p2000.L,cache=mmap,msize=1048576 ) test: (g=0): rw=randrw,
> > > 
> > > Bottleneck ------------------------------^
> > > 
> > > By increasing 'msize' you would encounter better 9P I/O results.
> > 
> > OK, I thought that was bigger than the default;  what number should I
> > use?
> 
> It depends on the underlying storage hardware. In other words: you have to
> try increasing the 'msize' value to a point where you no longer notice a
> negative performance impact (or almost). Which is fortunately quite easy to
> test on guest like:
> 
> 	dd if=/dev/zero of=test.dat bs=1G count=12
> 	time cat test.dat > /dev/null

I forgot: you should execute that 'dd' command and host side, and the 'cat' 
command on guest side, to avoid any caching making the benchmark result look 
better than it actually is. Because for finding a good 'msize' value you only 
care about actual 9p data really being transmitted between host and guest.

Best regards,
Christian Schoenebeck


