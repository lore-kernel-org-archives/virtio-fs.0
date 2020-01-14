DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=1ixk3HfhO8c365urQzGgVGgsVoFwEZPUVEM4zAoACW4=;
	b=lB7CHFooF5PjRlFrhcc9PvvcJSWuJFTjLBh4LDzMSZqO/JT6n3F33djzDImL3O4nqrc6PFeyZO0lv9/zmorTlvI84ggskQdyRdWmH08xpBXzmToNgNHcg3zeeS28qaWnPs3XzLW4l2O1m+QaV60lN2qo1Sm7R+ccEClgWUHusJQ=
From: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Date: Tue, 14 Jan 2020 11:34:18 +0000
Message-ID: <OSBPR01MB458222AE2AE6FBC956582417E5340@OSBPR01MB4582.jpnprd01.prod.outlook.com>
References: <20200110010722.27491-1-misono.tomohiro@jp.fujitsu.com>
	<20200113183835.GA23831@redhat.com>
	<CAOssrKcbi69mY0yk_8WpDRvsunqAzxCoBkUk9o5DQ7kAW6jORw@mail.gmail.com>
	<OSBPR01MB4582FF3E5050F4D4488F4DECE5340@OSBPR01MB4582.jpnprd01.prod.outlook.com>
	<CAOssrKf-nENQ-P53yZ5Z65vLyhm=hJh3Unnz-3LFU2SVZ3+1Lw@mail.gmail.com>
In-Reply-To: <CAOssrKf-nENQ-P53yZ5Z65vLyhm=hJh3Unnz-3LFU2SVZ3+1Lw@mail.gmail.com>
Content-Language: ja-JP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Fix xattr operations
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: 'Miklos Szeredi' <mszeredi@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

> On Tue, Jan 14, 2020 at 2:17 AM misono.tomohiro@fujitsu.com <misono.tomohiro@fujitsu.com> wrote:
> >
> > > On Mon, Jan 13, 2020 at 7:42 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > >
> > > > On Fri, Jan 10, 2020 at 10:07:22AM +0900, Misono Tomohiro wrote:
> > > >
> > > > [..]
> > > > > --- a/tools/virtiofsd/passthrough_ll.c
> > > > > +++ b/tools/virtiofsd/passthrough_ll.c
> > > > > @@ -133,6 +133,7 @@ struct lo_inode {
> > > > >      GHashTable *posix_locks; /* protected by
> > > > > lo_inode->plock_mutex */
> > > > >
> > > > >      bool is_symlink;
> > > > > +    bool is_regular;
> > > > >  };
> > > > >
> > > > >  struct lo_cred {
> > > > > @@ -1038,6 +1039,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> > > > >          }
> > > > >
> > > > >          inode->is_symlink = S_ISLNK(e->attr.st_mode);
> > > > > +        inode->is_regular = S_ISREG(e->attr.st_mode) +
> > > > > + S_ISDIR(e->attr.st_mode);
> > > >
> > > > How about having two variables. One for regular files and one for
> > > > directories. Say ->is_regular and ->is_dir.  That way if there are
> > > > other users later, these can cleary differentiate between regular
> > > > files and directories.
> >
> > Thanks for the comments
> > Maybe we should just hold st_mode in lo_inode? I'm fine with either approach and will update.
> >
> > > >
> > > > >
> > > > >          /*
> > > > >           * One for the caller and one for nlookup (released in
> > > > > @@
> > > > > -2345,6 +2347,7 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
> > > > >      ssize_t ret;
> > > > >      int saverr;
> > > > >      int fd = -1;
> > > > > +    bool dir_changed = false;
> > > > >
> > > > >      inode = lo_inode(req, ino);
> > > > >      if (!inode) {
> > > > > @@ -2360,16 +2363,20 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
> > > > >      fuse_log(FUSE_LOG_DEBUG, "lo_getxattr(ino=%" PRIu64 ", name=%s size=%zd)\n",
> > > > >               ino, name, size);
> > > > >
> > > > > -    if (inode->is_symlink) {
> > > > > -        /* Sorry, no race free way to getxattr on symlink. */
> > > > > -        saverr = EPERM;
> > > > > -        goto out;
> > > > > -    }
> > > > > -
> > > >
> > > > This code came from Miklos as part of original commit in libfuse.
> > > >
> > > > commit fc9f632a219decea427271dc5a77654f6aaa9610
> > > > Author: Miklos Szeredi <mszeredi@redhat.com>
> > > > Date:   Tue Aug 14 21:37:02 2018 +0200
> > > >
> > > >     passthrough_ll: add *xattr() operations
> > > >
> > > > Miklos, can you please help us understand what are the races you
> > > > are concerned about on symlink and whether this patch fixes those
> > > > races or not. If not, then we probably need to retain this code
> > > > and not allow xattr operations on symlink yet.
> > >
> > > I missed the fact that setattr(2), getattr(2) etc. on a proc symlink
> > > (A) pointing to a real symlink (B) will resolve A but not B.
> > >
> > > The patch looks good.
> > >
> > > Thanks,
> > > Miklos
> >
> > Thanks for review and confirming.
> > sidenote: so can we fix libfuse/passthrough_ll as well?
> 
> I think we should.

Ok, I will send a patch there too in my spare time.

> 
> BTW, you earlier wrote that there was a performance problem with the
> fchdir() + getxattr() + fchdir() sequence.   Can you quantify how much
> it is worse than the openat() + fgetxattr()  + close() sequence?
> Because I'm wondering whether the added complexity is really worth it.

I see some performance hit in xfstests. For example, the runtimes of generic/127 (using fsx) are:
 no xattr ≒ 390s
 xattr (this patch) ≒ 440s
 xattr (always fchdir) ≒ 460s~480s
(kernel 5.4, backend XFS, default virtiofsd option other than xattr)

I don't know if there is a better way to measure xattr performance.

Thanks,
Misono

