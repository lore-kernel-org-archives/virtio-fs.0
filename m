Date: Thu, 18 Jun 2020 15:27:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200618192717.GE3814@redhat.com>
References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200618190816.GD3814@redhat.com> <20200618191655.GI2769@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200618191655.GI2769@work-vm>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: drop Linux capabilities(7)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Jun 18, 2020 at 08:16:55PM +0100, Dr. David Alan Gilbert wrote:
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > On Thu, Apr 16, 2020 at 05:49:05PM +0100, Stefan Hajnoczi wrote:
> > > virtiofsd doesn't need of all Linux capabilities(7) available to root.  Keep a
> > > whitelisted set of capabilities that we require.  This improves security in
> > > case virtiofsd is compromised by making it hard for an attacker to gain further
> > > access to the system.
> > 
> > Hi Stefan,
> > 
> > I just noticed that this patch set breaks overlayfs on top of virtiofs.
> > 
> > overlayfs sets "trusted.overlay.*" and xattrs in trusted domain
> > need CAP_SYS_ADMIN.
> > 
> > man xattr says.
> > 
> >    Trusted extended attributes
> >        Trusted  extended  attributes  are  visible and accessible only to pro‐
> >        cesses that have the  CAP_SYS_ADMIN  capability.   Attributes  in  this
> >        class are used to implement mechanisms in user space (i.e., outside the
> >        kernel) which keep information in extended attributes to which ordinary
> >        processes should not have access.
> > 
> > There is a chance that overlay moves away from trusted xattr in future.
> > But for now we need to make it work. This is an important use case for
> > kata docker in docker build.
> > 
> > May be we can add an option to virtiofsd say "--add-cap <capability>" and
> > ask user to pass in "--add-cap cap_sys_admin" if they need to run daemon
> > with this capaibility.
> 
> I'll admit I don't like the idea of giving it cap_sys_admin.
> Can you explain:
>   a) What overlayfs uses trusted for?

overlayfs stores bunch of metadata and uses "trusted" xattrs for it.

>   b) If something nasty was to write junk into the trusted attributes,
>     what would happen?

This directory is owned by guest. So it should be able to write
anything it wants, as long as process in guest has CAP_SYS_ADMIN, right?

>   c) I see overlayfs has a fallback check if xattr isn't supported at
> all - what is the consequence?

It falls back to I think read only mode. 

For a moment forget about overlayfs. Say a user process in guest with
CAP_SYS_ADMIN is writing trusted.foo. Should that succeed? Is a
passthrough filesystem, so it should go through. But currently it
wont.

Thanks
Vivek

