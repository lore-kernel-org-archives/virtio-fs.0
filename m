DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1614783059; bh=fQlAUkOuVRvnCmYyJHQnsdaTj+GB9QJFxjaw/02FArU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mLQVegPYkUrZsCdYreGsoOKl4ML/xyscGspDzvsMv6TxhTRUm+Yn/oVexqrCulN1y
	PzhExH/oct667bVljAgDax6tHAEob/qJ7t1H4x07gfGlrDtFSjofdKBxNFgh+ZplgW
	a4de4IN6oND4KPkmKYU1KX8SeJHU77oKNpbHbsg0OUWasF2ph/B3btjRMuOlL7UtwH
	vSLalBvl6wLYcoXDeoHWuveTI2qqmCb+GOxIXtLDkBnTmHB7qRtZlCQaXgJW+yCBf0
	kcpEgBGGM312CV5zCVYACCkj2PCiPPSoqBAkiTXEC01md5077N4GfTEBC4wyiNLfOa
	S919cQuapJUNA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1614783058; bh=fQlAUkOuVRvnCmYyJHQnsdaTj+GB9QJFxjaw/02FArU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pOc5LbuP6Goz5SUDII5yH3Lc2mepSP12ylieddAM9txE/ObglBx8guCJ7Y1kXVnP1
	Jjo40Re+CGfZrXrJocdp3drNNhyHItuhIzpLCzMIk0zQ+P0CrKa48K+l6Hq8+qVGJO
	OuV77YyzkmxAf5tJEfI1GVdChEscu/Jle9ETd4tECM3TEPtz9tNUifwkmX6YkTFU0B
	hB2Ev1GfgvGirYHBceNYfkkrOWdiSet8kvdLMTGtJX5+E38QUwGLMS9RQOHuoDofCJ
	2HZNN/2Vpo8teakgC8YJRQd2zVieMxhbt+xHMxn/oVZwAs0nvB6qF2DVKEoXXYcMCE
	+YYm41XqO5/Fw==
Date: Wed, 3 Mar 2021 23:50:37 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
Message-ID: <YD+iPTKnOlF/HwlV@codewreck.org>
References: <20200918213436.GA3520@redhat.com> <1918692.k70u9Ml6kK@silver>
	<YDmMXCxxOqo1xKgq@odin> <1805660.C9YIKG4Ep7@silver>
MIME-Version: 1.0
In-Reply-To: <1805660.C9YIKG4Ep7@silver>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
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
To: Christian Schoenebeck <qemu_oss@crudebyte.com>
Cc: "cdupontd@redhat.com" <cdupontd@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, qemu-devel@nongnu.org, virtio-fs-list <virtio-fs@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, v9fs-developer@lists.sourceforge.net, "Shinde,
	Archana M" <archana.m.shinde@intel.com>

Christian Schoenebeck wrote on Wed, Mar 03, 2021 at 03:04:21PM +0100:
> > We can definitely increase the default, for all transports in my
> > opinion.
> > As a first step, 64 or 128k?
> 
> Just to throw some numbers first; when linearly reading a 12 GB file on guest 
> (i.e. "time cat test.dat > /dev/null") on a test machine, these are the 
> results that I get (cache=mmap):
> 
> msize=16k: 2min7s (95 MB/s)
> msize=64k: 17s (706 MB/s)
> msize=128k: 12s (1000 MB/s)
> msize=256k: 8s (1500 MB/s)
> msize=512k: 6.5s (1846 MB/s)
> 
> Personally I would raise the default msize value at least to 128k.

Thanks for the numbers.
I'm still a bit worried about too large chunks, let's go with 128k for
now -- I'll send a couple of patches increasing the tcp max/default as
well next week-ish.

> > The bottleneck people generally complain about (and where things hurt)
> > is if you have a single process reading then there is currently no
> > readahead as far as I know, so reads are really sent one at a time,
> > waiting for reply and sending next.
> 
> So that also means if you are running a multi-threaded app (in one process) on 
> guest side, then none of its I/O requests are handled in parallel right now. 
> It would be desirable to have parallel requests for multi-threaded apps as 
> well.

threads are independant there as far as the kernel goes, if multiple
threads issue IO in parallel it will be handled in parallel.
(the exception would be "lightweight threads" which don't spawn actual
OS thread, but in this case the IOs are generally sent asynchronously so
that should work as well)

> Personally I don't find raw I/O the worst performance issue right now. As you 
> can see from the numbers above, if 'msize' is raised and I/O being performed 
> with large chunk sizes (e.g. 'cat' automatically uses a chunk size according 
> to the iounit advertised by stat) then the I/O results are okay.
> 
> What hurts IMO the most in practice is the sluggish behaviour regarding 
> dentries ATM. The following is with cache=mmap (on guest side):
> 
> $ time ls /etc/ > /dev/null
> real    0m0.091s
> user    0m0.000s
> sys     0m0.044s
> $ time ls -l /etc/ > /dev/null
> real    0m0.259s
> user    0m0.008s
> sys     0m0.016s
> $ ls -l /etc/ | wc -l
> 113
> $

Yes, that is slow indeed.. Unfortunately cache=none/mmap means only open
dentries are pinned, so that means a load of requests everytime.

I was going to suggest something like readdirplus or prefetching
directory entries attributes in parallel/background, but since we're not
keeping any entries around we can't even do that in that mode.

> With cache=loose there is some improvement; on the first "ls" run (when its 
> not in the dentry cache I assume) the results are similar. The subsequent runs 
> then improve to around 50ms for "ls" and around 70ms for "ls -l". But that's 
> still far from numbers I would expect.

I'm surprised cached mode is that slow though, that is worth
investigating.
With that time range we are definitely sending more requests to the
server than I would expect for cache=loose, some stat revalidation
perhaps? I thought there wasn't any.

I don't like cache=loose/fscache right now as the reclaim mechanism
doesn't work well as far as I'm aware (I've heard reports of 9p memory
usage growing ad nauseam in these modes), so while it's fine for
short-lived VMs it can't really be used for long periods of time as
is... That's been on my todo for a while too, but unfortunately no time
for that.


Ideally if that gets fixed, it really should be the default with some
sort of cache revalidation like NFS does (if that hasn't changed, inode
stats have a lifetime after which they get revalidated on access, and
directory ctime changes lead to a fresh readdir) ; but we can't really
do that right now if it "leaks".

Some cap to the number of open fids could be appreciable as well
perhaps, to spare server resources and keep internal lists short.

> Keep in mind, even when you just open() & read() a file, then directory 
> components have to be walked for checking ownership and permissions. I have 
> seen huge slowdowns in deep directory structures for that reason.

Yes, each component is walked one at a time. In theory the protocol
allows opening a path with all components specified to a single walk and
letting the server handle intermediate directories check, but the VFS
doesn't allow that.
Using relative paths or openat/fstatat/etc helps but many programs
aren't very smart with that.. Note it's not just a problem with 9p
though, even network filesystems with proper caching have a noticeable
performance cost with deep directory trees.


Anyway, there definitely is room for improvement; if you need ideas I
have plenty but my time is more than limited right now and for the
forseeable future... 9p work is purely on my freetime and there isn't
much at the moment :(

I'll make time as necessary for reviews & tests but that's about as much
as I can promise, sorry and good luck!

-- 
Dominique

