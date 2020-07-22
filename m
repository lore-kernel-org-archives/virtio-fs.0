Date: Wed, 22 Jul 2020 18:03:28 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <20200722170328.GU2324845@redhat.com>
References: <20200722130206.224898-1-stefanha@redhat.com>
	<20200722130206.224898-4-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200722130206.224898-4-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH for-5.1 3/3] virtiofsd: probe
 unshare(CLONE_FS) and print an error
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: vromanso@redhat.com, qemu-devel@nongnu.org, virtio-fs@redhat.com, rmohr@redhat.com

On Wed, Jul 22, 2020 at 02:02:06PM +0100, Stefan Hajnoczi wrote:
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
> 
> Cc: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  tools/virtiofsd/fuse_virtio.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index 3b6d16a041..ebeb352514 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -949,6 +949,19 @@ int virtio_session_mount(struct fuse_session *se)
>  {
>      int ret;
>  
> +    /*
> +     * Test that unshare(CLONE_FS) works. fv_queue_worker() will need it. It's
> +     * an unprivileged system call but some Docker/Moby versions are known to
> +     * reject it via seccomp when CAP_SYS_ADMIN is not given.
> +     */
> +    ret = unshare(CLONE_FS);
> +    if (ret == -1 && errno == EPERM) {
> +        fuse_log(FUSE_LOG_ERR, "unshare(CLONE_FS) failed with EPERM. If "
> +                "running in a container please check that the container "
> +                "runtime seccomp policy allows unshare.\n");
> +        return -1;
> +    }
> +

This describes the unshare() call as a "probe" and a "test", but that's
misleading IMHO. A "probe" / "test" implies that after it has completed,
there's no lingering side-effect, which isn't the case here.

This is actively changing the process' namespace environment in the
success case, and not putting it back how it was originally.

May be this is in fact OK, but if so I think the commit message and
comment should explain/justify what its fine to have this lingering
side-effect.

If we want to avoid the side-effect then we need to fork() and run
unshare() in the child, and use a check of exit status of the child
to determine the result.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

