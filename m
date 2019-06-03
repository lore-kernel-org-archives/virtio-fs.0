Date: Mon, 3 Jun 2019 09:10:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190603131009.GA18585@redhat.com>
References: <20190531092403.77976-1-tao.peng@linux.alibaba.com>
	<20190531132228.GA26058@redhat.com>
	<20190531184454.ybk54uodcf5ozxts@US-160370MP2.local>
	<20190531185907.GC26058@redhat.com>
	<20190531195356.wun4rnl6hsogsmgv@US-160370MP2.local>
	<CACGKRzW9BpB_Vhp70y1ksHCdZZaamabhSZ4mLov_WV63C-KquA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGKRzW9BpB_Vhp70y1ksHCdZZaamabhSZ4mLov_WV63C-KquA@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH] fuse: refcount FORGET requests
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Tao Peng <bergwolf@hyper.sh>
Cc: virtio-fs@redhat.com, Peng Tao <tao.peng@linux.alibaba.com>

On Sat, Jun 01, 2019 at 09:40:27AM +0800, Tao Peng wrote:
> On Sat, Jun 1, 2019 at 3:54 AM Liu Bo <bo.liu@linux.alibaba.com> wrote:
> >
> > On Fri, May 31, 2019 at 02:59:07PM -0400, Vivek Goyal wrote:
> > > On Fri, May 31, 2019 at 11:44:55AM -0700, Liu Bo wrote:
> > > > On Fri, May 31, 2019 at 09:22:28AM -0400, Vivek Goyal wrote:
> > > > > On Fri, May 31, 2019 at 05:24:03PM +0800, Peng Tao wrote:
> > > > > > Right now FORGET requests are not tracked and they might be sent
> > > > > > after DESTROY request.
> > > > >
> > > > > How does that happen?
> > > > >
> > > >
> > > > A bit more details, it is those FORGETs that remain in HIGHPRI vq,
> > > > sent before DESTROY but not yet processed by daemon before DESTROY
> > > > gets back to guest, then they get processed after the 2nd INIT.
> > >
> > > I just posted 3 patches to make sure forget request is not sent after
> > > destroy. Can you give it a try and see if it solves the problem.
> > >
> >
> > Sorry, somehow this can only be reproduced on Peng Tao's setup.
> >
> > > I also pushed my changes to this branch.
> > >
> > > https://github.com/rhvgoyal/linux/commits/flush-forget
> Hi Vivek,
> 
> I looked at your patchset and I think the main issue is that there is
> already fc->num_waiting to track inflight requests. Yet you added
> virtio_fs_vq->in_flight to track vq requests and it is only used by
> the hiprio vq. You may think that it is only to track forget requests,
> but why inventing a specific wheel when there is a general one? The
> maintenance APIs for fc->num_waiting are already there and we don't
> need to re-implement the busy-waiting logic as is done in
> virtio_fs_flush_hiprio_queue(). The generic fuse code uses a waitqueue
> for that in fuse_wait_aborted().

I did the wait in virtio-fs for two reasons.

- Waiting for FORGET is need of virtio-fs and fuse never waited for
  completion of FORGET requests. So if generic fuse does not care
  about FORGET completion, it makes sense that virtio-fs takes care
  of it.

- FUSE currently aborts existing requests if these are still on 
  internal list and have not been sent to user space. In case of virtio-fs
  FORGET request is handed over to virtio-fs which might keep it on
  internal list (because virtqueue is full) and there is no way to abort
  it. Not that aborting forget is a must. So in that respect also it
  did not gel well with generic fuse logic.

Anyway, I do not have strong opinions on this. Given waiting for FORGET
was virtio-fs requirement and not fuse reuiqrement, I thought it was 
more appropriate that virtio-fs takes care of it.

Vivek

