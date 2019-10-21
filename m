Date: Mon, 21 Oct 2019 09:01:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20191021130143.GB13573@redhat.com>
References: <20191015174626.11593-1-vgoyal@redhat.com>
	<20191015174626.11593-6-vgoyal@redhat.com>
	<CAJfpegvg1ePA7=Fm3499bKsZBv_98j817KCDxOU18j=BdVfHyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvg1ePA7=Fm3499bKsZBv_98j817KCDxOU18j=BdVfHyA@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 5/5] virtiofs: Retry request submission from
 worker context
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On Mon, Oct 21, 2019 at 10:15:18AM +0200, Miklos Szeredi wrote:
[..]
> > @@ -268,13 +272,43 @@ static void virtio_fs_request_dispatch_work(struct work_struct *work)
> >                                                list);
> >                 if (!req) {
> >                         spin_unlock(&fsvq->lock);
> > -                       return;
> > +                       break;
> >                 }
> >
> >                 list_del_init(&req->list);
> >                 spin_unlock(&fsvq->lock);
> >                 fuse_request_end(fc, req);
> >         }
> > +
> > +       /* Dispatch pending requests */
> > +       while (1) {
> > +               spin_lock(&fsvq->lock);
> > +               req = list_first_entry_or_null(&fsvq->queued_reqs,
> > +                                              struct fuse_req, list);
> > +               if (!req) {
> > +                       spin_unlock(&fsvq->lock);
> > +                       return;
> > +               }
> > +               list_del_init(&req->list);
> > +               spin_unlock(&fsvq->lock);
> > +
> > +               ret = virtio_fs_enqueue_req(fsvq, req, true);
> > +               if (ret < 0) {
> > +                       if (ret == -ENOMEM || ret == -ENOSPC) {
> > +                               spin_lock(&fsvq->lock);
> > +                               list_add_tail(&req->list, &fsvq->queued_reqs);
> > +                               schedule_delayed_work(&fsvq->dispatch_work,
> > +                                                     msecs_to_jiffies(1));
> > +                               spin_unlock(&fsvq->lock);
> > +                               return;
> > +                       }
> > +                       req->out.h.error = ret;
> > +                       dec_in_flight_req(fsvq);
> 
> Missing locking.  Fixed.

Good catch. Thanks.

Vivek

