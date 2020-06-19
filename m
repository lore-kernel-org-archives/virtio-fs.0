Date: Fri, 19 Jun 2020 13:05:47 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <20200619120547.GJ700896@redhat.com>
References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200618190816.GD3814@redhat.com> <20200618191655.GI2769@work-vm>
	<20200618192717.GE3814@redhat.com> <20200619082746.GA2690@work-vm>
	<20200619113914.GI700896@redhat.com>
	<20200619114957.GG2690@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200619114957.GG2690@work-vm>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: drop Linux capabilities(7)
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Jun 19, 2020 at 12:49:57PM +0100, Dr. David Alan Gilbert wrote:
> * Daniel P. Berrangé (berrange@redhat.com) wrote:
> > On Fri, Jun 19, 2020 at 09:27:46AM +0100, Dr. David Alan Gilbert wrote:
> > > * Vivek Goyal (vgoyal@redhat.com) wrote:
> > > > On Thu, Jun 18, 2020 at 08:16:55PM +0100, Dr. David Alan Gilbert wrote:
> > > > > * Vivek Goyal (vgoyal@redhat.com) wrote:
> > > > > > On Thu, Apr 16, 2020 at 05:49:05PM +0100, Stefan Hajnoczi wrote:
> > > > > > > virtiofsd doesn't need of all Linux capabilities(7) available to root.  Keep a
> > > > > > > whitelisted set of capabilities that we require.  This improves security in
> > > > > > > case virtiofsd is compromised by making it hard for an attacker to gain further
> > > > > > > access to the system.
> > > > > > 
> > > > > > Hi Stefan,
> > > > > > 
> > > > > > I just noticed that this patch set breaks overlayfs on top of virtiofs.
> > > > > > 
> > > > > > overlayfs sets "trusted.overlay.*" and xattrs in trusted domain
> > > > > > need CAP_SYS_ADMIN.
> > > > > > 
> > > > > > man xattr says.
> > > > > > 
> > > > > >    Trusted extended attributes
> > > > > >        Trusted  extended  attributes  are  visible and accessible only to pro‐
> > > > > >        cesses that have the  CAP_SYS_ADMIN  capability.   Attributes  in  this
> > > > > >        class are used to implement mechanisms in user space (i.e., outside the
> > > > > >        kernel) which keep information in extended attributes to which ordinary
> > > > > >        processes should not have access.
> > > > > > 
> > > > > > There is a chance that overlay moves away from trusted xattr in future.
> > > > > > But for now we need to make it work. This is an important use case for
> > > > > > kata docker in docker build.
> > > > > > 
> > > > > > May be we can add an option to virtiofsd say "--add-cap <capability>" and
> > > > > > ask user to pass in "--add-cap cap_sys_admin" if they need to run daemon
> > > > > > with this capaibility.
> > > > > 
> > > > > I'll admit I don't like the idea of giving it cap_sys_admin.
> > > > > Can you explain:
> > > > >   a) What overlayfs uses trusted for?
> > > > 
> > > > overlayfs stores bunch of metadata and uses "trusted" xattrs for it.
> > > 
> > > Tell me more about this metadata.
> > > Taking a juicy looking one, what does OVL_XATTR_REDIRECT do?
> > > Or what happens if I was to write random numbers into OVL_XATTR_NLINK?
> > > 
> > > > >   b) If something nasty was to write junk into the trusted attributes,
> > > > >     what would happen?
> > > > 
> > > > This directory is owned by guest. So it should be able to write
> > > > anything it wants, as long as process in guest has CAP_SYS_ADMIN, right?
> > > 
> > > Well, we shouldn't be able to break/crash/escape into the host; how
> > > much does overlayfs validate trusted.* it uses?
> > > 
> > > > >   c) I see overlayfs has a fallback check if xattr isn't supported at
> > > > > all - what is the consequence?
> > > > 
> > > > It falls back to I think read only mode. 
> > > 
> > > It looks like the fallback is more subtle to me:
> > >         /*
> > >          * Check if upper/work fs supports trusted.overlay.* xattr
> > >          */
> > >         err = ovl_do_setxattr(ofs->workdir, OVL_XATTR_OPAQUE, "0", 1, 0);
> > >         if (err) {
> > >                 ofs->noxattr = true;
> > >                 ofs->config.index = false;
> > >                 ofs->config.metacopy = false;
> > >                 pr_warn("upper fs does not support xattr, falling back to index=off and metacopy=off.\n");
> > > 
> > > but I don't know what index and metacopy are.
> > > 
> > > > For a moment forget about overlayfs. Say a user process in guest with
> > > > CAP_SYS_ADMIN is writing trusted.foo. Should that succeed? Is a
> > > > passthrough filesystem, so it should go through. But currently it
> > > > wont.
> > > 
> > > As long as any effects of what it writes are contained to the area of
> > > the filesystem exposed to the guest, yes - however it worries me what
> > > the consequences of broken trusted metadata is.  If it's delicate enough
> > > that it's guarded by CAP_SYS_ADMIN someone must have worried about it.
> > 
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
> 
> overlayfs inside the kernel is using trusted though which is the case
> Vivek ran into.

IIUC, this is need on the lower-layer FS. If you're running overlayfs on the
host, then virtiofsd is exposing the upper layer FS, so guest use of "trusted."
on the upper layer won't clash with overlayfs in the host.

If you're running overlayfs in the guest, then virtiofs is the lower layer
so needs to support the "trusted." on the FS its exposing. Again this should
not clash with anything on the host.

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
> > 
> > Unfortuntely this implies allowing CAP_SYS_ADMIN by default. We could
> > have a "--trusted-xattrs=on|off" flag to allow people to run in a more
> > locked down state if they knowingly want to block trusted xattrs.
> 
> Does the trick described by Chirantan work for you, where the clients
> 'trusted' view is different from the host?

That works as long as you don't require any interoperability with
processes that have setup the exposed file tree on the host, or
might need to concurrently access it.

This probably suggests a need various modes of exposing xattrs

 - "passthrough"  - run CAP_SYS_ADMIN and pass directly
 - "mapped"       - no capabilities, rewrite everything into user. namespace
 - "disable"      - don't allow xattr

As mentioned in the other thread though, CAP_SYS_ADMIN needs to be present
in the initial namespace, so to support "passthrough" we'd have to NOT
use user namespace too. Something to be aware of when we accept the
user namespace patches.

Such "mapping" of attributes could also be used if virtiofs was running
as an unprivileged user account, to expose a full range of file owner,
group and permissions to the guest, while having everything be owned
by the normal user on the host.   QEMU's current 9p filesystem has
this kind of mapping support for owner/permissions, so guest view can
be distinct from the host view.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

