Date: Wed, 20 Oct 2021 12:06:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YXA+dYmIUGwGVskC@redhat.com>
References: <20211011030052.98923-1-jefflexu@linux.alibaba.com>
	<YW2Q5Y3u1TMlQEcW@redhat.com>
	<85e66fb6-7587-4b8b-3e6f-0fc1019996fc@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85e66fb6-7587-4b8b-3e6f-0fc1019996fc@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH v6 0/7] fuse,virtiofs: support per-file DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: JeffleXu <jefflexu@linux.alibaba.com>
Cc: miklos@szeredi.hu, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, linux-fsdevel@vger.kernel.org

On Wed, Oct 20, 2021 at 01:22:32PM +0800, JeffleXu wrote:
> 
> 
> On 10/18/21 11:21 PM, Vivek Goyal wrote:
> > On Mon, Oct 11, 2021 at 11:00:45AM +0800, Jeffle Xu wrote:
> >> changes since v5:
> >> Overall Design Changes:
> >> 1. virtiofsd now supports ioctl (only FS_IOC_SETFLAGS and
> >>   FS_IOC_FSSETXATTR), so that users inside guest could set/clear
> >>   persistent inode flags now. (FUSE kernel module has already supported
> >>   .ioctl(), virtiofsd need to suuport it.)
> > 
> > So no changes needed in fuse side (kernel) to support FS_IOC_FSSETXATTR?
> > Only virtiofsd needs to be changed. That sounds good.
> > 
> 
> Yes, the fuse kernel modules has already supported FUSE_IOCTL.
> 
> Per inode DAX on ext4/xfs will also call d_mark_dontcache() and try to
> evict this inode as soon as possible when the persistent (DAX) inode
> attribute has changed, just like [1].
> 
> But because of following reason:
> > 
> >> 2. The
> >>   algorithm used by virtiofsd to determine whether DAX shall be enabled
> >>   or not is totally implementation specific, and thus the following
> >>   scenario may exist: users inside guest has already set related persistent
> >>   inode flag (i.e. FS_XFLAG_DAX) on corresponding file but FUSE server finnaly
> >>   decides not to enable DAX for this file.
> 
> If we always call d_mark_dontcache() and try to evict this inode when
> the persistent (DAX) inode attribute has changed, the DAX state returned
> by virtiofsd may sustain the same, and thus the previous eviction is
> totally wasted and unnecessary.
> 
> So, as the following said,
> 
> >> Also because of this, d_mark_dontcache() is
> >>   not called when FS_IOC_SETFLAGS/FS_IOC_FSSETXATTR ioctl is done inside
> >>   guest. It's delayed to be done if the FUSE_ATTR_DAX flag **indeed**
> >>   changes (as showed in patch 6).
> 
> the call for d_mark_dontcache() and inode eviction is delayed when the
> DAX state returned by virtiofsd **indeed** changed (when dentry is timed
> out and a new FUSE_LOOKUP is requested). But the defect is that, if '-o
> cache=always' is set for virtiofsd, then the DAX state won't be updated
> for a long time, after users have changed the persistent (DAX) inode
> attribute inside guest via FS_IOC_FSSETXATTR ioctl.

Good point. I guess this probably is not too bad. If it becomes a concern,
we can always mark inode don't cache whenever client changes persistent
DAX flag.

Vivek
> 
> 
> 
> [1] https://www.spinics.net/lists/linux-fsdevel/msg200851.html
> 
> -- 
> Thanks,
> Jeffle
> 

