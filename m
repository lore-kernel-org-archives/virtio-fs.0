Date: Thu, 24 Sep 2020 10:19:58 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200924091958.GC4980@work-vm>
References: <20200916112250.760245-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916112250.760245-1-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: document cache=auto default
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
> From: "Harry G. Coin" <hgcoin@gmail.com>
> 
> The virtiofsd --help output documents the cache=auto default value but
> the man page does not. Fix this.
> 
> Signed-off-by: Harry G. Coin <hgcoin@gmail.com>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Queued

> ---
>  docs/tools/virtiofsd.rst | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
> index e33c81ed41..352a29ce3c 100644
> --- a/docs/tools/virtiofsd.rst
> +++ b/docs/tools/virtiofsd.rst
> @@ -103,6 +103,7 @@ Options
>    forbids the FUSE client from caching to achieve best coherency at the cost of
>    performance.  ``auto`` acts similar to NFS with a 1 second metadata cache
>    timeout.  ``always`` sets a long cache lifetime at the expense of coherency.
> +  The default is ``auto``.
>  
>  Examples
>  --------
> -- 
> 2.26.2
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

