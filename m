Date: Thu, 5 Dec 2019 10:41:07 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20191205104107.GD2824@work-vm>
References: <1575536486-24134-1-git-send-email-catherine.hecx@gmail.com>
	<3d26d626-de27-214b-2093-1dd850b632b6@linux.alibaba.com>
	<CAEn6zmGOUdukP-VsQ_jNipMdqganz5=-1M=wLZ430qOp2UZxGQ@mail.gmail.com>
	<dae2e70f-099d-bcfc-d3b4-8fb1b9491955@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dae2e70f-099d-bcfc-d3b4-8fb1b9491955@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: fix double
 fuse_mbuf_iter_advance when do_removemapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Peng Tao <tao.peng@linux.alibaba.com>
Cc: virtio-fs@redhat.com, Catherine Ho <catherine.hecx@gmail.com>

* Peng Tao (tao.peng@linux.alibaba.com) wrote:
> 
> 
> On 2019/12/5 17:34, Catherine Ho wrote:
> > Hi Peng
> > 
> > On Thu, 5 Dec 2019 at 17:19, Peng Tao <tao.peng@linux.alibaba.com> wrote:
> > > 
> > > On 2019/12/5 17:01, Catherine Ho wrote:
> > > > Commit 8e92b1fc98f7 ("DAX: virtiofsd: make FUSE_REMOVEMAPPING support
> > > > multiple entries") forgot to remove one fuse_mbuf_iter_advance in
> > > > do_removemapping.
> > > No, we do need to advance twice. One for fuse_removemapping_in, another
> > > for an array of fuse_removemapping_one.
> > > 
> > But seems it advances for 3 times. What I mean is the 2nd advance of *one*
> > is pointless.
> > Please see [1] [2]
> > [1]https://gitlab.com/virtio-fs/qemu/blob/virtio-fs-dev/contrib/virtiofsd/fuse_lowlevel.c#L1888
> > [2]https://gitlab.com/virtio-fs/qemu/blob/virtio-fs-dev/contrib/virtiofsd/fuse_lowlevel.c#L1896
> > 
> oops, that does look like a merge hunk. I don't have it in my local branch.
> After pulling the latest code I can see it too. And there was a branch reset
> at some point.
> 
> From https://gitlab.com/virtio-fs/qemu
>  + 42db960...5a356e6 virtio-fs-dev -> virtiofs/virtio-fs-dev  (forced
> update)
> 
> Now your patch looks good to me. Thanks!

That's probably my screwup sometime during a rebase.

Catherine: Thanks; I'll find the right place to merge your fix in.

Dave

> Cheers,
> Tao
> > Best Regards
> > Catherine
> > > > 
> > > > Without this patch, virtiofsd will report:
> > > > [ID: 00000123] do_removemapping: invalid in, expected 1 * 16, has 60 - 60
> > > > [ID: 00000123]    unique: 232, error: -22 (Invalid argument), outsize: 16
> > > > 
> > > What kernel version are you using? It appears that the remove mapping
> > > request does not container a proper fuse_removemapping_one struct.
> > > 
> > > > Fixes: 8e92b1fc98f7 ("DAX: virtiofsd: make FUSE_REMOVEMAPPING support multiple entries")
> > > > Cc: Peng Tao <tao.peng@linux.alibaba.com>
> > > > Signed-off-by: Catherine Ho <catherine.hecx@gmail.com>
> Reviewed-by: Peng Tao <tao.peng@linux.alibaba.com>
> 
> > > > ---
> > > >    contrib/virtiofsd/fuse_lowlevel.c | 8 --------
> > > >    1 file changed, 8 deletions(-)
> > > > 
> > > > diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
> > > > index bde66c72c3..752e7d97b9 100644
> > > > --- a/contrib/virtiofsd/fuse_lowlevel.c
> > > > +++ b/contrib/virtiofsd/fuse_lowlevel.c
> > > > @@ -1894,14 +1894,6 @@ static void do_removemapping(fuse_req_t req, fuse_ino_t nodeid,
> > > >                return;
> > > >        }
> > > > 
> > > > -     one = fuse_mbuf_iter_advance(iter, sizeof(*one));
> > > > -     if (!one) {
> > > > -             fuse_log(FUSE_LOG_ERR, "do_removemapping: invalid in, expected %d * %ld, has %ld - %ld\n",
> > > > -                      arg->count, sizeof(*one), iter->size, iter->pos);
> > > > -             fuse_reply_err(req, EINVAL);
> > > > -             return;
> > > > -     }
> > > > -
> > > >        if (req->se->op.removemapping)
> > > >                req->se->op.removemapping(req, req->se, nodeid, arg->count, one);
> > > The patch is wrong itself, as `one` is not assigned here.
> > > 
> 
> -- 
> Into something rich and strange.
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

