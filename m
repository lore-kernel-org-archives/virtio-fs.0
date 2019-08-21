DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to:user-agent;
	bh=oIi1GHUFdymipFlvelj7mlsATXjI3kgLh7fJzjvsheg=;
	b=qFTK1cBatOCayKKFmla3gPaZPVriPrSEDbff8X5OSUmhaBZnpk8ygmbZCBpgCtp9kA
	s3oOIHr0kEgCz6usOXWGA44vJYEB8m83OKgYZiX9DXlfy2DuKcxu4NJj5xspe5tY21Hp
	vmiu6Oi2T+MSOhmsDpe+mrPZYl8KOv6jVYudYiQwMPaB8VEwteJubo04GLWFfzrJPlrz
	DmnFPXkmUXplnQt1qY7L/B3LPyOyi6iyXho5A/ckpyi6faB1gdlGkl9jRWojwRos3dMx
	Y1w1weobd7Hqzz22ZjaJei2EFrBwDtoxasXbEbVt2yrVdZQ9Q8iiIHFtMXmcahqKk9Fq
	QuZQ==
Date: Tue, 20 Aug 2019 23:40:31 -0400
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <20190821034030.loduniymb6wja4qm@gabell>
References: <20190812210455.12540-1-msys.mizuma@gmail.com>
	<20190812210455.12540-4-msys.mizuma@gmail.com>
	<20190820100643.GF9855@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820100643.GF9855@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 3/3] virtio-fs: add tracepoints
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>

On Tue, Aug 20, 2019 at 11:06:43AM +0100, Stefan Hajnoczi wrote:
> On Mon, Aug 12, 2019 at 05:04:55PM -0400, Masayoshi Mizuma wrote:
> > @@ -251,6 +259,11 @@ static void virtio_fs_hiprio_dispatch_work(struct work_struct *work)
> >  		notify = virtqueue_kick_prepare(vq);
> >  		spin_unlock(&fsvq->lock);
> >  
> > +		trace_virtio_fs_hiprio_request_dispatched(
> > +			forget->ih.opcode, forget->ih.unique,
> > +			forget->ih.nodeid, forget->ih.len,
> > +			notify);
> > +
> 
> It is safer to trace the request before placing it in the queue and
> before releasing fsvq->lock.  I'm concerned that a fast device may
> complete the request and invoke virtio_fs_hiprio_done_work() so that
> kfree(req) is called before we've finished tracing it.
> 
> (We cannot rely on virtqueue_notify() because devices may poll the
> virtqueue, so as soon as the request has been added to the virtqueue it
> may be completed.)
> 
> > @@ -914,6 +931,10 @@ static int virtio_fs_enqueue_req(struct virtqueue *vq, struct fuse_req *req)
> >  
> >  	spin_unlock(&fsvq->lock);
> >  
> > +	trace_virtio_fs_request_dispatched(
> > +		req->in.h.opcode, req->in.h.unique,
> > +		req->in.h.nodeid, req->in.h.len, req->flags, notify);
> > +
> >  	if (notify)
> >  		virtqueue_notify(vq);
> 
> Same here, we no longer control the lifetime of req so it's not safe to
> access it after virtqueue_add_sgs() + spin_unlock(&fsvq->lock).

Thank you for your review. I'll move the trace before
spin_unlock(&fsvq->lock).

Thanks!
Masa

