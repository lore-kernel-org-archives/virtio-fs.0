Date: Thu, 25 Feb 2021 10:19:31 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YDd5swx5HA+WinFF@work-vm>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-19-dgilbert@redhat.com>
	<20210211142948.GS247031@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211142948.GS247031@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 18/24] DAX/unmap virtiofsd: Parse unmappable
	elements
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com, mst@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Tue, Feb 09, 2021 at 07:02:18PM +0000, Dr. David Alan Gilbert (git) wrote:
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > 
> > For some read/writes the virtio queue elements are unmappable by
> > the daemon; these are cases where the data is to be read/written
> > from non-RAM.  In viritofs's case this is typically a direct read/write
> > into an mmap'd DAX file also on virtiofs (possibly on another instance).
> > 
> > When we receive a virtio queue element, check that we have enough
> > mappable data to handle the headers.  Make a note of the number of
> > unmappable 'in' entries (ie. for read data back to the VMM),
> > and flag the fuse_bufvec for 'out' entries with a new flag
> > FUSE_BUF_PHYS_ADDR.
> 
> Looking back at this I think vhost-user will need generic
> READ_MEMORY/WRITE_MEMORY commands. It's okay for virtio-fs to have its
> own IO command (although not strictly necessary).
> 
> With generic READ_MEMORY/WRITE_MEMORY libvhost-user and other vhost-user
> device backend implementations can handle vring descriptors that point
> into the DAX window. This can be done transparently so individual device
> implementations (net, blk, etc) don't even know when memory is copied vs
> zero-copy shared memory access.
> 
> So this approach is okay for virtio-fs but it's not a long-term solution
> for all of vhost-user. Eventually the long-term solution may be needed
> so that other VIRTIO devices that have shared memory resources work.
> 
> Another bonus of READ_MEMORY/WRITE_MEMORY is that users that prefer an
> enforcing vIOMMU can disable shared memory (maybe just keep the vring
> itself mmapped).
> 
> I just wanted to share this idea but don't expect it to be addressed in
> this patch series.

Yes, that would be nice; although in this case it would imply an extra
memory copy; you'd have to do the IO in the daemon, and then perform a
read/write back across the socket.

> > diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_common.h
> > index a090040bb2..ed9280de91 100644
> > --- a/tools/virtiofsd/fuse_common.h
> > +++ b/tools/virtiofsd/fuse_common.h
> > @@ -611,6 +611,13 @@ enum fuse_buf_flags {
> >       * detected.
> >       */
> >      FUSE_BUF_FD_RETRY = (1 << 3),
> > +
> > +    /**
> > +     * The addresses in the iovec represent guest physical addresses
> > +     * that can't be mapped by the daemon process.
> > +     * IO must be bounced back to the VMM to do it.
> > +     */
> > +    FUSE_BUF_PHYS_ADDR = (1 << 4),
> 
> With a vIOMMU it's an IOVA. Without a vIOMMU it's a GPA. This constant
> may need to be renamed in the future, but it is okay for now.

Do we have any naming for something that's either a GPA or a IOVA?

> > +    if (req->bad_in_num || req->bad_out_num) {
> > +        bool handled_unmappable = false;
> > +
> > +        if (out_num > 2 && out_num_readable >= 2 && !req->bad_in_num &&
> > +            out_sg[0].iov_len == sizeof(struct fuse_in_header) &&
> > +            ((struct fuse_in_header *)fbuf.mem)->opcode == FUSE_WRITE &&
> > +            out_sg[1].iov_len == sizeof(struct fuse_write_in)) {
> 
> This violates the VIRTIO specification:
> 
>   2.6.4.1 Device Requirements: Message Framing
> 
>   The device MUST NOT make assumptions about the particular arrangement of descriptors.
> 
>   https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.html#x1-280004
> 
> The driver is not obligated to submit separate iovecs. out_num == 1 is
> valid and the device needs to process it byte-wise instead of making
> assumptions about iovec layout.

Yes, it's actually not new in this patch, but I'll clean it up.
I took the shortcut all the way back in:
  e17f7a580e2c599330ad virtiofsd: Pass write iov's all the way through

Dave

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

