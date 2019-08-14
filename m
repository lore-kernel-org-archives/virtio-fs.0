Date: Wed, 14 Aug 2019 13:57:02 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190814125702.GH2920@work-vm>
References: <20190814022751.116741-1-tao.peng@linux.alibaba.com>
	<20190814123618.GA23970@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814123618.GA23970@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: simplify setup_remount_slave
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, Peng Tao <tao.peng@linux.alibaba.com>

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Wed, Aug 14, 2019 at 10:27:51AM +0800, Peng Tao wrote:
> > We can just use MS_REC to propagate MS_SLAVE. This would also allow us
> > to close a race window between reading proc mountinfo and calling
> > mount(MS_SLAVE) for each entry, vs. others umounting the mount point in
> > parallel.
> > 
> > Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> > ---
> >  contrib/virtiofsd/passthrough_ll.c | 53 ++----------------------------
> >  1 file changed, 3 insertions(+), 50 deletions(-)
> 
> Let's try it!
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

OK thanks, merged in my local world


> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

