Date: Wed, 17 Mar 2021 11:18:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210317151857.GC324911@redhat.com>
References: <20210316160147.289193-1-vgoyal@redhat.com>
	<YFISL+dvR/qy6P+1@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YFISL+dvR/qy6P+1@suse.de>
Subject: Re: [Virtio-fs] [PATCH 0/1] fuse: acl: Send file mode updates using
	SETATTR
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Luis Henriques <lhenriques@suse.de>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, seth.forshee@canonical.com, miklos@szeredi.hu

On Wed, Mar 17, 2021 at 02:29:03PM +0000, Luis Henriques wrote:
> On Tue, Mar 16, 2021 at 12:01:46PM -0400, Vivek Goyal wrote:
> > Hi Miklos,
> >=20
> > Please find attached a patch to fix the SGID clearing issue upon=20
> > ACL change.=20
> >=20
> > Luis reported that currently fstests generic/375 fails on virtiofs. And
> > reason being that we don't clear SGID when it should be.
> >=20
> > Setting ACL can lead to file mode change. And this in-turn also can
> > lead to clearing SGID bit if.
> >=20
> > - None of caller's groups match file owner group.
> > AND
> > - Caller does not have CAP_FSETID.
> >=20
> > Current implementation relies on server updating the mode. But file
> > server does not have enough information to do so.=20
> >=20
> > Initially I thought of sending CAP_FSETID information to server but
> > then I realized, it is just one of the pieces. What about all the
> > groups caller is a member of. If this has to work correctly, then
> > all the information will have to be sent to virtiofsd somehow. Just
> > sending CAP_FSETID information required adding V2 of fuse_setxattr_in
> > because we don't have any space for sending extra information.
> >=20
> > https://github.com/rhvgoyal/linux/commit/681cf5bdbba9c965c3dbd4337c16e9=
b17f27debe
> >=20
> > Also this approach will not work with idmapped mounts because server
> > does not have information about idmapped mappings.
> >=20
> > So I started to look at the approach of sending file mode updates
> > using SETATTR. As filesystems like 9pfs and ceph are doing. This
> > seems simpler approach. Though it has its issues too.
> >=20
> > - File mode update and setxattr(system.posix_acl_access) are not atomic.
>=20
> After reviewing (and testing) the patch, the only comment I have is that
> we should at least pr_warn() an eventual failure in setxattr().  But f
> that operation fails at that point, probably something went wrong on the
> other side

Hi Luis,

If setxattr failed, user will get the error.=20

I guess pr_warn() could help with figuring out that there was a side affect
of failed failed setxattr operation. (mode changed). I will add something.

> and the kernel is unlikely to be able to revert the mode
> changes anyway.

Interestingly ceph code seems to revert mode changes if setxattr fails.
I think for now I am happy with just a pr_warn().
>=20
> (And a nit: your patch seems to require some whitespaces clean-up.)

Will check it and fix it and post V2.

Thanks
Vivek

>=20
> Cheers,
> --
> Lu=EDs
>=20
>=20
> > None of the approaches seem very clean to me. But sending SETATTR
> > explicitly seems to be lesser of two evils to me at this point of time.
> > Hence I am proposing this patch.=20
> >=20
> > I have run fstests acl tests and they pass. (./check -g acl).
> >=20
> > Corresponding virtiofsd patches are here.
> >=20
> > https://github.com/rhvgoyal/qemu/commits/acl-sgid-setattr
> >=20
> > What do you think.
> >=20
> > Vivek Goyal (1):
> >   fuse: Add a mode where fuse client sends mode changes on ACL change
> >=20
> >  fs/fuse/acl.c             | 54 ++++++++++++++++++++++++++++++++++++---
> >  fs/fuse/dir.c             | 11 ++++----
> >  fs/fuse/fuse_i.h          |  9 ++++++-
> >  fs/fuse/inode.c           |  4 ++-
> >  include/uapi/linux/fuse.h |  5 ++++
> >  5 files changed, 71 insertions(+), 12 deletions(-)
> >=20
> > --=20
> > 2.25.4
> >=20
>=20

