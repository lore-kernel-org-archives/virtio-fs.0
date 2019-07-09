MIME-Version: 1.0
References: <20190704104650.GF1609@stefanha-x1.localdomain>
	<20190708150822.GK2746@work-vm>
	<20190709081520.GC25663@stefanha-x1.localdomain>
In-Reply-To: <20190709081520.GC25663@stefanha-x1.localdomain>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Tue, 9 Jul 2019 11:31:39 +0200
Message-ID: <CAOssrKfm25cQex19UVpCiBKbxTiNaH6QeCE4_dfobJCV=Qeb8A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] Achieving parallelism in virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com

On Tue, Jul 9, 2019 at 10:15 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Mon, Jul 08, 2019 at 04:08:22PM +0100, Dr. David Alan Gilbert wrote:
> > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > > Hi,
> > > Here are my plans for achieving parallelism in virtiofsd.  This will
> > > improve performance for workloads that keep more than one request in
> > > flight at a time.
> > >
> > > Today virtiofsd performance is limited because it only processes 1
> > > request at a time.  This can be improved in two independent ways:
> > > parallel request processing and multiqueue.
> > >
> > > Parallel request processing means working on more than one request at a
> > > time.  A request that blocks should not prevent the next request from
> > > executing.  The FUSE protocol is asynchronous so it's just a question of
> > > adjusting virtiofsd.
> >
> > Are there any ordering constraints? Or barriers etc?
>
> FUSE_INIT must be processed before the session is usable for
> general-purpose requests.  So there is at least one ordering constraint
> in the FUSE protocol :).
>
> Miklos: Can you confirm that fuse.ko does not assume ordering
> constraints on general-purpose requests (lookup, create, read, write,
> etc)?  For example, does it ever queue up requests and expect them to be
> processed in order?

Fuse does not assume that requests will be processed in order of queuing.

If request B is dependent on request A, then B is only queued if reply
for A is received.

Thanks,
Miklos

