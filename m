Date: Mon, 16 Mar 2020 09:02:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200316130234.GA4013@redhat.com>
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<yrjh1rpzggg4.fsf@pohly-mobl1.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yrjh1rpzggg4.fsf@pohly-mobl1.fritz.box>
Subject: Re: [Virtio-fs] [PATCH 00/20] virtiofs: Add DAX support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Patrick Ohly <patrick.ohly@intel.com>
Cc: miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, mst@redhat.com, linux-fsdevel@vger.kernel.org

On Wed, Mar 11, 2020 at 02:38:03PM +0100, Patrick Ohly wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> > This patch series adds DAX support to virtiofs filesystem. This allows
> > bypassing guest page cache and allows mapping host page cache directly
> > in guest address space.
> >
> > When a page of file is needed, guest sends a request to map that page
> > (in host page cache) in qemu address space. Inside guest this is
> > a physical memory range controlled by virtiofs device. And guest
> > directly maps this physical address range using DAX and hence gets
> > access to file data on host.
> >
> > This can speed up things considerably in many situations. Also this
> > can result in substantial memory savings as file data does not have
> > to be copied in guest and it is directly accessed from host page
> > cache.
> 
> As a potential user of this, let me make sure I understand the expected
> outcome: is the goal to let virtiofs use DAX (for increased performance,
> etc.) or also let applications that use virtiofs use DAX?
> 
> You are mentioning using the host's page cache, so it's probably the
> former and MAP_SYNC on virtiofs will continue to be rejected, right?

Hi Patrick,

You are right. Its the former. That is we want virtiofs to be able to
make use of DAX to bypass guest page cache. But there is no persistent
memory so no persistent memory programming semantics available to user
space. For that I guess we have virtio-pmem.

We expect users will issue fsync/msync like a regular filesystem to
make changes persistent. So in that aspect, rejecting MAP_SYNC
makes sense. I will test and see if current code is rejecting MAP_SYNC
or not.

Thanks
Vivek

