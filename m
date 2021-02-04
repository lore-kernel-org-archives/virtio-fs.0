Date: Thu, 4 Feb 2021 18:14:17 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20210204181417.GN3039@work-vm>
References: <20210204150208.367837-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204150208.367837-1-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v5 0/3] virtiofsd: prevent opening of
 special files (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Daniel Berrange <berrange@redhat.com>, qemu-devel@nongnu.org, P J P <ppandit@redhat.com>, virtio-fs@redhat.com, Alex Xu <alex@alxu.ca>, Laszlo Ersek <lersek@redhat.com>, vgoyal@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> v4:
>  * Patch 1: Return positive errno if openat(2) fails in lo_do_open() [Greg]
>  * Patch 3: Return -fd instead or -errno after lo_inode_open() in lo_do_open() [Greg]
>  * Patch 3: Use De Morgan's Law to simplify the boolean expression in lo_create() [Vivek]
>  * Patch 3: Add missing errno = -truncfd after lo_inode_open() call in lo_setattr
> v3:
>  * Restructure lo_create() to handle externally-created files (we need
>    to allocate an inode for them) [Greg]
>  * Patch 1 & 2 refactor the code so that Patch 3 can implement the CVE fix
> v3:
>  * Protect lo_create() [Greg]
> v2:
>  * Add doc comment clarifying that symlinks are traversed client-side
>    [Daniel]
> 
> A well-behaved FUSE client does not attempt to open special files with
> FUSE_OPEN because they are handled on the client side (e.g. device nodes
> are handled by client-side device drivers).
> 
> The check to prevent virtiofsd from opening special files is missing in
> a few cases, most notably FUSE_OPEN. A malicious client can cause
> virtiofsd to open a device node, potentially allowing the guest to
> escape. This can be exploited by a modified guest device driver. It is
> not exploitable from guest userspace since the guest kernel will handle
> special files inside the guest instead of sending FUSE requests.
> 
> This patch series fixes this issue by introducing the lo_inode_open() function
> to check the file type before opening it. This is a short-term solution because
> it does not prevent a compromised virtiofsd process from opening device nodes
> on the host.
> 
> This issue was diagnosed on public IRC and is therefore already known
> and not embargoed.
> 
> Reported-by: Alex Xu <alex@alxu.ca>
> Fixes: CVE-2020-35517

Queued

> Stefan Hajnoczi (3):
>   virtiofsd: extract lo_do_open() from lo_open()
>   virtiofsd: optionally return inode pointer from lo_do_lookup()
>   virtiofsd: prevent opening of special files (CVE-2020-35517)
> 
>  tools/virtiofsd/passthrough_ll.c | 224 ++++++++++++++++++++-----------
>  1 file changed, 148 insertions(+), 76 deletions(-)
> 
> -- 
> 2.29.2
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

