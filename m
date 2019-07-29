Date: Mon, 29 Jul 2019 10:25:02 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190729092502.GA2756@work-vm>
References: <20190726083322.13637-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726083322.13637-1-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 0/3] virtiofsd: add FUSE_INIT map_alignment
	field
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> The client must know the server's alignment constraints for FUSE_SETUPMAPPING
> and FUSE_REMOVEMAPPING.  This is necessary because mmap(2)/munmap(2) have
> alignment constraints and the guest may have a different page size from the
> host.  The new FUSE_INIT map_alignment field communicates this information to
> the client.

OK, merged into my local world.

DAve

> Stefan Hajnoczi (3):
>   virtiofsd: sync up fuse.h Linux 5.1 header
>   virtiofsd: add map_alignment to fuse_kernel.h
>   virtiofsd: implement FUSE_INIT map_alignment field
> 
>  contrib/virtiofsd/fuse_kernel.h   | 56 +++++++++++++++++++++----------
>  contrib/virtiofsd/fuse_lowlevel.c |  8 +++++
>  2 files changed, 47 insertions(+), 17 deletions(-)
> 
> -- 
> 2.21.0
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

