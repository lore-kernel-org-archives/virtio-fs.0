Date: Fri, 18 Jun 2021 08:53:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210618125308.GB1234055@redhat.com>
References: <20210614174454.903555-1-vgoyal@redhat.com>
	<20210614174454.903555-2-vgoyal@redhat.com>
	<CAJfpeguD+F3Ai01=-JYNTKS4LP4d879=+8T7eOBewZpevTRbJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguD+F3Ai01=-JYNTKS4LP4d879=+8T7eOBewZpevTRbJg@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v2 1/2] init/do_mounts.c: Add a path to boot
 from tag based filesystems
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, Richard Weinberger <richard.weinberger@gmail.com>, Dominique Martinet <asmadeus@codewreck.org>, linux-kernel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net

On Fri, Jun 18, 2021 at 09:07:14AM +0200, Miklos Szeredi wrote:
> On Mon, 14 Jun 2021 at 19:45, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > We want to be able to mount virtiofs as rootfs and pass appropriate
> > kernel command line. Right now there does not seem to be a good way
> > to do that. If I specify "root=myfs rootfstype=virtiofs", system
> > panics.
> >
> > virtio-fs: tag </dev/root> not found
> > ..
> > ..
> > [ end Kernel panic - not syncing: VFS: Unable to mount root fs on
> > +unknown-block(0,0) ]
> >
> > Basic problem here is that kernel assumes that device identifier
> > passed in "root=" is a block device. But there are few execptions
> > to this rule to take care of the needs of mtd, ubi, NFS and CIFS.
> >
> > For example, mtd and ubi prefix "mtd:" or "ubi:" respectively.
> >
> > "root=mtd:<identifier>" or "root=ubi:<identifier>"
> >
> > NFS and CIFS use "root=/dev/nfs" and CIFS passes "root=/dev/cifs" and
> > actual root device details come from filesystem specific kernel
> > command line options.
> >
> > virtiofs does not seem to fit in any of the above categories. In fact
> > we have 9pfs which can be used to boot from but it also does not
> > have a proper syntax to specify rootfs and does not fit into any of
> > the existing syntax. They both expect a device "tag" to be passed
> > in a device to be mounted. And filesystem knows how to parse and
> > use "tag".
> >
> > So there seem to be a class of filesystems which specify root device
> > using a "tag" which is understood by the filesystem. And filesystem
> > simply expects that "tag" to be passed as "source" of mount and
> > how to mount filesystem using that "tag" is responsibility of filesystem.
> >
> > This patch proposes that we internally create a list of filesystems
> > which pass a "tag" in "root=<tag>" and expect that tag to be passed
> > as "source" of mount. With this patch I can boot into virtiofs rootfs
> > with following syntax.
> >
> > "root=myfs rootfstype=virtiofs rw"
> 
> The syntax and the implementation looks good.
> 
> Acked-by: Miklos Szeredi <mszeredi@redhat.com>

Thanks Miklos. Now Christoph has come up with another patch series to
achieve the same. And that patches series looks better than my patches.

https://lore.kernel.org/linux-fsdevel/20210617153649.1886693-1-hch@lst.de/

There are couple of minor issues to be taken care of. I am hoping after
that these patches can be merged.

Thanks
Vivek

