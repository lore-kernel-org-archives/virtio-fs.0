Date: Tue, 14 Jan 2020 07:55:07 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200114125507.GA23014@redhat.com>
References: <20200110010722.27491-1-misono.tomohiro@jp.fujitsu.com>
	<20200113183835.GA23831@redhat.com>
	<CAOssrKcbi69mY0yk_8WpDRvsunqAzxCoBkUk9o5DQ7kAW6jORw@mail.gmail.com>
	<OSBPR01MB4582FF3E5050F4D4488F4DECE5340@OSBPR01MB4582.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSBPR01MB4582FF3E5050F4D4488F4DECE5340@OSBPR01MB4582.jpnprd01.prod.outlook.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Fix xattr operations
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Tue, Jan 14, 2020 at 01:17:37AM +0000, misono.tomohiro@fujitsu.com wrote:
> > On Mon, Jan 13, 2020 at 7:42 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Fri, Jan 10, 2020 at 10:07:22AM +0900, Misono Tomohiro wrote:
> > >
> > > [..]
> > > > --- a/tools/virtiofsd/passthrough_ll.c
> > > > +++ b/tools/virtiofsd/passthrough_ll.c
> > > > @@ -133,6 +133,7 @@ struct lo_inode {
> > > >      GHashTable *posix_locks; /* protected by lo_inode->plock_mutex
> > > > */
> > > >
> > > >      bool is_symlink;
> > > > +    bool is_regular;
> > > >  };
> > > >
> > > >  struct lo_cred {
> > > > @@ -1038,6 +1039,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> > > >          }
> > > >
> > > >          inode->is_symlink = S_ISLNK(e->attr.st_mode);
> > > > +        inode->is_regular = S_ISREG(e->attr.st_mode) +
> > > > + S_ISDIR(e->attr.st_mode);
> > >
> > > How about having two variables. One for regular files and one for
> > > directories. Say ->is_regular and ->is_dir.  That way if there are
> > > other users later, these can cleary differentiate between regular
> > > files and directories.
> 
> Thanks for the comments
> Maybe we should just hold st_mode in lo_inode? I'm fine with either approach and will update.

Caching st_mode (only file type and not mode) sounds good to me. That's
even more generic and more usable for future use cases.

Thanks
Vivek

