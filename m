References: <20210312141003.819108-1-groug@kaod.org>
	<20210312141003.819108-3-groug@kaod.org>
From: Connor Kuehl <ckuehl@redhat.com>
Message-ID: <0203832e-bed5-cf64-872e-33bffae30674@redhat.com>
Date: Fri, 12 Mar 2021 09:13:39 -0600
MIME-Version: 1.0
In-Reply-To: <20210312141003.819108-3-groug@kaod.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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
To: Greg Kurz <groug@kaod.org>, qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com

On 3/12/21 8:10 AM, Greg Kurz wrote:
> Both currently only return 0 or 1.
> 
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>   tools/virtiofsd/passthrough_ll.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 27a6c636dcaf..f63016d35626 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -221,17 +221,17 @@ static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st,
>   static int xattr_map_client(const struct lo_data *lo, const char *client_name,
>                               char **out_name);
>   
> -static int is_dot_or_dotdot(const char *name)
> +static bool is_dot_or_dotdot(const char *name)
>   {
>       return name[0] == '.' &&
>              (name[1] == '\0' || (name[1] == '.' && name[2] == '\0'));
>   }
>   
>   /* Is `path` a single path component that is not "." or ".."? */
> -static int is_safe_path_component(const char *path)
> +static bool is_safe_path_component(const char *path)
>   {
>       if (strchr(path, '/')) {
> -        return 0;
> +        return false;
>       }
>   
>       return !is_dot_or_dotdot(path);
> 

Reviewed-by: Connor Kuehl <ckuehl@redhat.com>

