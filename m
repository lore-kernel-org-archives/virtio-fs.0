References: <AM0PR03MB62920E8F53722876D6FD3D30A6EF0@AM0PR03MB6292.eurprd03.prod.outlook.com>
From: Thomas Huth <thuth@redhat.com>
Message-ID: <d7f5f49c-0cf4-0116-91ac-50bad486e31f@redhat.com>
Date: Wed, 4 Nov 2020 10:47:42 +0100
MIME-Version: 1.0
In-Reply-To: <AM0PR03MB62920E8F53722876D6FD3D30A6EF0@AM0PR03MB6292.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [qemu-web PATCH] Add virtio-fs in OSv overview blog
	post
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Fotis Xenakis <foxen@windowslive.com>, qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com

On 04/11/2020 01.42, Fotis Xenakis wrote:
> This post briefly goes over the main points of virtio-fs and OSv, a
> unikernel running under QEMU/KVM and taking advantage of its virtio-fs
> implementation.
> 
> Feel free to review, I will be more than happy to address any comments.

Thanks, articles for the QEMU blog are always welcome! Some comments below...

> diff --git a/_posts/2020-11-04-osv-virtio-fs.md b/_posts/2020-11-04-osv-virtio-fs.md
> new file mode 100644
> index 0000000..af5bb0d
> --- /dev/null
> +++ b/_posts/2020-11-04-osv-virtio-fs.md
> @@ -0,0 +1,123 @@
> +---
> +layout: post
> +title:  "Using virtio-fs on a unikernel"
> +author: Fotis Xenakis
> +date:   2020-11-04 02:00:00 +0200
> +categories: [storage, virtio-fs, unikernel, OSv]
> +---
> +
> +This article provides an overview of virtio-fs, a novel way for sharing the host
> +file system with guests and OSv, a specialized, light-weight operating system
> +(unikernel) for the cloud, as well as how these two fit together.

I'd maybe add the links to the virtio-fs and OSv homepage in this paragraph
already, since they are mentioned here for the first time.
For links that you want to use multiple times, you can also declare them at
the end of the file, so that you only have to provide the URL one time. See
e.g. this article as an example:

https://gitlab.com/qemu-project/qemu-web/-/blob/master/_posts/2017-11-22-haxm-usage-windows.md#L101

