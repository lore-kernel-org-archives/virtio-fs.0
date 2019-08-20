Date: Tue, 20 Aug 2019 09:09:52 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190820080952.GA2867@work-vm>
References: <20190819160426.GB2625@stefanha-x1.localdomain>
	<335d2ae6-4d06-9fb3-e1f6-fbef8aee946f@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <335d2ae6-4d06-9fb3-e1f6-fbef8aee946f@linux.alibaba.com>
Subject: Re: [Virtio-fs] [kata-dev] [ANNOUNCE] virtio-fs v0.3 release
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Peng Tao <tao.peng@linux.alibaba.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, kata-dev@lists.katacontainers.io

* Peng Tao (tao.peng@linux.alibaba.com) wrote:
> 
> 
> On 2019/8/20 00:04, Stefan Hajnoczi wrote:
> > I am delighted to announce the release of virtio-fs v0.3, a shared file
> > system that lets virtual machines access a directory tree on the host.
> > This release is based on QEMU 4.1.0 and Linux 5.3-rc3.
> > 
> Good news! As virtio-fs is maturing and stabilizing, what's the plan for
> upstreaming both qemu and kernel part of it?

We're working on that.
A few days ago I sent the core qemu code to qemu-devel marked as
experiemental;  Vivek is planning on sending another kernel version out.

Dave

> Cheers,
> Tao
> 
> > For more information about virtio-fs: https://virtio-fs.gitlab.io/
> > 
> > This is a development release aimed at early adopters of virtio-fs.  Work is
> > being done to upstream the code into Linux and QEMU.  We expect to stop
> > publishing virtio-fs releases once the code has been merged by these upstream
> > projects.
> > 
> > Where to get it:
> > 
> >    https://gitlab.com/virtio-fs/linux/-/tags/virtio-fs-v0.3
> >    https://gitlab.com/virtio-fs/qemu/-/tags/virtio-fs-v0.3
> > 
> > Changes:
> > 
> >   * Please note that the mount syntax has changed to:
> > 
> >       # mount -t virtio_fs myfs /mnt -o ...
> > 
> >     The old syntax was "mount -t virtio_fs none /mnt -o tag=myfs,...".
> > 
> >   * virtiofsd --fd=FDNUM takes a listen socket file descriptor number.  File
> >     descriptor passing is an alternative way to manage the vhost-user UNIX
> >     domain socket.  The parent process no longer needs to wait for virtiofsd to
> >     create the listen socket before spawning the VM.
> > 
> >   * virtiofsd --syslog logs to syslog(2) instead of stderr.  Useful for unifying
> >     logging and when the virtiofsd process is not being supervised.
> > 
> >   * virtiofsd --thread-pool-size=NUM sets the maximum number of worker threads
> >     for FUSE request processing.  This can be used to control the host queue
> >     depth.  The default is 64.
> > 
> >   * Performance improvements and bug fixes.
> > 
> > Note for Kata Containers: the new kernel is not compatible with existing
> > Kata Containers releases due to the mount syntax change.  To try it out,
> > please apply the following kata-runtime patch:
> > 
> >    https://gitlab.com/virtio-fs/runtime/commit/a2e44de817e438c02a495cf258039774527e3178
> > 
> > Kata Containers patches for virtio-fs v0.3 are under development and will be
> > submitted to Kata soon.
> > 
> > Thanks to the following people for contributing code and to many more
> > for helping the virtio-fs effort:
> > 
> > Dr. David Alan Gilbert <dgilbert@redhat.com>
> > Eric Ren <renzhen@linux.alibaba.com>
> > Eryu Guan <eguan@linux.alibaba.com>
> > Ganesh Maharaj Mahalingam <ganesh.mahalingam@intel.com>
> > Jiufei Xue <jiufei.xue@linux.alibaba.com>
> > Liu Bo <bo.liu@linux.alibaba.com>
> > Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> > Miklos Szeredi <mszeredi@redhat.com>
> > Peng Tao <tao.peng@linux.alibaba.com>
> > piaojun <piaojun@huawei.com>
> > Sebastien Boeuf <sebastien.boeuf@intel.com>
> > Stefan Hajnoczi <stefanha@redhat.com>
> > Vivek Goyal <vgoyal@redhat.com>
> > Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> > 
> > 
> > _______________________________________________
> > kata-dev mailing list
> > kata-dev@lists.katacontainers.io
> > http://lists.katacontainers.io/cgi-bin/mailman/listinfo/kata-dev
> > 
> 
> -- 
> Into something rich and strange.
> 
> _______________________________________________
> kata-dev mailing list
> kata-dev@lists.katacontainers.io
> http://lists.katacontainers.io/cgi-bin/mailman/listinfo/kata-dev
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

