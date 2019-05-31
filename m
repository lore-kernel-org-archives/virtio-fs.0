Date: Fri, 31 May 2019 11:35:04 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190531183503.wgn23m3rg2jqkyge@US-160370MP2.local>
References: <20190531092403.77976-1-tao.peng@linux.alibaba.com>
	<20190531132228.GA26058@redhat.com>
	<20190531173821.q7fkvgeuo3236ieq@US-160370MP2.local>
	<20190531174435.GB26058@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531174435.GB26058@redhat.com>
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

On Fri, May 31, 2019 at 01:44:35PM -0400, Vivek Goyal wrote:
> On Fri, May 31, 2019 at 10:38:22AM -0700, Liu Bo wrote:
> > On Fri, May 31, 2019 at 09:22:28AM -0400, Vivek Goyal wrote:
> > > On Fri, May 31, 2019 at 05:24:03PM +0800, Peng Tao wrote:
> > > > Right now FORGET requests are not tracked and they might be sent
> > > > after DESTROY request.
> > > 
> > > How does that happen?
> > > 
> > > > Normally this is OK, since user space should
> > > > be able to reject them knowing that the file system is already umounted.
> > > > But if the same file system is mounted right again and the file is
> > > > opened again, user space can be confused by the refcount decrement
> > > > carried by the old FORGET requests.
> > > > 
> > > > E.g., it can trigger an assertion in virtiofsd when running xfstests
> > > > generic/129 and generic/130 together:
> > > > 
> > > > unique: 23, opcode: FORGET (2), nodeid: 4, insize: 64, pid: 0
> > > >   forget 4 1 -2
> > > > virtiofsd: contrib/virtiofsd/passthrough_ll.c:1044: unref_inode: Assertion `inode->refcount >= n' failed.
> > > > 
> > > > To avoid confusing user space in such case, refcount FORGET requests so
> > > > that fuse_sb_destroy() waits for all inflight requests before returning.
> > > 
> > > forgets are optional and destroy is supposed to cleanup any pending
> > > state.
> > 
> > Since we've ensured that DESTROY is the last fuse_request sent to userspace
> > daemon, we only need to deal with those FORGET requests sent before DESTROY.
> > 
> > Given that FORGET is sent via HIGHPRI vq, in order to solve the problem, would
> > it make sense to route DESTROY to HIGHPRI vq as well?
> > 
> > Or, we can let lo_init to clear reqs in HIGHPRI vq?
> 
> I am looking at another approach. Given sending forget is optional, I am
> writing a patch to not send forgets after virtio_kill_sb() has been
> called. And also flush any in flight forgets. Something like.
> 
> virtio_kill_sb() {
> 	disconnect fsvq. Do not send any further forgets.
> 	flush in flight and pending forgets;
> 	fuse_kill_sb_anon()
> }
> 
> This should make sure once daemon seems destroy, after that there are
> no more forget requests.

Does it refer to flushing &fsvq->done_work?

If so, flushing inflight only covers those returned FORGETs, doesn't it?

If there are inflight forgets not coming back from daemon, I think we have to
wait for them as well.

thanks,
-liubo

