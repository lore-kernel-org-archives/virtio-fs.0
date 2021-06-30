Date: Wed, 30 Jun 2021 09:07:56 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YNwmXOqT7LgbeVPn@work-vm>
References: <5d8f033c-eba2-7a8b-f19a-1005bbb615ea@schaufler-ca.com>
	<YNn4p+Zn444Sc4V+@work-vm>
	<a13f2861-7786-09f4-99a8-f0a5216d0fb1@schaufler-ca.com>
	<YNrhQ9XfcHTtM6QA@work-vm>
	<e6f9ed0d-c101-01df-3dff-85c1b38f9714@schaufler-ca.com>
	<20210629152007.GC5231@redhat.com>
	<78663f5c-d2fd-747a-48e3-0c5fd8b40332@schaufler-ca.com>
	<20210629173530.GD5231@redhat.com>
	<f4992b3a-a939-5bc4-a5da-0ce8913bd569@redhat.com>
	<YNvvLIv16jY8mfP8@mit.edu>
MIME-Version: 1.0
In-Reply-To: <YNvvLIv16jY8mfP8@mit.edu>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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
> On Tue, Jun 29, 2021 at 04:28:24PM -0400, Daniel Walsh wrote:
> > All this conversation is great, and I look forward to a better solution, but
> > if we go back to the patch, it was to fix an issue where the kernel is
> > requiring CAP_SYS_ADMIN for writing user Xattrs on link files and other
> > special files.
> > 
> > The documented reason for this is to prevent the users from using XATTRS to
> > avoid quota.
> 
> Huh?  Where is it so documented?

man xattr(7):

       The  file permission bits of regular files and directories are
       interpreted differently from the file permission bits of special
       files and symbolic links.  For regular files and directories the
       file permission bits define ac‐ cess to the file's contents,
       while for device special files they define access to the device
       described by the special file.  The file permissions of symbolic
       links are not used in access checks. *** These differences would
       al‐ low users to consume filesystem resources in a way not
       controllable by disk quotas for group or world writable special
       files and directories.****

       ***For  this reason, user extended attributes are allowed only
       for regular files and directories ***, and access to user extended
       attributes is restricted to the owner and to users with appropriate
       capabilities for directories with the sticky bit set (see the
       chmod(1) manual page for an explanation of the sticky bit).

(***'s my addition)


Dave

>  How file systems store and account
> for space used by extended attributes is a file-system specific
> question, but presumably any way that xattr's on regular files are
> accounted could also be used for xattr's on special files.
> 
> Also, xattr's are limited to 32k, so it's not like users can evade
> _that_ much quota space, at least not without it being pretty painful.
> (Assuming that quota is even enabled, which most of the time, it
> isn't.)
> 
> 						- Ted
> 
> P.S.  I'll note that if ext4's ea_in_inode is enabled, for large
> xattr's, if you have 2 million files that all have the same 12k
> windows SID stored as an xattr, ext4 will store that xattr only once.
> Those two million files might be owned by different uids, so we made
> an explicit design choice not to worry about accounting for the quota
> for said 12k xattr value.  After all, if you can save the space and
> access cost of 2M * 12k if each file had to store its own copy of that
> xattr, perhaps not including it in the quota calculation isn't that
> bad.  :-)
> 
> We also don't account for the disk space used by symbolic links (since
> sometimes they can be stored in the inode as fast symlinks, and
> sometimes they might consume a data block).  But again, that's a file
> system specific implementation question.
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

