Date: Tue, 28 Sep 2021 13:23:46 +1000
From: Dave Chinner <david@fromorbit.com>
Message-ID: <20210928032346.GI2361455@dread.disaster.area>
References: <20210923092526.72341-1-jefflexu@linux.alibaba.com>
	<20210923092526.72341-3-jefflexu@linux.alibaba.com>
	<YUzPUYU8R5LL4mzU@redhat.com>
	<20210923222618.GB2361455@dread.disaster.area>
	<YU0jovIYv+xeinQd@redhat.com>
	<20210927002148.GH2361455@dread.disaster.area>
	<YVHj8Z+XbN9QMJT8@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YVHj8Z+XbN9QMJT8@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v5 2/5] fuse: make DAX mount option a
	tri-state
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, joseph.qi@linux.alibaba.com

On Mon, Sep 27, 2021 at 11:32:01AM -0400, Vivek Goyal wrote:
> On Mon, Sep 27, 2021 at 10:21:48AM +1000, Dave Chinner wrote:
> > On Thu, Sep 23, 2021 at 09:02:26PM -0400, Vivek Goyal wrote:
> > > In summary, there seem to be two use cases.
> > > 
> > > A. virtiofsd/fuse-server wants do be able to come up with its own
> > > policy to decide which inodes should use guest.
> > > 
> > > B. guest client decides which inode use DAX based on FS_XFLAG_DAX
> > > attr on inode (and server does not play a role).
> > > 
> > > To be able to different between these two cases, I was suggesting
> > > using "-o dax=inode" for B and "-o dax=server" for A.
> > 
> > dax=inode covrees both these cases.  All the server side needs to do
> > is set the inode attribute according to policy, and all the client
> > needs to do is obey the server side per-inode attribute. IOWs,
> > client side using "dax=inode" means the server side controls the DAX
> > behaviour via the FUSE DAX attribute. 
> 
> Hi Dave,
> 
> Can a filesystem mounted with "-o dax=inode" enable DAX on a file even
> if FS_XFLAG_DAX attr is not set on the file. I think that's something new
> which will happen in case of fuse  and currently does not happen with
> ext4/xfs.

It can happen - the on-disk flag is defined as advisory in
Documentation/filesystems/dax.rst:

2. There exists a persistent flag `FS_XFLAG_DAX` that can be applied
   to regular files and directories. This advisory flag can be set or
   cleared at any time, but doing so does not immediately affect
   the `S_DAX` state.

So, we can have things like the inode get initialised, then the 
on disk flag is cleared. Now you have an inode that is accessed by
DAX in memory, and it will continue to be accessed using DAX until
to it removed from memory. IOWs, you can then check the on disk flag
and see that it is clear, yet check statx(STATX_ATTR_DAX) and see
that DAX is enabled.

Another counter example is that an inode has been reflink copied
and then the on-disk flag is set on the inode. Some time later
it is instantiated in memory, the filesystem sees that it has DAX
and shared extents and turns off DAX because it's not supported with
shared extents right now. So you can check the on-disk flag and
see that DAX -should- be enabled, but when you check
statx(STATX_ATTR_DAX) you will always set that DAX is disabled.

Another example: on disk bit is set, file contains inline data, or
compressed data, or encrypted data and so cannot provide direct
access to the storage. In which case, the filesysetm will ignore the
on disk bit and never use DAX on that inode.

IOWs, dax=inode means that the inode contains the *desired policy
for that inode*. It is a hint, not an enforced policy. The
filesystem and or kernel infrastructure can decide to ignore the
hint, and that is one of the reasons why checking
statx(STATX_ATTR_DAX) is required if the application needs DAX to
operate correctly.

> That's the use case A which wants to enable DAX attribute of a file
> based on its own policy (irrespective of state of FS_XFLAG_DAX on
> file).

Perfectly fine - dax=inode simply says "DAX policy is defined on
per-inode granularity". It does not guarantee any specific behaviour
will be followed because the per-inode policy flag is advisory.

> IIUC, you are ok with this. Just want to be sure because this
> is a subtle change from ext4/xfs behavior which will only enable
> DAX on a file if FS_XFLAG_DAX is set (with dax=inode). IOW, on
> ext4/xfs if FS_XFLAG_DAX is not set on file then DAX will not be
> enabled (dax=inode).

Again, the flag is -advisory- so there is nothing stopping us from
having other policies that combine with or override the on-disk
flag.

Fundamentally, the options are:

- "always" meaning *everything* *always* uses DAX.
- "never" meaning *nothing* *ever* uses DAX.
- "inode" meaning "derive behaviour from the inode advisory flag".

"dax=inode" does not rule out behaviour being derived from other
policy mechanisms - it just means that in the absence of any other
policy, decide behaviour dynamically on a per-inode granularity.  We
defined an API to set/clear that advisory flag on a per-inode basis,
and how it gets used is only limited by your imagination.

