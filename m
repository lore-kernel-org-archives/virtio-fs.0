Date: Mon, 13 Dec 2021 13:03:28 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YbeK8HOF5F8n+ZG8@redhat.com>
References: <20211102055646.103337-1-jefflexu@linux.alibaba.com>
	<Ya9y7uqsMoDfGIbc@redhat.com>
	<dab8877d-54ad-9384-4a0f-34eae2c93b75@linux.alibaba.com>
	<YbEP/1IeGVkDhbaC@redhat.com>
	<7815cbb4-4889-4d37-14d1-a23a0a960204@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7815cbb4-4889-4d37-14d1-a23a0a960204@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH v7 0/6] virtiofsd: support per inode DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: JeffleXu <jefflexu@linux.alibaba.com>
Cc: virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, miklos@szeredi.hu

On Fri, Dec 10, 2021 at 10:54:20AM +0800, JeffleXu wrote:
> Hi Vivek,
> 
> Besides, I'd like to know that, to make the per inode DAX feature merged
> into v5.17, shall the patches for virtiofsd also be ready during the
> merge window?

I think having virtiofsd patches ready is not a strict requirement to
merge kernel patches. I will provide my ack for the kernel patches.
After that it is up to the Miklos to accept or reject those patches.

Thanks
Vivek

> 
> 
> On 12/9/21 4:05 AM, Vivek Goyal wrote:
> > On Wed, Dec 08, 2021 at 09:38:45AM +0800, JeffleXu wrote:
> >>
> >>
> >> On 12/7/21 10:42 PM, Vivek Goyal wrote:
> >>> Hi Jeffle,
> >>>
> >>> I noticed that you posted V8 of kernel patches. I was away from work
> >>> so could not look at it. Now I am back and want to review and test
> >>> those patches.
> >>
> >> Thanks for reviewing and evaluating.
> >>
> >>>
> >>> Is there a new version of patches for virtiofsd as well?
> >>
> >> Nope. Patches for virtiofsd is not updated. v7 is the latest version.
> > 
> > Hi Jeffle,
> > 
> > I am testing these patches now. Using virtio-fs-dev branch and your
> > patches on top.
> > 
> > When I unmount virtiofs in guest, I see following qemu-kvm message
> > on console.
> > 
> > qemu-kvm: check_slave_message_entries: Short VhostUserFSSlaveMsg size, 8
> > 
> > Wondering have you noticed it. I have not debugged it. Wondering if
> > it is due to your patches or there is something in virtio-fs-dev
> > branch patches which triggers it.
> > 
> > Vivek
> > 
> 
> -- 
> Thanks,
> Jeffle
> 

