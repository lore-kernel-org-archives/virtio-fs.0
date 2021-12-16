DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=xNID7Sbx1YrHMAqjDAV6CUzhEiec7Mg9Bx/OS+Vsixc=;
	b=g0cW84uIYeFNmoqWgs8bcw1iIveqC4ILmnfk4sDrT/8R1Xq0KrwPWKErvGe2X++1oJ
	dARqW9hHCDfO8WdnLI42gt+UjeWYKDU25uvrzStw1Aql2sxwyMdxBeIxLKGWfEuyMRza
	b/iZtyDjB6KJkYe4k5eTjgbkuMvbO7saJ8Hs+zfhZe6bbVXEbtVn+PzXv72ZSO5DqGGA
	PTHrdHTt1uKTyLCGVILLM5+98w+ceBFLjl2aTAFmsItJPkv2v2BOF3lG3SP0jgTa9GbH
	y/8xIJouCFsLCglqHj/1nsDmFO/tzLGu5UMOJJFz3EcwAOeMDWUmST+DvXyhzO91c43R
	Gadg==
MIME-Version: 1.0
References: <20211111173043.GB25491@quack2.suse.cz>
	<CAOQ4uxiOUM6=190w4018w4nJRnqi+9gzzfQTsLh5gGwbQH_HgQ@mail.gmail.com>
	<CANXojcy9JzXeLQ6bz9+UOekkpqo8NkgQbhugmGmPE+x3+_=h3Q@mail.gmail.com>
	<CAO17o21YVczE2-BTAVg-0HJU6gjSUkzUSqJVs9k-_t7mYFNHaA@mail.gmail.com>
	<CAOQ4uxjpGMYZrq74S=EaSO2nvss4hm1WZ_k+Xxgrj2k9pngJgg@mail.gmail.com>
	<YaZC+R7xpGimBrD1@redhat.com>
	<CAO17o21uh3fJHd0gMu-SmZei5et6HJo91DiLk_YyfUqrtHy2pQ@mail.gmail.com>
	<CAOQ4uxjfCs=+Of69U6moOJ9T6_zDb1wcrLXWu4DROVme1cNnfQ@mail.gmail.com>
	<YbobZMGEl6sl+gcX@redhat.com>
	<CAOQ4uxj9XZNhHB3y9LuGcUJYp-i4f-LXQa2tzX8AkZpRERH+8w@mail.gmail.com>
	<Ybo/5h9umGlinaM4@redhat.com>
	<CAOQ4uxheVq-YHkT9eOu3vUNt1RU4Wa6MkyzXXLboHE_Pj6-6tw@mail.gmail.com>
In-Reply-To: <CAOQ4uxheVq-YHkT9eOu3vUNt1RU4Wa6MkyzXXLboHE_Pj6-6tw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 16 Dec 2021 13:03:00 +0200
Message-ID: <CAOQ4uxjzW7mt0pqA+K_sEJokYcv_D3e7axAOWLXxQ84bZDnfcw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [RFC PATCH 0/7] Inotify support in FUSE and virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Steve French <sfrench@samba.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, Nathan Youngman <git@nathany.com>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Stef Bon <stefbon@gmail.com>

> > I understand that part. But at the same time, remote fsnotify API will
> > probably evolve as you keep on adding more functionality. What if there
> > is another notification mechanism tomorrow say newfancynotify(), we
> > might have to modify remote fsnoitfy again to accomodate that.
> >
> > IOW, fsnotify seems to be just underlying plumbing and whatever you
> > add today might not be enough to support tomorrow's features. That's
> > why I wanted to start with a minimal set of functionality and add
> > more to it later.
> >
>
> I do want to start with minimal functionality.
> I did not request that you implement more functionality than what inotify
> provides.
>
> TBH, I can't even remember the specific details that made me say
> "this is remote inotify not remote fsnotify", but there were such details.
> I remember inotify rename cookie being one of them.
>

Let me repeat my concern about the rename cookie API.

As Jan has convinced me to create a new event FS_RENAME
for fanotify, there is no harm in FUSE passing the rename cookie
along with FS_MOVE events, but the FUSE out args:

struct fuse_notify_fsnotify_out {
 uint64_t inode;
 uint64_t mask;
 uint32_t namelen;
 uint32_t cookie;
};

How do you expect to extend it when somebody wants to implement
the FS_RENAME event that carries two names and two dir inodes
(and no cookie)?
Will they need to use a new out struct? a union?

Unlike inotify, fanotify can sometimes report the inode of the child
along with inode of the parent in events (e.g. FS_OPEN) when watching
a parent directory.

How will this out args struct be extended if we would want to pass that
information?

There is no need to address this now. I just want to know that the
design you suggest is extendable to future needs and if it is not,
I would prefer to reserve enough fields in the FUSE event
struct for the common needs of all current fsnotify backends,
just as we pass all the relevant info to the fsnotify_XXX() hooks.

> I guess this discussion is not very productive at this point as none of us
> are saying anything very specific about what should and should not
> be done, so let me try to suggest something -
>
> Try to see if you could replace the server side implementation with
> fanotify even if you use CAP_SYS_ADMIN for the experiment.
> fanotify should be almost a drop-in replacement for inotify at this point
> If you think that you cannot make this experiment with your current
> protocol and vfs extensions then you must have done something wrong
> and tied the protocol and/or the vfs API to inotify terminology.
>

So I did this thought experiment myself.
I did not find any obvious issues with implementing the backend as
fanotify. If anything, mapping fhandle to inode is even a bit easier
than mapping wd to inode if you know the fhandle encoding.

For event reporting, besides generalizing the out args, implementation
would be similar. Since FUSE uses nodeid to identify the object in
events, there is no problem for fanotify to report fhandle and inotify
to report wd.

For setting watches, protocol seems generic enough, although
I dislike how fuse_fsnotify_update_mark() masks out inotify
specific flags.

inotify back should mask out its own private flags when calling
into a generic vfs API for registering remote watches.
Also, masking out FS_EVENT_ON_CHILD is pretty weird, because
requesting a watch on children is functionally completely different
than requesting to watch the directory itself.

I think I gave you enough comments already for a new revision.
Are there any open questions left unanswered?

And please grep your kernel patches for "inotify" and "remote inotify"
in particular. When this term is used in comments and commit messages,
it is very likely that either the code or documentation is inaccurate.

Thanks,
Amir.

