Date: Thu, 7 Nov 2019 12:26:12 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20191107122612.GJ2816@work-vm>
References: <20191025100152.6638-1-stefanha@redhat.com>
	<20191025100152.6638-4-stefanha@redhat.com>
	<20191029003605.GC2508@work-vm>
	<20191105160252.GF166646@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105160252.GF166646@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [RFC 3/3] tests/vhost-user-fs-test: add
	vhost-user-fs test case
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, vgoyal@redhat.com

* Stefan Hajnoczi (stefanha@gmail.com) wrote:
> On Tue, Oct 29, 2019 at 12:36:05AM +0000, Dr. David Alan Gilbert wrote:
> > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > > +static void after_test(void *arg G_GNUC_UNUSED)
> > > +{
> > > +    unlink(socket_path);
> > > +
> > > +    remove_dir_and_children(shared_dir);
> > 
> > This scares me. Especially since it's running as root.
> > Can we add a bunch of paranoid checks to make sure it doesn't
> > end up rm -rf / ?
> 
> Yes, we can resolve the path and check it is not "/".

I suggest checking for "/", ".", ".." and ""
if any of those get in it's probably bad.

> > > +/* Open a file by nodeid using FUSE_OPEN */
> > > +static int32_t fuse_open(QVirtioFS *vfs, uint64_t nodeid, uint32_t flags,
> > > +                         uint64_t *fh)
> > > +{
> > > +    struct fuse_in_header in_hdr = {
> > > +        .opcode = guest32(FUSE_OPEN),
> > > +        .unique = guest64(virtio_fs_get_unique(vfs)),
> > > +        .nodeid = guest64(nodeid),
> > > +    };
> > > +    struct fuse_open_in in = {
> > > +        .flags = guest32(flags),
> > > +    };
> > > +    struct iovec sg_in[] = {
> > > +        { .iov_base = &in_hdr, .iov_len = sizeof(in_hdr) },
> > > +        { .iov_base = &in, .iov_len = sizeof(in) },
> > > +    };
> > > +    struct fuse_out_header out_hdr;
> > > +    struct fuse_open_out out;
> > > +    struct iovec sg_out[] = {
> > > +        { .iov_base = &out_hdr, .iov_len = sizeof(out_hdr) },
> > > +        { .iov_base = &out, .iov_len = sizeof(out) },
> > > +    };
> > 
> > I wonder if anything can be done to reduce the size of the iovec boiler
> > plate?
> 
> I'm not aware of a clean way to build the iovec array automatically but
> we could do this if you prefer it:
> 
>   #define IOVEC(elem) { .iov_base = &elem, .iov_len = sizeof(elem) }
> 
>   struct iovec sg_in[] = {
>     IOVEC(in_hdr),
>     IOVEC(in),
>   };
> 
> Do you find this nicer?

Only a little; probably not worth it.

Dave

> Stefan


--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

