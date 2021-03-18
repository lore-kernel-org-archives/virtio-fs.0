Date: Thu, 18 Mar 2021 09:56:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210318135600.GA368102@redhat.com>
References: <810089e0-3a09-0d8f-9f8e-be5b3ac70587@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <810089e0-3a09-0d8f-9f8e-be5b3ac70587@redhat.com>
Subject: Re: [Virtio-fs] Question about sg_count_fuse_req() in
	linux/fs/fuse/virtio_fs.c
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Connor Kuehl <ckuehl@redhat.com>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On Wed, Mar 17, 2021 at 01:12:01PM -0500, Connor Kuehl wrote:
> Hi,
> 
> I've been familiarizing myself with the virtiofs guest kernel module and I'm
> trying to better understand how virtiofs maps a FUSE request into
> scattergather lists.
> 
> sg_count_fuse_req() starts knowing that there will be at least one in
> header, as shown here (which makes sense):
> 
>         unsigned int size, total_sgs = 1 /* fuse_in_header */;
> 
> However, I'm confused about this snippet right beneath it:
> 
>         if (args->in_numargs - args->in_pages)
>                 total_sgs += 1;
> 
> What is the significance of the sg that is needed in the cases where this
> branch is taken? I'm not sure what its relationship is with args->in_numargs
> since it will increment total_sgs regardless args->in_numargs is 3, 2, or
> even 1 if args->in_pages is false.

Hi Conor,

I think all the in args are being mapped into a single scatter gather
element and that's why it does not matter whether in_numargs is 3, 2 or 1.
They will be mapped in a single element.

sg_init_fuse_args()
{
        len = fuse_len_args(numargs - argpages, args);
        if (len)
                sg_init_one(&sg[total_sgs++], argbuf, len);
}

        out_sgs += sg_init_fuse_args(&sg[out_sgs], req,
                                     (struct fuse_arg *)args->in_args,
                                     args->in_numargs, args->in_pages,
                                     req->argbuf, &argbuf_used);

When we are sending some data in some pages, then we set args->in_pages
to true. And in that case, last element of args->in_args[] contains the
total size of bytes in additional pages we are sending and is not part
of in_args being mapped to scatter gather element. That's why this
check.

	if (args->in_numargs - args->in_pages)
		total_sgs += 1;

Not sure when we will have a case where args->in_numargs = 1 and
args->in_pages=true. Do we ever hit that.

Thanks
Vivek

> 
> Especially since the block right below it counts pages if args->in_pages is
> true:
> 
>         if (args->in_pages) {
>                 size = args->in_args[args->in_numargs - 1].size;
>                 total_sgs += sg_count_fuse_pages(ap->descs, ap->num_pages,
>                                                  size);
>         }
> 
> The rest of the routine goes on similarly but for the 'out' components.
> 
> I doubt incrementing 'total_sgs' in the first if-statement I showed above is
> vestigial, I just think my mental model of what is happening here is
> incomplete.
> 
> Any clarification is much appreciated!

> 
> Connor
> 

