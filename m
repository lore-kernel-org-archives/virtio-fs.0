Date: Tue, 31 Aug 2021 07:31:56 +0800
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20210830233149.GA118114@rsjd01523.et2sqa>
References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
	<CAJfpeguw1hMOaxpDmjmijhf=-JEW95aEjxfVo_=D_LyWx8LDgw@mail.gmail.com>
	<YRut5sioYfc2M1p7@redhat.com>
	<6043c0b8-0ff1-2e11-0dd0-e23f9ff6b952@linux.alibaba.com>
	<YRvOZI3CvLsF96JA@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YRvOZI3CvLsF96JA@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v4 0/8] fuse,virtiofs: support per-file DAX
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, virtio-fs-list <virtio-fs@redhat.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, JeffleXu <jefflexu@linux.alibaba.com>

On Tue, Aug 17, 2021 at 10:57:40AM -0400, Vivek Goyal wrote:
> On Tue, Aug 17, 2021 at 09:22:53PM +0800, JeffleXu wrote:
> > 
> > 
> > On 8/17/21 8:39 PM, Vivek Goyal wrote:
> > > On Tue, Aug 17, 2021 at 10:06:53AM +0200, Miklos Szeredi wrote:
> > >> On Tue, 17 Aug 2021 at 04:22, Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> > >>>
> > >>> This patchset adds support of per-file DAX for virtiofs, which is
> > >>> inspired by Ira Weiny's work on ext4[1] and xfs[2].
> > >>
> > >> Can you please explain the background of this change in detail?
> > >>
> > >> Why would an admin want to enable DAX for a particular virtiofs file
> > >> and not for others?
> > > 
> > > Initially I thought that they needed it because they are downloading
> > > files on the fly from server. So they don't want to enable dax on the file
> > > till file is completely downloaded. 
> > 
> > Right, it's our initial requirement.
> > 
> > 
> > > But later I realized that they should
> > > be able to block in FUSE_SETUPMAPPING call and make sure associated
> > > file section has been downloaded before returning and solve the problem.
> > > So that can't be the primary reason.
> > 
> > Saying we want to access 4KB of one file inside guest, if it goes
> > through FUSE request routine, then the fuse daemon only need to download
> > this 4KB from remote server. But if it goes through DAX, then the fuse
> > daemon need to download the whole DAX window (e.g., 2MB) from remote
> > server, so called amplification. Maybe we could decrease the DAX window
> > size, but it's a trade off.
> 
> Downloading 2MB chunk should not be a big issue (IMHO). And if this
> turns out to be real concern, we could experiment with a smaller
> mapping granularity.
> 
> > 
> > > 
> > > Other reason mentioned I think was that only certain files benefit
> > > from DAX. But not much details are there after that. It will be nice
> > > to hear a more concrete use case and more details about this usage.
> > > 
> > 
> > Apart from our internal requirement, more fine grained control for DAX
> > shall be general and more flexible. Glad to hear more discussion from
> > community.
> 
> Sure it will be more general and flexible. But there needs to be 1-2
> good concrete use cases to justify additional complexity. And I don't
> think that so far a good use case has come forward.
>

Hi Vivek,

Our use case can be summarized like this, we need to share a readonly
fs image with _multiple_ guests while keeping the memory overhead as
low as possible.  More specifically, we have a userspace fs and a
tool[1] to split a ext4 directory into to metadata part and data part
in two individual files respectively, given the fact these two files
are supposed to be accessed multiple times and their sizes are
ususally larger than 2MB, it indeed matches what dax's best practice
hopes.

However, since these two files are sharing the same virtiofs mnt point
with non-fs-image files, we'd like to have a more fine-grained control
on the dax flag.

And please note that how guests would mount dax and use dax is under
our control, so it's server who will decide the dax flag.

AFAICS this patch set can let either server or guest make the
decision, but if most of us have concerns about the complexity brought
by mixing the two cases, I think we can go with only letting server
decide it by setting attr.flags.


[1]: https://github.com/dragonflyoss/image-service/blob/master/docs/nydus-design.md


> Thanks
> Vivek

