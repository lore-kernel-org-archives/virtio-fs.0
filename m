DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=IMleuJXp1BFCMdO8pZ1Sh8yv+RZboiDdVagdPozQ5ro=;
	b=rVPf3iXZoTd8p7ZHahrvHPzYSd/MUXUnZeEzWnBewZlgSqqXY4fM7Mn1EIRT4f+CKK
	TTKD2pXtnyHXpQE1/05m79f/n6MzvLHklC4bnUfEsV0M9WRQ7+H2IE11fblFD2S19n0A
	5EFPf6uxcJgRoMqu8DuKYBeizu7xU05CP8OvDv0Ck2bkju5FS6LJMqHnAqM4aP1kWjgQ
	/CtbFj3l/dP/o/Ef2MI6JH6lLmnvc7oUtuhka8nHI/bXEGGMqcr0GOkbyaQtx8MrXoN9
	545LRX7cXWlNbTuzy6U14v7UoRCZLiHFyCfwMQ1KZemnltv2T0MYrVXAg7w9g3+K8HhA
	D/qg==
MIME-Version: 1.0
References: <20210520154654.1791183-1-groug@kaod.org>
	<20210520154654.1791183-6-groug@kaod.org>
	<CAOQ4uxh69ii5Yk-DgFAq+TrrvJ6xCv9s8sKLfo3aBCSWjJvp9Q@mail.gmail.com>
	<YRqEPjzHg9IlifBo@redhat.com>
In-Reply-To: <YRqEPjzHg9IlifBo@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 16 Aug 2021 21:57:08 +0300
Message-ID: <CAOQ4uxg+UX6MWRv9JTQDmf6Yf_NyD+pJ438Ds270vGr9YSSPZw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel <linux-kernel@vger.kernel.org>, virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Max Reitz <mreitz@redhat.com>, Robert Krawitz <rlk@redhat.com>

On Mon, Aug 16, 2021 at 6:29 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Sun, Aug 15, 2021 at 05:14:06PM +0300, Amir Goldstein wrote:
> > Hi Greg,
> >
> > Sorry for the late reply, I have some questions about this change...
> >
> > On Fri, May 21, 2021 at 9:12 AM Greg Kurz <groug@kaod.org> wrote:
> > >
> > > Even if POSIX doesn't mandate it, linux users legitimately expect
> > > sync() to flush all data and metadata to physical storage when it
> > > is located on the same system. This isn't happening with virtiofs
> > > though : sync() inside the guest returns right away even though
> > > data still needs to be flushed from the host page cache.
> > >
> > > This is easily demonstrated by doing the following in the guest:
> > >
> > > $ dd if=/dev/zero of=/mnt/foo bs=1M count=5K ; strace -T -e sync sync
> > > 5120+0 records in
> > > 5120+0 records out
> > > 5368709120 bytes (5.4 GB, 5.0 GiB) copied, 5.22224 s, 1.0 GB/s
> > > sync()                                  = 0 <0.024068>
> > > +++ exited with 0 +++
> > >
> > > and start the following in the host when the 'dd' command completes
> > > in the guest:
> > >
> > > $ strace -T -e fsync /usr/bin/sync virtiofs/foo
> > > fsync(3)                                = 0 <10.371640>
> > > +++ exited with 0 +++
> > >
> > > There are no good reasons not to honor the expected behavior of
> > > sync() actually : it gives an unrealistic impression that virtiofs
> > > is super fast and that data has safely landed on HW, which isn't
> > > the case obviously.
> > >
> > > Implement a ->sync_fs() superblock operation that sends a new
> > > FUSE_SYNCFS request type for this purpose. Provision a 64-bit
> > > placeholder for possible future extensions. Since the file
> > > server cannot handle the wait == 0 case, we skip it to avoid a
> > > gratuitous roundtrip. Note that this is per-superblock : a
> > > FUSE_SYNCFS is send for the root mount and for each submount.
> > >
> > > Like with FUSE_FSYNC and FUSE_FSYNCDIR, lack of support for
> > > FUSE_SYNCFS in the file server is treated as permanent success.
> > > This ensures compatibility with older file servers : the client
> > > will get the current behavior of sync() not being propagated to
> > > the file server.
> >
> > I wonder - even if the server does not support SYNCFS or if the kernel
> > does not trust the server with SYNCFS, fuse_sync_fs() can wait
> > until all pending requests up to this call have been completed, either
> > before or after submitting the SYNCFS request. No?
>
> >
> > Does virtiofsd track all requests prior to SYNCFS request to make
> > sure that they were executed on the host filesystem before calling
> > syncfs() on the host filesystem?
>
> Hi Amir,
>
> I don't think virtiofsd has any such notion. I would think, that
> client should make sure all pending writes have completed and
> then send SYNCFS request.
>
> Looking at the sync_filesystem(), I am assuming vfs will take care
> of flushing out all dirty pages and then call ->sync_fs.
>
> Having said that, I think fuse queues the writeback request internally
> and signals completion of writeback to mm(end_page_writeback()). And
> that's why fuse_fsync() has notion of waiting for all pending
> writes to finish on an inode (fuse_sync_writes()).
>
> So I think you have raised a good point. That is if there are pending
> writes at the time of syncfs(), we don't seem to have a notion of
> first waiting for all these writes to finish before we send
> FUSE_SYNCFS request to server.

Maybe, but I was not referring to inode writeback requests.
I had assumed that those were handled correctly.
I was referring to pending metadata requests.

->sync_fs() in local fs also takes care of flushing metadata
(e.g. journal). I assumed that virtiofsd implements FUSE_SYNCFS
request by calling syncfs() on host fs, but it is does that than
there is no guarantee that all metadata requests have reached the
host fs from virtiofs unless client or server take care of waiting
for all pending metadata requests before issuing FUSE_SYNCFS.

But maybe I am missing something.

It might be worth mentioning that I did not find any sync_fs()
commands that request to flush metadata caches on the server in
NFS or SMB protocols either.

Thanks,
Amir.

