Date: Tue, 25 May 2021 19:49:15 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YK1Gq663KZxQPlVI@work-vm>
References: <20210518213538.693422-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518213538.693422-1-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 0/7] virtiofsd: Few cleanups in
	virtio_send_data_iov()
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
> Hi,
> 
> This is V2 of the patches. Changes since V1 are.
> 
> - Took care of coding style issue.
> - Got rid of label "err" completely in last patch. (Dave, Connor). 
> - Captured Reviewed-by tags from Connor and David.
> 
> Code in virtio_send_data_iov() little twisted and complicated. This
> patch series just tries to simplify it a bit to make it little easier
> to read this piece of code.

Queued

> Thanks
> Vivek
> 
> 
> Vivek Goyal (7):
>   virtiofsd: Check for EINTR in preadv() and retry
>   virtiofsd: Get rid of unreachable code in read
>   virtiofsd: Use iov_discard_front() to skip bytes
>   virtiofsd: get rid of in_sg_left variable
>   virtiofsd: Simplify skip byte logic
>   virtiofsd: Check EOF before short read
>   virtiofsd: Set req->reply_sent right after sending reply
> 
>  tools/virtiofsd/fuse_virtio.c | 81 +++++++++++------------------------
>  1 file changed, 25 insertions(+), 56 deletions(-)
> 
> -- 
> 2.25.4
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

