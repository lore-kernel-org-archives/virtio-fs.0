Date: Fri, 7 Jun 2019 11:15:34 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190607181533.r7xkszkdi377o5ha@US-160370MP2.local>
References: <1559875098-9347-1-git-send-email-bo.liu@linux.alibaba.com>
	<20190607152147.GI2631@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607152147.GI2631@work-vm>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: enable PARALLEL_DIROPS during
	INIT
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com

On Fri, Jun 07, 2019 at 04:21:47PM +0100, Dr. David Alan Gilbert wrote:
> * Liu Bo (bo.liu@linux.alibaba.com) wrote:
> > lookup is a RO operations, PARALLEL_DIROPS can be enabled.
> > 
> > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> 
> I'm not too sure what this is doing; and why doesn't upstream libfuse
> have this?

I'm not sure why libfuse doesn't include the capability, but AFAICT this
is needed for practical use.

Say that we have 100 threads doing 'ls /mnt/virtiofs/', then they are
serialized by a mutex in
---
fuse_lookup
  fuse_lock_inode
    if (!get_fuse_conn(inode)->parallel_dirops)
      mutex_lock(&get_fuse_inode(inode)->mutex);
---

What fuse_lookup does is a plain lookup with loading inode if necessary,
so I don't see anything wrong making operations parallel.

This is found by a fsmark test,
----
NFILES=100000

time $FSMARK  -D  10000  -S0  -n  $NFILES  -s  0  -L  5 -l /tmp/fs_log.txt \
        -d  $MNT/0  -d  $MNT/1 \
        -d  $MNT/2  -d  $MNT/3 \
        -d  $MNT/4  -d  $MNT/5 \
        -d  $MNT/6  -d  $MNT/7 \
        -d  $MNT/8  -d  $MNT/9 \
        -d  $MNT/10  -d  $MNT/11 \
        -d  $MNT/12  -d  $MNT/13 \
        -d  $MNT/14  -d  $MNT/15
----

the vanilla virtiofs was super slow due to the mutex lock.

thanks,
-liubo


> 
> Dave
> 
> > ---
> >  contrib/virtiofsd/fuse_lowlevel.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
> > index c460c4c..93ce788 100644
> > --- a/contrib/virtiofsd/fuse_lowlevel.c
> > +++ b/contrib/virtiofsd/fuse_lowlevel.c
> > @@ -2089,6 +2089,8 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
> >  
> >  	if (se->conn.want & FUSE_CAP_ASYNC_READ)
> >  		outarg.flags |= FUSE_ASYNC_READ;
> > +        if (se->conn.want & FUSE_CAP_PARALLEL_DIROPS)
> > +                outarg.flags |= FUSE_PARALLEL_DIROPS;
> >  	if (se->conn.want & FUSE_CAP_POSIX_LOCKS)
> >  		outarg.flags |= FUSE_POSIX_LOCKS;
> >  	if (se->conn.want & FUSE_CAP_ATOMIC_O_TRUNC)
> > -- 
> > 1.8.3.1
> > 
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

