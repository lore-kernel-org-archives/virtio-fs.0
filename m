Date: Wed, 31 Jul 2019 17:07:48 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190731160748.GG3203@work-vm>
References: <1558577194-61841-1-git-send-email-bo.liu@linux.alibaba.com>
	<20190731130121.GB22809@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731130121.GB22809@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: handle NULL dir in lo_do_lookup
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

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Thu, May 23, 2019 at 10:06:34AM +0800, Liu Bo wrote:
> > Reported by fstests/generic/467.
> > 
> > open_by_handle_at() called from fuse inside guest can carry fuse mount
> > point to daemon but lo_do_lookup() doesn't know its inode info because
> > it's out of fuse's scope, thus lo_inode(req, parent) ends up with
> > returning a NULL dir and breaks virtiofsd immediately.
> > 
> > Note that it'd break applications that uses open_by_handle_at.
> > 
> > It seems to me that nothing could be done to support open_by_handle_at in
> > this case.
> > 
> > This simply tells fuse a ENOENT error so that open_by_handle_at() in guest
> > can get a ESTALE.
> > 
> > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > ---
> >  contrib/virtiofsd/passthrough_ll.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>


OK, I've finally merged this.
Apologies for the delay; I got hung up on the questions about exportfs
that had been asked at the time and wanted to understand that
we had an answer.

Dave

--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

