Date: Mon, 16 Aug 2021 11:29:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YRqEPjzHg9IlifBo@redhat.com>
References: <20210520154654.1791183-1-groug@kaod.org>
	<20210520154654.1791183-6-groug@kaod.org>
	<CAOQ4uxh69ii5Yk-DgFAq+TrrvJ6xCv9s8sKLfo3aBCSWjJvp9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh69ii5Yk-DgFAq+TrrvJ6xCv9s8sKLfo3aBCSWjJvp9Q@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v4 5/5] virtiofs: propagate sync() to file
	server
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel <linux-kernel@vger.kernel.org>, virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Max Reitz <mreitz@redhat.com>, Robert Krawitz <rlk@redhat.com>

On Sun, Aug 15, 2021 at 05:14:06PM +0300, Amir Goldstein wrote:
> Hi Greg,
> 
> Sorry for the late reply, I have some questions about this change...
> 
> On Fri, May 21, 2021 at 9:12 AM Greg Kurz <groug@kaod.org> wrote:
> >
> > Even if POSIX doesn't mandate it, linux users legitimately expect
> > sync() to flush all data and metadata to physical storage when it
> > is located on the same system. This isn't happening with virtiofs
> > though : sync() inside the guest returns right away even though
> > data still needs to be flushed from the host page cache.
> >
> > This is easily demonstrated by doing the following in the guest:
> >
> > $ dd if=/dev/zero of=/mnt/foo bs=1M count=5K ; strace -T -e sync sync
> > 5120+0 records in
> > 5120+0 records out
> > 5368709120 bytes (5.4 GB, 5.0 GiB) copied, 5.22224 s, 1.0 GB/s
> > sync()                                  = 0 <0.024068>
> > +++ exited with 0 +++
> >
> > and start the following in the host when the 'dd' command completes
> > in the guest:
> >
> > $ strace -T -e fsync /usr/bin/sync virtiofs/foo
> > fsync(3)                                = 0 <10.371640>
> > +++ exited with 0 +++
> >
> > There are no good reasons not to honor the expected behavior of
> > sync() actually : it gives an unrealistic impression that virtiofs
> > is super fast and that data has safely landed on HW, which isn't
> > the case obviously.
> >
> > Implement a ->sync_fs() superblock operation that sends a new
> > FUSE_SYNCFS request type for this purpose. Provision a 64-bit
> > placeholder for possible future extensions. Since the file
> > server cannot handle the wait == 0 case, we skip it to avoid a
> > gratuitous roundtrip. Note that this is per-superblock : a
> > FUSE_SYNCFS is send for the root mount and for each submount.
> >
> > Like with FUSE_FSYNC and FUSE_FSYNCDIR, lack of support for
> > FUSE_SYNCFS in the file server is treated as permanent success.
> > This ensures compatibility with older file servers : the client
> > will get the current behavior of sync() not being propagated to
> > the file server.
> 
> I wonder - even if the server does not support SYNCFS or if the kernel
> does not trust the server with SYNCFS, fuse_sync_fs() can wait
> until all pending requests up to this call have been completed, either
> before or after submitting the SYNCFS request. No?

> 
> Does virtiofsd track all requests prior to SYNCFS request to make
> sure that they were executed on the host filesystem before calling
> syncfs() on the host filesystem?

Hi Amir,

I don't think virtiofsd has any such notion. I would think, that
client should make sure all pending writes have completed and
then send SYNCFS request.

Looking at the sync_filesystem(), I am assuming vfs will take care
of flushing out all dirty pages and then call ->sync_fs.

Having said that, I think fuse queues the writeback request internally
and signals completion of writeback to mm(end_page_writeback()). And
that's why fuse_fsync() has notion of waiting for all pending
writes to finish on an inode (fuse_sync_writes()).

So I think you have raised a good point. That is if there are pending
writes at the time of syncfs(), we don't seem to have a notion of
first waiting for all these writes to finish before we send
FUSE_SYNCFS request to server. 

In case of virtiofs, we could probably move away from the notion
of ending writeback immediately. IIUC, this was needed for regular
fuse where we wanted to make sure rouge/malfunctining fuse server
could not affect processes on system which are not dealing with
fuse. But in case of virtiofs, guest is trusting file server. I
had tried to get rid of this for virtiofs but ran into some
other issues which I could not resolve easily at the time and
then I got distracted in other things.

Anyway, irrespective of that, we probably need a way to flush
out all pending writes with fuse and then send FUSE_SYNCFS. (And
lost make sure writes coming after call to fuse_sync_fs(), continue
to be queued and we don't livelock.

BTW, in the context of virtiofs, this probably is problem only with
mmaped writes. otherwise cache=auto and cache=none are basically
writethrough caches. So write is sent to server immediately. So there
is nothing to be written back when syncfs() comes along. But mmaped()
writes are different and even with cache=auto there can be dirty pages.
(cache=none does not support mmap() at all).

> 
> I am not familiar enough with FUSE internals so there may already
> be a mechanism to track/wait for all pending requests?

fuse_sync_writes() does it for inode. I am not aware of anything
which can do it for the whole filesystem (all the inodes).

> 
> >
> > Note that such an operation allows the file server to DoS sync().
> > Since a typical FUSE file server is an untrusted piece of software
> > running in userspace, this is disabled by default.  Only enable it
> > with virtiofs for now since virtiofsd is supposedly trusted by the
> > guest kernel.
> 
> Isn't there already a similar risk of DoS to sync() from the ability of any
> untrusted (or malfunctioning) server to block writes?

I think fuse has some safeguards for this. Fuse signals completion
of writeback immediately so that vfs/mm/fs does not blocking trying
to writeback and if server is not finishing WRITES fast enough, the
there will be enough dirty pages in bdi that it will create back
pressure and block process dirtying pages.

Thanks
Vivek

