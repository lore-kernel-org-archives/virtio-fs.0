Date: Mon, 30 Aug 2021 14:45:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YS0nRQeuxEFppDxG@redhat.com>
References: <20210708175738.360757-2-vgoyal@redhat.com>
	<20210709091915.2bd4snyfjndexw2b@wittgenstein>
	<20210709152737.GA398382@redhat.com>
	<710d1c6f-d477-384f-0cc1-8914258f1fb1@schaufler-ca.com>
	<20210709175947.GB398382@redhat.com>
	<CAPL3RVGKg4G5qiiHo7KYPcsWWgeoW=qNPOSQpd3Sv329jrWrLQ@mail.gmail.com>
	<20210712140247.GA486376@redhat.com>
	<20210712154106.GB18679@fieldses.org>
	<20210712174759.GA502004@redhat.com>
	<3d55ff30-c6cf-46c4-0e32-3b578099343d@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d55ff30-c6cf-46c4-0e32-3b578099343d@schaufler-ca.com>
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
Cc: virtio-fs@redhat.com, Bruce Fields <bfields@redhat.com>, miklos@szeredi.hu, selinux@vger.kernel.org, jack@suse.cz, linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, casey.schaufler@intel.com, linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk, gscrivan@redhat.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, tytso@mit.edu, Christian Brauner <christian.brauner@ubuntu.com>

On Tue, Jul 13, 2021 at 07:17:00AM -0700, Casey Schaufler wrote:
> On 7/12/2021 10:47 AM, Vivek Goyal wrote:
> > On Mon, Jul 12, 2021 at 11:41:06AM -0400, J. Bruce Fields wrote:
> >> On Mon, Jul 12, 2021 at 10:02:47AM -0400, Vivek Goyal wrote:
> >>> On Fri, Jul 09, 2021 at 04:10:16PM -0400, Bruce Fields wrote:
> >>>> On Fri, Jul 9, 2021 at 1:59 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >>>>> nfs seems to have some issues.
> >>>> I'm not sure what the expected behavior is for nfs.  All I have for
> >>>> now is some generic troubleshooting ideas, sorry:
> >>>>
> >>>>> - I can set user.foo xattr on symlink and query it back using xattr name.
> >>>>>
> >>>>>   getfattr -h -n user.foo foo-link.txt
> >>>>>
> >>>>>   But when I try to dump all xattrs on this file, user.foo is being
> >>>>>   filtered out it looks like. Not sure why.
> >>>> Logging into the server and seeing what's set there could help confirm
> >>>> whether it's the client or server that's at fault.  (Or watching the
> >>>> traffic in wireshark; there are GET/SET/LISTXATTR ops that should be
> >>>> easy to spot.)
> >>>>
> >>>>> - I can't set "user.foo" xattr on a device node on nfs and I get
> >>>>>   "Permission denied". I am assuming nfs server is returning this.
> >>>> Wireshark should tell you whether it's the server or client doing that.
> >>>>
> >>>> The RFC is https://datatracker.ietf.org/doc/html/rfc8276, and I don't
> >>>> see any explicit statement about what the server should do in the case
> >>>> of symlinks or device nodes, but I do see "Any regular file or
> >>>> directory may have a set of extended attributes", so that was clearly
> >>>> the assumption.  Also, NFS4ERR_WRONG_TYPE is listed as a possible
> >>>> error return for the xattr ops.  But on a quick skim I don't see any
> >>>> explicit checks in the nfsd code, so I *think* it's just relying on
> >>>> the vfs for any file type checks.
> >>> Hi Bruce,
> >>>
> >>> Thanks for the response. I am just trying to do set a user.foo xattr on
> >>> a device node on nfs.
> >>>
> >>> setfattr -n "user.foo" -v "bar" /mnt/nfs/test-dev
> >>>
> >>> and I get -EACCESS.
> >>>
> >>> I put some printk() statements and EACCESS is being returned from here.
> >>>
> >>> nfs4_xattr_set_nfs4_user() {
> >>>         if (!nfs_access_get_cached(inode, current_cred(), &cache, true)) {
> >>>                 if (!(cache.mask & NFS_ACCESS_XAWRITE)) {
> >>>                         return -EACCES;
> >>>                 }
> >>>         }
> >>> }
> >>>
> >>> Value of cache.mask=0xd at the time of error.
> >> Looks like 0xd is what the server returns to access on a device node
> >> with mode bits rw- for the caller.
> >>
> >> Commit c11d7fd1b317 "nfsd: take xattr bits into account for permission
> >> checks" added the ACCESS_X* bits for regular files and directories but
> >> not others.
> >>
> >> But you don't want to determine permission from the mode bits anyway,
> >> you want it to depend on the owner,
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
> > not get a chance to block that operation.
> 
> That isn't going to fly. SELinux and Smack don't rely on ownership
> as a criteria for access. Being the owner of a symlink conveys no
> special privilege. The LSM must be consulted to determine if the
> module's policy allows the access.

Getting back to this thread after a while. Sorry got busy in other
things.

I noticed that if we skip calling inode_permission() for special files,
then we will skip calling security_inode_permission() but we will
still call security hooks for setxattr/getxattr/removexattr etc.

security_inode_setxattr()
security_inode_getxattr()
security_inode_removexattr()

So LSMs will still get a chance whether to allow/disallow this operation
or not.

And skipping security_inode_permission() kind of makes sense that for
special files, I am not writing to device. So taking permission from
LSMs, will not make much sense.

Thanks
Vivek

