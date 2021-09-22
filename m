Date: Wed, 22 Sep 2021 12:00:17 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YUsMwfZI3sQyT/Rj@work-vm>
References: <20210826211937.317558-1-vgoyal@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210826211937.317558-1-vgoyal@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Add capability to block
	xattrs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Vivek Goyal (vgoyal@redhat.com) wrote:
> As of now we have a knob "-o xattr/no_xattr" which either enables
> all xattrs or disables all xattrs.

Hi Vivek,
  Thanks for this.

> We need something more fine grained where we can selectively disable
> only certain xattrs (and not all).
> 
> For example, in some cases we want to disable "security.selinux"
> xattr. This is equivalent to virtiofs not supporting security.selinux
> and guest kernel will fallback to a single label for whole fs
> (virtiofs_t).
> 
> So add an option "-o block_xattr=<list-of-xattrs>" which will allow
> specifying a list of xattrs to block.

This is quite interesting; I'd not noticed you had the exisitng blocking
mechanism, however, as discussed, I think my preference is if this could
be done as a modification of the xattrmap it would avoid another set of
options.

The mapping code already has 'type's of:

  prefix, ok, bad

I think you just need to add a 'reject' type
that produces the error code you need.

Dave

> Vivek Goyal (2):
>   virtiofsd: Add an array to keep track of blocked xattrs
>   virtiofsd: Add option "block_xattr=" to block certain xattrs
> 
>  docs/tools/virtiofsd.rst         |  17 ++++
>  tools/virtiofsd/helper.c         |   3 +
>  tools/virtiofsd/passthrough_ll.c | 166 ++++++++++++++++++++++++++++---
>  3 files changed, 171 insertions(+), 15 deletions(-)
> 
> -- 
> 2.31.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

