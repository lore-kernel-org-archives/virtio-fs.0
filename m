Date: Sun, 14 Mar 2021 19:36:28 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210314233628.GD223210@redhat.com>
References: <20210312141003.819108-1-groug@kaod.org>
	<20210312141003.819108-3-groug@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312141003.819108-3-groug@kaod.org>
Subject: Re: [Virtio-fs] [PATCH 2/3] virtiofsd: Convert some functions to
 return bool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Fri, Mar 12, 2021 at 03:10:02PM +0100, Greg Kurz wrote:
> Both currently only return 0 or 1.
> 
> Signed-off-by: Greg Kurz <groug@kaod.org>

Looks good to me.

Reviewed-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  tools/virtiofsd/passthrough_ll.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 27a6c636dcaf..f63016d35626 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -221,17 +221,17 @@ static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st,
>  static int xattr_map_client(const struct lo_data *lo, const char *client_name,
>                              char **out_name);
>  
> -static int is_dot_or_dotdot(const char *name)
> +static bool is_dot_or_dotdot(const char *name)
>  {
>      return name[0] == '.' &&
>             (name[1] == '\0' || (name[1] == '.' && name[2] == '\0'));
>  }
>  
>  /* Is `path` a single path component that is not "." or ".."? */
> -static int is_safe_path_component(const char *path)
> +static bool is_safe_path_component(const char *path)
>  {
>      if (strchr(path, '/')) {
> -        return 0;
> +        return false;
>      }
>  
>      return !is_dot_or_dotdot(path);
> -- 
> 2.26.2
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs

