Date: Mon, 21 Sep 2020 15:08:03 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <20200921140803.GN1942072@redhat.com>
References: <20200918213436.GA3520@redhat.com> <20200921085019.GB3221@work-vm>
	<20200921133516.GA13362@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200921133516.GA13362@redhat.com>
Subject: Re: [Virtio-fs] tools/virtiofs: Multi threading seems to hurt
	performance
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Mon, Sep 21, 2020 at 09:35:16AM -0400, Vivek Goyal wrote:
> On Mon, Sep 21, 2020 at 09:50:19AM +0100, Dr. David Alan Gilbert wrote:
> > * Vivek Goyal (vgoyal@redhat.com) wrote:
> > > Hi All,
> > > 
> > > virtiofsd default thread pool size is 64. To me it feels that in most of
> > > the cases thread pool size 1 performs better than thread pool size 64.
> > > 
> > > I ran virtiofs-tests.
> > > 
> > > https://github.com/rhvgoyal/virtiofs-tests
> > > 
> > > And here are the comparision results. To me it seems that by default
> > > we should switch to 1 thread (Till we can figure out how to make
> > > multi thread performance better even when single process is doing
> > > I/O in client).
> > > 
> > > I am especially more interested in getting performance better for
> > > single process in client. If that suffers, then it is pretty bad.
> > > 
> > > Especially look at randread, randwrite, seqwrite performance. seqread
> > > seems pretty good anyway.
> > > 
> > > If I don't run who test suite and just ran randread-psync job,
> > > my throughput jumps from around 40MB/s to 60MB/s. That's a huge
> > > jump I would say.
> > > 
> > > Thoughts?
> > 
> > What's your host setup; how many cores has the host got and how many did
> > you give the guest?
> 
> Got 2 processors on host with 16 cores in each processor. With
> hyperthreading enabled, it makes 32 logical cores on each processor and
> that makes 64 logical cores on host.
> 
> I have given 32 to guest.

FWIW, I'd be inclined to disable hyperthreading in the BIOS for one
test to validate whether it is impacting performance results seen.
Hyperthreads are weak compared to a real CPU, and could result in
misleading data even if you are limiting your guest to 1/2 the host
logical CPUs.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

