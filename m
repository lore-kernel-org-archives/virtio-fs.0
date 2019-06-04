DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=hyper-sh.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=GJs+2Hlq50YOEnX2mC9RgAQmdu45ndv0PolJlsbAmWE=;
	b=vN1RsYNtz5Z7PxK4cXWErA7nwhJzgxpMS2wt/Z6TnpDaTvulgozA0zjpqWhXQ7NTG7
	KRoNWH51lSlBsXgy/KB2eAhdaWm+HcUqwc/nX90LG8B10jvl3VOeKljoSTpsYoXdGOJ5
	uiEECjxdpDI/VBUU1b1T0wmOFuolLKS7Ctv+8s2W85aQyffq3xXb3aLcVtJChB1d7Ioo
	4/P+adlVSOtHtT0MNsz+ipPzPwhj6xHgBlH9twLNS1ctA0SYUUJfBYwQe5xHVGcxTV8L
	Hk6/819Bc/SGK3kFBf/9Kd8O0bUB+LgMVnBacJguVkEx0ptCSKcXV65EqF5+MNfXdNY6
	euBw==
MIME-Version: 1.0
References: <20190531092403.77976-1-tao.peng@linux.alibaba.com>
	<20190531132228.GA26058@redhat.com>
	<20190531184454.ybk54uodcf5ozxts@US-160370MP2.local>
	<20190531185907.GC26058@redhat.com>
	<20190531195356.wun4rnl6hsogsmgv@US-160370MP2.local>
	<CACGKRzW9BpB_Vhp70y1ksHCdZZaamabhSZ4mLov_WV63C-KquA@mail.gmail.com>
	<20190603131009.GA18585@redhat.com>
In-Reply-To: <20190603131009.GA18585@redhat.com>
From: Tao Peng <bergwolf@hyper.sh>
Date: Tue, 4 Jun 2019 11:21:13 +0800
Message-ID: <CACGKRzUx5Fsk=LRfxk4=Z0kRm4WTUj6gisyUbV_Eu-HS2fE_tg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] fuse: refcount FORGET requests
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs@redhat.com, Peng Tao <tao.peng@linux.alibaba.com>

On Mon, Jun 3, 2019 at 9:10 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Sat, Jun 01, 2019 at 09:40:27AM +0800, Tao Peng wrote:
> > On Sat, Jun 1, 2019 at 3:54 AM Liu Bo <bo.liu@linux.alibaba.com> wrote:
> > >
> > > On Fri, May 31, 2019 at 02:59:07PM -0400, Vivek Goyal wrote:
> > > > On Fri, May 31, 2019 at 11:44:55AM -0700, Liu Bo wrote:
> > > > > On Fri, May 31, 2019 at 09:22:28AM -0400, Vivek Goyal wrote:
> > > > > > On Fri, May 31, 2019 at 05:24:03PM +0800, Peng Tao wrote:
> > > > > > > Right now FORGET requests are not tracked and they might be sent
> > > > > > > after DESTROY request.
> > > > > >
> > > > > > How does that happen?
> > > > > >
> > > > >
> > > > > A bit more details, it is those FORGETs that remain in HIGHPRI vq,
> > > > > sent before DESTROY but not yet processed by daemon before DESTROY
> > > > > gets back to guest, then they get processed after the 2nd INIT.
> > > >
> > > > I just posted 3 patches to make sure forget request is not sent after
> > > > destroy. Can you give it a try and see if it solves the problem.
> > > >
> > >
> > > Sorry, somehow this can only be reproduced on Peng Tao's setup.
> > >
> > > > I also pushed my changes to this branch.
> > > >
> > > > https://github.com/rhvgoyal/linux/commits/flush-forget
> > Hi Vivek,
> >
> > I looked at your patchset and I think the main issue is that there is
> > already fc->num_waiting to track inflight requests. Yet you added
> > virtio_fs_vq->in_flight to track vq requests and it is only used by
> > the hiprio vq. You may think that it is only to track forget requests,
> > but why inventing a specific wheel when there is a general one? The
> > maintenance APIs for fc->num_waiting are already there and we don't
> > need to re-implement the busy-waiting logic as is done in
> > virtio_fs_flush_hiprio_queue(). The generic fuse code uses a waitqueue
> > for that in fuse_wait_aborted().
>
> I did the wait in virtio-fs for two reasons.
>
> - Waiting for FORGET is need of virtio-fs and fuse never waited for
>   completion of FORGET requests. So if generic fuse does not care
>   about FORGET completion, it makes sense that virtio-fs takes care
>   of it.
>
> - FUSE currently aborts existing requests if these are still on
>   internal list and have not been sent to user space. In case of virtio-fs
>   FORGET request is handed over to virtio-fs which might keep it on
>   internal list (because virtqueue is full) and there is no way to abort
>   it. Not that aborting forget is a must. So in that respect also it
>   did not gel well with generic fuse logic.
>
Yeah, this is actually a very good point and my patch is missing it
(the internal hiprio list). I'm fine with using you version as it is
virtio-fs self-contained and the less virtio-fs modifies generic fuse
logic, the less it will be questioned when it comes to go upstream.
I've tested your patchset for more than 10 times and it all passed.

Cheers,
Tao
-- 
Into something rich and strange.

