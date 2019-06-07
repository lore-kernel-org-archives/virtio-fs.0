Date: Fri, 7 Jun 2019 17:19:57 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190607161957.GN2631@work-vm>
References: <1559857436-52685-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559857436-52685-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH v2 0/5] virtiofsd: leak fixes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com

* Liu Bo (bo.liu@linux.alibaba.com) wrote:
> Patch 1-4 fixes memory/fd/hashmap leakage.
> Patch 5 is a cleanup.

I've just pushed a new -dev branch that includes this and a bunch of
other fixes.

Dave

> Liu Bo (5):
>   virtiofsd: cleanup allocated resource in se
>   virtiofsd: fix memory leak on lo.source
>   virtiofsd: fix memory leak on lo.inodes hashmap
>   virtiofsd: fix error handling in main()
>   virtiofsd: add helper for lo_data cleanup
> 
>  contrib/virtiofsd/fuse_lowlevel.c  |  7 +++++++
>  contrib/virtiofsd/fuse_virtio.c    |  7 +++++++
>  contrib/virtiofsd/fuse_virtio.h    |  2 +-
>  contrib/virtiofsd/passthrough_ll.c | 36 ++++++++++++++++++++++--------------
>  4 files changed, 37 insertions(+), 15 deletions(-)
> 
> -- 
> 1.8.3.1
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

