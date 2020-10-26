Date: Mon, 26 Oct 2020 17:30:30 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201026173030.GE152260@work-vm>
References: <20201023165812.36028-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023165812.36028-1-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 0/5] virtiofsd xattr name mappings
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, dinechin@redhat.com, virtio-fs@redhat.com

* Dr. David Alan Gilbert (git) (dgilbert@redhat.com) wrote:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> 
> This is the 4th cut of an xattr name mapping option for virtiofsd.
> It allows the user of virtiofsd to define a fairly flexible mapping
> from the view of the xattr names the host fs has and the ones that the
> guest sees.
> 
>   The hope is this allows things like:
>     a) Different selinux attributes on host/guest
>     b) separation of trusted. attributes that clash on overlayfs
>     c) support for privileged xattr's in guests running with an
>        unprivileged virtiofsd.
> 
> There's no apparent standard for this kind of mapping, so I made
> it flexible by specifying a mapping rule in the option.
> 
> Prefix's can be added (selectively or globally), xattr's can be
> dropped in either direction or passed through.
> 
> v4
>   cleanups from Stefan and Vivek's reviews
> 
> Dave

Queued

> 
> 
> Dr. David Alan Gilbert (5):
>   tools/virtiofsd: xattr name mappings: Add option
>   tools/virtiofsd: xattr name mappings: Map client xattr names
>   tools/virtiofsd: xattr name mappings: Map server xattr names
>   tools/virtiofsd: xattr name mapping examples
>   tools/virtiofsd: xattr name mappings: Simple 'map'
> 
>  docs/tools/virtiofsd.rst         | 161 +++++++++++
>  tools/virtiofsd/passthrough_ll.c | 474 ++++++++++++++++++++++++++++++-
>  2 files changed, 632 insertions(+), 3 deletions(-)
> 
> -- 
> 2.28.0
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

