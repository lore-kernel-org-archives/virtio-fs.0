Date: Fri, 19 Jun 2020 11:57:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200619155737.GA12225@redhat.com>
References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200618190816.GD3814@redhat.com>
	<CAJfpegsfqADmK6foDyuQQnvMDh_jE0rNUCBRuxPchSSirrb04Q@mail.gmail.com>
	<20200619142508.GB3154@redhat.com>
	<CAJfpeguhS3w-AZTpyzO2QqcX_7F1qDm__5C8r3pBnCgPoxTKmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguhS3w-AZTpyzO2QqcX_7F1qDm__5C8r3pBnCgPoxTKmQ@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: drop Linux capabilities(7)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Fri, Jun 19, 2020 at 05:26:37PM +0200, Miklos Szeredi wrote:
> On Fri, Jun 19, 2020 at 4:25 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Fri, Jun 19, 2020 at 04:16:30PM +0200, Miklos Szeredi wrote:
> > > On Thu, Jun 18, 2020 at 9:08 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > >
> > > > On Thu, Apr 16, 2020 at 05:49:05PM +0100, Stefan Hajnoczi wrote:
> > > > > virtiofsd doesn't need of all Linux capabilities(7) available to root.  Keep a
> > > > > whitelisted set of capabilities that we require.  This improves security in
> > > > > case virtiofsd is compromised by making it hard for an attacker to gain further
> > > > > access to the system.
> > > >
> > > > Hi Stefan,
> > > >
> > > > I just noticed that this patch set breaks overlayfs on top of virtiofs.
> > >
> > > How so?  Virtiofs isn't mounting overlayfs, is it?  Only the mounter
> > > requires CAP_SYS_ADMIN, not the accessor.
> >
> > virtiofsd needs CAP_SYS_ADMIN, otherwise fsetxattr(trusted.overlay.opaque)
> > fails in lo_setxattr().
> >
> > This is triggered when we mount overlayfs on top of virtiofs and overlayfs
> > tries to set OVL_XATTR_OPAQUE on upper to check if trusted xattrs are
> > supported or not.
> 
> Ah, right.
> 
> Plan is to use "user.*" xattr for unprivileged overlay.  This would be
> a good way to eliminate this attack surface in the overlay on virtiofs
> case as well.

So unpriviliged overlay is one which is mounted from inside a user
namespace. But in this case we might be mounting it from init_user_ns
of guest. So from overlayfs perspective this will still be treated
as priviliged overlay instance and it will use trusted xattrs, IIUC?

Thanks
Vivek

> 
> Other ways to minimize risk is to separate operations requiring
> CAP_SYS_ADMIN into a separate process, preferably a separate
> executable, that communicates with virtiofsd using a pipe and contains
> the minimum amount of code.

> 
> Thanks,
> Miklos
> 

