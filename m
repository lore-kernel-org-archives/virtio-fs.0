Date: Tue, 5 Jan 2021 10:45:54 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210105154554.GC3200@redhat.com>
References: <20201210161126.GA125438@redhat.com>
	<CAOssrKcKaosJo1W+sek0AOA3CdyE+ZUWzx8KPsn=Gz3Nor+_iQ@mail.gmail.com>
	<20201211160603.GD3285@redhat.com> <20201211182956.GF3380@work-vm>
	<20201211192517.GF3285@redhat.com>
	<CAOssrKejTsvg6jZtOFVZ-5iGRmh=RdgfiAre+cbYDQLrrosvJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKejTsvg6jZtOFVZ-5iGRmh=RdgfiAre+cbYDQLrrosvJA@mail.gmail.com>
Subject: Re: [Virtio-fs] Some performance numbers for virtiofs,
	DAX and virtio-9p
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: "Venegas Munoz, Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, Christian Schoenebeck <qemu_oss@crudebyte.com>, QEMU Developers <qemu-devel@nongnu.org>, virtio-fs-list <virtio-fs@redhat.com>

On Tue, Jan 05, 2021 at 04:08:34PM +0100, Miklos Szeredi wrote:
> On Fri, Dec 11, 2020 at 8:25 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Fri, Dec 11, 2020 at 06:29:56PM +0000, Dr. David Alan Gilbert wrote:
> >
> > [..]
> > > > >
> > > > > Could we measure at what point does a large window size actually make
> > > > > performance worse?
> > > >
> > > > Will do. Will run tests with varying window sizes (small to large)
> > > > and see how does it impact performance for same workload with
> > > > same guest memory.
> > >
> > > I wonder how realistic it is though;  it makes some sense if you have a
> > > scenario like a fairly small root filesystem - something tractable;  but
> > > if you have a large FS you're not realistically going to be able to set
> > > the cache size to match it - that's why it's a cache!
> >
> > I think its more about active dataset size and not necessarily total
> > FS size. FS might be big but if application is not accessing all of
> > the in reasonabl small time window, then it does not matter.
> >
> > What worries me most is that cost of reclaim of a dax range seems
> > too high (or keeps the process blocked for long enogh), that it
> > kills the performance. I will need to revisit the reclaim path
> > and see if I can optimize something.
> 
> Can we dynamically increase the dax window size?  Or hot plug
> additional dax ranges on demand?

I don't think we can do that yet. In fact I am skeptical that currently
hotplug of whole virtio-fs device itself might not work.

> 
> That would solve the problem of trying to find the active set size in advance.

Agreed. Being able to grow dax window dynamically or be able to add
a new dax window to existing device dynamically will help.

David, Stefan, WDYT. Is it possible given current code of qemu and
virtio device. Do other virtio device allow similar operations.

Thanks
Vivek

> 
> We'd still need reclaim in order to prevent the window from growing
> indefinitely, but that would always be background reclaim and be done
> after some time of inactivity.
> 
> Thanks,
> Miklos
> 

