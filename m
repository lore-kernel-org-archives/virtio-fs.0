Date: Mon, 6 Sep 2021 15:55:28 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YTYr4MgWnOgf/SWY@work-vm>
References: <20210902152228.665959-1-vgoyal@redhat.com>
	<79dcd300-a441-cdba-e523-324733f892ca@schaufler-ca.com>
	<YTEEPZJ3kxWkcM9x@redhat.com> <YTENEAv6dw9QoYcY@redhat.com>
	<3bca47d0-747d-dd49-a03f-e0fa98eaa2f7@schaufler-ca.com>
	<YTEur7h6fe4xBJRb@redhat.com>
	<1f33e6ef-e896-09ef-43b1-6c5fac40ba5f@schaufler-ca.com>
MIME-Version: 1.0
In-Reply-To: <1f33e6ef-e896-09ef-43b1-6c5fac40ba5f@schaufler-ca.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
Cc: gscrivan@redhat.com, tytso@mit.edu, agruenba@redhat.com, miklos@szeredi.hu, selinux@vger.kernel.org, stephen.smalley.work@gmail.com, david@fromorbit.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, casey.schaufler@intel.com, linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, bfields@redhat.com, christian.brauner@ubuntu.com, Vivek Goyal <vgoyal@redhat.com>

* Casey Schaufler (casey@schaufler-ca.com) wrote:
> On 9/2/2021 1:06 PM, Vivek Goyal wrote:

> >  If LSMs are not configured,
> > then hiding the directory is the solution.
> 
> It's not a solution at all. It's wishful thinking that
> some admin is going to do absolutely everything right, will
> never make a mistake and will never, ever, read the mount(2)
> man page.

That is why we run our virtiofsd with a sandbox setup and seccomp; and
frankly anything we can or could turn on we would.

> > So why that's not a solution and only relying on CAP_SYS_ADMIN is the
> > solution. I don't understand that part.
> 
> It comes back to your design, which is fundamentally flawed. You
> can't store system security information in an attribute that can
> be manipulated by untrusted entities. That's why we have system.*
> xattrs. You want to have an attribute on the host that maps to a
> security attribute on the guest. The host has to protect the attribute
> on the guest with mechanisms of comparable strength as the guest's
> mechanisms.

Can you just explain this line to me a bit more: 
> Otherwise you can't trust the guest with host data.

Note we're not trying to trust the guest with the host data here;
we're trying to allow the guest to store the data on the host, while
trusting the host.

> 
> It's a real shame that CAP_SYS_ADMIN is so scary. The capability
> mechanism as implemented today won't scale to the hundreds of individual
> capabilities it would need to break CAP_SYS_ADMIN up. Maybe someday.
> I'm not convinced that there isn't a way to accomplish what you're
> trying to do without privilege, but this isn't it, and I don't know
> what is. Sorry.
> 
> > Also if directory is not hidden, unprivileged users can change file
> > data and other metadata.
> 
> I assumed that you've taken that into account. Are you saying that
> isn't going to be done correctly either?
> 
> >  Why that's not a concern and why there is
> > so much of focus only security xattr.
> 
> As with an NFS mount, the assumption is that UID 567 (or its magically
> mapped equivalent) has the same access rights on both the server/host
> and client/guest. I'm not worried about the mode bits because they are
> presented consistently on both machines. If, on the other hand, an
> attribute used to determine access is security.esprit on the guest and
> user.security.esprit on the host, the unprivileged user on the host
> can defeat the privilege requirements on the guest. That's why.

We're OK with that; remember that the host can do wth it likes to the
guest anyway - it can just go in and poke at the guests RAM if it wants
to do something evil to the guest.
We wouldn't suggest using a scheme like this once you have
encrypted/protected guest RAM for example (SEV/TDX etc)

> >  If you were to block modification
> > of file then you will have rely on LSMs.
> 
> No. We're talking about the semantics of the xattr namespaces.
> LSMs can further constrain access to xattrs, but the basic rules
> of access to the user.* and security.* attributes are different
> in any case. This is by design.

I'm happy if you can suggest somewhere else to store the guests xattr
data other than in one of the hosts xattr's - the challenge is doing
that in a non-racy way, and making sure that the xattr's never get
associated with the wrong file as seen by a guest.

> >  And if LSMs are not configured,
> > then we will rely on shared directory not being visible.
> 
> LSMs are not the problem. LSMs use security.* xattrs, which is why
> they come up in the discussion.
> 
> > Can you please help me understand why hiding shared directory from
> > unprivileged users is not a solution
> 
> Maybe you can describe the mechanism you use to "hide" a shared directory
> on the host. If the filesystem is mounted on the host it seems unlikely
> that you can provide a convincing argument for sufficient protection.

Why? What can a guests fs mounted on the host, under one of the
directories that's already typically used for container fs's do - it's
already what fileservers, and existing container systems do.

Dave



> >  (With both LSMs configured or
> > not configured on host). That's a requirement for virtiofs anyway. 
> > And if we agree on that, then I don't see why using "user.*" xattrs
> > for storing guest sercurity attributes is a problem.
> >
> > Thanks
> > Vivek
> >
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

