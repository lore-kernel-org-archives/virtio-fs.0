Date: Thu, 11 Feb 2021 16:39:22 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YCVduoTmMuV4sOZF@work-vm>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-11-dgilbert@redhat.com>
	<20210211123738.GK247031@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211123738.GK247031@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 10/24] DAX: virtiofsd: Add setup/remove
 mappings fuse commands
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com, mst@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Tue, Feb 09, 2021 at 07:02:10PM +0000, Dr. David Alan Gilbert (git) wrote:
> > +static void do_removemapping(fuse_req_t req, fuse_ino_t nodeid,
> > +                             struct fuse_mbuf_iter *iter)
> > +{
> > +    struct fuse_removemapping_in *arg;
> > +    struct fuse_removemapping_one *one;
> > +
> > +    arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
> > +    if (!arg || arg->count <= 0) {
> 
> arg->count is unsigned so < is tautologous.
> 
> > +        fuse_log(FUSE_LOG_ERR, "do_removemapping: invalid arg %p\n", arg);
> > +        fuse_reply_err(req, EINVAL);
> > +        return;
> > +    }
> > +
> > +    one = fuse_mbuf_iter_advance(iter, arg->count * sizeof(*one));
> 
> arg->count * sizeof(*one) is an integer overflow on 32-bit hosts. I
> think we should be more defensive here since this input comes from the
> guest.

OK, so I've gone with:

    if (!arg || !arg->count || 
        (uint64_t)arg->count * sizeof(*one) >= SIZE_MAX) {
        fuse_log(FUSE_LOG_ERR, "do_removemapping: invalid arg %p\n", arg);
        fuse_reply_err(req, EINVAL);
        return;
    }

to fix both of those (the compiler likes to moan on 64bit about
that comparison being always false in the simpler ways I tried it).

Dave

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

