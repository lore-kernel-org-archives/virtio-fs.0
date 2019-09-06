Date: Fri, 6 Sep 2019 10:17:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190906141705.GF22083@redhat.com>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<20190905194859.16219-9-vgoyal@redhat.com>
	<20190906105210.GP5900@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906105210.GP5900@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 08/18] virtiofs: Drain all pending requests
 during ->remove time
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: miklos@szeredi.hu, mst@redhat.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org

On Fri, Sep 06, 2019 at 11:52:10AM +0100, Stefan Hajnoczi wrote:
> On Thu, Sep 05, 2019 at 03:48:49PM -0400, Vivek Goyal wrote:
> > +static void virtio_fs_drain_queue(struct virtio_fs_vq *fsvq)
> > +{
> > +	WARN_ON(fsvq->in_flight < 0);
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
> I think all contexts that call this allow sleeping so we could avoid
> usleep here.

usleep_range() is supposed to be used from non-atomic context.

https://github.com/torvalds/linux/blob/master/Documentation/timers/timers-howto.rst

What construct you are thinking of?

Vivek

