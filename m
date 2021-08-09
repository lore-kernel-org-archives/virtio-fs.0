Date: Mon, 9 Aug 2021 11:21:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YRFH+vE30fwgGmu8@redhat.com>
References: <20210730150134.216126-1-mreitz@redhat.com>
	<20210730150134.216126-8-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730150134.216126-8-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 07/10] virtiofsd: Add lo_inode.fhandle
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Fri, Jul 30, 2021 at 05:01:31PM +0200, Max Reitz wrote:
> This new field is an alternative to lo_inode.fd: Either of the two must
> be set.  In case an O_PATH FD is needed for some lo_inode, it is either
> taken from lo_inode.fd, if valid, or a temporary FD is opened with
> open_by_handle_at().
> 
> Using a file handle instead of an FD has the advantage of keeping the
> number of open file descriptors low.
> 
> Because open_by_handle_at() requires a mount FD (i.e. a non-O_PATH FD
> opened on the filesystem to which the file handle refers), but every
> lo_fhandle only has a mount ID (as returned by name_to_handle_at()), we
> keep a hash map of such FDs in mount_fds (mapping ID to FD).
> get_file_handle(), which is added by a later patch, will ensure that
> every mount ID for which we have generated a handle has a corresponding
> entry in mount_fds.
> 
> Signed-off-by: Max Reitz <mreitz@redhat.com>
> Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c      | 116 ++++++++++++++++++++++----
>  tools/virtiofsd/passthrough_seccomp.c |   1 +
>  2 files changed, 102 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 292b7f7e27..487448d666 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -88,8 +88,25 @@ struct lo_key {
>      uint64_t mnt_id;
>  };
>  
> +struct lo_fhandle {
> +    union {
> +        struct file_handle handle;
> +        char padding[sizeof(struct file_handle) + MAX_HANDLE_SZ];
> +    };
> +    int mount_id;
> +};
> +
> +/* Maps mount IDs to an FD that we can pass to open_by_handle_at() */
> +static GHashTable *mount_fds;
> +pthread_rwlock_t mount_fds_lock = PTHREAD_RWLOCK_INITIALIZER;
> +

How about if we move this hash table inside "struct lo_data". That seems to
be one global data structure keeping all the info. Also it can be
cleaned up during lo_destroy().

Thanks
Vivek

