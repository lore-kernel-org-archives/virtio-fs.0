Date: Wed, 30 Jun 2021 16:01:42 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YNyHVhGPe1bFAt+C@work-vm>
References: <a13f2861-7786-09f4-99a8-f0a5216d0fb1@schaufler-ca.com>
	<YNrhQ9XfcHTtM6QA@work-vm>
	<e6f9ed0d-c101-01df-3dff-85c1b38f9714@schaufler-ca.com>
	<20210629152007.GC5231@redhat.com>
	<78663f5c-d2fd-747a-48e3-0c5fd8b40332@schaufler-ca.com>
	<20210629173530.GD5231@redhat.com>
	<f4992b3a-a939-5bc4-a5da-0ce8913bd569@redhat.com>
	<YNvvLIv16jY8mfP8@mit.edu> <YNwmXOqT7LgbeVPn@work-vm>
	<YNyECw/1FzDCW3G8@mit.edu>
MIME-Version: 1.0
In-Reply-To: <YNyECw/1FzDCW3G8@mit.edu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [RFC PATCH 0/1] xattr: Allow user.* xattr on
 symlink/special files if caller has CAP_SYS_RESOURCE
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Theodore Ts'o <tytso@mit.edu>
Cc: "berrange@redhat.com" <berrange@redhat.com>, "selinux@vger.kernel.org" <selinux@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "Schaufler,
	Casey" <casey.schaufler@intel.com>, linux-security-module <linux-security-module@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

* Theodore Ts'o (tytso@mit.edu) wrote:
> On Wed, Jun 30, 2021 at 09:07:56AM +0100, Dr. David Alan Gilbert wrote:
> > * Theodore Ts'o (tytso@mit.edu) wrote:
> > > On Tue, Jun 29, 2021 at 04:28:24PM -0400, Daniel Walsh wrote:
> > > > All this conversation is great, and I look forward to a better solution, but
> > > > if we go back to the patch, it was to fix an issue where the kernel is
> > > > requiring CAP_SYS_ADMIN for writing user Xattrs on link files and other
> > > > special files.
> > > > 
> > > > The documented reason for this is to prevent the users from using XATTRS to
> > > > avoid quota.
> > > 
> > > Huh?  Where is it so documented?
> > 
> > man xattr(7):
> >        The  file permission bits of regular files and directories are
> >        interpreted differently from the file permission bits of special
> >        files and symbolic links.  For regular files and directories the
> >        file permission bits define access to the file's contents,
> >        while for device special files they define access to the device
> >        described by the special file.  The file permissions of symbolic
> >        links are not used in access checks.
> 
> All of this is true...
> 
> >         *** These differences would
> >        allow users to consume filesystem resources in a way not
> >        controllable by disk quotas for group or world writable special
> >        files and directories.****
> 
> Anyone with group write access to a regular file can append to the
> file, and the blocks written will be charged the owner of the file.
> So it's perfectly "controllable" by the quota system; if you have
> group write access to a file, you can charge against the user's quota.
> This is Working As Intended.
> 
> And the creation of device special files take the umask into account,
> just like regular files, so if you have a umask that allows newly
> created files to be group writeable, the same issue would occur for
> regular files as device files.  Given that most users have a umask of
> 0077 or 0022, this is generally Not A Problem.
> 
> I think I see the issue which drove the above text, though, which is
> that Linux's syscall(2) is creating symlinks which do not take umask
> into account; that is, the permissions are always mode ST_IFLNK|0777.
> 
> Hence, it might be that the right answer is to remove this fairly
> arbitrary restriction entirely, and change symlink(2) so that it
> creates files which respects the umask.  Posix and SUS doesn't specify
> what the permissions are that are used, and historically (before the
> advent of xattrs) I suspect since it didn't matter, no one cared about
> whether or not umask was applied.
> 
> Some people might object to such a change arguing that with
> pre-existing file systems where there are symlinks which
> world-writeable, this might cause people to be able to charge up to
> 32k (or whatever the maximum size of the xattr supported by the file
> system) for each symlink.  However, (a) very few people actually use
> quotas, and this would only be an issue for those users, and (b) the
> amount of quota "abuse" that could be carried out this way is small
> enough that I'm not sure it matters.

Even if you fix symlinks, I don't think it fixes device nodes or
anything else where the permissions bitmap isn't purely used as the
permissions on the inode.

Dave

>      	    	  	      	  - Ted
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

