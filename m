DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=JrKE0/k9TqvO63dFVD5bdAgHBAm+WjFMdax9qWxHqKs=;
	b=CojCw9Fmh9zgr/0dIGJBy9xx9eWODCnoJMmbcD0f752ky4fgbcwRw7B9uOCFzQRteP
	O2rqfKu0O73IQxAsBUNVFV+5qRjL6w/6Z4E8M+CWtfRdEF7SgdIqv4cWr9QErt9oJsy+
	jvcNmhVrwy0jEDEA3z16tYXv1cKUu6B1tKL4lcF7T0uf19RthMQchvysM2Rzbg7XHXcV
	2jm8Gvduu8R9jNUnn67MjsyYV+hbQ+JgW5mOitej7bNy4O84oi5OzqlpW06UvPp+9zVR
	4aqsRg4qS05H8m0uUCO2eyQ4D/jDNHlDyZXtevyZcNDz1VIyS5MwcO9ADjmuvS064y2b
	8+Ug==
MIME-Version: 1.0
References: <CAJFHJroyC8SAFJZuQxcwHqph5EQRg=MqFdvfnwbK35Cv-A-neA@mail.gmail.com>
	<CAJfpegtWEMd_bCeULG13PACqPq5G5HbwKjMOnCoXyFQViXE0yQ@mail.gmail.com>
	<CAEjxPJ56JXRr0MWxtekBhfNS7i8hFex2oiwqGYrh=m1cH9X4kg@mail.gmail.com>
	<CAJFHJrppbb1cUTq9w7G7E2RrV5CbYx54dAfk62tiZYCewcwXhg@mail.gmail.com>
In-Reply-To: <CAJFHJrppbb1cUTq9w7G7E2RrV5CbYx54dAfk62tiZYCewcwXhg@mail.gmail.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Thu, 7 May 2020 09:06:43 -0400
Message-ID: <CAEjxPJ6LZowJJ1uQXa+NTSMA=y2AWatNKvtp3iDcH7kL4D-qcw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] fuse doesn't use security_inode_init_security?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel <fuse-devel@lists.sourceforge.net>, virtio-fs-list <virtio-fs@redhat.com>, SElinux list <selinux@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Thu, May 7, 2020 at 3:53 AM Chirantan Ekbote <chirantan@chromium.org> wrote:
> On Sat, May 2, 2020 at 3:32 AM Stephen Smalley
> <stephen.smalley.work@gmail.com> wrote:
> >
> >
> > (cc selinux list)
> >
> > security_inode_init_security() calls the initxattrs callback to
> > actually set each xattr in the backing store (if any), so unless you
> > have a way to pass that to the daemon along with the create request
> > the attribute won't be persisted with the file.  Setting the xattrs is
> > supposed to be atomic with the file creation, not a separate
> > setxattr() operation after creating the file, similar to ACL
> > inheritance on new files.
> >
>
> But it's not truly atomic, is it?  The underlying file system creates
> the inode and then the inode_init_security selinux hook actually sets
> the attributes.  What would happen if the computer lost power after
> the file system driver created the inode but before the selinux hook
> set the attributes?

IIUC, in the case of ext4 and xfs at least, the setting of the
security.selinux xattr is performed in the same transaction as the
file create, so a crash will either yield a file that has its xattr
set or no file at all.  This is also true of POSIX ACLs.  Labeled NFS
(NFSv4.2) likewise is supposed to send the MAC label with the file
create request and either create it with that label or not create it
at all.  Note that nfs however uses security_dentry_init_security() to
get the MAC label since it doesn't yet have an inode and MAC labels
are a first class abstraction in NFS not merely xattrs.

> > - deadlock during mount with userspace waiting for mount(2) to complete
> > and the kernel blocked on requesting the security.selinux xattr of the
> > root directory as part of superblock setup during mount
>
> I haven't personally run into this.  It Just Works, except for the
> fscreate issue.

Yes, this can be worked around in your fuse daemon if it supports
handling getxattr during mount (e.g. multi-threaded, other threads can
service the getxattr request while the mount(2) is still in progress).
But not supported by stock fuse userspace IIUC.

> I guess what I'm trying to understand is: what are the issues with
> having the fuse driver call the inode_init_security hooks?  Even if
> it's not something that can be turned on by default in mainline, I'd
> like to evaluate whether we can turn it on locally in our restricted
> environment.
>
> One issue is the lack of atomicity guarantees.  This is likely a
> deal-breaker for general fuse usage.  However, I don't think it's an
> issue for our restricted use of virtiofs because the attributes will
> be set "atomically" from the guest userspace's perspective.  It won't
> be atomic on the host side, but host processes don't have access to
> those directories anyway.
>
> Are there any other issues?

I don't have a problem with fuse calling the hook (either
security_inode_init_security or security_dentry_init_security).  It is
just a question of what it will do with the result (i.e. what its
initxattr callback will do for the former or what it will do with the
returned label in the latter). Optimally it will take the label
information and bundle it up along with the create request to the
daemon, which can then handle it as a single transaction.  Failing
that, it needs to support setting the label in some manner during file
creation that at least provides atomicity with respect to the user of
the filesystem (the guest in your case).


