Date: Mon, 22 Mar 2021 12:47:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210322164704.GD446288@redhat.com>
References: <2148A6EA-09CC-4DD2-8E03-8D51633D4137@apple.com>
	<CAOssrKdGOL3Zqmhz4VGEccWw8N0tp1kP7qooB8gN7JOi5+5gew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOssrKdGOL3Zqmhz4VGEccWw8N0tp1kP7qooB8gN7JOi5+5gew@mail.gmail.com>
Subject: Re: [Virtio-fs] Large memory consumption by virtiofsd,
 suspecting fd's aren't being closed?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Eric Ernst <eric_ernst@apple.com>

On Mon, Mar 22, 2021 at 05:09:32PM +0100, Miklos Szeredi wrote:
> On Mon, Mar 22, 2021 at 6:52 AM Eric Ernst <eric_ernst@apple.com> wrote:
> >
> > Hey ya’ll,
> >
> > One challenge I’ve been looking at is how to setup an appropriate memory cgroup limit for workloads that are leveraging virtiofs (ie, running pods with Kata Containers). I noticed that memory usage of the daemon itself can grow considerably depending on the workload; though much more than I’d expect.
> >
> > I’m running workload that simply runs a build on kernel sources with -j3. In doing this, the source of the linux kernel are shared via virtiofs (no DAX), so as the build goes on, there are a lot of files opened, closed, as well as created. The rss memory of virtiofsd grows into several hundreds of MBs.
> >
> > When taking a look, I’m suspecting that virtiofsd is carrying out the opens, but never actually closing fds. In the guest, I’m seeing fd’s on the order of 10-40 for all the container processes as it runs, whereas I see the number of fds for virtiofsd continually increasing, reaching over 80,000 fds. I’m guessing this isn’t expected?
> 
> The reason could be that guest is keeping a ref on the inodes
> (dcache->dentry->inode) and current implementation of server keeps an
> O_PATH fd open for each inode referenced by the client.
> 
> One way to avoid this is to use the "cache=none" option, which forces
> the client to drop dentries immediately from the cache if not in use.
> This is not desirable if cache is actually in use.
> 
> The memory use of the server should still be limited by the memory use
> of the guest:  if there's memory pressure in the guest kernel, then it
> will clean out caches, which results in the memory use decreasing in
> the server as well.  If the server memory use looks unbounded, that
> might be indicative of too much memory used for dcache in the guest
> (cat /proc/slabinfo | grep ^dentry).     Can you verify?

Hi Miklos,

Apart from above, we identified one more issue on IRC. I asked Eric
to drop caches manually in guest. (echo 3 > /proc/sys/vm/drop_caches)
and while it reduced the fds open it did not seem to free up significant
amount of memory.

So question remains where is that memory. One possibility is that we
have memory allocated for mapping arrays (inode and fd). These arrays
only grow and never shrink. So they can lock down some memory.

But still, lot of lo_inode memory should have been freed when
echo 3 > /proc/sys/vm/drop_caches was done. Why all that did not
show up in virtiofsd RSS usage, that's kind of little confusing.

cache=none is an alternative only if application is not using mmap.
I think even kernel compilation now uses mmap towards the end and
fails with cache=none. 

Thanks
Vivek

