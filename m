Date: Wed, 2 Sep 2020 14:08:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200902180804.GB1263242@redhat.com>
References: <20200901204045.1250822-1-vgoyal@redhat.com>
	<20200901204045.1250822-2-vgoyal@redhat.com>
	<CAJfpegtUMJqUDhFTePpFP=oQ=XGFj2tfvx+unV94sN3fFZbZHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtUMJqUDhFTePpFP=oQ=XGFj2tfvx+unV94sN3fFZbZHg@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 1/2] fuse: Add a flag FUSE_NONSHARED_FS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>

On Wed, Sep 02, 2020 at 08:57:07AM +0200, Miklos Szeredi wrote:
> On Tue, Sep 1, 2020 at 10:41 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > FUSE_NONSHARED_FS will signify that filesystem is not shared. That is
> > all fuse modifications are going thourgh this single fuse connection. It
> > should not happen that file's data/metadata changed without the knowledge
> > of fuse. Automatic file time stamp changes will probably be an exception
> > to this rule.
> >
> > If filesystem is shared between different clients, then this flag should
> > not be set.
> 
> I'm thinking maybe this flag should force some other parameters as well:

So you are thinking of fuse enforcing these parameters automatically
without server asking for it. IOW, override what server says about
following parameters and fuse sets their values if
FUSE_NONSHARED_FS is set?

Or should we recommend these for FUSE_NONSHARED_FS and let file server
specify all this.

> 
> ^FUSE_POSIX_LOCK

No remote posix locks. Makes sense. If filesystem is not shared then
there is no need of remote posix locks.

> ^FUSE_FLOCK_LOCKS

No remote BSD style file locks. If filesystem is not shared, then
local locks should work just fine.

> ^FUSE_AUTO_INVAL_DATA

This controls if page cache data should be invalidated upon mtime
change. For non shared fs, mtime should not change outside fuse, 
so makes sense to enforce ^FUSE_AUTO_INVAL_DATA.

> FUSE_EXPLICIT_INVAL_DATA

This tells fuse to not invalidate page cache and not truncate page cache
if attr->size or mtime change is detected. For non-shared fs we don't
expect attr->size or mtime to change, so it does not harm to enfroce
this.

> FUSE_CACHE_SYMLINKS

This caches readlink responses. Makes sense to enable it for
non shared fs. 

> attr_valid=inf
> entry_valid=inf

dentry and attr timeout being infinite should be good for performance
if filesystem is not shared.

> FOPEN_KEEP_CACHE

If this is not set, by default fuse invalidates page cache on open. Makes
sense to not flush page cache on open with FUSE_NONSHARED_FS.

> FOPEN_CACHE_DIR

Caching directory contents for FUSE_NONSHARED_FS makes sense too.

> 
> This would make sure that it's really only used in the non-shared case.

I am little afraid of enforcing this in fuse core because tomorrow
somebody will say hey I need hybrid mode where FUSE_NONSHARED_FS is
set but for some reason I want attrs to expire after some time. I 
don't have a good use case in my mind though.

If I were to choose, I will probably document it and suggest that
file servers sets all the above for the case of FUSE_NONSHARED_FS.

But I am also open to enforcing this in fuse core if you prefer
that option.

Thanks
Vivek

