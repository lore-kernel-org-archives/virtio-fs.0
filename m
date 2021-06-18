References: <20210609155551.44437-1-mreitz@redhat.com>
	<20210609155551.44437-8-mreitz@redhat.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <d5bf57eb-5ede-1951-29f9-2d40390dbbf7@redhat.com>
Date: Fri, 18 Jun 2021 10:30:33 +0200
MIME-Version: 1.0
In-Reply-To: <20210609155551.44437-8-mreitz@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH v2 7/9] virtiofsd: Add inodes_by_handle hash
	table
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com

On 09.06.21 17:55, Max Reitz wrote:
> Currently, lo_inode.fhandle is always NULL and so always keep an O_PATH
> FD in lo_inode.fd.  Therefore, when the respective inode is unlinked,
> its inode ID will remain in use until we drop our lo_inode (and
> lo_inode_put() thus closes the FD).  Therefore, lo_find() can safely use
> the inode ID as an lo_inode key, because any inode with an inode ID we
> find in lo_data.inodes (on the same filesystem) must be the exact same
> file.
>
> This will change when we start setting lo_inode.fhandle so we do not
> have to keep an O_PATH FD open.  Then, unlinking such an inode will
> immediately remove it, so its ID can then be reused by newly created
> files, even while the lo_inode object is still there[1].
>
> So creating a new file can then reuse the old file's inode ID, and
> looking up the new file would lead to us finding the old file's
> lo_inode, which is not ideal.
>
> Luckily, just as file handles cause this problem, they also solve it:  A
> file handle contains a generation ID, which changes when an inode ID is
> reused, so the new file can be distinguished from the old one.  So all
> we need to do is to add a second map besides lo_data.inodes that maps
> file handles to lo_inodes, namely lo_data.inodes_by_handle.  For
> clarity, lo_data.inodes is renamed to lo_data.inodes_by_ids.
>
> Unfortunately, we cannot rely on being able to generate file handles
> every time.  Therefore, we still enter every lo_inode object into
> inodes_by_ids, but having an entry in inodes_by_handle is optional.  A
> potential inodes_by_handle entry then has precedence, the inodes_by_ids
> entry is just a fallback.
>
> Note that we do not generate lo_fhandle objects yet, and so we also do
> not enter anything into the inodes_by_handle map yet.  Also, all lookups
> skip that map.  We might manually create file handles with some code
> that is immediately removed by the next patch again, but that would
> break the assumption in lo_find() that every lo_inode with a non-NULL
> .fhandle must have an entry in inodes_by_handle and vice versa.  So we
> leave actually using the inodes_by_handle map for the next patch.
>
> [1] If some application in the guest still has the file open, there is
> going to be a corresponding FD mapping in lo_data.fd_map.  In such a
> case, the inode will only go away once every application in the guest
> has closed it.  The problem described only applies to cases where the
> guest does not have the file open, and it is just in the dentry cache,
> basically.
>
> Signed-off-by: Max Reitz <mreitz@redhat.com>
> Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
> ---
>   tools/virtiofsd/passthrough_ll.c | 80 +++++++++++++++++++++++++-------
>   1 file changed, 64 insertions(+), 16 deletions(-)

[...]

> @@ -3931,10 +3954,34 @@ static gboolean lo_key_equal(gconstpointer a, gconstpointer b)
>       return la->ino == lb->ino && la->dev == lb->dev && la->mnt_id == lb->mnt_id;
>   }
>   
> +static guint lo_fhandle_hash(gconstpointer key)
> +{
> +    const struct lo_fhandle *fh = key;
> +    guint hash;
> +    size_t i;
> +
> +    /* Basically g_str_hash() */
> +    hash = 5381;
> +    for (i = 0; i < sizeof(fh->padding); i++) {
> +        hash += hash * 33 + (unsigned char)fh->padding[i];
> +    }
> +    hash += hash * 33 + fh->mount_id;

Just spotted: These `+=` should be `=`.

Max

> +
> +    return hash;
> +}

