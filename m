MIME-Version: 1.0
References: <20210127112131.308451-1-stefanha@redhat.com>
In-Reply-To: <20210127112131.308451-1-stefanha@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Wed, 27 Jan 2021 14:01:54 +0100
Message-ID: <CAOssrKfY7zDOH3NNbtyARHMCdJJN1tKQJri8ec=igjBf=K6Dog@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v3] virtiofsd: prevent opening of special
	files (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Daniel Berrange <berrange@redhat.com>, QEMU Developers <qemu-devel@nongnu.org>, virtio-fs-list <virtio-fs@redhat.com>, Alex Xu <alex@alxu.ca>, P J P <ppandit@redhat.com>, Laszlo Ersek <lersek@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Jan 27, 2021 at 12:21 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
              }
> @@ -1654,9 +1677,11 @@ static void update_open_flags(int writeback, int allow_direct_io,
>  static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
>                        mode_t mode, struct fuse_file_info *fi)
>  {
> +    int open_flags = (fi->flags | O_CREAT) & ~O_NOFOLLOW;
>      int fd;
>      struct lo_data *lo = lo_data(req);
>      struct lo_inode *parent_inode;
> +    struct lo_inode *existing_inode = NULL;
>      struct fuse_entry_param e;
>      int err;
>      struct lo_cred old = {};
> @@ -1682,11 +1707,23 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
>
>      update_open_flags(lo->writeback, lo->allow_direct_io, fi);
>
> -    fd = openat(parent_inode->fd, name, (fi->flags | O_CREAT) & ~O_NOFOLLOW,
> -                mode);
> +    /* First, try to create a new file but don't open existing files */
> +    fd = openat(parent_inode->fd, name, open_flags | O_EXCL, mode);
>      err = fd == -1 ? errno : 0;
> +
>      lo_restore_cred(&old);
>
> +    /* Second, open existing files if O_EXCL was not specified */
> +    if (err == EEXIST && !(fi->flags & O_EXCL)) {
> +        existing_inode = lookup_name(req, parent, name);
> +        if (existing_inode) {
> +            fd = lo_inode_open(lo, existing_inode, open_flags);
> +            if (fd < 0) {
> +                err = -fd;
> +            }
> +        }
> +    }
> +
>      if (!err) {
>          ssize_t fh;

It's more of a mess than I thought.

The problem here is there can also be a race between the open and the
subsequent lo_do_lookup().

At this point it's probably enough to verify that fuse_entry_param
refers to the same object as the fh (using fstat and comparing st_dev
and st_ino).

Also O_CREAT open is not supposed to return ENOENT, so failure to open
without O_CREAT (race between O_CREAT open and plain open) should at
least translate error to ESTALE or EIO.

Thanks,
Miklos

