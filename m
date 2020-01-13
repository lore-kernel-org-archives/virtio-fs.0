Date: Mon, 13 Jan 2020 13:38:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200113183835.GA23831@redhat.com>
References: <20200110010722.27491-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110010722.27491-1-misono.tomohiro@jp.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Fix xattr operations
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

On Fri, Jan 10, 2020 at 10:07:22AM +0900, Misono Tomohiro wrote:

[..]
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -133,6 +133,7 @@ struct lo_inode {
>      GHashTable *posix_locks; /* protected by lo_inode->plock_mutex */
>  
>      bool is_symlink;
> +    bool is_regular;
>  };
>  
>  struct lo_cred {
> @@ -1038,6 +1039,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>          }
>  
>          inode->is_symlink = S_ISLNK(e->attr.st_mode);
> +        inode->is_regular = S_ISREG(e->attr.st_mode) + S_ISDIR(e->attr.st_mode);

How about having two variables. One for regular files and one for
directories. Say ->is_regular and ->is_dir.  That way if there are other
users later, these can cleary differentiate between regular files and
directories.

>  
>          /*
>           * One for the caller and one for nlookup (released in
> @@ -2345,6 +2347,7 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
>      ssize_t ret;
>      int saverr;
>      int fd = -1;
> +    bool dir_changed = false;
>  
>      inode = lo_inode(req, ino);
>      if (!inode) {
> @@ -2360,16 +2363,20 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
>      fuse_log(FUSE_LOG_DEBUG, "lo_getxattr(ino=%" PRIu64 ", name=%s size=%zd)\n",
>               ino, name, size);
>  
> -    if (inode->is_symlink) {
> -        /* Sorry, no race free way to getxattr on symlink. */
> -        saverr = EPERM;
> -        goto out;
> -    }
> -

This code came from Miklos as part of original commit in libfuse.

commit fc9f632a219decea427271dc5a77654f6aaa9610
Author: Miklos Szeredi <mszeredi@redhat.com>
Date:   Tue Aug 14 21:37:02 2018 +0200

    passthrough_ll: add *xattr() operations

Miklos, can you please help us understand what are the races you are
concerned about on symlink and whether this patch fixes those races
or not. If not, then we probably need to retain this code and not
allow xattr operations on symlink yet.

Thanks
Vivek

