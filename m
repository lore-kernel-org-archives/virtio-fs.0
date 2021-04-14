Date: Wed, 14 Apr 2021 08:58:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210414125854.GL1235549@redhat.com>
References: <20210325151823.572089-1-vgoyal@redhat.com>
	<CAJfpegvU9zjT7qV=Rj4ok4kfYz-9BPhjp+xKz9odfSWaFxshyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvU9zjT7qV=Rj4ok4kfYz-9BPhjp+xKz9odfSWaFxshyA@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v2 0/2] fuse: Fix clearing SGID when access
	ACL is set
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, Seth Forshee <seth.forshee@canonical.com>, linux-fsdevel@vger.kernel.org

On Wed, Apr 14, 2021 at 01:57:01PM +0200, Miklos Szeredi wrote:
> On Thu, Mar 25, 2021 at 4:19 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> >
> > Hi,
> >
> > This is V2 of the patchset. Posted V1 here.
> >
> > https://lore.kernel.org/linux-fsdevel/20210319195547.427371-1-vgoyal@redhat.com/
> >
> > Changes since V1:
> >
> > - Dropped the helper to determine if SGID should be cleared and open
> >   coded it instead. I will follow up on helper separately in a different
> >   patch series. There are few places already which open code this, so
> >   for now fuse can do the same. Atleast I can make progress on this
> >   and virtiofs can enable ACL support.
> >
> > Luis reported that xfstests generic/375 fails with virtiofs. Little
> > debugging showed that when posix access acl is set that in some
> > cases SGID needs to be cleared and that does not happen with virtiofs.
> >
> > Setting posix access acl can lead to mode change and it can also lead
> > to clear of SGID. fuse relies on file server taking care of all
> > the mode changes. But file server does not have enough information to
> > determine whether SGID should be cleared or not.
> >
> > Hence this patch series add support to send a flag in SETXATTR message
> > to tell server to clear SGID.
> 
> Changed it to have a single extended structure for the request, which
> is how this has always been handled in the fuse API.
> 
> The ABI is unchanged, but you'll need to update the userspace part
> according to the API change.  Otherwise looks good.

Hi Miklos,

Thanks. Patches look good. I will update userspace part and repost.

Vivek

> 
> Applied and pushed to fuse.git#for-next.
> 
> Thanks,
> Miklos
> 

