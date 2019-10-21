DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=03r/9Cb7m0dz39INy4QP2z0kQDNkND9OqZpLu7+5s4A=;
	b=Q+B+d+NZLR+v151wETYlZf6jNjTuXn3iEVv9X/Qq/WaVRp8U1wNea9ikc/QG9BX2wp
	Ix/LBAlKgq6qf4WagB6X/tY3pCZQ8hRPL7iVf1WLP1UMIQlp3igDPxjOJwRK5+RTw97r
	xjlAIDiQF62nuXlSvjlX4no86sxfUm8ksGquY=
MIME-Version: 1.0
References: <20191015174626.11593-1-vgoyal@redhat.com>
	<20191015174626.11593-2-vgoyal@redhat.com>
	<CAJfpegtrFvuBUuQ7B+ynCLVmgZ8zRjbUYZYg+BzG6HDmt5RyXw@mail.gmail.com>
	<20191021115224.GA13573@redhat.com>
In-Reply-To: <20191021115224.GA13573@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 21 Oct 2019 15:58:01 +0200
Message-ID: <CAJfpegvB6gud1Y-rJGD-afx-c02Suagg29RbT8ETDL1C57A1wA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 1/5] virtiofs: Do not end request in
	submission context
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On Mon, Oct 21, 2019 at 1:52 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Mon, Oct 21, 2019 at 10:03:39AM +0200, Miklos Szeredi wrote:
>
> [..]
> > >  static void virtio_fs_hiprio_dispatch_work(struct work_struct *work)
> > > @@ -502,6 +522,7 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
> > >         names[VQ_HIPRIO] = fs->vqs[VQ_HIPRIO].name;
> > >         INIT_WORK(&fs->vqs[VQ_HIPRIO].done_work, virtio_fs_hiprio_done_work);
> > >         INIT_LIST_HEAD(&fs->vqs[VQ_HIPRIO].queued_reqs);
> > > +       INIT_LIST_HEAD(&fs->vqs[VQ_HIPRIO].end_reqs);
> > >         INIT_DELAYED_WORK(&fs->vqs[VQ_HIPRIO].dispatch_work,
> > >                         virtio_fs_hiprio_dispatch_work);
> > >         spin_lock_init(&fs->vqs[VQ_HIPRIO].lock);
> > > @@ -511,8 +532,9 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
> > >                 spin_lock_init(&fs->vqs[i].lock);
> > >                 INIT_WORK(&fs->vqs[i].done_work, virtio_fs_requests_done_work);
> > >                 INIT_DELAYED_WORK(&fs->vqs[i].dispatch_work,
> > > -                                       virtio_fs_dummy_dispatch_work);
> > > +                                 virtio_fs_request_dispatch_work);
> > >                 INIT_LIST_HEAD(&fs->vqs[i].queued_reqs);
> > > +               INIT_LIST_HEAD(&fs->vqs[i].end_reqs);
> > >                 snprintf(fs->vqs[i].name, sizeof(fs->vqs[i].name),
> > >                          "requests.%u", i - VQ_REQUEST);
> > >                 callbacks[i] = virtio_fs_vq_done;
> > > @@ -918,6 +940,7 @@ __releases(fiq->lock)
> > >         struct fuse_conn *fc;
> > >         struct fuse_req *req;
> > >         struct fuse_pqueue *fpq;
> > > +       struct virtio_fs_vq *fsvq;
> > >         int ret;
> > >
> > >         WARN_ON(list_empty(&fiq->pending));
> > > @@ -951,7 +974,8 @@ __releases(fiq->lock)
> > >         smp_mb__after_atomic();
> > >
> > >  retry:
> > > -       ret = virtio_fs_enqueue_req(&fs->vqs[queue_id], req);
> > > +       fsvq = &fs->vqs[queue_id];
> > > +       ret = virtio_fs_enqueue_req(fsvq, req);
> > >         if (ret < 0) {
> > >                 if (ret == -ENOMEM || ret == -ENOSPC) {
> > >                         /* Virtqueue full. Retry submission */
> > > @@ -965,7 +989,13 @@ __releases(fiq->lock)
> > >                 clear_bit(FR_SENT, &req->flags);
> > >                 list_del_init(&req->list);
> > >                 spin_unlock(&fpq->lock);
> > > -               fuse_request_end(fc, req);
> > > +
> > > +               /* Can't end request in submission context. Use a worker */
> > > +               spin_lock(&fsvq->lock);
> > > +               list_add_tail(&req->list, &fsvq->end_reqs);
> > > +               schedule_delayed_work(&fsvq->dispatch_work,
> > > +                                     msecs_to_jiffies(1));
> >
> > What's the reason to delay by one msec?  If this is purely for
> > deadlock avoidance, then a zero delay would work better, no?
>
> Hi Miklos,
>
> I have no good reason to do that. Will change it to zero delay.

Okay, fixed and pushed out to fuse.git#for-next.

Thanks,
Miklos

