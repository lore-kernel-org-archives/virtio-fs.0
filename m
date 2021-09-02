Date: Thu, 2 Sep 2021 16:06:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YTEur7h6fe4xBJRb@redhat.com>
References: <20210902152228.665959-1-vgoyal@redhat.com>
	<79dcd300-a441-cdba-e523-324733f892ca@schaufler-ca.com>
	<YTEEPZJ3kxWkcM9x@redhat.com> <YTENEAv6dw9QoYcY@redhat.com>
	<3bca47d0-747d-dd49-a03f-e0fa98eaa2f7@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bca47d0-747d-dd49-a03f-e0fa98eaa2f7@schaufler-ca.com>
Subject: Re: [Virtio-fs] [PATCH v3 0/1] Relax restrictions on user.* xattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: gscrivan@redhat.com, tytso@mit.edu, agruenba@redhat.com, miklos@szeredi.hu, selinux@vger.kernel.org, stephen.smalley.work@gmail.com, david@fromorbit.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, casey.schaufler@intel.com, linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, bfields@redhat.com, christian.brauner@ubuntu.com

On Thu, Sep 02, 2021 at 11:55:11AM -0700, Casey Schaufler wrote:
> On 9/2/2021 10:42 AM, Vivek Goyal wrote:
> > On Thu, Sep 02, 2021 at 01:05:01PM -0400, Vivek Goyal wrote:
> >> On Thu, Sep 02, 2021 at 08:43:50AM -0700, Casey Schaufler wrote:
> >>> On 9/2/2021 8:22 AM, Vivek Goyal wrote:
> >>>> Hi,
> >>>>
> >>>> This is V3 of the patch. Previous versions were posted here.
> >>>>
> >>>> v2:
> >>>> https://lore.kernel.org/linux-fsdevel/20210708175738.360757-1-vgoyal@redhat.com/
> >>>> v1:
> >>>> https://lore.kernel.org/linux-fsdevel/20210625191229.1752531-1-vgoyal@redhat.co
> >>>> +m/
> >>>>
> >>>> Changes since v2
> >>>> ----------------
> >>>> - Do not call inode_permission() for special files as file mode bits
> >>>>   on these files represent permissions to read/write from/to device
> >>>>   and not necessarily permission to read/write xattrs. In this case
> >>>>   now user.* extended xattrs can be read/written on special files
> >>>>   as long as caller is owner of file or has CAP_FOWNER.
> >>>>  
> >>>> - Fixed "man xattr". Will post a patch in same thread little later. (J.
> >>>>   Bruce Fields)
> >>>>
> >>>> - Fixed xfstest 062. Changed it to run only on older kernels where
> >>>>   user extended xattrs are not allowed on symlinks/special files. Added
> >>>>   a new replacement test 648 which does exactly what 062. Just that
> >>>>   it is supposed to run on newer kernels where user extended xattrs
> >>>>   are allowed on symlinks and special files. Will post patch in 
> >>>>   same thread (Ted Ts'o).
> >>>>
> >>>> Testing
> >>>> -------
> >>>> - Ran xfstest "./check -g auto" with and without patches and did not
> >>>>   notice any new failures.
> >>>>
> >>>> - Tested setting "user.*" xattr with ext4/xfs/btrfs/overlay/nfs
> >>>>   filesystems and it works.
> >>>>  
> >>>> Description
> >>>> ===========
> >>>>
> >>>> Right now we don't allow setting user.* xattrs on symlinks and special
> >>>> files at all. Initially I thought that real reason behind this
> >>>> restriction is quota limitations but from last conversation it seemed
> >>>> that real reason is that permission bits on symlink and special files
> >>>> are special and different from regular files and directories, hence
> >>>> this restriction is in place. (I tested with xfs user quota enabled and
> >>>> quota restrictions kicked in on symlink).
> >>>>
> >>>> This version of patch allows reading/writing user.* xattr on symlink and
> >>>> special files if caller is owner or priviliged (has CAP_FOWNER) w.r.t inode.
> >>> This part of your project makes perfect sense. There's no good
> >>> security reason that you shouldn't set user.* xattrs on symlinks
> >>> and/or special files.
> >>>
> >>> However, your virtiofs use case is unreasonable.
> >> Ok. So we can merge this patch irrespective of the fact whether virtiofs
> >> should make use of this mechanism or not, right?
> 
> I don't see a security objection. I did see that Andreas Gruenbacher
> <agruenba@redhat.com> has objections to the behavior.
> 
> 
> >>>> Who wants to set user.* xattr on symlink/special files
> >>>> -----------------------------------------------------
> >>>> I have primarily two users at this point of time.
> >>>>
> >>>> - virtiofs daemon.
> >>>>
> >>>> - fuse-overlay. Giuseppe, seems to set user.* xattr attrs on unpriviliged
> >>>>   fuse-overlay as well and he ran into similar issue. So fuse-overlay
> >>>>   should benefit from this change as well.
> >>>>
> >>>> Why virtiofsd wants to set user.* xattr on symlink/special files
> >>>> ----------------------------------------------------------------
> >>>> In virtiofs, actual file server is virtiosd daemon running on host.
> >>>> There we have a mode where xattrs can be remapped to something else.
> >>>> For example security.selinux can be remapped to
> >>>> user.virtiofsd.securit.selinux on the host.
> >>> As I have stated before, this introduces a breach in security.
> >>> It allows an unprivileged process on the host to manipulate the
> >>> security state of the guest. This is horribly wrong. It is not
> >>> sufficient to claim that the breach requires misconfiguration
> >>> to exploit. Don't do this.
> >> So couple of things.
> >>
> >> - Right now whole virtiofs model is relying on the fact that host
> >>   unpriviliged users don't have access to shared directory. Otherwise
> >>   guest process can simply drop a setuid root binary in shared directory
> >>   and unpriviliged process can execute it and take over host system.
> >>
> >>   So if virtiofs makes use of this mechanism, we are well with-in
> >>   the existing constraints. If users don't follow the constraints,
> >>   bad things can happen.
> >>
> >> - I think Smalley provided a solution for your concern in other thread
> >>   we discussed this issue.
> >>
> >>   https://lore.kernel.org/selinux/CAEjxPJ4411vL3+Ab-J0yrRTmXoEf8pVR3x3CSRgPjfzwiUcDtw@mail.gmail.com/T/#mddea4cec7a68c3ee5e8826d650020361030209d6
> >>
> >>
> >>   "So for example if the host policy says that only virtiofsd can set
> >> attributes on those files, then the guest MAC labels along with all
> >> the other attributes are protected against tampering by any other
> >> process on the host."
> 
> You can't count on SELinux policy to address the issue on a
> system running Smack.
> Or any other user of system.* xattrs,
> be they in the kernel or user space. You can't even count on
> SELinux policy to be correct. virtiofs has to present a "safe"
> situation regardless of how security.* xattrs are used and
> regardless of which, if any, LSMs are configured. You can't
> do that with user.* attributes.

Lets take a step back. Your primary concern with using user.* xattrs
by virtiofsd is that it can be modified by unprivileged users on host.
And our solution to that problem is hide shared directory from
unprivileged users.

In addition to that, LSMs on host can block setting "user.*" xattrs by
virtiofsd domain only for additional protection. If LSMs are not configured,
then hiding the directory is the solution.

So why that's not a solution and only relying on CAP_SYS_ADMIN is the
solution. I don't understand that part.

Also if directory is not hidden, unprivileged users can change file
data and other metadata. Why that's not a concern and why there is
so much of focus only security xattr. If you were to block modification
of file then you will have rely on LSMs. And if LSMs are not configured,
then we will rely on shared directory not being visible.

Can you please help me understand why hiding shared directory from
unprivileged users is not a solution (With both LSMs configured or
not configured on host). That's a requirement for virtiofs anyway. 
And if we agree on that, then I don't see why using "user.*" xattrs
for storing guest sercurity attributes is a problem.

Thanks
Vivek

