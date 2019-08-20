References: <20190819160426.GB2625@stefanha-x1.localdomain>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D5B3DDC.9070204@huawei.com>
Date: Tue, 20 Aug 2019 08:25:00 +0800
MIME-Version: 1.0
In-Reply-To: <20190819160426.GB2625@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [ANNOUNCE] virtio-fs v0.3 release
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com
Cc: qemu-devel@nongnu.org, kata-dev@lists.katacontainers.io

A big step for virtio-fs!

Jun

On 2019/8/20 0:04, Stefan Hajnoczi wrote:
> I am delighted to announce the release of virtio-fs v0.3, a shared file
> system that lets virtual machines access a directory tree on the host.
> This release is based on QEMU 4.1.0 and Linux 5.3-rc3.
> 
> For more information about virtio-fs: https://virtio-fs.gitlab.io/
> 
> This is a development release aimed at early adopters of virtio-fs.  Work is
> being done to upstream the code into Linux and QEMU.  We expect to stop
> publishing virtio-fs releases once the code has been merged by these upstream
> projects.
> 
> Where to get it:
> 
>   https://gitlab.com/virtio-fs/linux/-/tags/virtio-fs-v0.3
>   https://gitlab.com/virtio-fs/qemu/-/tags/virtio-fs-v0.3
> 
> Changes:
> 
>  * Please note that the mount syntax has changed to:
> 
>      # mount -t virtio_fs myfs /mnt -o ...
> 
>    The old syntax was "mount -t virtio_fs none /mnt -o tag=myfs,...".
> 
>  * virtiofsd --fd=FDNUM takes a listen socket file descriptor number.  File
>    descriptor passing is an alternative way to manage the vhost-user UNIX
>    domain socket.  The parent process no longer needs to wait for virtiofsd to
>    create the listen socket before spawning the VM.
> 
>  * virtiofsd --syslog logs to syslog(2) instead of stderr.  Useful for unifying
>    logging and when the virtiofsd process is not being supervised.
> 
>  * virtiofsd --thread-pool-size=NUM sets the maximum number of worker threads
>    for FUSE request processing.  This can be used to control the host queue
>    depth.  The default is 64.
> 
>  * Performance improvements and bug fixes.
> 
> Note for Kata Containers: the new kernel is not compatible with existing
> Kata Containers releases due to the mount syntax change.  To try it out,
> please apply the following kata-runtime patch:
> 
>   https://gitlab.com/virtio-fs/runtime/commit/a2e44de817e438c02a495cf258039774527e3178
> 
> Kata Containers patches for virtio-fs v0.3 are under development and will be
> submitted to Kata soon.
> 
> Thanks to the following people for contributing code and to many more
> for helping the virtio-fs effort:
> 
> Dr. David Alan Gilbert <dgilbert@redhat.com>
> Eric Ren <renzhen@linux.alibaba.com>
> Eryu Guan <eguan@linux.alibaba.com>
> Ganesh Maharaj Mahalingam <ganesh.mahalingam@intel.com>
> Jiufei Xue <jiufei.xue@linux.alibaba.com>
> Liu Bo <bo.liu@linux.alibaba.com>
> Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> Miklos Szeredi <mszeredi@redhat.com>
> Peng Tao <tao.peng@linux.alibaba.com>
> piaojun <piaojun@huawei.com>
> Sebastien Boeuf <sebastien.boeuf@intel.com>
> Stefan Hajnoczi <stefanha@redhat.com>
> Vivek Goyal <vgoyal@redhat.com>
> Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> 
> 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
> 

