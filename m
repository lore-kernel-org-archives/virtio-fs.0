Date: Wed, 3 Feb 2021 10:28:50 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210203152850.GA3307@redhat.com>
References: <20210203113719.83633-1-stefanha@redhat.com>
	<20210203113719.83633-4-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203113719.83633-4-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 3/3] virtiofsd: prevent opening of
 special files (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Daniel Berrange <berrange@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Alex Xu <alex@alxu.ca>, P J P <ppandit@redhat.com>, Laszlo Ersek <lersek@redhat.com>

On Wed, Feb 03, 2021 at 11:37:19AM +0000, Stefan Hajnoczi wrote:

[..]
> @@ -1727,36 +1764,38 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
>  
>      update_open_flags(lo->writeback, lo->allow_direct_io, fi);
>  
> -    fd = openat(parent_inode->fd, name, (fi->flags | O_CREAT) & ~O_NOFOLLOW,
> -                mode);
> +    /* Try to create a new file but don't open existing files */
> +    fd = openat(parent_inode->fd, name, fi->flags | O_CREAT | O_EXCL, mode);
>      err = fd == -1 ? errno : 0;
> +
>      lo_restore_cred(&old);
>  
> -    if (!err) {
> -        ssize_t fh;
> -
> -        pthread_mutex_lock(&lo->mutex);
> -        fh = lo_add_fd_mapping(lo, fd);
> -        pthread_mutex_unlock(&lo->mutex);
> -        if (fh == -1) {
> -            close(fd);
> -            err = ENOMEM;
> -            goto out;
> -        }
> +    /* Ignore the error if file exists and O_EXCL was not given */
> +    if (err && !(err == EEXIST && !(fi->flags & O_EXCL))) {

Can this check be simplified to.
       if (err && (err == EEXIST && (fi->flags & O_EXCL)) {
           goto out;
       }
> +        goto out;
> +    }


Vivek

