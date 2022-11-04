Return-Path: <fweimer@redhat.com>
From: Florian Weimer <fweimer@redhat.com>
References: <87r0yj17l6.fsf@oldenburg.str.redhat.com>
 <Y2UM/C3aYtQwf40M@redhat.com>
Date: Fri, 04 Nov 2022 18:44:39 +0100
In-Reply-To: <Y2UM/C3aYtQwf40M@redhat.com> (Vivek Goyal's message of "Fri, 4
 Nov 2022 09:00:44 -0400")
Message-ID: <875yfuzkag.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [Virtio-fs] Use of unshare(CLONE_FS) in virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Miklos Szeredi <mszeredi@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, Sergio Lopez <slp@redhat.com>

* Vivek Goyal:

>>  The usual
>> recommendation for emulating it is to use openat with O_PATH, and then
>> use getxattr on the virtual /proc/self/fd path.  This needs an
>> additional system call (openat, getxattr, close instead of fchdir,
>> getxattr),
>
> openat(O_PATH) + getxattr(/proc/self/fd) + close() sounds reasonable
> too. Not sure why did we not take that path. May be due to that extra
> syscall or something else.

Thanks.

>> but it avoids the unshare(CLONE_FS) call behind libc's back.
>
> Hmm.., did not know that libc does not like threads calling
> unshare(CLONE_FS). Not sure why that is a problem.

Here's a corner case: We plan to add chroot detection to NSS module
loading (so that we do not load NSS modules after chroot), as a form of
security hardening.  If the application calls unshare(CLONE_FS) and then
chroot, which NSS modules are loaded depends on which threads call NSS
functions.

One could argue that chdir/chroot are problematic, not
unshare(CLONE_FS). 8-)

> BTW, we need separate umask per thread as well. During file creation 
> we might be switching to umask provide in fuse protocol message
> and then switch back. Given multiple therads might be doing this
> creation in parallel, so we ofcourse need this to be per thread
> property.

That's a good point.  That's not something that can be worked around
with *at functions.

> So if your patches for pthread_create() with per thread filesystem
> attributes finally goes upstream, I guess we should be able to
> make use of it and drop unshare(CLONE_FS).

Thank you for the feedback.

Florian
