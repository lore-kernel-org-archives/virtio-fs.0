Date: Fri, 6 Sep 2019 08:08:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190906120817.GA22083@redhat.com>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<CAJfpegu8POz9gC4MDEcXxDWBD0giUNFgJhMEzntJX_u4+cS9Zw@mail.gmail.com>
	<20190906103613.GH5900@stefanha-x1.localdomain>
	<CAJfpegudNVZitQ5L8gPvA45mRPFDk9fhyboceVW6xShpJ4mLww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegudNVZitQ5L8gPvA45mRPFDk9fhyboceVW6xShpJ4mLww@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 00/18] virtiofs: Fix various races and
	cleanups round 1
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org

On Fri, Sep 06, 2019 at 01:52:41PM +0200, Miklos Szeredi wrote:
> On Fri, Sep 6, 2019 at 12:36 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> >
> > On Fri, Sep 06, 2019 at 10:15:14AM +0200, Miklos Szeredi wrote:
> > > On Thu, Sep 5, 2019 at 9:49 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > Michael Tsirkin pointed out issues w.r.t various locking related TODO
> > > > items and races w.r.t device removal.
> > > >
> > > > In this first round of cleanups, I have taken care of most pressing
> > > > issues.
> > > >
> > > > These patches apply on top of following.
> > > >
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git#virtiofs-v4
> > > >
> > > > I have tested these patches with mount/umount and device removal using
> > > > qemu monitor. For example.
> > >
> > > Is device removal mandatory?  Can't this be made a non-removable
> > > device?  Is there a good reason why removing the virtio-fs device
> > > makes sense?
> >
> > Hot plugging and unplugging virtio PCI adapters is common.  I'd very
> > much like removal to work from the beginning.
> 
> Can you give an example use case?

David Gilbert mentioned this could be useful if daemon stops responding
or dies. One could remove device. That will fail all future requests
and allow unmounting filesystem.

Havind said that, current implementation will help in above situation
only if there are no pending requests. If there are pending requests
and daemon stops responding, then removal will hang too, as we wait
for draining the queues.

So at some point of time, we also need some sort of timeout functionality
where we end requests with error after a timeout.

I feel we should support removing device at some point of time. But its
not necessarily a must have feature for first round.

Thanks
Vivek

