References: <20200827153657.111098-1-dgilbert@redhat.com>
	<20200827153657.111098-6-dgilbert@redhat.com>
From: Christophe de Dinechin <dinechin@redhat.com>
In-reply-to: <20200827153657.111098-6-dgilbert@redhat.com>
Date: Tue, 06 Oct 2020 18:17:51 +0200
Message-ID: <lyd01vl45s.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [Virtio-fs] [PATCH v2 5/6] tools/virtiofsd: xattr name
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
Cc: virtio-fs@redhat.com, vgoyal@redhat.com, qemu-devel@nongnu.org


On 2020-08-27 at 17:36 CEST, Dr. David Alan Gilbert (git) wrote...
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>
> Map xattr names coming from the server, i.e. the host filesystem;
> currently this is only from listxattr.
>
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 88 ++++++++++++++++++++++++++++++++
>  1 file changed, 88 insertions(+)
>
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 9b9c8f3ab1..7cd99186f7 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2188,6 +2188,42 @@ static int xattr_map_client(const char *client_name, char **out_name)
>      abort();
>  }
>
> +/*
> + * For use with listxattr where the server fs gives us a name and we may need
> + * to sanitize this for the client.
> + * Returns a pointer to the result in *out_name
> + *   This is always the original string or the current string with some prefix
> + *   removed; no reallocation is done.
> + * Returns 0 on success
> + * Can return -ENODATA to indicate the name should be dropped from the list.
> + */
> +static int xattr_map_server(const char *server_name, const char **out_name)
> +{
> +    const XattrMapEntry *cur_entry;
> +    for (cur_entry = xattr_map_list; ; cur_entry++) {
> +        if ((cur_entry->flags & XATTR_MAP_FLAG_SERVER) &&
> +            (!strncmp(cur_entry->prepend,
> +                      server_name,
> +                      strlen(cur_entry->prepend)))) {

Overall, the same remarks apply as for the client side.

> +            if (cur_entry->flags & XATTR_MAP_FLAG_END_BAD) {
> +                return -ENODATA;
> +            }
> +            if (cur_entry->flags & XATTR_MAP_FLAG_END_OK) {
> +                *out_name = server_name;
> +                return 0;
> +            }
> +            if (cur_entry->flags & XATTR_MAP_FLAG_PREFIX) {
> +                /* Remove prefix */
> +                *out_name = server_name + strlen(cur_entry->prepend);
> +                return 0;
> +            }
> +        }
> +    }
> +
> +    /* Shouldn't get here - rules should have an END_* */
> +    abort();
> +}
> +
>  static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
>                          size_t size)
>  {
> @@ -2342,8 +2378,60 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
>          if (ret == 0) {
>              goto out;
>          }
> +
> +        if (lo->xattrmap) {
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
> +                int mapret = xattr_map_server(in_ptr, &map_out);
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
>      }
>  out_free:


--
Cheers,
Christophe de Dinechin (IRC c3d)

