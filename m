Date: Mon, 9 Nov 2020 09:40:49 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201109144049.GC1479853@redhat.com>
References: <20201105194416.GA1384085@redhat.com>
	<20201109101102.GE3024@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109101102.GE3024@work-vm>
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
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, jose.carlos.venegas.munoz@intel.com, qemu-devel@nongnu.org

On Mon, Nov 09, 2020 at 10:11:02AM +0000, Dr. David Alan Gilbert wrote:
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > Right now we create a thread pool and main thread hands over the request
> > to thread in thread pool to process. Number of threads in thread pool
> > can be managed by option --thread-pool-size.
> > 
> > There is a chance that in case of some workloads, we might get better
> > performance if we don't handover the request to a different thread
> > and process in the context of thread receiving the request.
> > 
> > To implement that, redefine the meaning of --thread-pool-size=0 to
> > mean that don't use a thread pool. Instead process the request in
> > the context of thread receiving request from the queue.
> > 
> > I can't think how --thread-pool-size=0 is useful and hence using
> > that. If it is already useful somehow, I could look at defining
> > a new option say "--no-thread-pool".
> > 
> > I think this patch will be used more as a debug help to do comparison
> > when it is more effecient to do not hand over the requests to a
> > thread pool.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> I think this is OK, but you need to fix the style to match qemu rather
> than kernel style.
> (See qemu's scripts/checpatch.pl)

Sure. I just posted V2 of the patch and took care of all the issues
reported by qemu's scripts/checkpatch.pl.

Vivek

