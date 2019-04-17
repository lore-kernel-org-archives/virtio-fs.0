Date: Wed, 17 Apr 2019 15:05:27 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190417140527.GE2839@work-vm>
References: <20190416190858.16833-1-bo.liu@linux.alibaba.com>
	<20190416190858.16833-5-bo.liu@linux.alibaba.com>
	<20190417131848.GC2839@work-vm>
	<CAOssrKc2EfTZyGpKCZjbcpVrO2Osa6h4UNv=kqDnOSBfXMFCcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKc2EfTZyGpKCZjbcpVrO2Osa6h4UNv=kqDnOSBfXMFCcg@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 4/4] virtiofsd: use fallocate(2) instead
 posix_fallocate(3)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs@redhat.com

* Miklos Szeredi (mszeredi@redhat.com) wrote:
> On Wed, Apr 17, 2019 at 3:18 PM Dr. David Alan Gilbert
> <dgilbert@redhat.com> wrote:
> >
> > * Liu Bo (bo.liu@linux.alibaba.com) wrote:
> > > From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> > >
> > > This is because posix_fallocate(3) does not support FALLOC_FL_KEEP_SIZE
> > > and FALLOC_FL_PUNCH_HOLE. Our underlying host filesystem is ext4 and
> > > ext4 supports FALLOC_FL_KEEP_SIZE and FALLOC_FL_PUNCH_HOLE well, so
> > > this change will be ok.
> > >
> > > Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> >
> >   We need to check what 'fuse' expects - is it defined what
> > fallocate features it has, and what the semantics are?
> 
> The patch looks good to me.
> 
> Fuse (the kernel part) supports FALLOC_FL_KEEP_SIZE and
> FALLOC_FL_PUNCH_HOLE, but returns EOPNOTSUPP for any other flag.
> 
> Even if, at a later time, fuse starts supporting additional fallocate
> flags, then the passthrough implementation calling fallocate(2) should
> be fine.

OK, so then I'll take this patch; would it make sense for it to be sent
to upstream fuse?

Dave

> Thanks,
> Miklos
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

