DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=bSiqQA0MZWWf8S7+gK7PaBB451xMzG1qTgaiycXHH6A=;
	b=blxJ7Pfo3BKDaAK8gqyKFj2evj
	H7X6GywcluTHEGctSXgJHLYzJWBsavAAo04zoZloDzX0h28yr/B++2RwFumSckXHF8JYcpnZcT+EV
	0bxtWWxNCidKq0xo4kV1U4acDsqZsIbq8ANBsH5eAqMyF1joMPUAZrRFb1Fz9SkhHqRFJR5dwJvaZ
	i6l2yIqCV0MiMIfyEZT3ZRO3mpQBFUwG3rAymigOyZr0Ag+3JChfplEOKLnNecG1/4CNyWuoT7a//
	IOkRFHEgpTUZyEex4UzGHIdVXunCN3nlaSYTFty9cTuUe34O4lopNYEIhShhhewXwDcMW3VtpOCw7
	sAfpiPdMEdCY/pOVI1FGZKHWRwl4Aoft+vYJjcYwfDqpJvO95jU48QriW8KfpgKNkkBWmhvrIc/YO
	F0ZKuHicnNxqCGhaCczs2Ee9tO1RwR7bLu2ykeFW/7vQ+UbQqQFi5Xlk5X0RHVNolMWAZkDQm1c6C
	nG+ZlDlUKYBZCwTgTwROJvKhfNJF/98qbpbUxzNxZtYODSbXhubdBzt0UDdMOhJXmb/lTVF8/MQwx
	qUI1Hqt4E0j2khmFu9QyXBrl33FhY6/QQWaOOPGhnxA8iPEL/yTAUA37NAbcTbJ29kpQZrwBqBknN
	qIh1hpUN9YUbVXBr30W7KT7oTYP4AGUEzKvWbn7tw=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Tue, 29 Sep 2020 15:28:06 +0200
Message-ID: <2302525.O3mciSdnpG@silver>
In-Reply-To: <20200929130325.GA220516@redhat.com>
References: <20200918213436.GA3520@redhat.com> <66718708.HdZnNlUTFG@silver>
	<20200929130325.GA220516@redhat.com>
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

On Dienstag, 29. September 2020 15:03:25 CEST Vivek Goyal wrote:
> On Sun, Sep 27, 2020 at 02:14:43PM +0200, Christian Schoenebeck wrote:
> > On Freitag, 25. September 2020 20:51:47 CEST Dr. David Alan Gilbert wrote:
> > > * Christian Schoenebeck (qemu_oss@crudebyte.com) wrote:
> > > > On Freitag, 25. September 2020 15:05:38 CEST Dr. David Alan Gilbert 
wrote:
> > > > > > > 9p ( mount -t 9p -o trans=virtio kernel /mnt
> > > > > > > -oversion=9p2000.L,cache=mmap,msize=1048576 ) test: (g=0):
> > > > > > > rw=randrw,
> > > > > > 
> > > > > > Bottleneck ------------------------------^
> > > > > > 
> > > > > > By increasing 'msize' you would encounter better 9P I/O results.
> > > > > 
> > > > > OK, I thought that was bigger than the default;  what number should
> > > > > I
> > > > > use?
> > > > 
> > > > It depends on the underlying storage hardware. In other words: you
> > > > have to
> > > > try increasing the 'msize' value to a point where you no longer notice
> > > > a
> > > > negative performance impact (or almost). Which is fortunately quite
> > > > easy
> > > > to test on>
> > > > 
> > > > guest like:
> > > > 	dd if=/dev/zero of=test.dat bs=1G count=12
> > > > 	time cat test.dat > /dev/null
> > > > 
> > > > I would start with an absolute minimum msize of 10MB. I would
> > > > recommend
> > > > something around 100MB maybe for a mechanical hard drive. With a PCIe
> > > > flash
> > > > you probably would rather pick several hundred MB or even more.
> > > > 
> > > > That unpleasant 'msize' issue is a limitation of the 9p protocol:
> > > > client
> > > > (guest) must suggest the value of msize on connection to server
> > > > (host).
> > > > Server can only lower, but not raise it. And the client in turn
> > > > obviously
> > > > cannot see host's storage device(s), so client is unable to pick a
> > > > good
> > > > value by itself. So it's a suboptimal handshake issue right now.
> > > 
> > > It doesn't seem to be making a vast difference here:
> > > 
> > > 
> > > 
> > > 9p mount -t 9p -o trans=virtio kernel /mnt
> > > -oversion=9p2000.L,cache=mmap,msize=104857600
> > > 
> > > Run status group 0 (all jobs):
> > >    READ: bw=62.5MiB/s (65.6MB/s), 62.5MiB/s-62.5MiB/s
> > >    (65.6MB/s-65.6MB/s),
> > > 
> > > io=3070MiB (3219MB), run=49099-49099msec WRITE: bw=20.9MiB/s (21.9MB/s),
> > > 20.9MiB/s-20.9MiB/s (21.9MB/s-21.9MB/s), io=1026MiB (1076MB),
> > > run=49099-49099msec
> > > 
> > > 9p mount -t 9p -o trans=virtio kernel /mnt
> > > -oversion=9p2000.L,cache=mmap,msize=1048576000
> > > 
> > > Run status group 0 (all jobs):
> > >    READ: bw=65.2MiB/s (68.3MB/s), 65.2MiB/s-65.2MiB/s
> > >    (68.3MB/s-68.3MB/s),
> > > 
> > > io=3070MiB (3219MB), run=47104-47104msec WRITE: bw=21.8MiB/s (22.8MB/s),
> > > 21.8MiB/s-21.8MiB/s (22.8MB/s-22.8MB/s), io=1026MiB (1076MB),
> > > run=47104-47104msec
> > > 
> > > 
> > > Dave
> > 
> > Is that benchmark tool honoring 'iounit' to automatically run with max.
> > I/O
> > chunk sizes? What's that benchmark tool actually? And do you also see no
> > improvement with a simple
> > 
> > 	time cat largefile.dat > /dev/null
> 
> I am assuming that msize only helps with sequential I/O and not random
> I/O.
> 
> Dave is running random read and random write mix and probably that's why
> he is not seeing any improvement with msize increase.
> 
> If we run sequential workload (as "cat largefile.dat"), that should
> see an improvement with msize increase.
> 
> Thanks
> Vivek

Depends on what's randomized. If read chunk size is randomized, then yes, you 
would probably see less performance increase compared to a simple
'cat foo.dat'.

If only the read position is randomized, but the read chunk size honors 
iounit, a.k.a. stat's st_blksize (i.e. reading with the most efficient block 
size advertised by 9P), then I would assume still seeing a performance 
increase. Because seeking is a no/low cost factor in this case. The guest OS 
seeking does not transmit a 9p message. The offset is rather passed with any 
Tread message instead:
https://github.com/chaos/diod/blob/master/protocol.md

I mean, yes, random seeks reduce I/O performance in general of course, but in 
direct performance comparison, the difference in overhead of the 9p vs. 
virtiofs network controller layer is most probably the most relevant aspect if 
large I/O chunk sizes are used.

But OTOH: I haven't optimized anything in Tread handling in 9p (yet).

Best regards,
Christian Schoenebeck


