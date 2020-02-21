Date: Fri, 21 Feb 2020 10:18:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200221151835.GB25974@redhat.com>
References: <20200220114704.11592-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220114704.11592-1-misono.tomohiro@jp.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH v3 0/2] Fix xattr operation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: virtio-fs@redhat.com

On Thu, Feb 20, 2020 at 08:47:02PM +0900, Misono Tomohiro wrote:
> This fixes the xattr operation for directory and special files
> (which can be tested by xfstests generic/062 with -o xattr option).
> 
> The overall logic is switched back to the same as v1 in favor of performance
> (i.e. keep original implementation for regular files/directories)
> but I add a cleanup patch to improve readability as requested by Vivek.
> 
> Known issue is that if xattr enabled, seek sanity tests (generic/285,
> 436) will fail. However, I understand this is not a very serious bug
> like data corruption so leave it for now.

Hi Misono,

Do you know why generic/285 and generic/436 fail with xattr enabled.  Is
it something easily fixable later.

> 
> One question; I remove error handling of fchdir() in v3 since
> I believe fchdir to proc_self_fd/root.fd cannot fail in the situation
> but should I add error handling?

I would think its good to have error handling for fchdir() case. We don't
expect it, but if something goes wrong, we will like to catch it.

Thanks
Vivek

> 
> change v2 -> v3:
>  - rebased to current dev branch
>  - add cleanup path (first one) to simplify main patch (second patch)
>  - restore the logic of v1 in favor of performance
>    (as a result seek sanity test failure is not fixed by this series) 
>  - remove error handling of fchdir
>  - drop ACL fix included in v2 for now to focus xattr
>  
> v2 patch: https://www.redhat.com/archives/virtio-fs/2020-January/msg00131.html
> 
> Thanks!
> 
> Misono Tomohiro (2):
>   virtiofs: passthrough_ll: cleanup getxattr/listxattr
>   virtiofs: Fix xattr operations
> 
>  tools/virtiofsd/fuse_virtio.c    |  13 +++
>  tools/virtiofsd/passthrough_ll.c | 141 +++++++++++++++----------------
>  tools/virtiofsd/seccomp.c        |   6 ++
>  3 files changed, 87 insertions(+), 73 deletions(-)
> 
> -- 
> 2.21.1
> 

