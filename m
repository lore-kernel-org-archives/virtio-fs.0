Date: Thu, 22 Oct 2020 10:52:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201022145242.GB512900@redhat.com>
References: <20201014180209.49299-1-dgilbert@redhat.com>
	<20201014180209.49299-2-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014180209.49299-2-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 1/5] tools/virtiofsd: xattr name
	mappings: Add option
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

On Wed, Oct 14, 2020 at 07:02:05PM +0100, Dr. David Alan Gilbert (git) wrote:

[..]
> +/*
> + * Exit; process attribute unmodified if matched.
> + * An empty key applies to all.
> + */
> +#define XATTR_MAP_FLAG_END_OK  (1 <<  0)
> +/*
> + * The attribute is unwanted;
> + * EPERM on write hidden on read.
> + */
> +#define XATTR_MAP_FLAG_END_BAD (1 <<  1)
> +/*
> + * For attr that start with 'key' prepend 'prepend'
> + * 'key' maybe empty to prepend for all attrs
> + * key is defined from set/remove point of view.
> + * Automatically reversed on read
> + */
> +#define XATTR_MAP_FLAG_PREFIX  (1 <<  2)
> +/* Apply rule to get/set/remove */
> +#define XATTR_MAP_FLAG_CLIENT  (1 << 16)
> +/* Apply rule to list */
> +#define XATTR_MAP_FLAG_SERVER  (1 << 17)
> +/* Apply rule to all */
> +#define XATTR_MAP_FLAG_ALL   (XATTR_MAP_FLAG_SERVER | XATTR_MAP_FLAG_CLIENT)
> +
> +/* Last rule in the XATTR_MAP */
> +#define XATTR_MAP_FLAG_LAST    (1 << 30)

I see that you are using bit positions for flags. Not clear why you
used bit 0,1,2 and then jumped to 16,17 and then to 30. May be you
are doing some sort of reservation of bits. Will be nice to explain
that a bit so that next person modifying it can use bits from
correct pool.

> +
> +static XattrMapEntry *add_xattrmap_entry(XattrMapEntry *orig_map,
> +                                         size_t *nentries,
> +                                         const XattrMapEntry *new_entry)
> +{
> +    XattrMapEntry *res = g_realloc_n(orig_map, ++*nentries,
> +                                     sizeof(XattrMapEntry));
> +    res[*nentries - 1] = *new_entry;
> +
> +    return res;
> +}
> +
> +static void free_xattrmap(XattrMapEntry *map)
> +{
> +    XattrMapEntry *curr = map;
> +
> +    if (!map) {
> +        return;
> +    };

; after } is not needed.

> +
> +    do {
> +        g_free(curr->key);
> +        g_free(curr->prepend);
> +    } while (!(curr++->flags & XATTR_MAP_FLAG_LAST));
> +
> +    g_free(map);
> +}
> +
> +static XattrMapEntry *parse_xattrmap(struct lo_data *lo)
> +{
> +    XattrMapEntry *res = NULL;
> +    XattrMapEntry tmp_entry;
> +    size_t nentries = 0;

If you are calculating number of entries (nentries), may be this could
be stored in lo_data so that can be later used to free entries or loop
through rules etc.

> +    const char *map = lo->xattrmap;
> +    const char *tmp;
> +
> +    while (*map) {
> +        char sep;
> +
> +        if (isspace(*map)) {
> +            map++;
> +            continue;
> +        }
> +        /* The separator is the first non-space of the rule */
> +        sep = *map++;
> +        if (!sep) {
> +            break;
> +        }

When can sep be NULL? In that case while loop will not even continue.

> +
> +        /* Start of 'type' */
> +        if (strstart(map, "prefix", &map)) {
> +            tmp_entry.flags |= XATTR_MAP_FLAG_PREFIX;
> +        } else if (strstart(map, "ok", &map)) {
> +            tmp_entry.flags |= XATTR_MAP_FLAG_END_OK;
> +        } else if (strstart(map, "bad", &map)) {
> +            tmp_entry.flags |= XATTR_MAP_FLAG_END_BAD;
> +        } else {
> +            fuse_log(FUSE_LOG_ERR,
> +                     "%s: Unexpected type;"
> +                     "Expecting 'prefix', 'ok', or 'bad' in rule %zu\n",
> +                     __func__, nentries);
> +            exit(1);
> +        }
> +
> +        if (*map++ != sep) {
> +            fuse_log(FUSE_LOG_ERR,
> +                     "%s: Missing '%c' at end of type field of rule %zu\n",
> +                     __func__, sep, nentries);
> +            exit(1);
> +        }
> +
> +        /* Start of 'scope' */
> +        if (strstart(map, "client", &map)) {
> +            tmp_entry.flags |= XATTR_MAP_FLAG_CLIENT;
> +        } else if (strstart(map, "server", &map)) {
> +            tmp_entry.flags |= XATTR_MAP_FLAG_SERVER;
> +        } else if (strstart(map, "all", &map)) {
> +            tmp_entry.flags |= XATTR_MAP_FLAG_ALL;
> +        } else {
> +            fuse_log(FUSE_LOG_ERR,
> +                     "%s: Unexpected scope;"
> +                     " Expecting 'client', 'server', or 'all', in rule %zu\n",
> +                     __func__, nentries);
> +            exit(1);
> +        }
> +
> +        if (*map++ != sep) {
> +            fuse_log(FUSE_LOG_ERR,
> +                     "%s: Expecting '%c' found '%c'"
> +                     " after scope in rule %zu\n",
> +                     __func__, sep, *map, nentries);
> +            exit(1);
> +        }
> +
> +        /* At start of 'key' field */
> +        tmp = strchr(map, sep);
> +        if (!tmp) {
> +            fuse_log(FUSE_LOG_ERR,
> +                     "%s: Missing '%c' at end of key field of rule %zu",
> +                     __func__, sep, nentries);
> +            exit(1);
> +        }
> +        tmp_entry.key = g_strndup(map, tmp - map);
> +        map = tmp + 1;
> +
> +        /* At start of 'prepend' field */
> +        tmp = strchr(map, sep);
> +        if (!tmp) {
> +            fuse_log(FUSE_LOG_ERR,
> +                     "%s: Missing '%c' at end of prepend field of rule %zu",
> +                     __func__, sep, nentries);
> +            exit(1);
> +        }
> +        tmp_entry.prepend = g_strndup(map, tmp - map);
> +        map = tmp + 1;
> +
> +        lo->xattr_map_list = add_xattrmap_entry(lo->xattr_map_list, &nentries,
> +                                                &tmp_entry);
> +        /* End of rule - go around again for another rule */
> +    }
> +
> +    if (!nentries) {
> +        fuse_log(FUSE_LOG_ERR, "Empty xattr map\n");
> +        exit(1);
> +    }
> +
> +    /* Add a terminator to error in cases the user hasn't specified */
> +    tmp_entry.flags = XATTR_MAP_FLAG_ALL | XATTR_MAP_FLAG_END_BAD |
> +                      XATTR_MAP_FLAG_LAST;
> +    tmp_entry.key = g_strdup("");
> +    tmp_entry.prepend = g_strdup("");
> +    lo->xattr_map_list = add_xattrmap_entry(lo->xattr_map_list, &nentries,
> +                                            &tmp_entry);

Not sure why this default rule is needed when user has not specified one.

This seems to be equivalent of ":bad:all:::". Will this not block all
the xattrs which have not been caught by previous rules. And user
probably did not want it. 

Thanks
Vivek

