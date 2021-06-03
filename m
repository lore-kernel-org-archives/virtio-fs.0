Date: Thu, 3 Jun 2021 09:34:17 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210603093333.154c23ac@bahia.lan>
In-Reply-To: <7b4a3379-3004-98f2-841c-386ce62c888a@redhat.com>
References: <20210525150230.157586-1-groug@kaod.org>
	<20210525150230.157586-4-groug@kaod.org>
	<7b4a3379-3004-98f2-841c-386ce62c888a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 3/4] fuse: Call vfs_get_tree() for submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, 27 May 2021 15:24:40 +0200
Max Reitz <mreitz@redhat.com> wrote:

> On 25.05.21 17:02, Greg Kurz wrote:
> > We recently fixed an infinite loop by setting the SB_BORN flag on
> > submounts along with the write barrier needed by super_cache_count().
> > This is the job of vfs_get_tree() and FUSE shouldn't have to care
> > about the barrier at all.
> > 
> > Split out some code from fuse_dentry_automount() to a new dedicated
> > fuse_get_tree_submount() handler for submounts and call vfs_get_tree().
> > 
> > The fs_private field of the filesystem context isn't used with
> > submounts : hijack it to pass the FUSE inode of the mount point
> > down to fuse_get_tree_submount().
> 
> What exactly do you mean by “isn’t used”?  virtio_fs_init_fs_context() 
> still sets it (it is non-NULL in fuse_dentry_automount() after 
> fs_context_for_submount()).  It does appear like it is never read, but 
> one thing that definitely would need to be done is for it to be freed 
> before putting mp_fi there.
> 

Oops... yes it should. Thanks for the catch !

> So I think it may technically be fine to use this field, but then 
> virtio_fs_init_fs_context() shouldn’t set it for submounts (should be 
> discernible with fsc->purpose), and perhaps that should be a separate patch.
> 

Yes, I'll do just that.

> (Apart from that, this patch looks good to me, though.)
> 
> Max
> 
> > Finally, adapt virtiofs to use this.
> > 
> > Signed-off-by: Greg Kurz <groug@kaod.org>
> > ---
> >   fs/fuse/dir.c       | 58 +++++++--------------------------------------
> >   fs/fuse/fuse_i.h    |  6 +++++
> >   fs/fuse/inode.c     | 44 ++++++++++++++++++++++++++++++++++
> >   fs/fuse/virtio_fs.c |  3 +++
> >   4 files changed, 62 insertions(+), 49 deletions(-)
> 


