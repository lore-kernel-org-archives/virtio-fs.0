References: <e5914ad202a13e9c1bc2a5efa267ff3bd4f48db6.1625173475.git.hubert.jasudowicz@gmail.com>
From: Laurent Vivier <laurent@vivier.eu>
Message-ID: <bcedbdaf-f09a-0679-5bd5-bb2f97a9dc39@vivier.eu>
Date: Fri, 9 Jul 2021 11:06:34 +0200
MIME-Version: 1.0
In-Reply-To: <e5914ad202a13e9c1bc2a5efa267ff3bd4f48db6.1625173475.git.hubert.jasudowicz@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: fr
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Add missing newline in error
	message
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hubert Jasudowicz <hubert.jasudowicz@gmail.com>, qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, qemu-trivial@nongnu.org

Le 01/07/2021 à 23:11, Hubert Jasudowicz a écrit :
> From: Hubert Jasudowicz <hubert.jasudowicz@gmail.com>
> 
> Signed-off-by: Hubert Jasudowicz <hubert.jasudowicz@gmail.com>
> ---
>  tools/virtiofsd/fuse_virtio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index fa4aff9b0e..fc2564a603 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -917,7 +917,7 @@ static bool fv_socket_lock(struct fuse_session *se)
>      dir = qemu_get_local_state_pathname("run/virtiofsd");
>  
>      if (g_mkdir_with_parents(dir, S_IRWXU) < 0) {
> -        fuse_log(FUSE_LOG_ERR, "%s: Failed to create directory %s: %s",
> +        fuse_log(FUSE_LOG_ERR, "%s: Failed to create directory %s: %s\n",
>                   __func__, dir, strerror(errno));
>          return false;
>      }
> 
Applied to my trivial-patches branch.

Thanks,
Laurent

