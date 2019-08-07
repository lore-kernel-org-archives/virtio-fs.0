Date: Wed, 7 Aug 2019 10:35:10 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190807093510.GF13267@stefanha-x1.localdomain>
References: <20190801165409.20121-1-stefanha@redhat.com>
	<20190801165409.20121-2-stefanha@redhat.com>
	<20190805120231.GL13734@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805120231.GL13734@work-vm>
Subject: Re: [Virtio-fs] [PATCH 1/4] virtiofsd: process requests in a thread
	pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Mon, Aug 05, 2019 at 01:02:31PM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > +        if (se->debug)
> > +                fuse_debug("%s: elem %d: with %d out desc of length %zd"
> > +                           " bad_in_num=%u bad_out_num=%u\n",
> > +                           __func__, elem->index, out_num,
> > +                           out_len, req->bad_in_num, req->bad_out_num);
> 
> Are the debug/logging calls thread safe?

Yes, vsyslog(3) and vfprintf(3) are thread-safe.

Stefan

