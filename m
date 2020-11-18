Date: Wed, 18 Nov 2020 15:19:30 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201118201930.GC111728@redhat.com>
References: <20201105194416.GA1384085@redhat.com>
	<20201105195253.GB1384085@redhat.com>
	<D9233684-9B76-468E-A5F1-B35DA3F3C091@intel.com>
	<20201106223524.GG1436035@redhat.com>
	<CAOssrKcJr9a_5EUTU19BTp1UaST64Shh9w0UeR6TXPLqkN7bBw@mail.gmail.com>
	<CAOssrKeyRVSxCCyvPJvjoXgPYd3Dkkwn5fwAzxeyj-h3g8FqqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKeyRVSxCCyvPJvjoXgPYd3Dkkwn5fwAzxeyj-h3g8FqqA@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Use --thread-pool-size=0 to mean
 no thread pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Nov 12, 2020 at 10:57:11AM +0100, Miklos Szeredi wrote:
[..]
> 
> Another performance issue with virtiofs could be due to the strict
> page writeback rules in fuse that are meant to prevent misuse of
> kernel memory by unprivileged processes.   Since virtiofs isn't
> subject to that limitation, these could be relaxed.

Hi Miklos,

I tried this patch with some of the write mmap workloads and it seems
to help. I ran virtiofsd with following options.

$ virtiofsd --socket-path=/tmp/vhostqemu -o source=/mnt//virtiofs-source -o no_posix_lock  -o cache=auto --thread-pool-size=0 --daemonize

Note, these workloads are not doing any fsync after write. So
they are effectively testing how fast one can do cached writes.

NAME                    WORKLOAD                Bandwidth       IOPS
limit-bdi               seqwrite-mmap           201.4mb         50.3k
nolimit-bdi             seqwrite-mmap           253.4mb         63.3k

limit-bdi               seqwrite-mmap-multi     386.7mb         96.6k
nolimit-bdi             seqwrite-mmap-multi     752.2mb         188.0k

limit-bdi               randwrite-mmap          53.5mb          13.3k
nolimit-bdi             randwrite-mmap          60.6mb          15.1k

limit-bdi               randwrite-mmap-multi    206.3mb         51.5k
nolimit-bdi             randwrite-mmap-multi    255.5mb         63.8k

seqwrite-mmap-multi seems to see the biggest jump.

So it might be a good idea to apply this patch.

> 
> Attaching a patch that does one half of this.  The other half is
> getting rid of the page copying, that's a bit more involved, but
> shouldn't be too difficult.  Just need to duplicate the cached
> writeback callbacks for virtiofs and do away with the complex temp
> page stuff.

Aha..., so we don't need all the complexity related to allocating
those temporary pages and then keeping track of writes in rb tree
and waiting for writes to finish etc. And it could be more like
a regular filesystem where lot of this stuff could be taken care
by common code for the case of virtiofs. That will be really nice.
Less code complexity to deal with. Also might provide performance
improvement.

Thanks
Vivek

