DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=vK60LVqZ1MizhW17MFO70pzqiivCnOEjbQpiOY4eEnQ=;
	b=BhoDwYUpxPKYsSIrcxOSQn0Ye6
	xoEKDA3F5AjYG7a9vuosWfQ1ARAEAW9NNdLjYixzHzr+D4Z+HZg6IbJJfQIiFb+bL/OsDOhDSVBDA
	AaDkbzoOI0fnWcjmRSgUe8FLsG/OulyKqeVxfmsrMxu8OdLFuAP3+WcOGqnElUgIT+xpcMusNi/U9
	//eG3/gOV9KS24Rb0WC/sj5o6g87YXj61vnyQl4y8SedEaLIJlZjsUkLtyL55NRZE4vCQEcbvNkGO
	mRvGKFSUmRkrIZVxLbHFvXsEoB/ARjYsElLg85/T4XuLFbDmWQLIw7wmZyC3911oZGBD4rcvnFrBj
	cSWQM5D3QeV6HJR1K6LbdcMXQsjoKX3U5/l/7uleEtRUGypRNOKvA24C8/W3ifZUJEpCRpdDTM9Yd
	gBYeoViKxA46gY0p+vZ91Hrm6Wgn2mukuiNHhJnmh4+P/web1yFRWebDz12CkEfyRIH9VudNUkUeM
	XkY7Mmg3Zgn6fZn+PXrhnXGLHzDs2asduD9CxWabIMJZ5x2rMlsOAUV5Bos12jL7ywEzmosyQ13y+
	hQ53SkdqgBeK2qlXnSdc0VfjVyjkoVgBujQt8iFI3QWrdxbSdb9U6yVyp51f0cHfhz6rXJWdYJYyB
	981BUHDc4hgb3Xj9DoGVRGstUdoSbv1GwcGtoo6B4=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Wed, 03 Mar 2021 15:04:21 +0100
Message-ID: <1805660.C9YIKG4Ep7@silver>
In-Reply-To: <YDmMXCxxOqo1xKgq@odin>
References: <20200918213436.GA3520@redhat.com> <1918692.k70u9Ml6kK@silver>
	<YDmMXCxxOqo1xKgq@odin>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [Virtio-fs] Can not set high msize with virtio-9p (Was: Re:
	virtiofs vs 9p performance)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "cdupontd@redhat.com" <cdupontd@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Dominique Martinet <asmadeus@codewreck.org>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, virtio-fs-list <virtio-fs@redhat.com>, v9fs-developer@lists.sourceforge.net, "Shinde,
	Archana M" <archana.m.shinde@intel.com>, Vivek Goyal <vgoyal@redhat.com>

On Samstag, 27. Februar 2021 01:03:40 CET Dominique Martinet wrote:
> Christian Schoenebeck wrote on Fri, Feb 26, 2021 at 02:49:12PM +0100:
> > Right now the client uses a hard coded amount of 128 elements. So what
> > about replacing VIRTQUEUE_NUM by a variable which is initialized with a
> > value according to the user's requested 'msize' option at init time?
> > 
> > According to the virtio specs the max. amount of elements in a virtqueue
> > is
> > 32768. So 32768 * 4k = 128M as new upper limit would already be a
> > significant improvement and would not require too many changes to the
> > client code, right?
> The current code inits the chan->sg at probe time (when driver is
> loader) and not mount time, and it is currently embedded in the chan
> struct, so that would need allocating at mount time (p9_client_create ;
> either resizing if required or not sharing) but it doesn't sound too
> intrusive yes.
> 
> I don't see more adherenences to VIRTQUEUE_NUM that would hurt trying.

Ok, then I will look into changing this when I hopefully have some time in few 
weeks.

> > > On the 9p side itself, unrelated to virtio, we don't want to make it
> > > *too* big as the client code doesn't use any scatter-gather and will
> > > want to allocate upfront contiguous buffers of the size that got
> > > negotiated -- that can get ugly quite fast, but we can leave it up to
> > > users to decide.
> > 
> > With ugly you just mean that it's occupying this memory for good as long
> > as
> > the driver is loaded, or is there some runtime performance penalty as well
> > to be aware of?
> 
> The main problem is memory fragmentation, see /proc/buddyinfo on various
> systems.
> After a fresh boot memory is quite clean and there is no problem
> allocating 2MB contiguous buffers, but after a while depending on the
> workload it can be hard to even allocate large buffers.
> I've had that problem at work in the past with a RDMA driver that wanted
> to allocate 256KB and could get that to fail quite reliably with our
> workload, so it really depends on what the client does.
> 
> In the 9p case, the memory used to be allocated for good and per client
> (= mountpoint), so if you had 15 9p mounts that could do e.g. 32
> requests in parallel with 1MB buffers you could lock 500MB of idling
> ram. I changed that to a dedicated slab a while ago, so that should no
> longer be so much of a problem -- the slab will keep the buffers around
> as well if used frequently so the performance hit wasn't bad even for
> larger msizes

Ah ok, good to know.

BTW qemu now handles multiple filesystems below one 9p share correctly by 
(optionally) remapping inode numbers from host side -> guest side 
appropriately to prevent potential file ID collisions. This might reduce the 
need to have a large amount of 9p mount points on guest side.

For instance I am running entire guest systems entirely on one 9p mount point 
as root fs that is. The guest system is divided into multiple filesystems on 
host side (e.g. multiple zfs datasets), not on guest side.

> > > One of my very-long-term goal would be to tend to that, if someone has
> > > cycles to work on it I'd gladly review any patch in that area.
> > > A possible implementation path would be to have transport define
> > > themselves if they support it or not and handle it accordingly until all
> > > transports migrated, so one wouldn't need to care about e.g. rdma or xen
> > > if you don't have hardware to test in the short term.
> > 
> > Sounds like something that Greg suggested before for a slightly different,
> > even though related issue: right now the default 'msize' on Linux client
> > side is 8k, which really hurts performance wise as virtually all 9p
> > messages have to be split into a huge number of request and response
> > messages. OTOH you don't want to set this default value too high. So Greg
> > noted that virtio could suggest a default msize, i.e. a value that would
> > suit host's storage hardware appropriately.
> 
> We can definitely increase the default, for all transports in my
> opinion.
> As a first step, 64 or 128k?

Just to throw some numbers first; when linearly reading a 12 GB file on guest 
(i.e. "time cat test.dat > /dev/null") on a test machine, these are the 
results that I get (cache=mmap):

msize=16k: 2min7s (95 MB/s)
msize=64k: 17s (706 MB/s)
msize=128k: 12s (1000 MB/s)
msize=256k: 8s (1500 MB/s)
msize=512k: 6.5s (1846 MB/s)

Personally I would raise the default msize value at least to 128k.

> > > The next best thing would be David's netfs helpers and sending
> > > concurrent requests if you use cache, but that's not merged yet either
> > > so it'll be a few cycles as well.
> > 
> > So right now the Linux client is always just handling one request at a
> > time; it sends a 9p request and waits for its response before processing
> > the next request?
> 
> Requests are handled concurrently just fine - if you have multiple
> processes all doing their things it will all go out in parallel.
> 
> The bottleneck people generally complain about (and where things hurt)
> is if you have a single process reading then there is currently no
> readahead as far as I know, so reads are really sent one at a time,
> waiting for reply and sending next.

So that also means if you are running a multi-threaded app (in one process) on 
guest side, then none of its I/O requests are handled in parallel right now. 
It would be desirable to have parallel requests for multi-threaded apps as 
well.

Personally I don't find raw I/O the worst performance issue right now. As you 
can see from the numbers above, if 'msize' is raised and I/O being performed 
with large chunk sizes (e.g. 'cat' automatically uses a chunk size according 
to the iounit advertised by stat) then the I/O results are okay.

What hurts IMO the most in practice is the sluggish behaviour regarding 
dentries ATM. The following is with cache=mmap (on guest side):

$ time ls /etc/ > /dev/null
real    0m0.091s
user    0m0.000s
sys     0m0.044s
$ time ls -l /etc/ > /dev/null
real    0m0.259s
user    0m0.008s
sys     0m0.016s
$ ls -l /etc/ | wc -l
113
$

With cache=loose there is some improvement; on the first "ls" run (when its 
not in the dentry cache I assume) the results are similar. The subsequent runs 
then improve to around 50ms for "ls" and around 70ms for "ls -l". But that's 
still far from numbers I would expect.

Keep in mind, even when you just open() & read() a file, then directory 
components have to be walked for checking ownership and permissions. I have 
seen huge slowdowns in deep directory structures for that reason.

Best regards,
Christian Schoenebeck


