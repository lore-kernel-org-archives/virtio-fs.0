Date: Wed, 5 Jun 2019 14:39:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190605183913.GB22236@redhat.com>
References: <20190531185709.10267-1-vgoyal@redhat.com>
	<20190531185709.10267-4-vgoyal@redhat.com>
	<20190605182606.mrw4e2qobp2u4kjj@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605182606.mrw4e2qobp2u4kjj@US-160370MP2.local>
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
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com, tao.peng@linux.alibaba.com

On Wed, Jun 05, 2019 at 11:26:07AM -0700, Liu Bo wrote:

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
> > +		kfree(forget);
> > +	}
> > +
> > +	spin_unlock(&fsvq->lock);
> > +
> > +	/* Wait for in flight requests to finish.*/
> > +	while (1) {
> > +		spin_lock(&fsvq->lock);
> > +		if (!fsvq->in_flight) {
> > +			spin_unlock(&fsvq->lock);
> > +			break;
> > +		}
> > +		spin_unlock(&fsvq->lock);
> > +		usleep_range(1000, 2000);
> > +	}
> 
> why not a wait_queue for fsvq->in_flight == 0?

It was much simpler to do busy wait as I am not expecting this wait to
be long. But if this turns out to be issue later, we can switch to
wait queue.

Vivek

