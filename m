Date: Thu, 2 Jan 2020 11:13:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200102161342.GD6051@redhat.com>
References: <68b2f70664616734f98f572a9d70d0a8fe4627d6.camel@intel.com>
	<20200102135505.GC6051@redhat.com>
	<fc1e89f565bb14906e05a31a9a1729b759f77bd0.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc1e89f565bb14906e05a31a9a1729b759f77bd0.camel@intel.com>
Subject: Re: [Virtio-fs] virtio-fs kernel patches
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

On Thu, Jan 02, 2020 at 03:55:11PM +0000, Boeuf, Sebastien wrote:
> On Thu, 2020-01-02 at 08:55 -0500, Vivek Goyal wrote:
> > On Mon, Dec 23, 2019 at 10:37:13PM +0000, Boeuf, Sebastien wrote:
> > > Hi folks,
> > > 
> > > I was wondering what was the status regarding the linux kernel
> > > patches
> > > for virtio-fs?
> > > Do you have a series ready on top of 5.5-rcX?
> > 
> > Hi Sebastien,
> > 
> > Its not ready yet. I was planning to work on it before start of
> > holidays
> > but I could not. I am planning to work on it now. Will let you know
> > as
> > soon as its ready.
> 
> Great, thank you :)

Hi Sebastien,

I pushed DAX pathces for 5.5-rc4 here.

https://github.com/rhvgoyal/linux/commits/virtiofs-dax-5.5

Give it a try and let me know if you face issues.

Thanks
Vivek

