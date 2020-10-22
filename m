Date: Thu, 22 Oct 2020 12:16:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201022161656.GD512900@redhat.com>
References: <20201014180209.49299-1-dgilbert@redhat.com>
	<20201014180209.49299-4-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014180209.49299-4-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 3/5] tools/virtiofsd: xattr name
 mappings: Map server xattr names
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: dinechin@redhat.com, virtio-fs@redhat.com, qemu-devel@nongnu.org

On Wed, Oct 14, 2020 at 07:02:07PM +0100, Dr. David Alan Gilbert (git) wrote:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> 
> Map xattr names coming from the server, i.e. the host filesystem;
> currently this is only from listxattr.
> 
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 89 ++++++++++++++++++++++++++++++++
>  1 file changed, 89 insertions(+)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 57ebe17ed6..8406a2ae86 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2220,6 +2220,43 @@ static int xattr_map_client(const struct lo_data *lo, const char *client_name,
>          }
>      }
>  
> +    /* Shouldn't get here - rules should have an END_* - check parse_xattrmap */
> +    abort();
> +}
> +
> +/*
> + * For use with listxattr where the server fs gives us a name and we may need
> + * to sanitize this for the client.
> + * Returns a pointer to the result in *out_name
> + *   This is always the original string or the current string with some prefix
> + *   removed; no reallocation is done.
> + * Returns 0 on success
> + * Can return -ENODATA to indicate the name should be dropped from the list.
> + */
> +static int xattr_map_server(const struct lo_data *lo, const char *server_name,
> +                            const char **out_name)
> +{
> +    const XattrMapEntry *cur_entry;
> +    const char *end;
> +
> +    for (cur_entry = lo->xattr_map_list; ; cur_entry++) {
> +        if ((cur_entry->flags & XATTR_MAP_FLAG_SERVER) &&
> +            (strstart(server_name, cur_entry->prepend, &end))) {
> +            if (cur_entry->flags & XATTR_MAP_FLAG_END_BAD) {
> +                return -ENODATA;
> +            }
> +            if (cur_entry->flags & XATTR_MAP_FLAG_END_OK) {
> +                *out_name = server_name;
> +                return 0;
> +            }
> +            if (cur_entry->flags & XATTR_MAP_FLAG_PREFIX) {
> +                /* Remove prefix */
> +                *out_name = end;
> +                return 0;
> +            }
> +        }
> +    }
> +
>      /* Shouldn't get here - rules should have an END_* */
>      abort();

I am wondering why to put that restriction. If none of the rules match,
can't we just return as nothing has to be done.

>  }
> @@ -2378,8 +2415,60 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
>          if (ret == 0) {
>              goto out;
>          }
> +
> +        if (lo->xattr_map_list) {
> +            /*
> +             * Map the names back, some attributes might be dropped,
> +             * some shortened, but not increased, so we shouldn't
> +             * run out of room.
> +             */
> +            size_t out_index, in_index;
> +            out_index = 0;
> +            in_index = 0;
> +            while (in_index < ret) {
> +                const char *map_out;
> +                char *in_ptr = value + in_index;
> +                /* Length of current attribute name */
> +                size_t in_len = strlen(value + in_index) + 1;
> +
> +                int mapret = xattr_map_server(lo, in_ptr, &map_out);
> +                if (mapret != -ENODATA && mapret != 0) {
> +                    /* Shouldn't happen */
> +                    saverr = -mapret;
> +                    goto out;
> +                }
> +                if (mapret == 0) {
> +                    /* Either unchanged, or truncated */
> +                    size_t out_len;
> +                    if (map_out != in_ptr) {
> +                        /* +1 copies the NIL */
> +                        out_len = strlen(map_out) + 1;
> +                    } else {
> +                        /* No change */
> +                        out_len = in_len;
> +                    }
> +                    /*
> +                     * Move result along, may still be needed for an unchanged
> +                     * entry if a previous entry was changed.
> +                     */
> +                    memmove(value + out_index, map_out, out_len);
> +
> +                    out_index += out_len;
> +                }
> +                in_index += in_len;
> +            }
> +            ret = out_index;
> +            if (ret == 0) {
> +                goto out;
> +            }
> +        }
>          fuse_reply_buf(req, value, ret);
>      } else {
> +        /*
> +         * xattrmap only ever shortens the result,
> +         * so we don't need to do anything clever with the
> +         * allocation length here.
> +         */
>          fuse_reply_xattr(req, ret);

Hmmm.., so this code returns the length of buffer which will fit xattrs.
So we will will changing the semantics a bit. Instead of returning
the exact size of buffer needed, we will be returning max size. I hope
its not a problem. Fixing it will be too expensive I guess.

Thanks
Vivek

