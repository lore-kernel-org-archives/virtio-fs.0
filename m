Date: Fri, 24 Sep 2021 19:32:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YU5gF9xDhj4g+0Oe@redhat.com>
References: <20210924192442.916927-1-vgoyal@redhat.com>
	<20210924192442.916927-3-vgoyal@redhat.com>
	<a02d3e08-3abc-448a-be32-2640d8a991e0@www.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a02d3e08-3abc-448a-be32-2640d8a991e0@www.fastmail.com>
Subject: Re: [Virtio-fs] [PATCH 2/2] fuse: Send security context of inode on
	file creation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Colin Walters <walters@verbum.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, selinux@vger.kernel.org, stephen.smalley.work@gmail.com, virtio-fs@redhat.com, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Fri, Sep 24, 2021 at 06:00:10PM -0400, Colin Walters wrote:
> 
> 
> On Fri, Sep 24, 2021, at 3:24 PM, Vivek Goyal wrote:
> > When a new inode is created, send its security context to server along
> > with creation request (FUSE_CREAT, FUSE_MKNOD, FUSE_MKDIR and FUSE_SYMLINK).
> > This gives server an opportunity to create new file and set security
> > context (possibly atomically). In all the configurations it might not
> > be possible to set context atomically.
> >
> > Like nfs and ceph, use security_dentry_init_security() to dermine security
> > context of inode and send it with create, mkdir, mknod, and symlink requests.
> >
> > Following is the information sent to server.
> >
> > - struct fuse_secctx.
> >   This contains total size of security context which follows this structure.
> >
> > - xattr name string.
> >   This string represents name of xattr which should be used while setting
> >   security context. As of now it is hardcoded to "security.selinux".
> 
> Any reason not to just send all `security.*` xattrs found on the inode? 
> 
> (I'm not super familiar with this code, it looks like we're going from the LSM-cached version attached to the inode, but presumably since we're sending bytes we can just ask the filesytem for the raw data instead)

So this inode is about to be created. There are no xattrs yet. And
filesystem is asking LSMs, what security labels should be set on this
inode before it is published. 

For local filesystems it is somewhat easy. They are the one creating
inode and can set all xattrs/labels before inode is added to inode
cache.

But for remote like filesystems, it is more tricky. Actual inode
creation first will happen on server and then client will instantiate
an inode based on information returned by server (Atleast that's
what fuse does).

So security_dentry_init_security() was created (I think by NFS folks)
so that they can query the label and send it along with create
request and server can take care of setting label (along with file
creation).

One limitation of security_dentry_init_security() is that it practically
supports only one label. And only SELinux has implemented. So for
all practical purposes this is a hook to obtain selinux label. NFS
and ceph already use it in that way.

Now there is a desire to be able to return more than one security
labels and support smack and possibly other LSMs. Sure, that great.
But I think for that we will have to implement a new hook which
can return multiple labels and filesystems like nfs, ceph and fuse
will have to be modified to cope with this new hook to support
multiple lables. 

And I am arguing that we can modify fuse when that hook has been
implemented. There is no point in adding that complexity in fuse
code as well all fuse-server implementations when there is nobody
generating multiple labels. We can't even test it.

Thanks
Vivek

