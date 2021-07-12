Date: Mon, 12 Jul 2021 14:49:30 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210712144849.121c948c@bahia.lan>
In-Reply-To: <710d1c6f-d477-384f-0cc1-8914258f1fb1@schaufler-ca.com>
References: <20210708175738.360757-1-vgoyal@redhat.com>
	<20210708175738.360757-2-vgoyal@redhat.com>
	<20210709091915.2bd4snyfjndexw2b@wittgenstein>
	<20210709152737.GA398382@redhat.com>
	<710d1c6f-d477-384f-0cc1-8914258f1fb1@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: gscrivan@redhat.com, tytso@mit.edu, miklos@szeredi.hu, selinux@vger.kernel.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk, Christoph Hellwig <hch@infradead.org>, casey.schaufler@intel.com, jack@suse.cz, Christian Brauner <christian.brauner@ubuntu.com>, Vivek Goyal <vgoyal@redhat.com>

On Fri, 9 Jul 2021 08:34:41 -0700
Casey Schaufler <casey@schaufler-ca.com> wrote:

> On 7/9/2021 8:27 AM, Vivek Goyal wrote:
> > On Fri, Jul 09, 2021 at 11:19:15AM +0200, Christian Brauner wrote:
> >> On Thu, Jul 08, 2021 at 01:57:38PM -0400, Vivek Goyal wrote:
> >>> Currently user.* xattr are not allowed on symlink and special files.
> >>>
> >>> man xattr and recent discussion suggested that primary reason for this
> >>> restriction is how file permissions for symlinks and special files
> >>> are little different from regular files and directories.
> >>>
> >>> For symlinks, they are world readable/writable and if user xattr were
> >>> to be permitted, it will allow unpriviliged users to dump a huge amount
> >>> of user.* xattrs on symlinks without any control.
> >>>
> >>> For special files, permissions typically control capability to read/write
> >>> from devices (and not necessarily from filesystem). So if a user can
> >>> write to device (/dev/null), does not necessarily mean it should be allowed
> >>> to write large number of user.* xattrs on the filesystem device node is
> >>> residing in.
> >>>
> >>> This patch proposes to relax the restrictions a bit and allow file owner
> >>> or priviliged user (CAP_FOWNER), to be able to read/write user.* xattrs
> >>> on symlink and special files.
> >>>
> >>> virtiofs daemon has a need to store user.* xatrrs on all the files
> >>> (including symlinks and special files), and currently that fails. This
> >>> patch should help.
> >>>
> >>> Link: https://lore.kernel.org/linux-fsdevel/20210625191229.1752531-1-vgoyal@redhat.com/
> >>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> >>> ---
> >> Seems reasonable and useful.
> >> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> >>
> >> One question, do all filesystem supporting xattrs deal with setting them
> >> on symlinks/device files correctly?
> > Wrote a simple bash script to do setfattr/getfattr user.foo xattr on
> > symlink and device node on ext4, xfs and btrfs and it works fine.
> 
> How about nfs, tmpfs, overlayfs and/or some of the other less conventional
> filesystems?
> 

How about virtiofs then ? :-)

> >
> > https://github.com/rhvgoyal/misc/blob/master/generic-programs/user-xattr-special-files.sh
> >
> > I probably can add some more filesystems to test.
> >
> > Thanks
> > Vivek
> >
> >>>  fs/xattr.c | 10 ++++++----
> >>>  1 file changed, 6 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/fs/xattr.c b/fs/xattr.c
> >>> index 5c8c5175b385..2f1855c8b620 100644
> >>> --- a/fs/xattr.c
> >>> +++ b/fs/xattr.c
> >>> @@ -120,12 +120,14 @@ xattr_permission(struct user_namespace *mnt_userns, struct inode *inode,
> >>>  	}
> >>>  
> >>>  	/*
> >>> -	 * In the user.* namespace, only regular files and directories can have
> >>> -	 * extended attributes. For sticky directories, only the owner and
> >>> -	 * privileged users can write attributes.
> >>> +	 * In the user.* namespace, for symlinks and special files, only
> >>> +	 * the owner and priviliged users can read/write attributes.
> >>> +	 * For sticky directories, only the owner and privileged users can
> >>> +	 * write attributes.
> >>>  	 */
> >>>  	if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
> >>> -		if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
> >>> +		if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode) &&
> >>> +		    !inode_owner_or_capable(mnt_userns, inode))
> >>>  			return (mask & MAY_WRITE) ? -EPERM : -ENODATA;
> >>>  		if (S_ISDIR(inode->i_mode) && (inode->i_mode & S_ISVTX) &&
> >>>  		    (mask & MAY_WRITE) &&
> >>> -- 
> >>> 2.25.4
> >>>
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
> 

