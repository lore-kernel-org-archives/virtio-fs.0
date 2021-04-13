Date: Tue, 13 Apr 2021 16:41:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210413204102.GK1235549@redhat.com>
References: <20210325151823.572089-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325151823.572089-1-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 0/2] fuse: Fix clearing SGID when access
 ACL is set
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu
Cc: seth.forshee@canonical.com

Hi Miklos,

Ping for this patch series.

Vivek

On Thu, Mar 25, 2021 at 11:18:21AM -0400, Vivek Goyal wrote:
> 
> Hi,
> 
> This is V2 of the patchset. Posted V1 here.
> 
> https://lore.kernel.org/linux-fsdevel/20210319195547.427371-1-vgoyal@redhat.com/
> 
> Changes since V1:
> 
> - Dropped the helper to determine if SGID should be cleared and open
>   coded it instead. I will follow up on helper separately in a different
>   patch series. There are few places already which open code this, so
>   for now fuse can do the same. Atleast I can make progress on this
>   and virtiofs can enable ACL support.
> 
> Luis reported that xfstests generic/375 fails with virtiofs. Little
> debugging showed that when posix access acl is set that in some
> cases SGID needs to be cleared and that does not happen with virtiofs.
> 
> Setting posix access acl can lead to mode change and it can also lead
> to clear of SGID. fuse relies on file server taking care of all
> the mode changes. But file server does not have enough information to
> determine whether SGID should be cleared or not.
> 
> Hence this patch series add support to send a flag in SETXATTR message
> to tell server to clear SGID.
> 
> I have staged corresponding virtiofsd patches here.
> 
> https://github.com/rhvgoyal/qemu/commits/acl-sgid-setxattr-flag
> 
> With these patches applied "./check -g acl" passes now on virtiofs.
> 
> Thanks
> Vivek
> 
> Vivek Goyal (2):
>   fuse: Add support for FUSE_SETXATTR_V2
>   fuse: Add a flag FUSE_SETXATTR_ACL_KILL_SGID to kill SGID
> 
>  fs/fuse/acl.c             |  8 +++++++-
>  fs/fuse/fuse_i.h          |  5 ++++-
>  fs/fuse/inode.c           |  4 +++-
>  fs/fuse/xattr.c           | 21 +++++++++++++++------
>  include/uapi/linux/fuse.h | 17 +++++++++++++++++
>  5 files changed, 46 insertions(+), 9 deletions(-)
> 
> -- 
> 2.25.4
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs

