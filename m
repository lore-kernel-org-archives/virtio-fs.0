Date: Thu, 27 Aug 2020 19:40:13 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200827184013.GG2837@work-vm>
References: <20200727190223.422280-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727190223.422280-1-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 0/3] virtiofsd: allow virtiofsd to run in
	a container
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: vromanso@redhat.com, qemu-devel@nongnu.org, rmohr@redhat.com, virtio-fs@redhat.com, mpatel@redhat.com, vgoyal@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> v2:
>  * Update virtiofsd.rst documentation on sandboxing modes
>  * Change syntax to -o sandbox=namespace|chroot
>  * Add comment explaining that unshare(CLONE_FS) has no visible side-effect
>    while single-threaded
>  * xfstests and pjdfstest pass. Did not run tests on overlayfs because required
>    xattrs do not work without CAP_SYS_ADMIN.
> 
> Mrunal and Dan: This patch series adds a sandboxing mode where virtiofsd relies
> on the container runtime for isolation. It only does
> chroot("path/to/shared-dir"), seccomp, and drops Linux capabilities. Previously
> it created a new mount, pid, and net namespace but cannot do this without
> CAP_SYS_ADMIN when run inside a container. pivot_root("path/to/shared-dir") has
> been replaced with chroot("path/to/shared-dir"), again because CAP_SYS_ADMIN is
> unavailable. The point of the chroot() is to prevent escapes from the shared
> directory during path traversal. Does this ring any alarm bells or does it
> sound sane?
> 
> Container runtimes handle namespace setup and remove privileges needed by
> virtiofsd to perform sandboxing. Luckily the container environment already
> provides most of the sandbox that virtiofsd needs for security.
> 
> Introduce a new "virtiofsd -o sandbox=chroot" option that uses chroot(2)
> instead of namespaces. This option allows virtiofsd to work inside a container.
> 
> Please see the individual patches for details on the changes and security
> implications.
> 
> Given that people are starting to attempt running virtiofsd in containers I
> think this should go into QEMU 5.1.

I've queued 1 and 3; waiting for someone with better knowledge of chroot
to review 2.

Dave

> Stefan Hajnoczi (3):
>   virtiofsd: drop CAP_DAC_READ_SEARCH
>   virtiofsd: add container-friendly -o sandbox=chroot option
>   virtiofsd: probe unshare(CLONE_FS) and print an error
> 
>  tools/virtiofsd/fuse_virtio.c    | 16 +++++++++
>  tools/virtiofsd/helper.c         |  8 +++++
>  tools/virtiofsd/passthrough_ll.c | 58 ++++++++++++++++++++++++++++++--
>  docs/tools/virtiofsd.rst         | 32 ++++++++++++++----
>  4 files changed, 104 insertions(+), 10 deletions(-)
> 
> -- 
> 2.26.2
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

