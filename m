Date: Fri, 26 Jun 2020 12:26:02 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200626112602.GG3087@work-vm>
References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200618190816.GD3814@redhat.com> <20200618191655.GI2769@work-vm>
	<20200618192717.GE3814@redhat.com> <20200619082746.GA2690@work-vm>
	<20200619113914.GI700896@redhat.com>
	<20200619191254.GH3154@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200619191254.GH3154@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: drop Linux capabilities(7)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, qemu-devel@nongnu.org, Miklos Szeredi <miklos@szeredi.hu>

* Vivek Goyal (vgoyal@redhat.com) wrote:
> On Fri, Jun 19, 2020 at 12:39:14PM +0100, Daniel P. Berrangé wrote:
> [..]
> > The CAP_SYS_ADMIN requirement for 'trusted.' xattrs is simply a useful
> > mechanism for applications to control access. The host kernel doesn'
> > tuse this namespace itself. Linux has four namespaces for xattrs:
> > 
> >  -  user - for userspace apps. accessible based on read/write permissions
> >  -  trusted - for userspace apps. accessible by CAP_SYS_ADMIN processes only
> >  -  system - for kernel only. used by ACLs
> >  -  security - for kernel only. used by SELinux
> > 
> > The use case for "trusted" xattrs is thus where a privileged management
> > application or service wants to store metadata against the file, but
> > also needs to grant an unprivileged process access to write to this file
> > while not allowing that unprivileged process the ability to change the
> > metadata. This is mentioned in the man page:
> > 
> > [man xattr(7)]
> >    Trusted extended attributes
> >        Trusted  extended attributes are visible and accessible only to pro‐
> >        cesses that have the CAP_SYS_ADMIN capability.  Attributes  in  this
> >        class  are used to implement mechanisms in user space (i.e., outside
> >        the kernel) which keep information in extended attributes  to  which
> >        ordinary processes should not have access.
> > 
> >    User extended attributes
> >        User  extended  attributes  may be assigned to files and directories
> >        for storing arbitrary additional information such as the mime  type,
> >        character  set  or  encoding  of a file.  The access permissions for
> >        user attributes are defined by the file permission bits:  read  per‐
> >        mission is required to retrieve the attribute value, and writer per‐
> >        mission is required to change it.
> > [/man]
> > 
> > Libvirtd uses the "trusted." xattr namespace to record information against
> > disk images for QEMU, because we need to grant QEMU access to read/write
> > the disk iamges, but don't want QEMU to be able to alter our xattrs.
> > 
> > It is unfortunate that this namespace is tied to the CAP_SYS_ADMIN cap.
> > It really ought to have had its own dedicated capability :-( Such is
> > life with anything that uses CAP_SYS_ADMIN...
> > 
> > With this in mind we really should have both trusted. & user. xattrs
> > allowed to the guest by default.
> > 
> > Conversely, we'll need to block usage of the security. and system.
> > namespaces.
> 
> I am wondering can we block usage of "system" and "security"?  What
> about guest setting acls over virtiofs files. These will have to
> go through and that means we need to allow system xattrs.
> 
> Similarly setting file capabilities inside should trigger
> setxattr(security.capability) and that means we need to allow security
> xattr as well.

Yep, we see that when people install Fedora packages, when rpm
unpackgs /usr/bin/newgidmap which has:

$ getfattr -d '--match=.*' /usr/bin/newgidmap 
getfattr: Removing leading '/' from absolute path names
# file: usr/bin/newgidmap
security.capability=0sAQAAAkAAAAAAAAAAAAAAAAAAAAA=
security.selinux="system_u:object_r:bin_t:s0"


Dave

> Thanks
> Vivek
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

