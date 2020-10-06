References: <20200827153657.111098-1-dgilbert@redhat.com>
	<20200827153657.111098-4-dgilbert@redhat.com>
From: Christophe de Dinechin <dinechin@redhat.com>
In-reply-to: <20200827153657.111098-4-dgilbert@redhat.com>
Date: Tue, 06 Oct 2020 17:51:00 +0200
Message-ID: <lyimbnl5ej.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [Virtio-fs] [PATCH v2 3/6] tools/virtiofsd: xattr name
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
Cc: virtio-fs@redhat.com, vgoyal@redhat.com, qemu-devel@nongnu.org


On 2020-08-27 at 17:36 CEST, Dr. David Alan Gilbert (git) wrote...
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>
> Add an option to define mappings of xattr names so that
> the client and server filesystems see different views.
> This can be used to have different SELinux mappings as
> seen by the guest, to run the virtiofsd with less privileges
> (e.g. in a case where it can't set trusted/system/security
> xattrs but you want the guest to be able to), or to isolate
> multiple users of the same name; e.g. trusted attributes
> used by stacking overlayfs.
>
> A mapping engine is used wit 3 simple rules; the rules can
> be combined to allow most useful mapping scenarios.
> The ruleset is defined by -o xattrmap='rules...'.
>
> This patch doesn't use the rule maps yet.
>
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  docs/tools/virtiofsd.rst         |  55 ++++++++++++
>  tools/virtiofsd/passthrough_ll.c | 148 +++++++++++++++++++++++++++++++
>  2 files changed, 203 insertions(+)
>
> diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
> index 824e713491..2efa16d3c5 100644
> --- a/docs/tools/virtiofsd.rst
> +++ b/docs/tools/virtiofsd.rst
> @@ -107,6 +107,60 @@ Options
>    performance.  ``auto`` acts similar to NFS with a 1 second metadata cache
>    timeout.  ``always`` sets a long cache lifetime at the expense of coherency.
>
> +xattr-mapping
> +-------------
> +
> +By default the name of xattr's used by the client are passed through to the server
> +file system.  This can be a problem where either those xattr names are used
> +by something on the server (e.g. selinux client/server confusion) or if the
> +virtiofsd is running in a container with restricted priviliges where it cannot
> +access some attributes.
> +
> +A mapping of xattr names can be made using -o xattrmap=mapping where the ``mapping``
> +string consists of a series of rules.
> +
> +The first matching rule terminates the mapping.
> +
> +Each rule consists of a number of fields separated with a separator that is the
> +first non-white space character in the rule.  This separator must then be used
> +for the whole rule.
> +White space may be added before and after each rule.
> +Using ':' as the separator a rule is of the form:
> +
> +``:scope:type:key:prepend:``
> +
> +**scope** is:
> +
> +- 'client' - match 'key' against a xattr name from the client for
> +             setxattr/getxattr/removexattr
> +- 'server' - match 'prepend' against a xattr name from the server
> +             for listxattr
> +- 'all' - can be used to match both cases.
> +
> +**type** is one of:
> +
> +- 'prefix' - If 'key' matches the client then the 'prepend'
> +  is added before the name is passed to the server.
> +  For a server case, the prepend is tested and stripped
> +  if matching.
> +
> +- 'ok' - The attribute name is OK and passed through to
> +  the server unchanged.
> +
> +- 'bad' - If a client tries to use this name it's
> +  denied using EPERM; when the server passes an attribute
> +  name matching it's hidden.
> +
> +**key** is a string tested as a prefix on an attribute name originating
> +on the client.  It maybe empty in which case a 'client' rule
> +will always match on client names.
> +
> +**prepend** is a string tested as a prefix on an attribute name originiating
> +on the server, and used as a new prefix.  It maybe empty
> +in which case a 'server' rule will always match on all names from
> +the server.
> +
> +
>  Examples
>  --------
>
> @@ -123,3 +177,4 @@ Export ``/var/lib/fs/vm001/`` on vhost-user UNIX domain socket
>        -numa node,memdev=mem \
>        ...
>    guest# mount -t virtiofs myfs /mnt
> +
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 083d17a960..00e96a10cd 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -64,6 +64,7 @@
>  #include <syslog.h>
>  #include <unistd.h>
>
> +#include "qemu/cutils.h"
>  #include "passthrough_helpers.h"
>  #include "passthrough_seccomp.h"
>
> @@ -144,6 +145,7 @@ struct lo_data {
>      int flock;
>      int posix_lock;
>      int xattr;
> +    char *xattrmap;

Who owns that field? Should it be cleaned up in fuse_lo_data_cleanup() just like
source is?

>      char *source;
>      char *modcaps;
>      double timeout;
> @@ -171,6 +173,7 @@ static const struct fuse_opt lo_opts[] = {
>      { "no_posix_lock", offsetof(struct lo_data, posix_lock), 0 },
>      { "xattr", offsetof(struct lo_data, xattr), 1 },
>      { "no_xattr", offsetof(struct lo_data, xattr), 0 },
> +    { "xattrmap=%s", offsetof(struct lo_data, xattrmap), 0 },
>      { "modcaps=%s", offsetof(struct lo_data, modcaps), 0 },
>      { "timeout=%lf", offsetof(struct lo_data, timeout), 0 },
>      { "timeout=", offsetof(struct lo_data, timeout_set), 1 },
> @@ -2003,6 +2006,146 @@ static void lo_flock(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
>      fuse_reply_err(req, res == -1 ? errno : 0);
>  }
>
> +typedef struct xattr_map_entry {
> +    const char *key;
> +    const char *prepend;
> +    unsigned int flags;
> +} XattrMapEntry;
> +
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
> +static XattrMapEntry *xattr_map_list;

Curious why you made it a static variable and not a field in struct lo_data?

> +
> +static XattrMapEntry *parse_xattrmap(const char *map)
> +{
> +    XattrMapEntry *res = NULL;
> +    size_t nentries = 0;
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
> +
> +        /* Allocate some space for the rule */
> +        res = g_realloc_n(res, ++nentries, sizeof(XattrMapEntry));
> +        res[nentries - 1].flags = 0;

I would probably create an `entry` pointer to `res[nentries - 1]`
since there are 9 uses for it.

> +
> +        if (strstart(map, "client", &map)) {
> +            res[nentries - 1].flags |= XATTR_MAP_FLAG_CLIENT;
> +        } else if (strstart(map, "server", &map)) {
> +            res[nentries - 1].flags |= XATTR_MAP_FLAG_SERVER;
> +        } else if (strstart(map, "all", &map)) {
> +            res[nentries - 1].flags |= XATTR_MAP_FLAG_ALL;
> +        } else {
> +            fuse_log(FUSE_LOG_ERR,
> +                     "%s: Unexpected scope;"
> +                     " Expecting 'client', 'server', or 'all', in rule %zu\n",
> +                     __func__, nentries);
> +            exit(1);
> +        }
> +
> +
> +        if (*map != sep) {
> +            fuse_log(FUSE_LOG_ERR,
> +                     "%s: Expecting '%c' found '%c'"
> +                     " after scope in rule %zu\n",
> +                     __func__, sep, *map, nentries + 1);

I think it should be `nentries` here like in the others

> +            exit(1);
> +        }
> +        /* Skip the separator, now at the start of the 'type' */
> +        map++;
> +
> +        /* Start of 'type' */
> +        if (strstart(map, "prefix", &map)) {
> +            res[nentries - 1].flags |= XATTR_MAP_FLAG_PREFIX;
> +        } else if (strstart(map, "ok", &map)) {
> +            res[nentries - 1].flags |= XATTR_MAP_FLAG_END_OK;
> +        } else if (strstart(map, "bad", &map)) {
> +            res[nentries - 1].flags |= XATTR_MAP_FLAG_END_BAD;
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
> +        /* At start of 'key' field */
> +        tmp = strchr(map, sep);
> +        if (!tmp) {
> +            fuse_log(FUSE_LOG_ERR,
> +                     "%s: Missing '%c' at end of key field of rule %zu",
> +                     __func__, sep, nentries);
> +            exit(1);
> +        }
> +        res[nentries - 1].key = g_strndup(map, tmp - map);
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
> +        res[nentries - 1].prepend = g_strndup(map, tmp - map);
> +        map = tmp + 1;
> +        /* End of rule - go around again for another rule */
> +    }
> +
> +    if (!nentries) {
> +        fuse_log(FUSE_LOG_ERR, "Empty xattr map\n");
> +        exit(1);
> +    }
> +
> +    /* Add a terminator to error in cases the user hasn't specified */
> +    res = g_realloc_n(res, ++nentries, sizeof(XattrMapEntry));
> +    res[nentries - 1].flags = XATTR_MAP_FLAG_ALL | XATTR_MAP_FLAG_END_BAD;
> +    res[nentries - 1].key = g_strdup("");
> +    res[nentries - 1].prepend = g_strdup("");
> +
> +    return res;
> +}
> +
>  static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
>                          size_t size)
>  {
> @@ -2909,6 +3052,11 @@ int main(int argc, char *argv[])
>      } else {
>          lo.source = strdup("/");
>      }
> +
> +    if (lo.xattrmap) {
> +        xattr_map_list = parse_xattrmap(lo.xattrmap);

This is never freed. If you put the static in struct lo_data, you could
naturally clean it up in fuse_lo_data_cleanup.

> +    }
> +
>      if (!lo.timeout_set) {
>          switch (lo.cache) {
>          case CACHE_NONE:


--
Cheers,
Christophe de Dinechin (IRC c3d)

