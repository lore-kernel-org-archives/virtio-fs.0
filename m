Date: Fri, 25 Sep 2020 09:13:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200925131356.GD132653@redhat.com>
References: <20200918213436.GA3520@redhat.com>
	<46D726A6-72F3-40FE-9382-A189513F783D@intel.com>
	<20200924221023.GB132653@redhat.com> <17216624.eqST2d0sUl@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17216624.eqST2d0sUl@silver>
Subject: Re: [Virtio-fs] virtiofs vs 9p performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christian Schoenebeck <qemu_oss@crudebyte.com>
Cc: "Shinde, Archana M" <archana.m.shinde@intel.com>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, qemu-devel@nongnu.org, virtio-fs-list <virtio-fs@redhat.com>, Greg Kurz <groug@kaod.org>, "cdupontd@redhat.com" <cdupontd@redhat.com>

On Fri, Sep 25, 2020 at 10:06:41AM +0200, Christian Schoenebeck wrote:
> On Freitag, 25. September 2020 00:10:23 CEST Vivek Goyal wrote:
> > In my testing, with cache=none, virtiofs performed better than 9p in
> > all the fio jobs I was running. For the case of cache=auto  for virtiofs
> > (with xattr enabled), 9p performed better in certain write workloads. I
> > have identified root cause of that problem and working on
> > HANDLE_KILLPRIV_V2 patches to improve WRITE performance of virtiofs
> > with cache=auto and xattr enabled.
> 
> Please note, when it comes to performance aspects, you should set a reasonable 
> high value for 'msize' on 9p client side:
> https://wiki.qemu.org/Documentation/9psetup#msize

Interesting. I will try that. What does "msize" do? 

> 
> I'm also working on performance optimizations for 9p BTW. There is plenty of 
> headroom to put it mildly. For QEMU 5.2 I started by addressing readdir 
> requests:
> https://wiki.qemu.org/ChangeLog/5.2#9pfs

Nice. I guess this performance comparison between 9p and virtiofs is good.
Both the projects can try to identify weak points and improve performance.

Thanks
Vivek

