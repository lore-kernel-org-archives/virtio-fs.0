Date: Tue, 3 Sep 2019 18:32:31 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190903173231.GV2744@work-vm>
References: <20190827095437.18819-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827095437.18819-1-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 0/4] virtiofsd: implement vhost-user.rst
 "Backend program conventions"
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> This series implements the conventions for vhost-user backend programs
> described in vhost-user.rst:
> 1. Run in the foreground by default.
> 2. Show vhost-user.json capabilities when --print-capabilities is given.
> 3. Ship a vhost-user.json file so the program can be discovered.
> 
> No command-line options or VHostUserBackendCapabilities are defined for the
> 'fs' backend type yet.  Let's until it becomes clear what should be standard
> for all 'fs' backends and what is specific to virtiofsd.

1,3,4 merged; 2 waiting on reivew from someone who understands the json
requirement.

> 
> Stefan Hajnoczi (4):
>   virtiofsd: make -f (foreground) the default
>   virtiofsd: add --print-capabilities option
>   virtiofsd: install virtiofsd in libexec
>   virtiofsd: add vhost-user.json file
> 
>  docs/interop/vhost-user.json                |  4 +++-
>  Makefile                                    |  3 +++
>  contrib/virtiofsd/fuse_lowlevel.h           |  1 +
>  contrib/virtiofsd/helper.c                  |  5 +++++
>  contrib/virtiofsd/passthrough_ll.c          | 12 ++++++++++++
>  .gitignore                                  |  1 +
>  contrib/virtiofsd/50-qemu-virtiofsd.json.in |  5 +++++
>  7 files changed, 30 insertions(+), 1 deletion(-)
>  create mode 100644 contrib/virtiofsd/50-qemu-virtiofsd.json.in
> 
> -- 
> 2.21.0
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

