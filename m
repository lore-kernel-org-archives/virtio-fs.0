Date: Fri, 11 Oct 2019 16:36:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20191011203647.GC13861@redhat.com>
References: <7331fd60-10c6-6076-4cf5-f5cce7bc6ef1@jp.fujitsu.com>
	<20191007143444.GA174343@work-vm> <20191009165116.GJ2893@work-vm>
	<27035e4a-bd12-e5d8-30d0-0df45e75457c@jp.fujitsu.com>
	<CAJFHJrr5Esq=cjZNW4qZRABtCCh_vpkFJEQO9kYb=Pg62O+weQ@mail.gmail.com>
	<20191011195935.GB13861@redhat.com>
	<CAJFHJrq6bQo=yvO0tAxH7RWg=U=ftpsePs3c7y-AcE90Wh4afg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJFHJrq6bQo=yvO0tAxH7RWg=U=ftpsePs3c7y-AcE90Wh4afg@mail.gmail.com>
Subject: Re: [Virtio-fs] xfstest results for virtio-fs on aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>

On Sat, Oct 12, 2019 at 05:13:51AM +0900, Chirantan Ekbote wrote:
> On Sat, Oct 12, 2019 at 4:59 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Sat, Oct 12, 2019 at 03:45:01AM +0900, Chirantan Ekbote wrote:
> > > This is unrelated but there's also a nullptr dereference in the driver
> > > if the device advertises more than request queue.  This is problematic
> > > code:
> > >
> > > /* Allocate fuse_dev for hiprio and notification queues */
> > > for (i = 0; i < VQ_REQUEST; i++) {
> > >     struct virtio_fs_vq *fsvq = &fs->vqs[i];
> > >
> > >     fsvq->fud = fuse_dev_alloc();
> > >     if (!fsvq->fud)
> > >         goto err_free_fuse_devs;
> > > }
> > >
> > > ctx.fudptr = (void **)&fs->vqs[VQ_REQUEST].fud;
> > > err = fuse_fill_super_common(sb, &ctx);
> > > if (err < 0)
> > >     goto err_free_fuse_devs;
> > >
> > > fc = fs->vqs[VQ_REQUEST].fud->fc;
> > >
> > > for (i = 0; i < fs->nvqs; i++) {
> > >     struct virtio_fs_vq *fsvq = &fs->vqs[i];
> > >
> > >     if (i == VQ_REQUEST)
> > >         continue; /* already initialized */
> > >     fuse_dev_install(fsvq->fud, fc);
> > > }
> > >
> > > The first loop only initializes fsvq->fud for queues up to VQ_REQUEST
> > > but then the second loop calls fuse_dev_install with fsvq->fud for all
> > > queues up to fs->nvqs.  When fs->nvqs is greater than VQ_REQUEST this
> > > will end up dereferencing an uninitialized pointer.  I think the fix
> > > is to skip calling fuse_dev_alloc for the VQ_REQUEST queue but then
> > > call it for all the other queues up to fs->nvqs.
> >
> > Right now we support only 1 request queue and multi queue support is
> > not there. Planning to add multiqueue support in future releases though.
> >
> 
> Could you elaborate on what is missing for multiqueue support?  For
> reference, this patch was enough to get it working for me:

May be not much is missing. Just that were focussed on first getting a
basic version of virtiofs upstream and then start looking at performance
improvement features.

> 
> @@ -922,7 +990,8 @@ static int virtio_fs_enqueue_req(struct virtqueue
> *vq, struct fuse_req *req)
>  static void virtio_fs_wake_pending_and_unlock(struct fuse_iqueue *fiq)
>  __releases(fiq->waitq.lock)
>  {
> -       unsigned queue_id = VQ_REQUEST; /* TODO multiqueue */
> +       /* unsigned queue_id = VQ_REQUEST; /\* TODO multiqueue *\/ */
> +       unsigned queue_id;
>         struct virtio_fs *fs;
>         struct fuse_conn *fc;
>         struct fuse_req *req;
> @@ -937,6 +1006,7 @@ __releases(fiq->waitq.lock)
>         spin_unlock(&fiq->waitq.lock);
> 
>         fs = fiq->priv;
> +       queue_id = (req->in.h.unique % (fs->nvqs - 1)) + 1;
>         fc = fs->vqs[queue_id].fud->fc;
> 
>         dev_dbg(&fs->vqs[queue_id].vq->vdev->dev,
> 
> 
> This is simply round-robin scheduling but even going from one to two
> queues gives a significant performance improvement (especially because
> crosvm doesn't support shared memory regions yet).

Interesting. I thought virtiofsd is hard coded right now to support
only one queue. Did you modify virtiofsd to support more than one
request queue?

Can you give some concrete numbers. How much performance improvement
do you see with multiqueue. What workload you are using for testing.

Thanks
Vivek

