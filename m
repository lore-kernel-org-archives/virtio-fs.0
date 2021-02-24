Date: Wed, 24 Feb 2021 09:58:51 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210224145851.GC3148@redhat.com>
References: <20210223225250.23945-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223225250.23945-1-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 0/2] virtiofsd: Enable posix_acl by
	default
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: miklos@szeredi.hu

On Tue, Feb 23, 2021 at 05:52:48PM -0500, Vivek Goyal wrote:
> Hi,
> 
> This is V3 of the patches. Changes since v2 are.
> 
> - I dropped the patch to give user an option to enable/disable acls.
>   Now acls are enabled by default if xattrs are enabled and fuse
>   client offers FUSE_POSIX_ACL capability.
>  
> Miklos mentioned that ACLS might not have lot of overhead as these
> can be cached. So it might make sense to enable these by default.

Maybe ACL caching will only work well with cache=auto and cache=always.
With cache=none it probably will show most extra overhead.

For example, with cache=none, I did "su test". And then did "cat foo.txt"
and every time it results in two GETXATTR(system.posix_acl_access) calls.

2021-02-24 09:56:09.45-0500] [ID: 00000004] lo_getxattr(ino=1, name=system.posix_acl_access size=4096)
[2021-02-24 09:56:09.45-0500] [ID: 00000004] lo_getxattr(ino=2, name=system.posix_acl_access size=4096)

So this will definitely impact the performance with cache=none negatively.

I am now inclined to respin the patches and add options to enable/disable
acl and keep acl disabled by default. Those who need it, can enable it.

Vivek

> 
> If we run into performance issues, then we can add another patch to
> give option to enable/disable and disable it by default.
> 
> Luis Henriques reported that fstest generic/099 fails with virtiofs.
> Little debugging showed that we don't enable acl support. This
> patch series should fix the issue
> 
> Vivek Goyal (2):
>   virtiofsd: Add umask to seccom allow list
>   virtiofsd: Enable posix_acls by default if xattrs are enabled
> 
>  tools/virtiofsd/passthrough_ll.c      | 29 +++++++++++++++++++++------
>  tools/virtiofsd/passthrough_seccomp.c |  1 +
>  2 files changed, 24 insertions(+), 6 deletions(-)
> 
> -- 
> 2.25.4
> 

