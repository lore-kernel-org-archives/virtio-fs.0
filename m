Date: Mon, 29 Jun 2020 09:56:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200629135629.GA269627@redhat.com>
References: <20200629115420.98443-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629115420.98443-1-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 0/3] virtiofsd capability changes and
	addition
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Mon, Jun 29, 2020 at 12:54:17PM +0100, Dr. David Alan Gilbert (git) wrote:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> 
> Hi,
>   This is a set of changes relating to the capability restirctions
> introduced in virtiofsd back in a59feb483b8.
>  
> The first one is a potentially important fix; the missing terminator
> could mean extra capabilities are added based on junk on the stack;
> although that's not been seen in practice.
>  
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> 

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Mounting overlayfs on top of virtiofs now works for me once I
gave CAP_SYS_ADMIN to daemon.

Thanks
Vivek

> v2
>   Pass a copy of the parameter list into setup_capabilities
> 
> Dr. David Alan Gilbert (3):
>   virtiofsd: Terminate capability list
>   virtiofsd: Check capability calls
>   virtiofsd: Allow addition or removal of capabilities
> 
>  docs/tools/virtiofsd.rst         |  5 +++
>  tools/virtiofsd/helper.c         |  2 +
>  tools/virtiofsd/passthrough_ll.c | 71 +++++++++++++++++++++++++++++---
>  3 files changed, 73 insertions(+), 5 deletions(-)
> 
> -- 
> 2.26.2
> 

