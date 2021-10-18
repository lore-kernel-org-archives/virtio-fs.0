Date: Mon, 18 Oct 2021 13:07:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YW2p1NAv5wiOtzDs@redhat.com>
References: <20210916084045.31684-1-hreitz@redhat.com>
	<20210916084045.31684-2-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916084045.31684-2-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 01/12] virtiofsd: Keep
	/proc/self/mountinfo open
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

On Thu, Sep 16, 2021 at 10:40:34AM +0200, Hanna Reitz wrote:
> File handles are specific to mounts, and so name_to_handle_at() returns
> the respective mount ID.  However, open_by_handle_at() is not content
> with an ID, it wants a file descriptor for some inode on the mount,
> which we have to open.
> 
> We want to use /proc/self/mountinfo to find the mounts' root directories
> so we can open them and pass the respective FDs to open_by_handle_at().
> (We need to use the root directory, because we want the inode belonging
> to every mount FD be deletable.  Before the root directory can be
> deleted, all entries within must have been closed, and so when it is
> deleted, there should not be any file handles left that need its FD as
> their mount FD.  Thus, we can then close that FD and the inode can be
> deleted.[1])
> 
> That is why we need to open /proc/self/mountinfo so that we can use it
> to translate mount IDs into root directory paths.  We have to open it
> after setup_mounts() was called, because if we try to open it before, it
> will appear as an empty file after setup_mounts().
> 
> [1] Note that in practice, you still cannot delete the mount root
> directory.  It is a mount point on the host, after all, and mount points
> cannot be deleted.  But by using the mount point as the mount FD, we
> will at least not hog any actually deletable inodes.
> 
> Signed-off-by: Hanna Reitz <hreitz@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 40 ++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 38b2af8599..6511a6acb4 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -172,6 +172,8 @@ struct lo_data {
>  
>      /* An O_PATH file descriptor to /proc/self/fd/ */
>      int proc_self_fd;
> +    /* A read-only FILE pointer for /proc/self/mountinfo */
> +    FILE *mountinfo_fp;
>      int user_killpriv_v2, killpriv_v2;
>      /* If set, virtiofsd is responsible for setting umask during creation */
>      bool change_umask;
> @@ -3718,6 +3720,19 @@ static void setup_chroot(struct lo_data *lo)
>  static void setup_sandbox(struct lo_data *lo, struct fuse_session *se,
>                            bool enable_syslog)
>  {
> +    int proc_self, mountinfo_fd;
> +    int saverr;
> +
> +    /*
> +     * Open /proc/self before we pivot to the new root so we can still
> +     * open /proc/self/mountinfo afterwards
> +     */
> +    proc_self = open("/proc/self", O_PATH);
> +    if (proc_self < 0) {
> +        fuse_log(FUSE_LOG_WARNING, "Failed to open /proc/self: %m; "
> +                 "will not be able to use file handles\n");
> +    }
> +

Hi Hanna,

Should we open /proc/self and /proc/self/mountinfo only if user wants
to file handle. We have already parsed options by now so we know.

Also, if user asked for file handles, and we can't open /proc/self or
/proc/self/mountinfo successfully, I would think we should error out
and not continue (instead of just log it and continue).

That seems to be general theme. If user asked for a feature and if
we can't enable it, we error out and let user retry without that
particular feature.

>      if (lo->sandbox == SANDBOX_NAMESPACE) {
>          setup_namespaces(lo, se);
>          setup_mounts(lo->source);
> @@ -3725,6 +3740,31 @@ static void setup_sandbox(struct lo_data *lo, struct fuse_session *se,
>          setup_chroot(lo);
>      }
>  
> +    /*
> +     * Opening /proc/self/mountinfo before the umount2() call in
> +     * setup_mounts() leads to the file appearing empty.  That is why
> +     * we defer opening it until here.
> +     */
> +    lo->mountinfo_fp = NULL;
> +    if (proc_self >= 0) {
> +        mountinfo_fd = openat(proc_self, "mountinfo", O_RDONLY);
> +        if (mountinfo_fd < 0) {
> +            saverr = errno;
> +        } else if (mountinfo_fd >= 0) {
> +            lo->mountinfo_fp = fdopen(mountinfo_fd, "r");
> +            if (!lo->mountinfo_fp) {
> +                saverr = errno;
> +                close(mountinfo_fd);
> +            }
> +        }
> +        if (!lo->mountinfo_fp) {
> +            fuse_log(FUSE_LOG_WARNING, "Failed to open /proc/self/mountinfo: "
> +                     "%s; will not be able to use file handles\n",
> +                     strerror(saverr));
> +        }
> +        close(proc_self);
> +    }
> +

Above code couple probably be moved in a helper function. Makes it
easier to read setup_sandbox(). Same here, open mountinfo only if
user wants file handle support and error out if file handle support
can't be enabled.

Thanks
Vivek
>      setup_seccomp(enable_syslog);
>      setup_capabilities(g_strdup(lo->modcaps));
>  }
> -- 
> 2.31.1
> 

