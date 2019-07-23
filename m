Date: Tue, 23 Jul 2019 16:27:21 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190723232720.mxktygnxaafxgzzg@US-160370MP2.local>
References: <20190716174910.GA19673@localhost>
	<20190723185008.GB11628@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723185008.GB11628@redhat.com>
Subject: Re: [Virtio-fs] virtiofsd permission problem to work with KATA on
 older host kernel
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
Cc: virtio-fs@redhat.com

On Tue, Jul 23, 2019 at 02:50:08PM -0400, Vivek Goyal wrote:
> On Wed, Jul 17, 2019 at 01:49:10AM +0800, Eric Ren wrote:
> > Hi,
> > 
> > I'm trying virtio-fs with KATA container on older kernel (3.10) host.
> > I failed to run container as follows:
> > 
> > ```
> > $sudo docker run --it busybox sh
> > standard_init_linux.go:190: exec user process caused "read-only file system"
> > ERRO[0001] init failed                                   error="standard_init_linux.go:190: exec user process caused \"read-only file system\"" name=kata-agent pid=1 source=agent
> > panic: --this line should have never been executed, congratulations--
> > 
> > goroutine 1 [running, locked to thread]:
> > main.init.0()
> > 	/home/admin/rpmbuild/BUILD/go/src/github.com/kata-containers/agent/agent.go:1228 +0x10f
> > ```
> > 
> > After some troubleshooting, I find it's OK to read/write within
> > virtio-fs dir, and no problem happens if no overlayfs in between.
> > 
> > However, it fails with EROFS error when executing binary on overlayfs,
> > which can reproduce as below:
> > 
> > ```
> > $mv hello lowdir/
> > $mkdir uppperdir workdir merged
> > $sudo mount -t overlay overlay -olowerdir=lowdir,upperdir=upperdir,workdir=workdir merged
> > $sudo docker run --name=virtio-fs-1 -v /home/eric/lab/merged:/mnt/ --runtime=kata-runtime -it busybox sh
> > 
> > [hack kata-agent to sleep in deadloop, and login the VM]
> > 
> > /run/kata-containers/shared/containers/833c4dad342ecd55a25d6470faf99b57c1057fe854b2309bd8efc41b26d10627-840ec5db9825b5ac-mnt # ./hello
> > /bin/sh: ./hello: Read-only file system
> > ```
> > 
> > The problem seems that `lowdir` of overlay is readonly, but we relax
> > `open` to use O_RDWR, so they conflict when `execve` syscall to open
> > executable binary.
> > 
> > This test patch fixes this problem for me:
> > ```
> > git diff
> > diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> > index 78716c8aca..eaba3db22c 100644
> > --- a/contrib/virtiofsd/passthrough_ll.c
> > +++ b/contrib/virtiofsd/passthrough_ll.c
> > @@ -1898,7 +1898,17 @@ static void lo_setupmapping(fuse_req_t req, fuse_ino_t ino, uint64_t foffset,
> >                  * TODO: O_RDWR might not be allowed if file is read only or
> >                  * write only. Fix it.
> >                  */
> > -               fd = openat(lo->proc_self_fd, buf, O_RDWR);
> > +               #define RW_MASK 0x3
> > +               fd = openat(lo->proc_self_fd, buf, flags & RW_MASK);
> > ```
> 
> Hi Eric,
> 
> Problem with doing read-only open is that what about following use case.
> 
> - Process A opens a file read-only and maps a page read-only.
> - Process B opens same file read-write and maps a page read-write.
> 
> Now this means that previsouly we setup a mapping read-only and now
> it needs to be upgraded to read-write so that process B does not fail.
> 
> And currently we don't have logic to upgrade an existing mapping.
> 
> I agree that this is a hack and needs to be changed. It breaks overlayfs
> horribly as all the files will be copied up and there will not be any
> page cache sharing between guests for files which are not being modified.
> 

Just FYI, on a older kernel centos 3.10, it's worse than a unnecessary copy-up.

If we'd like to execuate a binary hosted on a overlayfs, 3 steps are done by
order, i.e. 1) lookup, 2) open 3) setupmapping.

On the daemon side, lookup uses open(O_PATH|O_RDONLY), open and setupmapping
uses openat(proc_self_fd...), since openat() finds file from following symlinks
in /proc/self/fd/, on 3.10 these symlinks always point to a file path of lower
layer so that any openat(O_RDWR) would fail with an annoying EROFS.

thanks,
-liubo

> Just that fix is little involved and requires modification in all
> the components (kernel, qemu and virtiofsd).
> 
> I think somebody had posted patches to upgrade mapping from read-only
> to read-write on virtio-fs list. I did not get time to dive into details
> at that time. If you will like to look into it, will help.
> 
> Vivek
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

