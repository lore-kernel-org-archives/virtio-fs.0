Date: Fri, 30 Apr 2021 14:32:08 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210430143208.3d826302@bahia.lan>
In-Reply-To: <20210430121757.GA1936051@redhat.com>
References: <20210426151011.840459-1-groug@kaod.org>
	<20210427171206.GA1805363@redhat.com>
	<20210427210921.7b01c661@bahia.lan>
	<20210430121757.GA1936051@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v2] virtiofs: propagate sync() to file server
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Robert Krawitz <rlk@redhat.com>

On Fri, 30 Apr 2021 08:17:57 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Tue, Apr 27, 2021 at 09:09:21PM +0200, Greg Kurz wrote:
> [..]
> > > > diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> > > > index 54442612c48b..1265ca17620c 100644
> > > > --- a/include/uapi/linux/fuse.h
> > > > +++ b/include/uapi/linux/fuse.h
> > > > @@ -179,6 +179,9 @@
> > > >   *  7.33
> > > >   *  - add FUSE_HANDLE_KILLPRIV_V2, FUSE_WRITE_KILL_SUIDGID, FATTR_KILL_SUIDGID
> > > >   *  - add FUSE_OPEN_KILL_SUIDGID
> > > > + *
> > > > + *  7.34
> > > > + *  - add FUSE_SYNCFS
> > > >   */
> > > >  
> > > >  #ifndef _LINUX_FUSE_H
> > > > @@ -214,7 +217,7 @@
> > > >  #define FUSE_KERNEL_VERSION 7
> > > >  
> > > >  /** Minor version number of this interface */
> > > > -#define FUSE_KERNEL_MINOR_VERSION 33
> > > > +#define FUSE_KERNEL_MINOR_VERSION 34
> > > >  
> > > >  /** The node ID of the root inode */
> > > >  #define FUSE_ROOT_ID 1
> > > > @@ -499,6 +502,7 @@ enum fuse_opcode {
> > > >  	FUSE_COPY_FILE_RANGE	= 47,
> > > >  	FUSE_SETUPMAPPING	= 48,
> > > >  	FUSE_REMOVEMAPPING	= 49,
> > > > +	FUSE_SYNCFS		= 50,
> > > >  
> > > >  	/* CUSE specific operations */
> > > >  	CUSE_INIT		= 4096,
> > > > @@ -957,4 +961,8 @@ struct fuse_removemapping_one {
> > > >  #define FUSE_REMOVEMAPPING_MAX_ENTRY   \
> > > >  		(PAGE_SIZE / sizeof(struct fuse_removemapping_one))
> > > >  
> > > > +struct fuse_syncfs_in {
> > > > +	uint64_t flags;
> > > > +};
> > > > +
> > > 
> > > Hi Greg,
> > > 
> > > Will it be better if 32bits are for flags and reset 32 are
> > > padding and can be used in whatever manner.
> > > 
> > > struct fuse_syncfs_in {
> > > 	uint32_t flags;
> > > 	uint32_t padding;
> > > };
> > > 
> > > This will increase the flexibility if we were to send more information
> > > in future.
> > > 
> > > I already see bunch of structures where flags are 32 bit and reset
> > > are padding bits. fuse_read_in, fuse_write_in, fuse_rename2_in etc.
> > > 
> > > Thanks
> > > Vivek
> > > 
> > 
> > Yes, it makes sense. I'll wait a few more days and roll out a v3.
> 
> Thinking more about it. We are not using any of the fields of this
> structure right now. So may be all of it can be padding and no need
> to add "flags".
> 
> struct fuse_syncfs_in {
> 	uint64_t padding;
> };
> 
> Essentially what you have already done  :-). Just rename flags to
> padding/unused to make it clear its unused for now.
> 

Yeah and this would allow to get rid of the assert() on non-zero flags
on the virtiofsd size, which was looking a bit awkward :-)

> Vivek
> 

