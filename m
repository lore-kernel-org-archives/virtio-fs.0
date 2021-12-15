DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc:content-transfer-encoding;
	bh=HLzkZwxUORSuAaMga1zZZgHl5SrVra1DV3qXR9oBK4E=;
	b=bvkmtkKyhwwp20nFZcpttLJ9ahPgY7YGMwR2dOLRtvbBp0GS5cM/ApJmUfycc/w5ou
	p1vnYA3unPaU0Mx1RJ4Ir7Ed6QX5396oNCoCoZQDo9AXd8Gbp6+X23Uza1eOiTMc1RhW
	3S6qUgzIgWNfz46S75xudpKHcUnDGS3YpQ6C4FCM71aprLnaZjnannVx70ccDWJY+zoM
	1q5l0RIcn3O6mg2p6vRuLxkGHxvIhozCORRUsgkMvplUMtf3yIrmJ0pMuy/mkgYCcdrF
	I746fQXaT6oDbYPtjBB/J/4O7sbalUuKmk4Hm5cJPClHSk9cp3jV6RISRjtbRR9zOeYT
	ImDA==
MIME-Version: 1.0
References: <CAOQ4uxjsULgLuOFUYkEePySx6iPXRczgCZMxx8E5ncw=oarLPg@mail.gmail.com>
	<YYMO1ip9ynXFXc8f@redhat.com> <20211104100316.GA10060@quack2.suse.cz>
	<YYU/7269JX2neLjz@redhat.com>
	<CAOQ4uxiM_i+6Zs+ewg8mfA5aKs-gY7yj3kdrmPLO8Zn+bz4DbA@mail.gmail.com>
	<20211111173043.GB25491@quack2.suse.cz>
	<CAOQ4uxiOUM6=190w4018w4nJRnqi+9gzzfQTsLh5gGwbQH_HgQ@mail.gmail.com>
	<CANXojcy9JzXeLQ6bz9+UOekkpqo8NkgQbhugmGmPE+x3+_=h3Q@mail.gmail.com>
	<CAO17o21YVczE2-BTAVg-0HJU6gjSUkzUSqJVs9k-_t7mYFNHaA@mail.gmail.com>
	<CAOQ4uxjpGMYZrq74S=EaSO2nvss4hm1WZ_k+Xxgrj2k9pngJgg@mail.gmail.com>
	<YaZC+R7xpGimBrD1@redhat.com>
	<CAO17o21uh3fJHd0gMu-SmZei5et6HJo91DiLk_YyfUqrtHy2pQ@mail.gmail.com>
In-Reply-To: <CAO17o21uh3fJHd0gMu-SmZei5et6HJo91DiLk_YyfUqrtHy2pQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 15 Dec 2021 09:10:47 +0200
Message-ID: <CAOQ4uxjfCs=+Of69U6moOJ9T6_zDb1wcrLXWu4DROVme1cNnfQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [RFC PATCH 0/7] Inotify support in FUSE and virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Ioannis Angelakopoulos <iangelak@redhat.com>
Cc: Steve French <sfrench@samba.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, Nathan Youngman <git@nathany.com>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Stef Bon <stefbon@gmail.com>

On Wed, Dec 15, 2021 at 1:22 AM Ioannis Angelakopoulos
<iangelak@redhat.com> wrote:
>
> Hello Amir and Jan,
>
> After testing some of your proposals, related to extending the remote notification to fanotify as well, we came across some issues that are not straightforward to overcome:
>
> 1) Currently fuse does not support persistent file handles.  This means that file handles become stale if an inode is flushed out of the cache. The file handle support is very limited at the moment in fuse. Thus, the only option left is to implement fanotify both in server and guest with file descriptors.

That premise is not completely accurate...

