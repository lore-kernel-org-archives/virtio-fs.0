Date: Fri, 11 Jun 2021 15:19:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210611191925.GA767764@redhat.com>
References: <20210609155551.44437-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210609155551.44437-1-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 0/9] virtiofsd: Allow using file handles
 instead of O_PATH FDs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Wed, Jun 09, 2021 at 05:55:42PM +0200, Max Reitz wrote:
> Hi,
> 
> v1 cover letter for an overview:
> https://listman.redhat.com/archives/virtio-fs/2021-June/msg00033.html

Hi Max,

What's the impact of these patches on performance? Just trying to 
get some idea what to expect. Performance remains more or less
same or we expect a hit.

Thanks
Vivek

> 
> In v2, I (tried to) fix the bug Dave found, which is that
> get_file_handle() indiscriminately opened the given dirfd/name
> combination to get an O_RDONLY fd without checking whether we’re
> actually allowed to open dirfd/name; namely, we don’t allow ourselves to
> open files that aren’t regular files or directories.
> 
> So that openat(.., O_RDONLY) is changed to an openat(..., O_PATH), and
> then check the file type with the statx() we’re doing anyway.  If the
> file is OK to open, we reopen it O_RDONLY with the help of
> /proc/self/fd, like we always do.
> 
> (This only affects patch 8.)
> 
> 
> git-backport-diff against v1:
> 
> Key:
> [----] : patches are identical
> [####] : number of functional differences between upstream/downstream patch
> [down] : patch is downstream-only
> The flags [FC] indicate (F)unctional and (C)ontextual differences, respectively
> 
> 001/9:[----] [--] 'virtiofsd: Add TempFd structure'
> 002/9:[----] [--] 'virtiofsd: Use lo_inode_open() instead of openat()'
> 003/9:[----] [--] 'virtiofsd: Add lo_inode_fd() helper'
> 004/9:[----] [--] 'virtiofsd: Let lo_fd() return a TempFd'
> 005/9:[----] [--] 'virtiofsd: Let lo_inode_open() return a TempFd'
> 006/9:[----] [--] 'virtiofsd: Add lo_inode.fhandle'
> 007/9:[----] [--] 'virtiofsd: Add inodes_by_handle hash table'
> 008/9:[0045] [FC] 'virtiofsd: Optionally fill lo_inode.fhandle'
> 009/9:[----] [--] 'virtiofsd: Add lazy lo_do_find()'
> 
> 
> Max Reitz (9):
>   virtiofsd: Add TempFd structure
>   virtiofsd: Use lo_inode_open() instead of openat()
>   virtiofsd: Add lo_inode_fd() helper
>   virtiofsd: Let lo_fd() return a TempFd
>   virtiofsd: Let lo_inode_open() return a TempFd
>   virtiofsd: Add lo_inode.fhandle
>   virtiofsd: Add inodes_by_handle hash table
>   virtiofsd: Optionally fill lo_inode.fhandle
>   virtiofsd: Add lazy lo_do_find()
> 
>  tools/virtiofsd/helper.c              |   3 +
>  tools/virtiofsd/passthrough_ll.c      | 836 +++++++++++++++++++++-----
>  tools/virtiofsd/passthrough_seccomp.c |   2 +
>  3 files changed, 694 insertions(+), 147 deletions(-)
> 
> -- 
> 2.31.1
> 
> 

