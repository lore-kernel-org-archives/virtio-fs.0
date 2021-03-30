Date: Tue, 30 Mar 2021 10:37:05 +0100
From: Luis Henriques <lhenriques@suse.de>
Message-ID: <YGLxQR5V4d+8mQiK@suse.de>
References: <20210325153852.572927-1-vgoyal@redhat.com>
	<20210325153852.572927-6-vgoyal@redhat.com>
	<YGHz3a9JCAV21Aun@suse.de> <20210329195151.GF676525@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210329195151.GF676525@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v5 5/5] virtiofsd: Switch creds,
 drop FSETID for system.posix_acl_access xattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, miklos@szeredi.hu, qemu-devel@nongnu.org

On Mon, Mar 29, 2021 at 03:51:51PM -0400, Vivek Goyal wrote:
> On Mon, Mar 29, 2021 at 04:35:57PM +0100, Luis Henriques wrote:
> > On Thu, Mar 25, 2021 at 11:38:52AM -0400, Vivek Goyal wrote:
> > > When posix access acls are set on a file, it can lead to adjusting fi=
le
> > > permissions (mode) as well. If caller does not have CAP_FSETID and it
> > > also does not have membership of owner group, this will lead to clear=
ing
> > > SGID bit in mode.
> > >=20
> > > Current fuse code is written in such a way that it expects file server
> > > to take care of chaning file mode (permission), if there is a need.
> > > Right now, host kernel does not clear SGID bit because virtiofsd is
> > > running as root and has CAP_FSETID. For host kernel to clear SGID,
> > > virtiofsd need to switch to gid of caller in guest and also drop
> > > CAP_FSETID (if caller did not have it to begin with).
> > >=20
> > > If SGID needs to be cleared, client will set the flag
> > > FUSE_SETXATTR_ACL_KILL_SGID in setxattr request. In that case server
> > > should kill sgid.
> > >=20
> > > Currently just switch to uid/gid of the caller and drop CAP_FSETID
> > > and that should do it.
> > >=20
> > > This should fix the xfstest generic/375 test case.
> > >=20
> > > We don't have to switch uid for this to work. That could be one optim=
ization
> > > that pass a parameter to lo_change_cred() to only switch gid and not =
uid.
> > >=20
> > > Also this will not work whenever (if ever) we support idmapped mounts=
. In
> > > that case it is possible that uid/gid in request are 0/0 but still we
> > > need to clear SGID. So we will have to pick a non-root sgid and switch
> > > to that instead. That's an TODO item for future when idmapped mount
> > > support is introduced.
> > >=20
> > > Reported-by: Luis Henriques <lhenriques@suse.de>
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > >  include/standard-headers/linux/fuse.h |  7 +++++
> > >  tools/virtiofsd/passthrough_ll.c      | 42 +++++++++++++++++++++++++=
--
> > >  2 files changed, 47 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/include/standard-headers/linux/fuse.h b/include/standard=
-headers/linux/fuse.h
> > > index cc87ff27d0..4eb79399d4 100644
> > > --- a/include/standard-headers/linux/fuse.h
> > > +++ b/include/standard-headers/linux/fuse.h
> > > @@ -180,6 +180,7 @@
> > >   *  - add FUSE_HANDLE_KILLPRIV_V2, FUSE_WRITE_KILL_SUIDGID, FATTR_KI=
LL_SUIDGID
> > >   *  - add FUSE_OPEN_KILL_SUIDGID
> > >   *  - add FUSE_SETXATTR_V2
> > > + *  - add FUSE_SETXATTR_ACL_KILL_SGID
> > >   */
> > > =20
> > >  #ifndef _LINUX_FUSE_H
> > > @@ -450,6 +451,12 @@ struct fuse_file_lock {
> > >   */
> > >  #define FUSE_OPEN_KILL_SUIDGID	(1 << 0)
> > > =20
> > > +/**
> > > + * setxattr flags
> > > + * FUSE_SETXATTR_ACL_KILL_SGID: Clear SGID when system.posix_acl_acc=
ess is set
> > > + */
> > > +#define FUSE_SETXATTR_ACL_KILL_SGID    (1 << 0)
> > > +
> > >  enum fuse_opcode {
> > >  	FUSE_LOOKUP		=3D 1,
> > >  	FUSE_FORGET		=3D 2,  /* no reply */
> > > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passt=
hrough_ll.c
> > > index 3f5c267604..8a48071d0b 100644
> > > --- a/tools/virtiofsd/passthrough_ll.c
> > > +++ b/tools/virtiofsd/passthrough_ll.c
> > > @@ -175,7 +175,7 @@ struct lo_data {
> > >      int user_killpriv_v2, killpriv_v2;
> > >      /* If set, virtiofsd is responsible for setting umask during cre=
ation */
> > >      bool change_umask;
> > > -    int user_posix_acl;
> > > +    int user_posix_acl, posix_acl;
> > >  };
> > > =20
> > >  static const struct fuse_opt lo_opts[] =3D {
> > > @@ -716,8 +716,10 @@ static void lo_init(void *userdata, struct fuse_=
conn_info *conn)
> > >           * in fuse_lowlevel.c
> > >           */
> > >          fuse_log(FUSE_LOG_DEBUG, "lo_init: enabling posix acl\n");
> > > -        conn->want |=3D FUSE_CAP_POSIX_ACL | FUSE_CAP_DONT_MASK;
> > > +        conn->want |=3D FUSE_CAP_POSIX_ACL | FUSE_CAP_DONT_MASK |
> > > +                      FUSE_CAP_SETXATTR_V2;
> >=20
> > An annoying thing with this is that if we're using a kernel without
> > _V2 support the mount will still succeed.  But we'll see:
> >=20
> > ls: cannot access '/mnt': Connection refused
> >=20
> > and in the userspace:
> >=20
> > fuse: error: filesystem requested capabilities 0x20000000 that are not =
supported by kernel, aborting.
> >=20
> > Maybe it would be worth to automatically disable acl support if this
> > happens (with an error message) but still allow the filesystem to be
> > used.
>=20
> If user specific "-o posix_acl" then it is better to fail explicitly
> if posix_acl can't be enabled. If user did not specify anything, then
> it makes sense to automatically disable posix acl  and continue.
>=20
> > Or, which is probably better, to handle the EPROTO error in the
> > kernel during mount.
>=20
> This will have been idea but in fuse, init process handling happens
> asynchronously. That is mount returns to user space while init
> command might complete at a later point of time. So can't return
> -EPROTO at mount time.

Oh, right.  I remember the first time I looked that I found it a bit odd
that fuse_send_init() didn't wait to return an error.  So, my suggestion
isn't feasible.

> So one of the problems seem to be that error message is not very
> clear. How about adding following so that user is clear that posix acl
> can't be enabled.

Thanks, I think this extra information is indeed useful.

Cheers,
--
Lu=EDs

>=20
> Vivek
>=20
> ---
>  tools/virtiofsd/passthrough_ll.c |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>=20
> Index: rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- rhvgoyal-qemu.orig/tools/virtiofsd/passthrough_ll.c	2021-03-29 14:59:=
28.483340964 -0400
> +++ rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c	2021-03-29 15:42:21.79=
7482846 -0400
> @@ -712,10 +712,18 @@ static void lo_init(void *userdata, stru
>      if (lo->user_posix_acl =3D=3D 1) {
>          /*
>           * User explicitly asked for this option. Enable it unconditiona=
lly.
> -         * If connection does not have this capability, it should fail
> -         * in fuse_lowlevel.c
> +         * If connection does not have this capability, give out message
> +         * now. fuse_lowlevel.c will error out.
>           */
> -        fuse_log(FUSE_LOG_DEBUG, "lo_init: enabling posix acl\n");
> +        if (!(conn->capable & FUSE_CAP_POSIX_ACL) ||
> +            !(conn->capable & FUSE_CAP_DONT_MASK) ||
> +            !(conn->capable & FUSE_CAP_SETXATTR_V2)) {
> +            fuse_log(FUSE_LOG_ERR, "lo_init: Can not enable posix acl."
> +                     " kernel does not support FUSE_POSIX_ACL, FUSE_DONT=
_MASK"
> +                     " or FUSE_SETXATTR_V2 capability.\n");
> +        } else {
> +            fuse_log(FUSE_LOG_DEBUG, "lo_init: enabling posix acl\n");
> +        }
>          conn->want |=3D FUSE_CAP_POSIX_ACL | FUSE_CAP_DONT_MASK |
>                        FUSE_CAP_SETXATTR_V2;
>          lo->change_umask =3D true;
>=20
>=20