> +## virtio-fs
> +
> +[Virtio-fs](https://virtio-fs.gitlab.io/) is a new host-guest shared filesystem,
> +purpose-built for local file system semantics and performance. To that end, it
> +takes full advantage of the host's and the guest's colocation on the same
> +physical machine, unlike network-based efforts, like virtio-9p.
> +
> +As the name suggests, virtio-fs builds on virtio for providing an efficient
> +transport: it is included in the (currently draft, to become v1.2) virtio
> +[specification](https://github.com/oasis-tcs/virtio-spec) as a new device. The
> +protocol used by the device is a slightly extended version of
> +[FUSE](https://github.com/libfuse/libfuse), providing a solid foundation for
> +all file system operations native on Linux. Implementation-wise, on the QEMU
> +side, it takes the approach of splitting between the guest interface (handled
> +by QEMU) and the host file system interface (the device "backend"). The latter
> +is handled by virtiofsd ("virtio-fs daemon"), running as a separate process,
> +utilizing the
> +[vhost-user](https://www.qemu.org/docs/master/interop/vhost-user.html) protocol
> +to communicate with QEMU.
> +
> +One prominent performance feature of virtio-fs is the DAX (Direct Access)
> +window. What is that? It's a shared memory window between the host and the

I'd rather simply say "This is a shared ..." and scratch the "What is that?"
question.

> +guest, exposed as device memory (a PCI BAR) to the second. How is it used? Upon

I'd rather drop the "How is it used?" question.

> +request, the host (QEMU) maps file contents to the window for the guest to
> +access directly. This bears performance gains due to taking VMEXITs out of the
> +read/write data path and bypassing the guest page cache on Linux, while not
> +counting against the VM's memory (since it's just device memory, managed on the
> +host).
> +
> +![virtio-fs DAX architecture](https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/-/raw/master/architecture.svg)
> +
> +Virtio-fs is under active development, with its community focussing on a pair of
> +device implementation in QEMU and device driver in Linux. Both components are
> +already available upstream in their initial iterations, while upstreaming
> +continues further e.g. with DAX window support.
> +
> +## OSv
> +
> +[OSv](https://github.com/cloudius-systems/osv) is a
> +[unikernel](https://en.wikipedia.org/wiki/Unikernel) (framework). The two
> +defining characteristics of a unikernel are:
> +
> +- **Application-specialized**: a unikernel is an executable machine image,
> +  consisting of an application and supporting code (drivers, memory management,
> +  runtime etc.) linked together, running in a single address space (typically
> +  in guest "kernel mode").
> +- **Library OS**: each unikernel only contains the functionality mandated by its
> +  application in terms of non-application code, i.e. no unused drivers, or even
> +  whole subsystems (e.g. networking, if the application doesn't use the
> +  network).
> +
> +OSv in particular strives for binary compatibility with Linux. What this means

I'd rather say "This means that ..." instead.

> +is that applications built for Linux should run as OSv unikernels without
> +requiring modifications or even rebuilding, at least most of the time.

Sorry for asking ignorant questions: Does that mean that OSv has a dynamic
linker for Linux ELF binaries?

> Of
> +course, not the whole Linux ABI is supported, with system calls like `fork()`
> +and relatives missing by design in all unikernels, which lack the notion of a
> +process. Despite this limitation, OSv is quite full featured, with full SMP
> +support, virtual memory, a virtual file system (and many filesystem
> +implementations, including ZFS) as well as a mature networking stack, based of
> +off FreeBSD's.

maybe rather "based on the FreeBSD sources" or something similar?

> +At this point, one is sure to wonder "Why bother with unikernels?". The problem
> +they were originally
> +[introduced](http://unikernel.org/files/2013-asplos-mirage.pdf) to solve is
> +that of bloat in the modern cloud software stack.

I'm not a native speaker, but I'd maybe rather say something like:
.. to solve is the burden of the bloat of the modern cload software stack ?

> Running general-purpose
> +operating systems as guests, typically for a single application/service, on top
> +of a hypervisor which already takes care of isolation and provides a standard
> +device model means duplication, as well as loss of efficiency. This is were
> +unikernels come in, trying to be just enough to support a single application
> +and as light-weight as possible, based on the assumption that they are executing
> +inside a VM. Below is an illustration of the comparison between
> +general-purpose OS, unikernels and containers (as another approach to the same
> +problem, for completeness).
> +
> +![Unikernels vs GPOS vs containers](/screenshots/2020-11-04-unikernel-vs-gpos.svg)
> +
> +## OSv, meet virtio-fs
> +
> +As is apparent e.g. from the container world, it is very common for applications
> +running in isolated environments (such as containers, or unikernels even more
> +so) to require host file system access. Whereas containers sharing the host
> +kernel thus have an obvious, controlled path to the host file system, with
> +unikernels this has been more complex: all solutions were somewhat heavyweight,
> +requiring a network link or indirection through network protocols. Virtio-fs
> +then provided a significantly more attractive route: straight-forward mapping of
> +fs operations (via FUSE), reusing the existing virtio transport and decent
> +performance without high memory overhead.
> +
> +The OSv community quickly identified the opportunity and came up with a
> +read-only implementation on its side, when executing under QEMU. This emphasized
> +being lightweight complexity-wise, while catering to many of its applications'
> +requirements (they are stateless, think e.g. serverless). Notably, it includes
> +support for the DAX window (even before that's merged in upstream QEMU),
> +providing [excellent performance](https://github.com/foxeng/diploma), directly
> +rivalling that of its local (non-shared) counterparts such as ZFS and ROFS (an
> +OSv-specific read-only file system).
> +
> +One central point is OSv's support for booting from virtio-fs: this enables
> +deploying a modified version or a whole new application **without rebuilding**
> +the image, just by adjusting its root file system contents on the host. Last,
> +owing to the DAX window practically providing low-overhead access to the host's
> +page cache, scalability is also expected to excel, with it being a common
> +concern due to the potentially high density of unikernels per host.

After reading the initial paragraphs of this mail, I was somehow expecting
to see at least a short example / description of how to use virtio-fs with
OSv ... do you maybe at least want to provide a pointer to further
documentation here so that people know where to look next if they want to
try out virtio-fs with OSv?

> +## Conclusion
> +
> +OSv has gained a prominent new feature, powered by virtio-fs and its QEMU
> +implementation. This allows efficient, lightweight and performant access to the
> +host's file system, thanks to the native virtio transport, usage of the FUSE
> +protocol and the DAX window architecture. In turn, it enables use cases like
> +rapid unikernel reconfiguration.

 Thomas

