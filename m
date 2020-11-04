From: Fotis Xenakis <foxen@windowslive.com>
Date: Wed,  4 Nov 2020 02:42:22 +0200
Message-ID: <AM0PR03MB62920E8F53722876D6FD3D30A6EF0@AM0PR03MB6292.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [qemu-web PATCH] Add virtio-fs in OSv overview blog post
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, thuth@redhat.com

This post briefly goes over the main points of virtio-fs and OSv, a
unikernel running under QEMU/KVM and taking advantage of its virtio-fs
implementation.

Feel free to review, I will be more than happy to address any comments.

Signed-off-by: Fotis Xenakis <foxen@windowslive.com>
---
 _posts/2020-11-04-osv-virtio-fs.md           | 123 +++++++++++++++++++
 screenshots/2020-11-04-unikernel-vs-gpos.svg |   1 +
 2 files changed, 124 insertions(+)
 create mode 100644 _posts/2020-11-04-osv-virtio-fs.md
 create mode 100644 screenshots/2020-11-04-unikernel-vs-gpos.svg

diff --git a/_posts/2020-11-04-osv-virtio-fs.md b/_posts/2020-11-04-osv-virtio-fs.md
new file mode 100644
index 0000000..af5bb0d
--- /dev/null
+++ b/_posts/2020-11-04-osv-virtio-fs.md
@@ -0,0 +1,123 @@
+---
+layout: post
+title:  "Using virtio-fs on a unikernel"
+author: Fotis Xenakis
+date:   2020-11-04 02:00:00 +0200
+categories: [storage, virtio-fs, unikernel, OSv]
+---
+
+This article provides an overview of virtio-fs, a novel way for sharing the host
+file system with guests and OSv, a specialized, light-weight operating system
+(unikernel) for the cloud, as well as how these two fit together.
+
+## virtio-fs
+
+[Virtio-fs](https://virtio-fs.gitlab.io/) is a new host-guest shared filesystem,
+purpose-built for local file system semantics and performance. To that end, it
+takes full advantage of the host's and the guest's colocation on the same
+physical machine, unlike network-based efforts, like virtio-9p.
+
+As the name suggests, virtio-fs builds on virtio for providing an efficient
+transport: it is included in the (currently draft, to become v1.2) virtio
+[specification](https://github.com/oasis-tcs/virtio-spec) as a new device. The
+protocol used by the device is a slightly extended version of
+[FUSE](https://github.com/libfuse/libfuse), providing a solid foundation for
+all file system operations native on Linux. Implementation-wise, on the QEMU
+side, it takes the approach of splitting between the guest interface (handled
+by QEMU) and the host file system interface (the device "backend"). The latter
+is handled by virtiofsd ("virtio-fs daemon"), running as a separate process,
+utilizing the
+[vhost-user](https://www.qemu.org/docs/master/interop/vhost-user.html) protocol
+to communicate with QEMU.
+
+One prominent performance feature of virtio-fs is the DAX (Direct Access)
+window. What is that? It's a shared memory window between the host and the
+guest, exposed as device memory (a PCI BAR) to the second. How is it used? Upon
+request, the host (QEMU) maps file contents to the window for the guest to
+access directly. This bears performance gains due to taking VMEXITs out of the
+read/write data path and bypassing the guest page cache on Linux, while not
+counting against the VM's memory (since it's just device memory, managed on the
+host).
+
+![virtio-fs DAX architecture](https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/-/raw/master/architecture.svg)
+
+Virtio-fs is under active development, with its community focussing on a pair of
+device implementation in QEMU and device driver in Linux. Both components are
+already available upstream in their initial iterations, while upstreaming
+continues further e.g. with DAX window support.
+
+## OSv
+
+[OSv](https://github.com/cloudius-systems/osv) is a
+[unikernel](https://en.wikipedia.org/wiki/Unikernel) (framework). The two
+defining characteristics of a unikernel are:
+
+- **Application-specialized**: a unikernel is an executable machine image,
+  consisting of an application and supporting code (drivers, memory management,
+  runtime etc.) linked together, running in a single address space (typically
+  in guest "kernel mode").
+- **Library OS**: each unikernel only contains the functionality mandated by its
+  application in terms of non-application code, i.e. no unused drivers, or even
+  whole subsystems (e.g. networking, if the application doesn't use the
+  network).
+
+OSv in particular strives for binary compatibility with Linux. What this means
+is that applications built for Linux should run as OSv unikernels without
+requiring modifications or even rebuilding, at least most of the time. Of
+course, not the whole Linux ABI is supported, with system calls like `fork()`
+and relatives missing by design in all unikernels, which lack the notion of a
+process. Despite this limitation, OSv is quite full featured, with full SMP
+support, virtual memory, a virtual file system (and many filesystem
+implementations, including ZFS) as well as a mature networking stack, based of
+off FreeBSD's.
+
+At this point, one is sure to wonder "Why bother with unikernels?". The problem
+they were originally
+[introduced](http://unikernel.org/files/2013-asplos-mirage.pdf) to solve is
+that of bloat in the modern cloud software stack. Running general-purpose
+operating systems as guests, typically for a single application/service, on top
+of a hypervisor which already takes care of isolation and provides a standard
+device model means duplication, as well as loss of efficiency. This is were
+unikernels come in, trying to be just enough to support a single application
+and as light-weight as possible, based on the assumption that they are executing
+inside a VM. Below is an illustration of the comparison between
+general-purpose OS, unikernels and containers (as another approach to the same
+problem, for completeness).
+
+![Unikernels vs GPOS vs containers](/screenshots/2020-11-04-unikernel-vs-gpos.svg)
+
+## OSv, meet virtio-fs
+
+As is apparent e.g. from the container world, it is very common for applications
+running in isolated environments (such as containers, or unikernels even more
+so) to require host file system access. Whereas containers sharing the host
+kernel thus have an obvious, controlled path to the host file system, with
+unikernels this has been more complex: all solutions were somewhat heavyweight,
+requiring a network link or indirection through network protocols. Virtio-fs
+then provided a significantly more attractive route: straight-forward mapping of
+fs operations (via FUSE), reusing the existing virtio transport and decent
+performance without high memory overhead.
+
+The OSv community quickly identified the opportunity and came up with a
+read-only implementation on its side, when executing under QEMU. This emphasized
+being lightweight complexity-wise, while catering to many of its applications'
+requirements (they are stateless, think e.g. serverless). Notably, it includes
+support for the DAX window (even before that's merged in upstream QEMU),
+providing [excellent performance](https://github.com/foxeng/diploma), directly
+rivalling that of its local (non-shared) counterparts such as ZFS and ROFS (an
+OSv-specific read-only file system).
+
+One central point is OSv's support for booting from virtio-fs: this enables
+deploying a modified version or a whole new application **without rebuilding**
+the image, just by adjusting its root file system contents on the host. Last,
+owing to the DAX window practically providing low-overhead access to the host's
+page cache, scalability is also expected to excel, with it being a common
+concern due to the potentially high density of unikernels per host.
+
+## Conclusion
+
+OSv has gained a prominent new feature, powered by virtio-fs and its QEMU
+implementation. This allows efficient, lightweight and performant access to the
+host's file system, thanks to the native virtio transport, usage of the FUSE
+protocol and the DAX window architecture. In turn, it enables use cases like
+rapid unikernel reconfiguration.
diff --git a/screenshots/2020-11-04-unikernel-vs-gpos.svg b/screenshots/2020-11-04-unikernel-vs-gpos.svg
new file mode 100644
index 0000000..010db7e
--- /dev/null
+++ b/screenshots/2020-11-04-unikernel-vs-gpos.svg
@@ -0,0 +1 @@
+<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" width="681px" height="201px" viewBox="-0.5 -0.5 681 201"><defs/><g><rect x="40" y="160" width="160" height="40" fill="#f5f5f5" stroke="#666666" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 158px; height: 1px; padding-top: 180px; margin-left: 41px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #333333; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">Hardware</div></div></div></foreignObject><text x="120" y="184" fill="#333333" font-family="Helvetica" font-size="12px" text-anchor="middle">Hardware</text></switch></g><rect x="40" y="120" width="160" height="40" fill="#dae8fc" stroke="#6c8ebf" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 158px; height: 1px; padding-top: 140px; margin-left: 41px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">Host OS</div></div></div></foreignObject><text x="120" y="144" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">Host OS</text></switch></g><rect x="40" y="80" width="160" height="40" fill="#dae8fc" stroke="#6c8ebf" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 158px; height: 1px; padding-top: 100px; margin-left: 41px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">Hypervisor</div></div></div></foreignObject><text x="120" y="104" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">Hypervisor</text></switch></g><rect x="40" y="40" width="160" height="40" fill="#f8cecc" stroke="#b85450" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 158px; height: 1px; padding-top: 60px; margin-left: 41px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">Guest OS</div></div></div></foreignObject><text x="120" y="64" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">Guest OS</text></switch></g><rect x="40" y="0" width="160" height="40" fill="#f8cecc" stroke="#b85450" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 158px; height: 1px; padding-top: 20px; margin-left: 41px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">Application</div></div></div></foreignObject><text x="120" y="24" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">Application</text></switch></g><rect x="0" y="120" width="40" height="40" fill="#ffffff" stroke="#000000" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 38px; height: 1px; padding-top: 140px; margin-left: 1px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">HKS</div></div></div></foreignObject><text x="20" y="144" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">HKS</text></switch></g><rect x="0" y="80" width="40" height="40" fill="#ffffff" stroke="#000000" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 38px; height: 1px; padding-top: 100px; margin-left: 1px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">HUS</div></div></div></foreignObject><text x="20" y="104" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">HUS</text></switch></g><rect x="0" y="40" width="40" height="40" fill="#ffffff" stroke="#000000" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 38px; height: 1px; padding-top: 60px; margin-left: 1px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">GKS</div></div></div></foreignObject><text x="20" y="64" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">GKS</text></switch></g><rect x="0" y="0" width="40" height="40" fill="#ffffff" stroke="#000000" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 38px; height: 1px; padding-top: 20px; margin-left: 1px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">GUS</div></div></div></foreignObject><text x="20" y="24" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">GUS</text></switch></g><rect x="280" y="160" width="160" height="40" fill="#f5f5f5" stroke="#666666" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 158px; height: 1px; padding-top: 180px; margin-left: 281px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #333333; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">Hardware</div></div></div></foreignObject><text x="360" y="184" fill="#333333" font-family="Helvetica" font-size="12px" text-anchor="middle">Hardware</text></switch></g><rect x="280" y="120" width="160" height="40" fill="#dae8fc" stroke="#6c8ebf" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 158px; height: 1px; padding-top: 140px; margin-left: 281px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">Host OS</div></div></div></foreignObject><text x="360" y="144" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">Host OS</text></switch></g><rect x="280" y="80" width="160" height="40" fill="#dae8fc" stroke="#6c8ebf" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 158px; height: 1px; padding-top: 100px; margin-left: 281px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">Hypervisor</div></div></div></foreignObject><text x="360" y="104" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">Hypervisor</text></switch></g><rect x="280" y="40" width="160" height="40" fill="#f8cecc" stroke="#b85450" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 158px; height: 1px; padding-top: 60px; margin-left: 281px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">Unikernel</div></div></div></foreignObject><text x="360" y="64" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">Unikernel</text></switch></g><rect x="240" y="120" width="40" height="40" fill="#ffffff" stroke="#000000" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 38px; height: 1px; padding-top: 140px; margin-left: 241px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">HKS</div></div></div></foreignObject><text x="260" y="144" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">HKS</text></switch></g><rect x="240" y="80" width="40" height="40" fill="#ffffff" stroke="#000000" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 38px; height: 1px; padding-top: 100px; margin-left: 241px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">HUS</div></div></div></foreignObject><text x="260" y="104" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">HUS</text></switch></g><rect x="240" y="40" width="40" height="40" fill="#ffffff" stroke="#000000" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 38px; height: 1px; padding-top: 60px; margin-left: 241px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">GKS</div></div></div></foreignObject><text x="260" y="64" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">GKS</text></switch></g><rect x="520" y="160" width="160" height="40" fill="#f5f5f5" stroke="#666666" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 158px; height: 1px; padding-top: 180px; margin-left: 521px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #333333; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">Hardware</div></div></div></foreignObject><text x="600" y="184" fill="#333333" font-family="Helvetica" font-size="12px" text-anchor="middle">Hardware</text></switch></g><rect x="520" y="120" width="160" height="40" fill="#dae8fc" stroke="#6c8ebf" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 158px; height: 1px; padding-top: 140px; margin-left: 521px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">Host OS</div></div></div></foreignObject><text x="600" y="144" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">Host OS</text></switch></g><rect x="520" y="80" width="160" height="40" fill="#dae8fc" stroke="#6c8ebf" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 158px; height: 1px; padding-top: 100px; margin-left: 521px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">Container runtime</div></div></div></foreignObject><text x="600" y="104" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">Container runtime</text></switch></g><rect x="520" y="40" width="160" height="40" fill="#fff2cc" stroke="#d6b656" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 158px; height: 1px; padding-top: 60px; margin-left: 521px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">Container</div></div></div></foreignObject><text x="600" y="64" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">Container</text></switch></g><rect x="480" y="120" width="40" height="40" fill="#ffffff" stroke="#000000" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 38px; height: 1px; padding-top: 140px; margin-left: 481px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">HKS</div></div></div></foreignObject><text x="500" y="144" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">HKS</text></switch></g><rect x="480" y="40" width="40" height="80" fill="#ffffff" stroke="#000000" pointer-events="all"/><g transform="translate(-0.5 -0.5)"><switch><foreignObject style="overflow: visible; text-align: left;" pointer-events="none" width="100%" height="100%" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div xmlns="http://www.w3.org/1999/xhtml" style="display: flex; align-items: unsafe center; justify-content: unsafe center; width: 38px; height: 1px; padding-top: 80px; margin-left: 481px;"><div style="box-sizing: border-box; font-size: 0; text-align: center; "><div style="display: inline-block; font-size: 12px; font-family: Helvetica; color: #000000; line-height: 1.2; pointer-events: all; white-space: normal; word-wrap: normal; ">HUS</div></div></div></foreignObject><text x="500" y="84" fill="#000000" font-family="Helvetica" font-size="12px" text-anchor="middle">HUS</text></switch></g></g><switch><g requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"/><a transform="translate(0,-5)" xlink:href="https://desk.draw.io/support/solutions/articles/16000042487" target="_blank"><text text-anchor="middle" font-size="10px" x="50%" y="100%">Viewer does not support full SVG 1.1</text></a></switch></svg>
\ No newline at end of file
-- 
2.29.2


