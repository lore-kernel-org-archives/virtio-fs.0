Date: Wed, 5 May 2021 12:06:42 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YJJ8Qs3a1tXWPODq@work-vm>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-2-dgilbert@redhat.com>
	<YJFgDGYi93A27ZFa@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJFgDGYi93A27ZFa@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH v3 01/26] virtiofs: Fixup printf args
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Wed, Apr 28, 2021 at 12:00:35PM +0100, Dr. David Alan Gilbert (git) wrote:
> > @@ -3097,9 +3097,10 @@ static void lo_copy_file_range(fuse_req_t req, fuse_ino_t ino_in, off_t off_in,
> >  
> >      fuse_log(FUSE_LOG_DEBUG,
> >               "lo_copy_file_range(ino=%" PRIu64 "/fd=%d, "
> > -             "off=%lu, ino=%" PRIu64 "/fd=%d, "
> > -             "off=%lu, size=%zd, flags=0x%x)\n",
> > -             ino_in, in_fd, off_in, ino_out, out_fd, off_out, len, flags);
> > +             "off=%ju, ino=%" PRIu64 "/fd=%d, "
> > +             "off=%ju, size=%zd, flags=0x%x)\n",
> > +             ino_in, in_fd, (intmax_t)off_in,
> > +             ino_out, out_fd, (intmax_t)off_out, len, flags);
> 
> The rest of the patch used uint64_t. Why intmax_t here?

Because it seems to be the standard way of doing it for things that may
be off_t.

> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

Thanks.

Dave


-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