For example, the "inherit DAX from parent directory" policy is based
on setting the DAX flag set on the directory. We cannot use DAX to
access directory data directly, so this flag on a directory becomes
a *policy propagation mechanism* rather than an enabling
hint.

Hence the user might not even be aware that the admin of the system
(or even a package installer) set up DAX propagation policies. Hence
all their data directories are defaulting to using DAX even though
they never set a DAX flag or dax=always mount option themselves.

IOWs, having the FUSE server dynamically and/or silently propagate,
control or influence client side DAX behaviour under client side
dax=inode behaviour falls well within the "admin controlled policy
propoagation" guise that dax=inode is supposed to allow admins to
implement.

> I don't want applications to be making assumption that if FS_XFFLAG_DAX
> is not set on a file, then DAX will not be enabled on that file because
> that's what exactly fuse/virtiofs can do.

Applications *must* check statx(STATX_ATTR_DAX) after they have
opened the file to determine if DAX is in use. FS_XFLAG_DAX is an
advisory hint, not an indication of current behaviour, and it's
irrelevant if dax=never or dax=always is in use. In those cases,
statx() is pretty much the only way to sanely check the DAX state of
an open file.


> > If the server wants the client to always use DAX, then it always
> > sets the FUSE inode attribute. If the server says "never use DAX",
> > then it never sets the FUSE inode attribute.  If the server doesn't
> > want the client to control policy, then it just rejects attempts to
> > change the per-inode persistent DAX flag via client side
> > ioctl(FS_XFLAG_DAX) calls. Hence we have use case A completely
> > covered.
> 
> Ok, I think the behavior of ioctl(FS_XFLAG_DAX) calls is confusing
> me most in this context. IIUC, you are suggesting that server will
> define the policy whether it is supporting ioctl(FS_XFLAG_DAX)
> or not. This is will part of feature negotiation of fuse protocol.
>
> If server decides to support ioctl(FS_XFLAG_DAX), then it should
> work similar to ext4/xfs and also follow inheritance rules.
> 
> If server decides to not support (or not enable) ioctl(FS_XFLAG_DAX),
> then server need to reject any attempt from client to set
> FS_XFLAG_DAX. And if client queries the current state of 
> FS_XFLAG_DAX, then we need to return it is not set (even if it
> set on underlying filesystem). That way client will think FS_XFLAG_DAX
> is not set and will not expect DAX to be necessarily enabled.

No, I'm not suggesting that's what you do. How the server controls
the DAX policy is largely irrelevant to the discussion.

Start by looking at how the client implements FS_XFLAG_DAX.  It's
already supported, because the fuse client already has the
FSGETXATTR/FSSETXATTR protocol mechanisms for doing this
(fuse_fileattr_get(), fuse_fileattr_set()). Hence the client is
already passing FS_XFLAG_DAX to the server for persistent storage,
and it should already be getting it back from the server.

The basis of XFS/ext4 dax=inode behaviour is already implemented
in the fuse client. All you need to do is hook up
fuse_dax_inode_init() to look at that flag to determine behaviour
instead of always applying the connection DAX state as the
determination. i.e.:

	if (!fc->dax)
		return;
	if ("dax=never")
		return;
	if ("dax=inode" && !fuse_inode_has_dax(inode))
		return;

	inode->i_flags |= S_DAX;
	inode->i_data.a_ops = &fuse_dax_file_aops;

And there's not much more to implement on the client side for
dax=inode behaviour.

So, if you want server side policy control, the FUSE protocol needs
to ensure that fuse_inode_has_dax(inode) follows whatever the server
side requires the policy to be. This may be combined with the
user FS_XFLAG_DAX attribute, or it may be a separate inode flag
that overrides FS_XFLAG_DAX. But that's FUSE implementation detail,
and not something I'm concerned about.

The fact is that server side override doesn't change the client side
logic or behaviour. The FS_XFLAG_DAX behaviour follows what the user
sets, dax=inode follows that in the absence of other policy
overrides that the user may or may not know about but are applied on
a per-inode granularity...

> > For case B, which is true dax=inode behaviour at the client, then
> > the server side honours the client side requests to change the
> > persistent FUSE DAX inode attribute via client side FS_XFLAG_DAX
> > ioctls.
> > 
> > See? At the client side, there is absolutely no difference between
> > server side policy control and true dax=inode support. The client is
> > completely unaware of server side policies and that's how the client
> > side should be implemented. The applications have to be prepared for
> > policy to change dynamically with either dax=server or dax=inode, so
> > there's no difference to applications running in the guest either.
> > 
> > Hence I just don't see the justification for a special DAX mode from
> > an architectural POV. It's no more work to implement per-inode DAX
> > properly form the start and we don't end up with a special, subtly
> > different mode.
> 
> Ok, So I guess initially we could just implement "-o dax=inode" and
> *not support FS_XFLAG_DAX" API at all.

No, please don't do that, and please stop wasting my time by making
me have to repeatedly explain to you why doing stuff like this is
harmful to our user base. Implement compatible, common dax=inode
behaviour *first*, then layer your server side policy variants on
top of that.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

