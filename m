Date: Mon, 10 Aug 2020 09:08:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200810130809.GA455528@redhat.com>
References: <20200807195526.426056-1-vgoyal@redhat.com>
	<CAJfpegtboe-XssmqrcvsJm1R0FBP8fYFrTMv5cuBhfmebiGfQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtboe-XssmqrcvsJm1R0FBP8fYFrTMv5cuBhfmebiGfQw@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v2 00/20] virtiofs: Add DAX support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <dan.j.williams@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org

On Mon, Aug 10, 2020 at 09:29:47AM +0200, Miklos Szeredi wrote:
> On Fri, Aug 7, 2020 at 9:55 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> 
> > Most of the changes are limited to fuse/virtiofs. There are couple
> > of changes needed in generic dax infrastructure and couple of changes
> > in virtio to be able to access shared memory region.
> 
> So what's the plan for merging the different subsystems?  I can take
> all that into the fuse tree, but would need ACKs from the respective
> maintainers.

I am assuming for DAX patches we need ACK from Dan Williams and for
virtio patches we need ack from Michael S. Tsirkin.

Dan, Michael, can you please review the dax and virtio patches
respectively and if there are no concerns, please provide ACK. Or
suggest an alternative way of how these patches can be merged.

Thanks
Vivek

