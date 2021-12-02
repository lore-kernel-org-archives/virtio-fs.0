Date: Thu, 2 Dec 2021 10:51:58 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YajrnsEFa+Zkcke3@redhat.com>
References: <CAJh=p+6o8_2UekwO0nQ8+sjcgpcEzGhFrTsiTjN4n72R3vNAGw@mail.gmail.com>
	<Yafy7hF56oPn9h4/@redhat.com>
	<CAJh=p+6RYEHVCVdqFg8+zZJ=bBy_De7v=-mCqa5k5_g0qih1gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJh=p+6RYEHVCVdqFg8+zZJ=bBy_De7v=-mCqa5k5_g0qih1gg@mail.gmail.com>
Subject: Re: [Virtio-fs] [virtiofsd][virtiofsd-rs] unlink an openfile over
	NFS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: German Maglione <gmaglione@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Dec 02, 2021 at 04:03:20PM +0100, German Maglione wrote:
> On Wed, Dec 1, 2021 at 11:10 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > On Wed, Dec 01, 2021 at 01:06:23PM +0100, German Maglione wrote:
> > > Hi,
> > >
> > > I was working on [1] (related to [2]), and I saw that both versions
> > > (C and rust) of virtiofsd make the NFs client to "silly rename" an open
> > > file that were unlinked, because we keep each file open as O_PATH in the
> > > lo_do_lookup/do_lookup function. David pointed me to this problem, and I
> > > confirmed that this is the case.
> > >
> > > This fires the silly rename in the nfs client. I'm talking with
> > > Bruce Fields (nfs team) to see how to move the silly rename functionality
> > > to the nfs server and outside the directory tree [4], to avoid having
> > > non-really-empty
> > > dirs full of .nfsxxx files. But it is not an easy task.
> > > Also, this will not solve some potential issues with the resource usage:
> > > disk space and open file limits (I hit this limit a couple of times
> > during
> > > my
> > > tests). And, in some cases could be worst, more than one guest sharing
> > the
> > > same
> > > exported dir, one guest just 'ls' or 'find' while the other 'rm' some
> > files.
> > > (The 'find' command will open all files, btw)
> > >
> > > Vivek, I saw in [5] that you mentioned that this could be fixed
> > introducing
> > > synchronous, could you elaborate a bit or point me to some code?
> >
> > Hi German,
> >
> > Right now forget messages are asynchronous. They are sent to server and
> > client does not wait for any reply. That means when unlink() returns,
> > it is possible that a FORGET message is in progress and has not finished
> > yet.
> >
> > Idea behind synchronous FORGET messages is that it will generate a reply
> > and client will wait for it. Given inode on server should be gone,
> > I am not sure how much sense does it make. But anyway conceputaully
> > that's the idea. If we want for FORGET message to finish, that will
> > mean that O_PATH fd opened by virtiofsd is closed and we will not
> > have NFS silly rename issue (atleast due to virtiofsd). If virtiofs
> > client has file open, then issue will still happen.
> >
> > I think using file handles in virtiofsd_rs (--inode-file-handles) is
> > a reasonable solution for this problem. Trying to add synchronous
> > FORGET might be overkill.
> >
> >
> Hi Vivek,
> 
> Yes, as you said the solution is using --inode-file-hanldes, turns out
> the problem was the --inode-file-handles failed silently when
> choosing a sandbox other than namespace (now fixed by Hanna).
> 
> So now the thing is, what we do if it fails? Hanna posted an Issue about
> that:
> "[RFE] Reporting failure to generate file handles".

My take from the beginning has been that if file handle generation fails,
then report it back to user (instead of falling back to O_PATH fd
silently). That way user atleast knows that file handles can't be used.

If file handles can't be generated due to lack of resources in system,
then error should be returned to caller as well.

> 
> There is any problem to use file handles as default?

It gives CAP_DAC_READ_SEARCH in init_user_ns. So enabling it by default
might not be desirable. Especially given the fact that we want to move
towards user namespaces and run virtiofsd with least priviliges. So
I will think user needs to enable it if they need it.

> I mean without
> --inode-file-handles so let them fail and force the user to use something
> like
> --no-file-handles/--force-no-file-handles with a warning.

If we were to enable it by default, we probably should test if file
handles are supported on shared dir. If yes, then enable it by default
otherwise continue to use O_PATH fd. But this will be mode switch for
the whole shared filesystem.

I think given we have notion of submounts and some of the submounted
filesystems might not support file handles, so key question will be
what do we do here. Do we return error in this case or fallback to
O_PATH fd for that submount. If we stick to our design philosophy,
then I would say return error. But some people might object because
they might want a mode where there is mix of filesystems in shared
dir and they want to use file handles where supported. So I am sitting
on the fence on this one.

Thanks
Vivek

