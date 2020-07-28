DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=iJLwpsTVnamdBcvWM3pinX7B3nkos738/piCt9lRNMc=;
	b=msblpOIW9d4SS3JGe+spzmO/ebCMAuFn7GsyYwfM1LpjdHgRP6QrIc68CJ4l8BS6K3Mlnu6vdnCFrHAZwLMEjMLtFgguCv+OSqb9av+whTA56VbB+TTyDYQ4jo4dl9acq+tr9ywZNMxnkHxFbvqRU3FTHHQcXYyY8ibBVPYr6AE=
From: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Date: Tue, 28 Jul 2020 01:05:10 +0000
Message-ID: <OSBPR01MB45826073E5A54CF869E56721E5730@OSBPR01MB4582.jpnprd01.prod.outlook.com>
References: <20200727190223.422280-1-stefanha@redhat.com>
	<20200727190223.422280-4-stefanha@redhat.com>
In-Reply-To: <20200727190223.422280-4-stefanha@redhat.com>
Content-Language: ja-JP
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS)
 and print an error
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: 'Stefan Hajnoczi' <stefanha@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Cc: "vromanso@redhat.com" <vromanso@redhat.com>, "rmohr@redhat.com" <rmohr@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "mpatel@redhat.com" <mpatel@redhat.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>

> Subject: [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS) and print an error
> 
> An assertion failure is raised during request processing if
> unshare(CLONE_FS) fails. Implement a probe at startup so the problem can
> be detected right away.
> 
> Unfortunately Docker/Moby does not include unshare in the seccomp.json
> list unless CAP_SYS_ADMIN is given. Other seccomp.json lists always
> include unshare (e.g. podman is unaffected):
> https://raw.githubusercontent.com/seccomp/containers-golang/master/seccomp.json
> 
> Use "docker run --security-opt seccomp=path/to/seccomp.json ..." if the
> default seccomp.json is missing unshare.

Hi, sorry for a bit late.

unshare() was added to fix xattr problem: 
  https://github.com/qemu/qemu/commit/bdfd66788349acc43cd3f1298718ad491663cfcc#
In theory we don't need to call unshare if xattr is disabled, but it is hard to get to know
if xattr is enabled or disabled in fv_queue_worker(), right?

So, it looks good to me.
Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Regards,
Misono

> 
> Cc: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  tools/virtiofsd/fuse_virtio.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index 3b6d16a041..9e5537506c 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -949,6 +949,22 @@ int virtio_session_mount(struct fuse_session *se)
>  {
>      int ret;
> 
> +    /*
> +     * Test that unshare(CLONE_FS) works. fv_queue_worker() will need it. It's
> +     * an unprivileged system call but some Docker/Moby versions are known to
> +     * reject it via seccomp when CAP_SYS_ADMIN is not given.
> +     *
> +     * Note that the program is single-threaded here so this syscall has no
> +     * visible effect and is safe to make.
> +     */
> +    ret = unshare(CLONE_FS);
> +    if (ret == -1 && errno == EPERM) {
> +        fuse_log(FUSE_LOG_ERR, "unshare(CLONE_FS) failed with EPERM. If "
> +                "running in a container please check that the container "
> +                "runtime seccomp policy allows unshare.\n");
> +        return -1;
> +    }
> +
>      ret = fv_create_listen_socket(se);
>      if (ret < 0) {
>          return ret;
> --
> 2.26.2


