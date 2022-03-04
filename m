Date: Fri, 4 Mar 2022 07:11:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YiIB8XnpQPqktxWG@redhat.com>
References: <20220303171323.580712-1-groug@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303171323.580712-1-groug@kaod.org>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Support FUSE_SYNCFS on
 unannounced submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com

On Thu, Mar 03, 2022 at 06:13:21PM +0100, Greg Kurz wrote:
> This is the current patches I have : one to track submounts
> and the other to call syncfs() on them. Tested on simple
> cases only.
> 
> I won't be able to work on this anymore, so I'm posting for the
> records. Anyone is welcome to pick it up as there won't be a v2
> from my side.

Thanks Greg. Hopefully somebody else will be able to pick it up.

What are TODO items to take this patch series to completion.

Vivek

> 
> Cheers,
> 
> --
> Greg
> 
> Greg Kurz (2):
>   virtiofsd: Track submounts
>   virtiofsd: Support FUSE_SYNCFS on unannounced submounts
> 
>  tools/virtiofsd/passthrough_ll.c | 61 ++++++++++++++++++++++++++++----
>  1 file changed, 55 insertions(+), 6 deletions(-)
> 
> -- 
> 2.34.1
> 
> 

