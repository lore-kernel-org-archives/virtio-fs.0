Date: Wed, 20 Oct 2021 08:31:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YXAMH1nyfM+IA4Ce@redhat.com>
References: <YWWMO/ZDrvDZ5X4c@redhat.com>
	<CAHC9VhRv8xOoPtfpSYSvUrcHUjhqQWw5LiDSfwR2f4VJ=9Qr8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRv8xOoPtfpSYSvUrcHUjhqQWw5LiDSfwR2f4VJ=9Qr8Q@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v2] security: Return xattr name from
 security_dentry_init_security()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Paul Moore <paul@paul-moore.com>
Cc: bfields@fieldses.org, linux-nfs@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, selinux@vger.kernel.org, Stephen Smalley <stephen.smalley.work@gmail.com>, jlayton@kernel.org, James Morris <jmorris@namei.org>, anna.schumaker@netapp.com, virtio-fs@redhat.com, casey@schaufler-ca.com, linux-security-module@vger.kernel.org, chuck.lever@oracle.com, linux-fsdevel@vger.kernel.org, idryomov@gmail.com, ceph-devel@vger.kernel.org, trond.myklebust@hammerspace.com, Serge Hallyn <serge@hallyn.com>

On Wed, Oct 20, 2021 at 08:24:44AM -0400, Paul Moore wrote:
> On Tue, Oct 12, 2021 at 9:23 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Right now security_dentry_init_security() only supports single security
> > label and is used by SELinux only. There are two users of of this hook,
> > namely ceph and nfs.
> >
> > NFS does not care about xattr name. Ceph hardcodes the xattr name to
> > security.selinux (XATTR_NAME_SELINUX).
> >
> > I am making changes to fuse/virtiofs to send security label to virtiofsd
> > and I need to send xattr name as well. I also hardcoded the name of
> > xattr to security.selinux.
> >
> > Stephen Smalley suggested that it probably is a good idea to modify
> > security_dentry_init_security() to also return name of xattr so that
> > we can avoid this hardcoding in the callers.
> >
> > This patch adds a new parameter "const char **xattr_name" to
> > security_dentry_init_security() and LSM puts the name of xattr
> > too if caller asked for it (xattr_name != NULL).
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > Reviewed-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >
> > Changes since v1:
> > - Updated comment to make it clear caller does not have to free the
> >   xattr_name. (Jeff Layton).
> > - Captured Jeff's Reviewed-by ack.
> >
> > I have tested this patch with virtiofs and compile tested for ceph and nfs.
> >
> > NFS changes are trivial. Looking for an ack from NFS maintainers.
> >
> > ---
> >  fs/ceph/xattr.c               |    3 +--
> >  fs/nfs/nfs4proc.c             |    3 ++-
> >  include/linux/lsm_hook_defs.h |    3 ++-
> >  include/linux/lsm_hooks.h     |    3 +++
> >  include/linux/security.h      |    6 ++++--
> >  security/security.c           |    7 ++++---
> >  security/selinux/hooks.c      |    6 +++++-
> >  7 files changed, 21 insertions(+), 10 deletions(-)
> 
> This looks fine to me and considering the trivial nature of the NFS
> changes I'm okay with merging this without an explicit ACK from the
> NFS folks.  Similarly, I generally dislike merging new functionality
> once we hit -rc6, but this is trivial enough that I think it's okay;
> I'm merging this into selinux/next now, thanks everyone.

Thanks Paul. I agree that this a trivial fix with no functionality
change and probability of this breaking something is very very low.

Vivek

