Date: Mon, 28 Jun 2021 09:17:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210628131708.GA1803896@redhat.com>
References: <20210625191229.1752531-1-vgoyal@redhat.com>
	<BN0PR11MB57275823CE05DED7BC755460FD069@BN0PR11MB5727.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN0PR11MB57275823CE05DED7BC755460FD069@BN0PR11MB5727.namprd11.prod.outlook.com>
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
To: "Schaufler, Casey" <casey.schaufler@intel.com>
Cc: "berrange@redhat.com" <berrange@redhat.com>, "selinux@vger.kernel.org" <selinux@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "casey@schaufler-ca.com" <casey@schaufler-ca.com>, linux-security-module <linux-security-module@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

On Fri, Jun 25, 2021 at 09:49:51PM +0000, Schaufler, Casey wrote:
> > -----Original Message-----
> > From: Vivek Goyal <vgoyal@redhat.com>
> > Sent: Friday, June 25, 2021 12:12 PM
> > To: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> > viro@zeniv.linux.org.uk
> > Cc: virtio-fs@redhat.com; dwalsh@redhat.com; dgilbert@redhat.com;
> > berrange@redhat.com; vgoyal@redhat.com
> 
> Please include Linux Security Module list <linux-security-module@vger.kernel.org>
> and selinux@vger.kernel.org on this topic.
> 
> > Subject: [RFC PATCH 0/1] xattr: Allow user.* xattr on symlink/special files if
> > caller has CAP_SYS_RESOURCE
> > 
> > Hi,
> > 
> > In virtiofs, actual file server is virtiosd daemon running on host.
> > There we have a mode where xattrs can be remapped to something else.
> > For example security.selinux can be remapped to
> > user.virtiofsd.securit.selinux on the host.
> 
> This would seem to provide mechanism whereby a user can violate
> SELinux policy quite easily. 

Hi Casey,

As david already replied, we are not bypassing host's SELinux policy (if
there is one). We are just trying to provide a mode where host and
guest's SELinux policies could co-exist without interefering
with each other.

By remappming guests SELinux xattrs (and not host's SELinux xattrs),
a file probably will have two xattrs

"security.selinux" and "user.virtiofsd.security.selinux". Host will
enforce SELinux policy based on security.selinux xattr and guest
will see the SELinux info stored in "user.virtiofsd.security.selinux"
and guest SELinux policy will enforce rules based on that.
(user.virtiofsd.security.selinux will be remapped to "security.selinux"
when guest does getxattr()).

IOW, this mode is allowing both host and guest SELinux policies to
co-exist and not interefere with each other. (Remapping guests's
SELinux xattr is not changing hosts's SELinux label and is not
bypassing host's SELinux policy).

virtiofsd also provides for the mode where if guest process sets
SELinux xattr it shows up as security.selinux on host. But now we
have multiple issues. There are two SELinux policies (host and guest)
which are operating on same lable. And there is a very good chance
that two have not been written in such a way that they work with
each other. In fact there does not seem to exist a notion where
two different SELinux policies are operating on same label.

At high level, this is in a way similar to files created on
virtio-blk devices. Say this device is backed by a foo.img file
on host. Now host selinux policy will set its own label on
foo.img and provide access control while labels created by guest
are not seen or controlled by host's SELinux policy. Only guest
SELinux policy works with those labels.

So this is similar kind of attempt. Provide isolation between
host and guests's SELinux labels so that two policies can
co-exist and not interfere with each other.

> 
> > 
> > This remapping is useful when SELinux is enabled in guest and virtiofs
> > as being used as rootfs. Guest and host SELinux policy might not match
> > and host policy might deny security.selinux xattr setting by guest
> > onto host. Or host might have SELinux disabled and in that case to
> > be able to set security.selinux xattr, virtiofsd will need to have
> > CAP_SYS_ADMIN (which we are trying to avoid). Being able to remap
> > guest security.selinux (or other xattrs) on host to something else
> > is also better from security point of view.
> 
> Can you please provide some rationale for this assertion?
> I have been working with security xattrs longer than anyone
> and have trouble accepting the statement.

If guest is not able to interfere or change host's SELinux labels
directly, it sounded better.

Irrespective of this, my primary concern is that to allow guest
VM to be able to use SELinux seamlessly in diverse host OS
environments (typical of cloud deployments). And being able to
provide a mode where host and guest's security labels can
co-exist and policies can work independently, should be able
to achieve that goal.

> 
> > But when we try this, we noticed that SELinux relabeling in guest
> > is failing on some symlinks. When I debugged a little more, I
> > came to know that "user.*" xattrs are not allowed on symlinks
> > or special files.
> > 
> > "man xattr" seems to suggest that primary reason to disallow is
> > that arbitrary users can set unlimited amount of "user.*" xattrs
> > on these files and bypass quota check.
> > 
> > If that's the primary reason, I am wondering is it possible to relax
> > the restrictions if caller has CAP_SYS_RESOURCE. This capability
> > allows caller to bypass quota checks. So it should not be
> > a problem atleast from quota perpective.
> > 
> > That will allow me to give CAP_SYS_RESOURCE to virtiofs deamon
> > and remap xattrs arbitrarily.
> 
> On a Smack system you should require CAP_MAC_ADMIN to remap
> security. xattrs. I sounds like you're in serious danger of running afoul
> of LSM attribute policy on a reasonable general level.

I think I did not explain xattr remapping properly and that's why this
confusion is there. Only guests's xattrs will be remapped and not
hosts's xattr. So one can not bypass any access control implemented
by any of the LSM on host.

Thanks
Vivek

