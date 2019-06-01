DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=hyper-sh.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=kIR8EReE+P+KdrGSVidRCyWpWhb4M3agUh68z4oQrlc=;
	b=HkJsVditZfc9CJ2gm7IQtx5HxSHF1TM6hJGiPjJFiDg+hYXyscIAczLudpgDq/vZ36
	3HkPBeT4K9o9U7gkzv2HLDIqWrwk5RIgMI9q1EJKbdWMwaI5LKHJzkWrI6C1Ck86qupI
	uBLg/lu2WujWvhyVqJonysIUd3d7uGGT97DfC1zHkVkKC2hj2EKBwbWApHop8Wk1+yHj
	BB9k7lNA0tCcPKOU6wK+TNYT1xG2x+HLyBGmopgC4oIO1Zm5zdVDoXnVfJL7CX2swZbO
	zzJcotIvvNOld2yIHOMvUJAI0+SUsUcGFxRkfIoi2ETrZeYoeKkkxZVCt1G663HBXVQL
	xSoA==
MIME-Version: 1.0
References: <20190531092403.77976-1-tao.peng@linux.alibaba.com>
	<20190531132228.GA26058@redhat.com>
	<20190531184454.ybk54uodcf5ozxts@US-160370MP2.local>
	<20190531185907.GC26058@redhat.com>
	<20190531195356.wun4rnl6hsogsmgv@US-160370MP2.local>
In-Reply-To: <20190531195356.wun4rnl6hsogsmgv@US-160370MP2.local>
From: Tao Peng <bergwolf@hyper.sh>
Date: Sat, 1 Jun 2019 09:40:27 +0800
Message-ID: <CACGKRzW9BpB_Vhp70y1ksHCdZZaamabhSZ4mLov_WV63C-KquA@mail.gmail.com>
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
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com, Peng Tao <tao.peng@linux.alibaba.com>, Vivek Goyal <vgoyal@redhat.com>

On Sat, Jun 1, 2019 at 3:54 AM Liu Bo <bo.liu@linux.alibaba.com> wrote:
>
> On Fri, May 31, 2019 at 02:59:07PM -0400, Vivek Goyal wrote:
> > On Fri, May 31, 2019 at 11:44:55AM -0700, Liu Bo wrote:
> > > On Fri, May 31, 2019 at 09:22:28AM -0400, Vivek Goyal wrote:
> > > > On Fri, May 31, 2019 at 05:24:03PM +0800, Peng Tao wrote:
> > > > > Right now FORGET requests are not tracked and they might be sent
> > > > > after DESTROY request.
> > > >
> > > > How does that happen?
> > > >
> > >
> > > A bit more details, it is those FORGETs that remain in HIGHPRI vq,
> > > sent before DESTROY but not yet processed by daemon before DESTROY
> > > gets back to guest, then they get processed after the 2nd INIT.
> >
> > I just posted 3 patches to make sure forget request is not sent after
> > destroy. Can you give it a try and see if it solves the problem.
> >
>
> Sorry, somehow this can only be reproduced on Peng Tao's setup.
>
> > I also pushed my changes to this branch.
> >
> > https://github.com/rhvgoyal/linux/commits/flush-forget
Hi Vivek,

I looked at your patchset and I think the main issue is that there is
already fc->num_waiting to track inflight requests. Yet you added
virtio_fs_vq->in_flight to track vq requests and it is only used by
the hiprio vq. You may think that it is only to track forget requests,
but why inventing a specific wheel when there is a general one? The
maintenance APIs for fc->num_waiting are already there and we don't
need to re-implement the busy-waiting logic as is done in
virtio_fs_flush_hiprio_queue(). The generic fuse code uses a waitqueue
for that in fuse_wait_aborted().

And another issue is that now virtiofs tracks FORGET requests while
generic fuse does not. It is better to unify the behavior.

> >
>
> The 2nd mount & INIT can only work after vq->fud is released, and
>
> virtio_kill_sb
>   fuse_kill_sb_anon
>   virtio_fs_free_devs
>     #release vq->fud
>
> So it's not necessary to have DESTROY to be the very last one, it only
> matters whether we wait for inflight FORGETS before setting vq->fud to
> NULL.
Yes, we don't necessarily need to make sure DESTROY is the last
request. We just need to make sure when kill_sb returns, all inflight
requests are cleaned up. And it is exactly what my patch is doing.

Cheers,
Tao
-- 
Into something rich and strange.

