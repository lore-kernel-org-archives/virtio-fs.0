Date: Fri, 24 Sep 2021 08:26:18 +1000
From: Dave Chinner <david@fromorbit.com>
Message-ID: <20210923222618.GB2361455@dread.disaster.area>
References: <20210923092526.72341-1-jefflexu@linux.alibaba.com>
	<20210923092526.72341-3-jefflexu@linux.alibaba.com>
	<YUzPUYU8R5LL4mzU@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YUzPUYU8R5LL4mzU@redhat.com>
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

On Thu, Sep 23, 2021 at 03:02:41PM -0400, Vivek Goyal wrote:
> On Thu, Sep 23, 2021 at 05:25:23PM +0800, Jeffle Xu wrote:
> > We add 'always', 'never', and 'inode' (default). '-o dax' continues to
> > operate the same which is equivalent to 'always'. To be consistemt with
> > ext4/xfs's tri-state mount option, when neither '-o dax' nor '-o dax='
> > option is specified, the default behaviour is equal to 'inode'.
> 
> So will "-o dax=inode" be used for per file DAX where dax mode comes
> from server?
> 
> I think we discussed this. It will be better to leave "-o dax=inode"
> alone. It should be used when we are reading dax status from file
> attr (like ext4 and xfs). 
> 
> And probably create separate option say "-o dax=server" where server
> specifies which inode should use dax.

That seems like a poor idea to me.

The server side already controls what the client side does by
controlling the inode attributes that the client side sees.  That
is, if the server is going to specify whether the client side data
access is going to use dax, then the server presents the client with
an inode that has the DAX attribute flag set on it.

In that case, turning off dax on the guest side should be
communicated to the fuse server so the server turns off the DAX flag
on the server side iff server side policy allows it.  When the guest
then purges it's local inode and reloads it from the server then it
will get an inode with the DAX flag set according to server side
policy.

Hence if the server side is configured with "dax=always" or
dax="never" semantics it means the client side inode flag state
cannot control DAX mode. That means, regardless of the client side
mount options, DAX is operating under always or never policy,
enforced by the server side by direct control of the client inode
DAX attribute flag. If dax=inode is in use on both sides, the the
server honours the requests of the client to set/clear the inode
flags and presents the inode flag according to the state the client
side has requested.

This policy state probably should be communicated to
the fuse client from the server at mount time so policy conflicts
can be be resolved at mount time (e.g. reject mount if policy
conflict occurs, default to guest overrides server or vice versa,
etc). This then means that that the client side mount policies will
default to server side policy when they set "dax=inode" but also
provide a local override for always or never local behaviour.

Hence, AFAICT, there is no need for a 'dax=server' option - this
seems to be exactly what 'dax=inode' behaviour means on the client
side - it behaves according to how the server side propagates the
DAX attribute to the client for each inode.

> Otherwise it will be very confusing. People familiar with "-o dax=inode"
> on ext4/xfs will expect file attr to work and that's not what we
> are implementing, IIUC.

The dax mount option behaviour is already confusing enough without
adding yet another weird, poorly documented, easily misunderstood
mode that behaves subtly different to existing modes.

Please try to make the virtiofs behaviour compatible with existing
modes - it's not that hard to make the client dax=inode behaviour be
controlled by the server side without any special client side mount
modes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

