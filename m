Date: Fri, 31 May 2019 14:59:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190531185907.GC26058@redhat.com>
References: <20190531092403.77976-1-tao.peng@linux.alibaba.com>
	<20190531132228.GA26058@redhat.com>
	<20190531184454.ybk54uodcf5ozxts@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531184454.ybk54uodcf5ozxts@US-160370MP2.local>
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
Cc: virtio-fs@redhat.com, Peng Tao <tao.peng@linux.alibaba.com>

On Fri, May 31, 2019 at 11:44:55AM -0700, Liu Bo wrote:
> On Fri, May 31, 2019 at 09:22:28AM -0400, Vivek Goyal wrote:
> > On Fri, May 31, 2019 at 05:24:03PM +0800, Peng Tao wrote:
> > > Right now FORGET requests are not tracked and they might be sent
> > > after DESTROY request.
> > 
> > How does that happen?
> >
> 
> A bit more details, it is those FORGETs that remain in HIGHPRI vq,
> sent before DESTROY but not yet processed by daemon before DESTROY
> gets back to guest, then they get processed after the 2nd INIT.

I just posted 3 patches to make sure forget request is not sent after
destroy. Can you give it a try and see if it solves the problem.

I also pushed my changes to this branch.

https://github.com/rhvgoyal/linux/commits/flush-forget

Vivek