>
> 2) Since we can only use file descriptors, to support fanotify in viritofsd we need CAP_SYS_ADMIN enabled. The virtiofs developers are not very positive about the idea of using CAP_SYS_ADMIN for security reasons. Thus we attempted to support some basic fanotify functionality on the client/guest by modifying our existing implementation with inotify/fsnotify.
>
> 3) Basically, we continue to use inotify on the virtiofsd/fuse server but we add support on the client/guest kernel to be able to support simple fanotify events (i.e., for now the same events as inotify). However, two important problems arise from the use of the fanotify file descriptor mode in a guest process:

You may use whatever implementation you like is the server.
inotify, fanotify, pub/sub to notify one client on changes from other clients.
My comments are only about the protocol and vfs API, which affect all
other FUSE servers
that would want to implement fsnotify support in the future and other remote
filesystems that would want to implement remote fsnotify in the future.

>
> 3a) First, to be able to support fanotify in the file descriptor mode we need to pass to a "struct path" to the fsnotify call (within the guest kernel) that corresponds to the inode that we are monitoring. Unfortunately, when the guest receives the remote event from the server it only has information about the target inode. Since there is more than one mapping of "struct path" to a "struct inode" we do not know which path information to pass to the fsnotify call.
>
> 3b) Second, since the guest kernel needs to pass an open file descriptor back to the guest user space as part of the fanotify event data, internally the guest kernel (through fanotify's "create_fd" function) issues a "dentry_open" which will result in an additional FUSE_OPEN call to the server and subsequently the generation of an open event on the server (If the server monitors for an open event). This will inevitably cause an infinite loop of FUSE_OPEN requests and generation of open events on the server. One idea was to modify the open syscall (on the host kernel) to allow the use of FMODE_NONOTIFY flag from user space (currently it is used internally in the kernel code only), to be able to suppress open events. However, a malicious guest might be able to exploit that flag to disrupt the event generation for a file (I am not entirely sure if this is possible, yet).
>

Supporting event->fd and permission events for that matter was never
my intention when I suggested limited fanotify support.

> To sum up, it seems that the support for fanotify causes some problems that are very difficult to mitigate at the moment. The fanotify file handles mode would probably solve most if not all of the above problems we are facing, however as Vivek pointed out the file handle support in virtiofs/fuse is another project altogether.
>
> So we would like to ask you for any suggestions related to the aforementioned problems. If there are no "easy" solutions in sight for these fanotify issues, we would like to at least continue to support the remote inotify in the next version of the patches and try to solve issues around it.
>

The mistake in your premise at 1) is to state that "fuse does not
support persistent file handles"
without looking into what that statement means.
What it really means is that user cannot always open_by_handle_at()
from a previously
obtained file handle, which has obvious impact on exporting fuse to NFS (*).

But there is no requirement of fanotify for the user to be able to
open_by_handle_at()
from the information in the event, in fact, it is a non-requirement, because
open_by_handle_at() requires CAP_DAC_READ_SEARCH and fanotify supports
non privileged users.
Quoting the fanotify.7 man page:
"file_handle
              ...It is an opaque handle that corresponds to a
specified object on a filesystem
              as returned by name_to_handle_at(2).  It can  be  used
to uniquely identify a file
              on a filesystem and can be passed as an argument to
open_by_handle_at(2).
"
It CAN be passed to open_by_handle_at() - it does not have to be passed, because
a unique object id is useful enough without being able to open_by_handle_at() as
long as the user who set up the watch on the object keeps a record of
that unique id.
So the project of file handle support in virtiofs/fuse is completely independent
and complementary to supporting remote fanotify in file handle mode.

I hope I was able to explain myself.
Let me know if anything is not clear.

Thanks,
Amir.

(*) It is correct to state that "FUSE support for persistent file
handles is limited",
and FUSE protocol does need to be extended to provide better file
handle support,
but actually, it would be more accurate to say that virtiofs (and most
other fuse servers)
support for persistent file handles is limited.
I wrote a generic framework called fuse_passthrough [1] that can be
used to write a fuse
server that does export persistent file handles to NFS when passing
through to xfs/ext4
(and the server has CAP_SYS_ADMIN).

[1] https://github.com/amir73il/libfuse/commits/fuse_passthrough


