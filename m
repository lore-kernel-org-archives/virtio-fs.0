Date: Wed, 23 Feb 2022 11:18:35 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20220223111835.00ef0e83@bahia>
In-Reply-To: <20220223092340.9043-1-hreitz@redhat.com>
References: <20220223092340.9043-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Let meson check for
 statx.stx_mnt_id
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Reitz <hreitz@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Wed, 23 Feb 2022 10:23:40 +0100
Hanna Reitz <hreitz@redhat.com> wrote:

> In virtiofsd, we assume that the presence of the STATX_MNT_ID macro
> implies existence of the statx.stx_mnt_id field.  Unfortunately, that is
> not necessarily the case: glibc has introduced the macro in its commit
> 88a2cf6c4bab6e94a65e9c0db8813709372e9180, but the statx.stx_mnt_id field
> is still missing from its own headers.
> 
> Let meson.build actually chek for both STATX_MNT_ID and
> statx.stx_mnt_id, and set CONFIG_STATX_MNT_ID if both are present.
> Then, use this config macro in virtiofsd.
> 
> Closes: https://gitlab.com/qemu-project/qemu/-/issues/882
> Signed-off-by: Hanna Reitz <hreitz@redhat.com>
> ---

Reviewed-by: Greg Kurz <groug@kaod.org>

>  meson.build                      | 13 +++++++++++++
>  tools/virtiofsd/passthrough_ll.c |  2 +-
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/meson.build b/meson.build
> index 8df40bfac4..a5b63e62cd 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -1306,6 +1306,18 @@ statx_test = gnu_source_prefix + '''
>  
>  has_statx = cc.links(statx_test)
>  
> +# Check whether statx() provides mount ID information
> +
> +statx_mnt_id_test = gnu_source_prefix + '''
> +  #include <sys/stat.h>
> +  int main(void) {
> +    struct statx statxbuf;
> +    statx(0, "", 0, STATX_BASIC_STATS | STATX_MNT_ID, &statxbuf);
> +    return statxbuf.stx_mnt_id;
> +  }'''
> +
> +has_statx_mnt_id = cc.links(statx_mnt_id_test)
> +
>  have_vhost_user_blk_server = get_option('vhost_user_blk_server') \
>    .require(targetos == 'linux',
>             error_message: 'vhost_user_blk_server requires linux') \
> @@ -1553,6 +1565,7 @@ config_host_data.set('CONFIG_NETTLE', nettle.found())
>  config_host_data.set('CONFIG_QEMU_PRIVATE_XTS', xts == 'private')
>  config_host_data.set('CONFIG_MALLOC_TRIM', has_malloc_trim)
>  config_host_data.set('CONFIG_STATX', has_statx)
> +config_host_data.set('CONFIG_STATX_MNT_ID', has_statx_mnt_id)
>  config_host_data.set('CONFIG_ZSTD', zstd.found())
>  config_host_data.set('CONFIG_FUSE', fuse.found())
>  config_host_data.set('CONFIG_FUSE_LSEEK', fuse_lseek.found())
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index dfa2fc250d..028dacdd8f 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -1039,7 +1039,7 @@ static int do_statx(struct lo_data *lo, int dirfd, const char *pathname,
>  {
>      int res;
>  
> -#if defined(CONFIG_STATX) && defined(STATX_MNT_ID)
> +#if defined(CONFIG_STATX) && defined(CONFIG_STATX_MNT_ID)
>      if (lo->use_statx) {
>          struct statx statxbuf;
>  

