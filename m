Date: Wed, 9 Jun 2021 09:45:47 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210609094547.222fc420@bahia.lan>
In-Reply-To: <0d3b4dfb-2474-2200-80d1-39dcbf8f626e@redhat.com>
References: <20210604161156.408496-1-groug@kaod.org>
	<20210604161156.408496-7-groug@kaod.org>
	<0d3b4dfb-2474-2200-80d1-39dcbf8f626e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v2 6/7] fuse: Switch to fc_mount() for
	submounts
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

On Tue, 8 Jun 2021 17:51:03 +0200
Max Reitz <mreitz@redhat.com> wrote:

> On 04.06.21 18:11, Greg Kurz wrote:
> > fc_mount() already handles the vfs_get_tree(), sb->s_umount
> > unlocking and vfs_create_mount() sequence. Using it greatly
> > simplifies fuse_dentry_automount().
> >
> > Signed-off-by: Greg Kurz <groug@kaod.org>
> > ---
> >   fs/fuse/dir.c | 26 +++++---------------------
> >   1 file changed, 5 insertions(+), 21 deletions(-)
> >
> > diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> > index b88e5785a3dd..fc9eddf7f9b2 100644
> > --- a/fs/fuse/dir.c
> > +++ b/fs/fuse/dir.c
> > @@ -311,38 +311,22 @@ static struct vfsmount *fuse_dentry_automount(struct path *path)
> >   	struct fs_context *fsc;
> >   	struct vfsmount *mnt;
> >   	struct fuse_inode *mp_fi = get_fuse_inode(d_inode(path->dentry));
> > -	int err;
> >   
> >   	fsc = fs_context_for_submount(path->mnt->mnt_sb->s_type, path->dentry);
> > -	if (IS_ERR(fsc)) {
> > -		err = PTR_ERR(fsc);
> > -		goto out;
> > -	}
> > +	if (IS_ERR(fsc))
> > +		return (struct vfsmount *) fsc;
> 
> I think ERR_CAST(fsc) would be nicer.
> 

Indeed. I'll fix that if I need to repost.

> Apart from that:
> 
> Reviewed-by: Max Reitz <mreitz@redhat.com>
> 

