Date: Mon, 21 Sep 2020 09:39:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200921133944.GB13362@redhat.com>
References: <20200918213436.GA3520@redhat.com>
	<20200921083923.GA71121@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921083923.GA71121@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] tools/virtiofs: Multi threading seems to hurt
	performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Mon, Sep 21, 2020 at 09:39:23AM +0100, Stefan Hajnoczi wrote:
> On Fri, Sep 18, 2020 at 05:34:36PM -0400, Vivek Goyal wrote:
> > And here are the comparision results. To me it seems that by default
> > we should switch to 1 thread (Till we can figure out how to make
> > multi thread performance better even when single process is doing
> > I/O in client).
> 
> Let's understand the reason before making changes.
> 
> Questions:
>  * Is "1-thread" --thread-pool-size=1?

Yes.

>  * Was DAX enabled?

No.

>  * How does cache=none perform?

I just ran random read workload with cache=none.

cache-none              randread-psync          45(MiB/s)       11k             
cache-none-1-thread     randread-psync          63(MiB/s)       15k

With 1 thread it offers more IOPS.

>  * Does commenting out vu_queue_get_avail_bytes() + fuse_log("%s:
>    Queue %d gave evalue: %zx available: in: %u out: %u\n") in
>    fv_queue_thread help?

Will try that.

>  * How do the kvm_stat vmexit counters compare?

This should be same, isn't it. Changing number of threads serving should
not change number of vmexits?

>  * How does host mpstat -P ALL compare?

Never used mpstat. Will try running it and see if I can get something
meaningful.

>  * How does host perf record -a compare?

Will try it. I feel this might be too big and too verbose to get
something meaningful.

>  * Does the Rust virtiofsd show the same pattern (it doesn't use glib
>    thread pools)?

No idea. Never tried rust implementation of virtiofsd.

But I suepct it has to do with thread pool implementation and possibly
extra cacheline bouncing.

Thanks
Vivek

