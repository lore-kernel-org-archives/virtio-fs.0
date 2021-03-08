Date: Mon, 8 Mar 2021 17:04:06 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YEZZBlojfa6PH3Wb@work-vm>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-8-dgilbert@redhat.com>
	<20210211103203.GH247031@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211103203.GH247031@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 07/24] DAX: virtio-fs: Add vhost-user slave
 commands for mapping
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
> On Tue, Feb 09, 2021 at 07:02:07PM +0000, Dr. David Alan Gilbert (git) wrote:
> > diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> > index d6085f7045..1deedd3407 100644
> > --- a/docs/interop/vhost-user.rst
> > +++ b/docs/interop/vhost-user.rst
> > @@ -1432,6 +1432,26 @@ Slave message types
> >  
> >    The state.num field is currently reserved and must be set to 0.
> >  
> > +``VHOST_USER_SLAVE_FS_MAP``
> > +  :id: 6
> > +  :equivalent ioctl: N/A
> > +  :slave payload: fd + n * (offset + address + len)
> 
> I'm not sure I understand this notation. '+' means field concatenation?
> Is 'fd' a field or does it indicate file descriptor passing?
> 
> I suggest using a struct name instead of informal notation so that the
> payload size and representation is clear.
> 
> The same applies for VHOST_USER_SLAVE_FS_UNMAP.
> 
> > +  :master payload: N/A
> > +
> > +  Requests that the QEMU mmap the given fd into the virtio-fs cache;
> 
> s/QEMU mmap the given fd/given fd be mmapped/
> 
> Please avoid mentioning QEMU specifically. Any VMM should be able to
> implement this spec.
> 
> The same applies for VHOST_USER_SLAVE_FS_UNMAP.

OK, I've changed this to:

+``VHOST_USER_SLAVE_FS_MAP``
+  :id: 6
+  :equivalent ioctl: N/A
+  :slave payload: ``struct VhostUserFSSlaveMsg``
+  :master payload: N/A
+
+  Requests that an fd, provided in the ancillary data, be mmapped
+  into the virtio-fs cache; multiple chunks can be mapped in one
+  command.
+  A reply is generated indicating whether mapping succeeded.
+
+``VHOST_USER_SLAVE_FS_UNMAP``
+  :id: 7
+  :equivalent ioctl: N/A
+  :slave payload: ``struct VhostUserFSSlaveMsg``
+  :master payload: N/A
+
+  Requests that the range in the virtio-fs cache is unmapped;
+  multiple chunks can be unmapped in one command.
+  A reply is generated indicating whether unmapping succeeded.
+

(Although it'll get a little more complicated as I rework for
Chirantan's comment)

Dave

> > +  multiple chunks can be mapped in one command.
> > +  A reply is generated indicating whether mapping succeeded.
> > +
> > +``VHOST_USER_SLAVE_FS_UNMAP``
> > +  :id: 7
> > +  :equivalent ioctl: N/A
> > +  :slave payload: n * (address + len)
> > +  :master payload: N/A
> > +
> > +  Requests that the QEMU un-mmap the given range in the virtio-fs cache;
> > +  multiple chunks can be unmapped in one command.
> > +  A reply is generated indicating whether unmapping succeeded.


-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

