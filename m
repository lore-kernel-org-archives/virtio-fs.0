Date: Wed, 17 Feb 2021 10:07:21 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210217150721.GB31184@redhat.com>
References: <20210216233611.33400-1-vgoyal@redhat.com>
	<20210216233611.33400-2-vgoyal@redhat.com>
	<CAJfpegspJGL_W+8zaXyHfuAhtB_Q7V0YyOZJEhpCd=KaL_W71A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegspJGL_W+8zaXyHfuAhtB_Q7V0YyOZJEhpCd=KaL_W71A@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 1/3] virtiofsd: Add an option to
	enable/disable posix acls
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Wed, Feb 17, 2021 at 09:53:04AM +0100, Miklos Szeredi wrote:
> On Wed, Feb 17, 2021 at 12:36 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > fuse has an option FUSE_POSIX_ACL which needs to be opted in by fuse
> > server to enable posix acls.
> >
> > Add virtiofsd option "-o posix_acl/no_posix_acl" to let users enable/disable
> > posix acl support. By default it is disabled as of now.
> 
> If I read the code correctly, then no_posix_acl will still result in
> system.posix_acl_* xattr ops being passed through to virtiofsd, which
> will forward them to the underlying fs, resulting in posix acls
> appearing to work, but doing so incorrectly (i.e. no change from
> previous behavior).

Yes, and this is confuing me a lot. fuse server has not indicated
support for POSIX_ACL, still user can get and set ACLs. fuse_xattr_get()
and fuse_xattr_set() must be kicking in.

I do see that we have fuse_no_acl_xattr_handlers and that should
be able to block setting/getting acls if acl support is not there
but we register it only if we are not mounted in init_user_ns.

        if (sb->s_user_ns != &init_user_ns)
                sb->s_xattr = fuse_no_acl_xattr_handlers;

So question is, should fuse client be fixed as well to block setting
and getting acls if fuse server does not support ACL? Or we now need
to keep it around for backward compatibility.

> Possibly better would be to have three different
> modes of operation:
> 
> 1) no option: default fall back to broken acl support for backward
> compat (this could be removed in the future)

What about FUSE_DONT_MASK in this mode. ACLs are not enabled but
user can get/set these. Should that mean we still honor default
acl and not apply umask?

Probably I should opt for FUSE_DONT_MASK only if posix_acl support is
enabled. Given this does not work even today (atleast for virtiofs), so
it is not a backward compatibility issue. And its confusing anyway.

> 2) no_posix_acl: really disable acl support

That is block getting and setting system.posix_acl xattr. Will do that.
I think we will have to block it even if somebody has remapped xattrs
in virtiofsd.

> 3) posix_acl: enable proper acl support

Thanks
Vivek

> 
> Thanks,
> Miklos
> 

