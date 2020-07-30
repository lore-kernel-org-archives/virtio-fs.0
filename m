Date: Thu, 30 Jul 2020 09:59:37 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <20200730085937.GA3477223@redhat.com>
References: <20200729221410.147556-1-vgoyal@redhat.com>
	<20200729221410.147556-3-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200729221410.147556-3-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/5] virtiofsd: create lock/pid file in per
	user cache dir
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, vromanso@redhat.com, qemu-devel@nongnu.org

On Wed, Jul 29, 2020 at 06:14:07PM -0400, Vivek Goyal wrote:
> Right now we create lock/pid file in /usr/local/var/... and unprivliged
> user does not have access to create files there.
> 
> So create this file in per user cache dir as queried as specified
> by environment variable XDG_RUNTIME_DIR.
> 
> Note: "su $USER" does not update XDG_RUNTIME_DIR and it still points to
> root user's director. So for now I create a directory /tmp/$UID to save
> lock/pid file. Dan pointed out that it can be a problem if a malicious
> app already has /tmp/$UID created. So we probably need to get rid of this.

IMHO use of "su $USER" is simply user error and we don't need to
care about workarounds. They will see the startup fail due to
EPERM on /run/user/0 directory, and then they'll have to fix
their command to use "su - $USER" to setup a clean environment.


> +    /*
> +     * Unpriviliged users don't have access to /usr/local/var. Hence
> +     * store lock/pid file in per user directory. Use environment
> +     * variable XDG_RUNTIME_DIR.
> +     * If one logs into the system as root and then does "su" then
> +     * XDG_RUNTIME_DIR still points to root user directory. In that
> +     * case create a directory for user in /tmp/$UID
> +     */
> +    if (unprivileged) {
> +        gchar *user_dir = NULL;
> +        gboolean create_dir = false;
> +        user_dir = g_strdup(g_get_user_runtime_dir());
> +        if (!user_dir || g_str_has_suffix(user_dir, "/0")) {
> +            user_dir = g_strdup_printf("/tmp/%d", geteuid());
> +            create_dir = true;
> +        }

As above, I don't think we need to have this fallback code to deal
with something that is just user error.

Also, g_get_user_runtime_dir() is guaranteed to return non-NULL.

> +
> +        if (create_dir && g_mkdir_with_parents(user_dir, S_IRWXU) < 0) {
> +            fuse_log(FUSE_LOG_ERR, "%s: Failed to create directory %s: %s",
> +                     __func__, user_dir, strerror(errno));
> +            g_free(user_dir);
> +            return false;
> +        }
> +        dir = g_strdup(user_dir);

Don't we also want to be appending "virtiofsd" to this directory path
like we do in the privileged case ?


> +        g_free(user_dir);
> +    } else {
> +        dir = qemu_get_local_state_pathname("run/virtiofsd");
> +        if (g_mkdir_with_parents(dir, S_IRWXU) < 0) {
> +            fuse_log(FUSE_LOG_ERR, "%s: Failed to create directory %s: %s",
> +                     __func__, dir, strerror(errno));
> +            return false;
> +        }
>      }
>  
>      sk_name = g_strdup(se->vu_socket_path);
> -- 
> 2.25.4
> 

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

