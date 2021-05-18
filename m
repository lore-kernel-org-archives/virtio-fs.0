Date: Tue, 18 May 2021 16:34:50 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210518203450.GA682636@horse>
References: <20210518190059.GB118510@rsjd01523.et2sqa>
MIME-Version: 1.0
In-Reply-To: <20210518190059.GB118510@rsjd01523.et2sqa>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [Question] can we make dax flag per-inode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com

On Wed, May 19, 2021 at 03:00:59AM +0800, Liu Bo wrote:
> Hi,
> 
> Currently dax mode is enabled through the mount option "dax", and it
> affects all the file IO under virtiofs (Correct me if I was wrong).
> 
> My case is that there is only one virtiofs mount point in the guest,
> but I don't think that dax would benefit all the files, such as some
> files may only be accessed once and setupmapping+page fault overhead
> is too much in such cases, thus I would like to see dax flag as a per
> inode flag.

So you know enough about filesystem and workload so you have figured
out which files will benefit from dax? I am assuming its not just
about file size. Because workload has to keep file mapped and reuse
that data many times to benfit from dax.

> 
> So the questions come to, a) how do we set dax flags (we can do chattr
> or fuse specific flags passed from the server side), b) should it be
> toggled only once?

I think recently xfs added per inode dax flag option.
Documentation/filesystem/dax.txt says.

 2. There exists a persistent flag FS_XFLAG_DAX that can be applied to regular
    files and directories. This advisory flag can be set or cleared at any
    time, but doing so does not immediately affect the S_DAX state.

So looks like we can look at similar approach. Set this flag on a file
/directory we want to enable DAX on and then mount virtiofs with
option "cache=inode".

Not sure how much of work it is and if there are specific challenges
in the context of fuse. Give it a try.

Thanks
Vivek

