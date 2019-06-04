Date: Tue, 4 Jun 2019 09:29:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190604132936.GA18863@redhat.com>
References: <20190531185709.10267-1-vgoyal@redhat.com>
	<20190531185709.10267-4-vgoyal@redhat.com>
	<fe5f90d3-0986-5cbb-0f1e-11f3384476ad@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe5f90d3-0986-5cbb-0f1e-11f3384476ad@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH 3/3] virtio-fs: Waiting for pending forget
 requests to finish
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Peng Tao <tao.peng@linux.alibaba.com>
Cc: virtio-fs@redhat.com

On Tue, Jun 04, 2019 at 12:06:40PM +0800, Peng Tao wrote:
[..]
> > +static void virtio_fs_flush_hiprio_queue(struct virtio_fs_vq *fsvq)
> > +{
> > +	struct virtio_fs_forget *forget;
> > +
> > +	WARN_ON(fsvq->in_flight < 0);
> > +
> > +	/* Go through pending forget reuests and free them */
> > +	spin_lock(&fsvq->lock);
> > +	while(1) {
> > +		forget = list_first_entry_or_null(&fsvq->queued_reqs,
> > +					struct virtio_fs_forget, list);
> > +		if (!forget)
> > +			break;
> missing list_del()?

Good catch. Will fix it.

Vivek

