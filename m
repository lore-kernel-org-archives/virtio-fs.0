Date: Mon, 9 Sep 2019 12:18:13 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20190909121604-mutt-send-email-mst@kernel.org>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<CAJfpegu8POz9gC4MDEcXxDWBD0giUNFgJhMEzntJX_u4+cS9Zw@mail.gmail.com>
	<20190906103613.GH5900@stefanha-x1.localdomain>
	<CAJfpegudNVZitQ5L8gPvA45mRPFDk9fhyboceVW6xShpJ4mLww@mail.gmail.com>
	<866a1469-2c4b-59ce-cf3f-32f65e861b99@huawei.com>
	<20190909161455.GG20875@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909161455.GG20875@stefanha-x1.localdomain>
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On Mon, Sep 09, 2019 at 06:14:55PM +0200, Stefan Hajnoczi wrote:
> On Sun, Sep 08, 2019 at 07:53:55PM +0800, piaojun wrote:
> > 
> > 
> > On 2019/9/6 19:52, Miklos Szeredi wrote:
> > > On Fri, Sep 6, 2019 at 12:36 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > >>
> > >> On Fri, Sep 06, 2019 at 10:15:14AM +0200, Miklos Szeredi wrote:
> > >>> On Thu, Sep 5, 2019 at 9:49 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >>>>
> > >>>> Hi,
> > >>>>
> > >>>> Michael Tsirkin pointed out issues w.r.t various locking related TODO
> > >>>> items and races w.r.t device removal.
> > >>>>
> > >>>> In this first round of cleanups, I have taken care of most pressing
> > >>>> issues.
> > >>>>
> > >>>> These patches apply on top of following.
> > >>>>
> > >>>> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git#virtiofs-v4
> > >>>>
> > >>>> I have tested these patches with mount/umount and device removal using
> > >>>> qemu monitor. For example.
> > >>>
> > >>> Is device removal mandatory?  Can't this be made a non-removable
> > >>> device?  Is there a good reason why removing the virtio-fs device
> > >>> makes sense?
> > >>
> > >> Hot plugging and unplugging virtio PCI adapters is common.  I'd very
> > >> much like removal to work from the beginning.
> > > 
> > > Can you give an example use case?
> > 
> > I think VirtFS migration need hot plugging, or it may cause QEMU crash
> > or some problems.
> 
> Live migration is currently unsupported.  Hot unplugging the virtio-fs
> device would allow the guest to live migrate successfully, so it's a
> useful feature to work around the missing live migration support.
> 
> Is this what you mean?
> 
> Stefan

Exactly. That's what I also said. To add to that, hotplug can not be
negotiated, so it's not a feature we can easily add down the road if old
guests crash on unplug. Thus a driver that does not support unplug
should not claim to support removal.

-- 
MST

