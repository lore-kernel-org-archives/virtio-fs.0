Date: Mon, 12 Jul 2021 17:22:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210712212201.GD502004@redhat.com>
References: <20210708175738.360757-2-vgoyal@redhat.com>
	<20210709091915.2bd4snyfjndexw2b@wittgenstein>
	<20210709152737.GA398382@redhat.com>
	<710d1c6f-d477-384f-0cc1-8914258f1fb1@schaufler-ca.com>
	<20210709175947.GB398382@redhat.com>
	<CAPL3RVGKg4G5qiiHo7KYPcsWWgeoW=qNPOSQpd3Sv329jrWrLQ@mail.gmail.com>
	<20210712140247.GA486376@redhat.com>
	<20210712154106.GB18679@fieldses.org>
	<20210712174759.GA502004@redhat.com>
	<20210712193139.GA22997@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712193139.GA22997@fieldses.org>
Subject: Re: [Virtio-fs] [PATCH v2 1/1] xattr: Allow user.* xattr on symlink
 and special files
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: gscrivan@redhat.com, Bruce Fields <bfields@redhat.com>, miklos@szeredi.hu, selinux@vger.kernel.org, jack@suse.cz, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk, Christoph Hellwig <hch@infradead.org>, Casey Schaufler <casey@schaufler-ca.com>, tytso@mit.edu, Christian Brauner <christian.brauner@ubuntu.com>, casey.schaufler@intel.com

On Mon, Jul 12, 2021 at 03:31:39PM -0400, J. Bruce Fields wrote:
> On Mon, Jul 12, 2021 at 01:47:59PM -0400, Vivek Goyal wrote:
> > On Mon, Jul 12, 2021 at 11:41:06AM -0400, J. Bruce Fields wrote:
> > > Looks like 0xd is what the server returns to access on a device node
> > > with mode bits rw- for the caller.
> > > 
> > > Commit c11d7fd1b317 "nfsd: take xattr bits into account for permission
> > > checks" added the ACCESS_X* bits for regular files and directories but
> > > not others.
> > > 
> > > But you don't want to determine permission from the mode bits anyway,
> > > you want it to depend on the owner,
> > 
> > Thinking more about this part. Current implementation of my patch is
> > effectively doing both the checks. It checks that you are owner or
> > have CAP_FOWNER in xattr_permission() and then goes on to call
> > inode_permission(). And that means file mode bits will also play a
> > role. If caller does not have write permission on the file, it will
> > be denied setxattr().
> > 
> > If I don't call inode_permission(), and just return 0 right away for
> > file owner (for symlinks and special files), then just being owner
> > is enough to write user.* xattr. And then even security modules will
> > not get a chance to block that operation. IOW, if you are owner of
> > a symlink or special file, you can write as many user.* xattr as you
> > like and except quota does not look like anything else can block
> > it. I am wondering if this approach is ok?
> 
> Yeah, I'd expect security modules to get a say, and I wouldn't expect
> mode bits on device nodes to be useful for deciding whether it makes
> sense for xattrs to be readable or writeable.

Actually, calling inode_permission() for symlinks probably should be
fine.

Its the device node which is problematic. Because we started with the
assumption that mode bits there represent access writes for read/writing
to device (and not to the filesystem). 

> 
> But, I don't really know.

> 
> Do we have any other use cases besides this case of storing security
> labels in user xattrs?

Storing security label was one example. In case of virtiofs, there is
a good chance that we will end up remapping all the guest xattrs and
prefix these with "user.virtiofsd".

fuse-overlay is another use case. They are storing real uid/gid in 
user.* xattrs for files over NFS.

I think overlayfs can be another benefeciary in some form. Now there
is support for unpriviliged mouting of overlayfs from inside a user
namespace. And that uses xattrs "user.overlay" on upper files for
overlayfs specific metadata. Device nodes are not copied up. But
they might have an issue with symlinks. Miklos, will know more.

Thanks
Vivek

