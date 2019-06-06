Date: Thu, 6 Jun 2019 17:14:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190606211412.GA13194@redhat.com>
References: <20190531185709.10267-1-vgoyal@redhat.com>
	<20190531185709.10267-4-vgoyal@redhat.com>
	<20190606210645.2o7o53rscennhksl@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606210645.2o7o53rscennhksl@US-160370MP2.local>
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

On Thu, Jun 06, 2019 at 02:06:46PM -0700, Liu Bo wrote:

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
> 
> Looks like #include <linux/delay.h> is also needed in order to pass
> building.

Its already there.

https://gitlab.com/virtio-fs/linux/blob/virtio-fs-dev/fs/fuse/virtio_fs.c#L14

Vivek

