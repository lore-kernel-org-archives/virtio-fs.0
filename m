Date: Tue, 23 Mar 2021 18:50:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210323225046.GH483930@redhat.com>
References: <20210319195547.427371-1-vgoyal@redhat.com>
	<20210319195547.427371-2-vgoyal@redhat.com>
	<CAHpGcMKhFxotKDxPryfKdhNMMDWO4Ws33s6fEm2NP0u_4vffnQ@mail.gmail.com>
	<20210320100322.ox5gzgauo7iqf2fv@gmail.com>
	<20210322170111.GE446288@redhat.com>
	<20210323093233.iyl4k6x432ytb72c@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210323093233.iyl4k6x432ytb72c@wittgenstein>
Subject: Re: [Virtio-fs] [PATCH 1/3] posic_acl: Add a helper determine if
 SGID should be cleared
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Andreas =?iso-8859-1?Q?Gr=FCnbacher?= <andreas.gruenbacher@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, Seth Forshee <seth.forshee@canonical.com>, Christian Brauner <christian.brauner@canonical.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>

On Tue, Mar 23, 2021 at 10:32:33AM +0100, Christian Brauner wrote:
> On Mon, Mar 22, 2021 at 01:01:11PM -0400, Vivek Goyal wrote:
> > On Sat, Mar 20, 2021 at 11:03:22AM +0100, Christian Brauner wrote:
> > > On Fri, Mar 19, 2021 at 11:42:48PM +0100, Andreas Gr=FCnbacher wrote:
> > > > Hi,
> > > >=20
> > > > Am Fr., 19. M=E4rz 2021 um 20:58 Uhr schrieb Vivek Goyal <vgoyal@re=
dhat.com>:
> > > > > posix_acl_update_mode() determines what's the equivalent mode and=
 if SGID
> > > > > needs to be cleared or not. I need to make use of this code in fu=
se
> > > > > as well. Fuse will send this information to virtiofs file server =
and
> > > > > file server will take care of clearing SGID if it needs to be don=
e.
> > > > >
> > > > > Hence move this code in a separate helper so that more than one p=
lace
> > > > > can call into it.
> > > > >
> > > > > Cc: Jan Kara <jack@suse.cz>
> > > > > Cc: Andreas Gruenbacher <agruenba@redhat.com>
> > > > > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > > > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > > > ---
> > > > >  fs/posix_acl.c            |  3 +--
> > > > >  include/linux/posix_acl.h | 11 +++++++++++
> > > > >  2 files changed, 12 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/fs/posix_acl.c b/fs/posix_acl.c
> > > > > index f3309a7edb49..2d62494c4a5b 100644
> > > > > --- a/fs/posix_acl.c
> > > > > +++ b/fs/posix_acl.c
> > > > > @@ -684,8 +684,7 @@ int posix_acl_update_mode(struct user_namespa=
ce *mnt_userns,
> > > > >                 return error;
> > > > >         if (error =3D=3D 0)
> > > > >                 *acl =3D NULL;
> > > > > -       if (!in_group_p(i_gid_into_mnt(mnt_userns, inode)) &&
> > > > > -           !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSET=
ID))
> > > > > +       if (posix_acl_mode_clear_sgid(mnt_userns, inode))
> > > > >                 mode &=3D ~S_ISGID;
> > > > >         *mode_p =3D mode;
> > > > >         return 0;
> > > > > diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
> > > > > index 307094ebb88c..073c5e546de3 100644
> > > > > --- a/include/linux/posix_acl.h
> > > > > +++ b/include/linux/posix_acl.h
> > > > > @@ -59,6 +59,17 @@ posix_acl_release(struct posix_acl *acl)
> > > > >  }
> > > > >
> > > > >
> > > > > +static inline bool
> > > > > +posix_acl_mode_clear_sgid(struct user_namespace *mnt_userns,
> > > > > +                         struct inode *inode)
> > > > > +{
> > > > > +       if (!in_group_p(i_gid_into_mnt(mnt_userns, inode)) &&
> > > > > +           !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSET=
ID))
> > > > > +               return true;
> > > > > +
> > > > > +       return false;
> > > >=20
> > > > That's just
> > > >=20
> > > > return !in_group_p(i_gid_into_mnt(mnt_userns, inode)) &&
> > > >     !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID);
> > > >=20
> > > > The same pattern we have in posix_acl_update_mode also exists in
> > > > setattr_copy and inode_init_owner, and almost the same pattern exis=
ts
> > > > in setattr_prepare, so can this be cleaned up as well? The function
> > > > also isn't POSIX ACL specific, so the function name is misleading.
> > >=20
> > > Good idea but that should probably be spun into a separate patchset t=
hat
> > > only touches the vfs parts.
> >=20
> > IIUC, suggestion is that I should write a VFS helper (and not posix
> > acl helper) and use that helper at other places too in the code.=20
>=20
> If there are other callers outside of acls (which should be iirc) then
> yes.
>=20
> >=20
> > I will do that and post in a separate patch series.
>=20
> Yeah, I think that makes more sense to have this be a separate change
> instead of putting it together with the fuse change if it touches more
> than one place.

I do see that there are few places where this pattern is used and atleast
some of them should be straight forward conversion.

I will follow this up in separate patch series. I suspect that this
might take little bit of back and forth, so will follow with fuse
changes in parallel and open code there. Once this series gets merged
will send another patch for fuse.

Thanks
Vivek

