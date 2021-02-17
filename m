DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=iGNOIOy2GJaYx3HOn2Z3RLtBKccx+R0p/5yVtYw9ok4=;
	b=D+1vgZDiWyROF/evG30igtWDyAjFPZhBACNTdWWzns/kgwnqMe8veh/jWWTSPEgYmZ
	i7iOuksrQPAxFuL4GNGZ/8AbPp/UR+DOW/rQGbFlErYXPIfNx33rIbGpZL+HeEK0I8/s
	obSSxS0jSqziioYDb/YwT/E17z+jgxNrAzOnI=
MIME-Version: 1.0
References: <20210216233611.33400-1-vgoyal@redhat.com>
	<20210216233611.33400-2-vgoyal@redhat.com>
In-Reply-To: <20210216233611.33400-2-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 17 Feb 2021 09:53:04 +0100
Message-ID: <CAJfpegspJGL_W+8zaXyHfuAhtB_Q7V0YyOZJEhpCd=KaL_W71A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 1/3] virtiofsd: Add an option to
	enable/disable posix acls
List-Id: Development discussions about virtio-fs <virtio-fs.listman.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@listman.redhat.com>
List-Help: <mailto:virtio-fs-request@listman.redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Wed, Feb 17, 2021 at 12:36 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> fuse has an option FUSE_POSIX_ACL which needs to be opted in by fuse
> server to enable posix acls.
>
> Add virtiofsd option "-o posix_acl/no_posix_acl" to let users enable/disable
> posix acl support. By default it is disabled as of now.

If I read the code correctly, then no_posix_acl will still result in
system.posix_acl_* xattr ops being passed through to virtiofsd, which
will forward them to the underlying fs, resulting in posix acls
appearing to work, but doing so incorrectly (i.e. no change from
previous behavior).   Possibly better would be to have three different
modes of operation:

1) no option: default fall back to broken acl support for backward
compat (this could be removed in the future)
2) no_posix_acl: really disable acl support
3) posix_acl: enable proper acl support

Thanks,
Miklos

