Date: Tue, 28 May 2019 17:29:33 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190528212933.GB6446@redhat.com>
References: <1558577194-61841-1-git-send-email-bo.liu@linux.alibaba.com>
	<20190523032254.GB15291@e18g06458.et15sqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523032254.GB15291@e18g06458.et15sqa>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: handle NULL dir in lo_do_lookup
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eryu Guan <eguan@linux.alibaba.com>
Cc: virtio-fs@redhat.com

On Thu, May 23, 2019 at 11:22:54AM +0800, Eryu Guan wrote:
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
> 
> Then perhaps we should consider disabling exportfs support in virtio-fs
> case? I noticed that currently fuse set
> 
> 	sb->s_export_op = &fuse_export_operations
> 
> unconditionally, maybe we could implement a feature mask in fuse and let
> filesystem implementation registers what features it supports, e.g.
> exportfs in this case.
> 
> Or we could try adding real exportfs support to virtiofs? Though I'm not
> sure if it's possible or worth it at the moment.

If we don't support export operations, we should disable it. Looks like
we have enabled it in virtiofsd.

lo_init() {
        if(conn->capable & FUSE_CAP_EXPORT_SUPPORT)
                conn->want |= FUSE_CAP_EXPORT_SUPPORT;
}

So if we were to disable it, I guess we will have to remove it.

Not sure if it is possible to support export ops in virtio-fs case. Need
to read more about it.

Vivek

