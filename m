Date: Thu, 1 Jul 2021 09:10:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210701131030.GB159380@redhat.com>
References: <20210629152007.GC5231@redhat.com>
	<78663f5c-d2fd-747a-48e3-0c5fd8b40332@schaufler-ca.com>
	<20210629173530.GD5231@redhat.com>
	<f4992b3a-a939-5bc4-a5da-0ce8913bd569@redhat.com>
	<YNvvLIv16jY8mfP8@mit.edu> <YNwmXOqT7LgbeVPn@work-vm>
	<YNyECw/1FzDCW3G8@mit.edu> <YNyHVhGPe1bFAt+C@work-vm>
	<YNzNLTxflKbDi8W2@mit.edu> <YN2BYXv79PswrN2E@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YN2BYXv79PswrN2E@work-vm>
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
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: "berrange@redhat.com" <berrange@redhat.com>, Theodore Ts'o <tytso@mit.edu>, "selinux@vger.kernel.org" <selinux@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "Schaufler,
	Casey" <casey.schaufler@intel.com>, linux-security-module <linux-security-module@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

On Thu, Jul 01, 2021 at 09:48:33AM +0100, Dr. David Alan Gilbert wrote:
> * Theodore Ts'o (tytso@mit.edu) wrote:
> > On Wed, Jun 30, 2021 at 04:01:42PM +0100, Dr. David Alan Gilbert wrote:
> > > 
> > > Even if you fix symlinks, I don't think it fixes device nodes or
> > > anything else where the permissions bitmap isn't purely used as the
> > > permissions on the inode.
> > 
> > I think we're making a mountain out of a molehill.  Again, very few
> > people are using quota these days.  And if you give someone write
> > access to a 8TB disk, do you really care if they can "steal" 32k worth
> > of space (which is the maximum size of an xattr, enforced by the VFS).
> > 
> > OK, but what about character mode devices?  First of all, most users
> > don't have access to huge number of devices, but let's assume
> > something absurd.  Let's say that a user has write access to *1024*
> > devices.  (My /dev has 233 character mode devices, and I have write
> > access to well under a dozen.)
> > 
> > An 8TB disk costs about $200.  So how much of the "stolen" quota space
> > are we talking about, assuming the user has access to 1024 devices,
> > and the file system actually supports a 32k xattr.
> > 
> >     32k * 1024 * $200 / 8TB / (1024*1024*1024) = $0.000763 = 0.0763 cents
> > 
> > A 2TB SSD is less around $180, so even if we calculate the prices
> > based on SSD space, we're still talking about a quarter of a penny.
> > 
> > Why are we worrying about this?
> 
> I'm not worrying about storage cost, but we would need to define what
> the rules are on who can write and change a user.* xattr on a device
> node.  It doesn't feel sane to make it anyone who can write to the
> device; then everyone can start leaving droppings on /dev/null.
> 
> The other evilness I can imagine, is if there's a 32k limit on xattrs on
> a node, an evil user could write almost 32k of junk to the node
> and then break the next login that tries to add an acl or breaks the
> next relabel.

I guess 64k is per xattr VFS size limit.

#define XATTR_SIZE_MAX 65536

I just wrote a simple program to write "user.<N>" xattrs of size 1K
each and could easily write 1M xattrs. So that 1G worth data right
there. I did not try to push it further.

So a user can write lot of data in the form of user.* xattrs on
symlinks and device nodes if were to open it unconditionally. Hence
permission semantics will probably will have to defined properly.

I am wondering will it be alright if owner of the file (or CAP_FOWNER),
is allowed to write user.* xattrs on symlinks and special files.

Vivek

