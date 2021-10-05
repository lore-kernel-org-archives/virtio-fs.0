Date: Tue, 5 Oct 2021 10:43:58 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YVweXhsYK9V6oH1Q@work-vm>
References: <YUt9qbmgAfCFfg5t@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YUt9qbmgAfCFfg5t@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: xattr mapping add a new type
	"unsupported"
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Vivek Goyal (vgoyal@redhat.com) wrote:
> Right now for xattr remapping, we support types of "prefix", "ok" or "bad".
> Type "bad" returns -EPERM on setxattr and hides xattr in listxattr. For
> getxattr, mapping code returns -EPERM but getxattr code converts it to -ENODATA.
> 
> I need a new semantics where if an xattr is unsupported, then
> getxattr()/setxattr() return -ENOTSUP and listxattr() should hide the xattr.
> This is needed to simulate that security.selinux is not supported by
> virtiofs filesystem and in that case client falls back to some default
> label specified by policy.
> 
> So add a new type "unsupported" which returns -ENOTSUP on getxattr() and
> setxattr() and hides xattrs in listxattr().
> 
> For example, one can use following mapping rule to not support
> security.selinux xattr and allow others.
> 
> "-o xattrmap=/unsupported/all/security.selinux/security.selinux//ok/all///"
> 
> Suggested-by: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Yes, that's nice and simple.


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  docs/tools/virtiofsd.rst         |    6 ++++++
>  tools/virtiofsd/passthrough_ll.c |   17 ++++++++++++++---
>  2 files changed, 20 insertions(+), 3 deletions(-)
> 
> Index: rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c
> ===================================================================
> --- rhvgoyal-qemu.orig/tools/virtiofsd/passthrough_ll.c	2021-09-22 08:37:16.070377732 -0400
> +++ rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c	2021-09-22 14:17:09.543016250 -0400
> @@ -2465,6 +2465,11 @@ static void lo_flock(fuse_req_t req, fus
>   * Automatically reversed on read
>   */
>  #define XATTR_MAP_FLAG_PREFIX  (1 <<  2)
> +/*
> + * The attribute is unsupported;
> + * ENOTSUP on write, hidden on read.
> + */
> +#define XATTR_MAP_FLAG_UNSUPPORTED     (1 <<  3)
>  
>  /* scopes */
>  /* Apply rule to get/set/remove */
> @@ -2636,6 +2641,8 @@ static void parse_xattrmap(struct lo_dat
>              tmp_entry.flags |= XATTR_MAP_FLAG_OK;
>          } else if (strstart(map, "bad", &map)) {
>              tmp_entry.flags |= XATTR_MAP_FLAG_BAD;
> +        } else if (strstart(map, "unsupported", &map)) {
> +            tmp_entry.flags |= XATTR_MAP_FLAG_UNSUPPORTED;
>          } else if (strstart(map, "map", &map)) {
>              /*
>               * map is sugar that adds a number of rules, and must be
> @@ -2646,8 +2653,8 @@ static void parse_xattrmap(struct lo_dat
>          } else {
>              fuse_log(FUSE_LOG_ERR,
>                       "%s: Unexpected type;"
> -                     "Expecting 'prefix', 'ok', 'bad' or 'map' in rule %zu\n",
> -                     __func__, lo->xattr_map_nentries);
> +                     "Expecting 'prefix', 'ok', 'bad', 'unsupported' or 'map'"
> +                     " in rule %zu\n", __func__, lo->xattr_map_nentries);
>              exit(1);
>          }
>  
> @@ -2749,6 +2756,9 @@ static int xattr_map_client(const struct
>              if (cur_entry->flags & XATTR_MAP_FLAG_BAD) {
>                  return -EPERM;
>              }
> +            if (cur_entry->flags & XATTR_MAP_FLAG_UNSUPPORTED) {
> +                return -ENOTSUP;
> +            }
>              if (cur_entry->flags & XATTR_MAP_FLAG_OK) {
>                  /* Unmodified name */
>                  return 0;
> @@ -2788,7 +2798,8 @@ static int xattr_map_server(const struct
>  
>          if ((cur_entry->flags & XATTR_MAP_FLAG_SERVER) &&
>              (strstart(server_name, cur_entry->prepend, &end))) {
> -            if (cur_entry->flags & XATTR_MAP_FLAG_BAD) {
> +            if (cur_entry->flags & XATTR_MAP_FLAG_BAD ||
> +                cur_entry->flags & XATTR_MAP_FLAG_UNSUPPORTED) {
>                  return -ENODATA;
>              }
>              if (cur_entry->flags & XATTR_MAP_FLAG_OK) {
> Index: rhvgoyal-qemu/docs/tools/virtiofsd.rst
> ===================================================================
> --- rhvgoyal-qemu.orig/docs/tools/virtiofsd.rst	2021-09-22 08:37:15.938372097 -0400
> +++ rhvgoyal-qemu/docs/tools/virtiofsd.rst	2021-09-22 14:44:09.814188712 -0400
> @@ -183,6 +183,12 @@ Using ':' as the separator a rule is of
>    'ok' as either an explicit terminator or for special handling of certain
>    patterns.
>  
> +- 'unsupported' - If a client tries to use a name matching 'key' it's
> +  denied using ENOTSUP; when the server passes an attribute
> +  name matching 'prepend' it's hidden.  In many ways it's use is very like
> +  'ok' as either an explicit terminator or for special handling of certain
> +  patterns.
> +
>  **key** is a string tested as a prefix on an attribute name originating
>  on the client.  It maybe empty in which case a 'client' rule
>  will always match on client names.
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

