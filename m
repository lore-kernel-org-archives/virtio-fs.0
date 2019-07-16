Date: Wed, 17 Jul 2019 01:49:10 +0800
From: Eric Ren <renzhen@linux.alibaba.com>
Message-ID: <20190716174910.GA19673@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] virtiofsd permission problem to work with KATA on older
	host kernel
Reply-To: Eric Ren <renzhen@linux.alibaba.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hi,

I'm trying virtio-fs with KATA container on older kernel (3.10) host.
I failed to run container as follows:

```
$sudo docker run --it busybox sh
standard_init_linux.go:190: exec user process caused "read-only file system"
ERRO[0001] init failed                                   error="standard_init_linux.go:190: exec user process caused \"read-only file system\"" name=kata-agent pid=1 source=agent
panic: --this line should have never been executed, congratulations--

goroutine 1 [running, locked to thread]:
main.init.0()
	/home/admin/rpmbuild/BUILD/go/src/github.com/kata-containers/agent/agent.go:1228 +0x10f
```

After some troubleshooting, I find it's OK to read/write within
virtio-fs dir, and no problem happens if no overlayfs in between.

However, it fails with EROFS error when executing binary on overlayfs,
which can reproduce as below:

```
$mv hello lowdir/
$mkdir uppperdir workdir merged
$sudo mount -t overlay overlay -olowerdir=lowdir,upperdir=upperdir,workdir=workdir merged
$sudo docker run --name=virtio-fs-1 -v /home/eric/lab/merged:/mnt/ --runtime=kata-runtime -it busybox sh

[hack kata-agent to sleep in deadloop, and login the VM]

/run/kata-containers/shared/containers/833c4dad342ecd55a25d6470faf99b57c1057fe854b2309bd8efc41b26d10627-840ec5db9825b5ac-mnt # ./hello
/bin/sh: ./hello: Read-only file system
```

The problem seems that `lowdir` of overlay is readonly, but we relax
`open` to use O_RDWR, so they conflict when `execve` syscall to open
executable binary.

This test patch fixes this problem for me:
```
git diff
diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 78716c8aca..eaba3db22c 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -1898,7 +1898,17 @@ static void lo_setupmapping(fuse_req_t req, fuse_ino_t ino, uint64_t foffset,
                 * TODO: O_RDWR might not be allowed if file is read only or
                 * write only. Fix it.
                 */
-               fd = openat(lo->proc_self_fd, buf, O_RDWR);
+               #define RW_MASK 0x3
+               fd = openat(lo->proc_self_fd, buf, flags & RW_MASK);
```

But, it's intersting why newer host kernel like 4.19 is free of this
problem?

Regards,
Eric

