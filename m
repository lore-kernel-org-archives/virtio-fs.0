Date: Fri, 21 Aug 2020 16:02:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200821200232.GA905782@redhat.com>
References: <20200724183812.19573-1-vgoyal@redhat.com>
	<CAJfpeguzG3tfjHkToikA+v4Pu7iEa7Y=RxaO+SnycZHxFHRLGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguzG3tfjHkToikA+v4Pu7iEa7Y=RxaO+SnycZHxFHRLGg@mail.gmail.com>
Subject: Re: [Virtio-fs] [RFC PATCH 0/5] fuse: Implement
 FUSE_HANDLE_KILLPRIV_V2 and enable SB_NOSEC
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

On Fri, Aug 21, 2020 at 04:46:44PM +0200, Miklos Szeredi wrote:
> On Fri, Jul 24, 2020 at 8:38 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > If you are concerned about regression w.r.t clear of caps, then we
> > can think of enabling SB_NOSEC conditionally. Say user chooses it
> > as mount option. But given caps is just an outlier and currently
> > we clear suid/sgid based on cache (and not based on state on server),
> > I feel it might not be a huge issue.
> >
> > What do you think?
> 
> I think enabling xattr caching should be a separate feature, and yes,
> SB_NOSEC would effectively enable xattr caching.
> 
> We could add the FUSE_CACHE_XATTR feature flag without actually adding
> real caching, just SB_NOSEC...
> 
> Does that sound sane?

Hi Miklos,

I found one the old threads on this topic here.

https://patchwork.kernel.org/patch/9306393/

In the end you have suggested few solutions to the problem and frankly
speaking I think I like following the best one.

"Perhaps add a "local fs" mode where we can assume proper consistency
 between cache and backing."

Distributed filesystems are complicated and we need a proper protocol
so that file server can tell fuse its a distributed filesystem and
also come up with a way to invalidate various cached attributes
(depending on cache coherency model). For example, shouldn't file
server notify fuse that certain attr got invalidated. (If it detects
that another client modified it). Even that will be racy because
some other operation might already be making use of stale attribute
while we are invalidating it. That's where a better method like
delegation or something else will be needed, probably

But in case of local fs (ex. non-shared mode of virtiofs), all the
cached data should be valid as all changes should go through single
fuse instance. If fuse knows that, then probably lot of code can be
simplified for this important use case. Including setting SB_NOSEC.

To me caching xattr will bring another set of complex considrations
about how and when xattrs are invalidated and a lot will depend on
what guarantees said distributed filesystem is providing. So I am
little vary of going in that direction and make SB_NOSEC
conditional on FUSE_CACHE_XATTR. I am afraid that I will just
define this flag today without defining rest of the behavior
of xattr caching and that will probably break things later. This
probably should be done when we are actually implementing xattr
caching and keeping distributed filesystems in mind.

So how about, we instead implement a flag which tells fuse that
file server is implementing a local filesystem and it does not
expect anything to changed outside fuse. This will make sure
distributed filesystems like gluster don't regress because
of this change and a class of local filesystems can gain from
this. Once we support sharing mode in virtiofs, then we will
need to revisit it again and do it right for distributed
filesystems (depending on their invalidation mechanism).

Thanks
Vivek

