Date: Fri, 31 May 2019 12:53:57 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190531195356.wun4rnl6hsogsmgv@US-160370MP2.local>
References: <20190531092403.77976-1-tao.peng@linux.alibaba.com>
	<20190531132228.GA26058@redhat.com>
	<20190531184454.ybk54uodcf5ozxts@US-160370MP2.local>
	<20190531185907.GC26058@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531185907.GC26058@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] fuse: refcount FORGET requests
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, Peng Tao <tao.peng@linux.alibaba.com>

On Fri, May 31, 2019 at 02:59:07PM -0400, Vivek Goyal wrote:
> On Fri, May 31, 2019 at 11:44:55AM -0700, Liu Bo wrote:
> > On Fri, May 31, 2019 at 09:22:28AM -0400, Vivek Goyal wrote:
> > > On Fri, May 31, 2019 at 05:24:03PM +0800, Peng Tao wrote:
> > > > Right now FORGET requests are not tracked and they might be sent
> > > > after DESTROY request.
> > > 
> > > How does that happen?
> > >
> > 
> > A bit more details, it is those FORGETs that remain in HIGHPRI vq,
> > sent before DESTROY but not yet processed by daemon before DESTROY
> > gets back to guest, then they get processed after the 2nd INIT.
> 
> I just posted 3 patches to make sure forget request is not sent after
> destroy. Can you give it a try and see if it solves the problem.
>

Sorry, somehow this can only be reproduced on Peng Tao's setup.

> I also pushed my changes to this branch.
> 
> https://github.com/rhvgoyal/linux/commits/flush-forget
>

The 2nd mount & INIT can only work after vq->fud is released, and

virtio_kill_sb
  fuse_kill_sb_anon
  virtio_fs_free_devs
    #release vq->fud

So it's not necessary to have DESTROY to be the very last one, it only
matters whether we wait for inflight FORGETS before setting vq->fud to
NULL.

Peng's patch seems more fit.

thanks,
-liubo

